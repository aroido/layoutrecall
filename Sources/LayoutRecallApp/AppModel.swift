import AppKit
import CoreGraphics
import Foundation
import LayoutRecallKit
import Observation

struct AppModelServices {
    let store: any ProfileStoring
    let settingsStore: any AppSettingsStoring
    let diagnosticsStore: any DiagnosticsStoring
    let snapshotReader: any DisplaySnapshotReading
    let eventMonitor: any DisplayEventMonitoring
    let commandBuilder: any DisplayCommandBuilding
    let coordinator: RestoreCoordinator
    let executor: any RestoreExecuting
    let dependencyInstaller: any DependencyInstalling
    let verifier: any RestoreVerifying
    let loginItemManager: any LoginItemManaging
    let shortcutManager: any ShortcutManaging
    let updateChecker: any AppUpdateChecking
    let updateInstaller: any AppUpdateInstalling
    let updatePrompt: any AppUpdatePrompting
    let displayIdentifier: any DisplayIdentifying
    let terminateApplication: @MainActor () -> Void
    let debounceNanoseconds: UInt64
    let restoreCooldown: TimeInterval
    let shouldBootstrapOnLaunch: Bool
}

struct AppModelTaskState {
    var debounceTask: Task<Void, Never>?
    var restoreCooldownUntil: Date?
    var installationTask: Task<Void, Never>?
    var automaticInstallAttempted = false
    var promptedUpdateVersion: String?
    var hasBootstrapped = false
    var pendingTerminationTasks: [UUID: Task<Void, Never>] = [:]
    var manualRestoreExpectedOrigins: [DisplayOrigin]?
    var manualRestoreActionTaken: String?
}

@MainActor
@Observable
final class AppModel {
    var profiles: [DisplayProfile] = []
    var diagnostics: [DiagnosticsEntry] = []
    var statusLine = L10n.t("status.starting")
    var decisionLine = L10n.t("status.waitingSavedProfile")
    var dependencyLine = L10n.t("status.checkingDependency")
    var dependencyAvailable = false
    var installationInProgress = false
    var loginItemLine = L10n.t("status.checkingLoginItem")
    var lastCommand = ""
    var detectedDisplayCount = 0
    var currentDisplaySnapshots: [DisplaySnapshot] = []
    var latestDecision: RestoreDecision?
    var latestMatchedProfileName: String?
    var latestMatchScore: Int?
    var updateState: AppUpdateState = .idle
    var availableUpdate: AppRelease?
    var automaticUpdateChecksEnabled = true
    var autoRestoreEnabled = true
    var askBeforeAutomaticRestoreEnabled = false
    var launchAtLoginEnabled = false
    var preferredLanguageOption: AppLanguageOption = .system
    var restoreCommandInProgress = false
    var shortcuts = ShortcutSettings()
    var skippedReleaseVersion: String?

    let services: AppModelServices
    var taskState = AppModelTaskState()

    init(
        store: any ProfileStoring = ProfileStore(),
        settingsStore: any AppSettingsStoring = AppSettingsStore(),
        diagnosticsStore: any DiagnosticsStoring = DiagnosticsLogger(),
        snapshotReader: any DisplaySnapshotReading = DisplaySnapshotReader(),
        eventMonitor: any DisplayEventMonitoring = CGDisplayEventMonitor(),
        commandBuilder: any DisplayCommandBuilding = DisplayplacerCommandBuilder(),
        coordinator: RestoreCoordinator = RestoreCoordinator(),
        executor: any RestoreExecuting = DisplayplacerRestoreExecutor(),
        dependencyInstaller: any DependencyInstalling = DisplayplacerInstaller(),
        verifier: any RestoreVerifying = RestoreVerifier(),
        loginItemManager: any LoginItemManaging = AppLoginItemManager(),
        shortcutManager: any ShortcutManaging = GlobalHotKeyManager(),
        updateChecker: any AppUpdateChecking = NoopAppUpdateChecker(),
        updateInstaller: any AppUpdateInstalling = NoopAppUpdateInstaller(),
        updatePrompt: any AppUpdatePrompting = NoopAppUpdatePrompt(),
        displayIdentifier: any DisplayIdentifying = DisplayOverlayPresenter(),
        terminateApplication: @escaping @MainActor () -> Void = { NSApp.terminate(nil) },
        debounceNanoseconds: UInt64 = 2_000_000_000,
        restoreCooldown: TimeInterval = 8,
        autoBootstrap: Bool = true
    ) {
        services = AppModelServices(
            store: store,
            settingsStore: settingsStore,
            diagnosticsStore: diagnosticsStore,
            snapshotReader: snapshotReader,
            eventMonitor: eventMonitor,
            commandBuilder: commandBuilder,
            coordinator: coordinator,
            executor: executor,
            dependencyInstaller: dependencyInstaller,
            verifier: verifier,
            loginItemManager: loginItemManager,
            shortcutManager: shortcutManager,
            updateChecker: updateChecker,
            updateInstaller: updateInstaller,
            updatePrompt: updatePrompt,
            displayIdentifier: displayIdentifier,
            terminateApplication: terminateApplication,
            debounceNanoseconds: debounceNanoseconds,
            restoreCooldown: restoreCooldown,
            shouldBootstrapOnLaunch: autoBootstrap
        )
    }

    var hasPendingTerminationWork: Bool {
        !pendingTerminationTasks.isEmpty
    }

    func prepareForTermination() async {
        while true {
            let tasks = Array(pendingTerminationTasks.values)
            guard !tasks.isEmpty else {
                return
            }

            for task in tasks {
                await task.value
            }
        }
    }

    func bootstrapIfNeeded() async {
        guard !hasBootstrapped else {
            await logStartup("bootstrapIfNeeded skipped because hasBootstrapped=true")
            return
        }

        hasBootstrapped = true
        await logStartup("bootstrapIfNeeded starting bootstrap()")
        await bootstrap()
    }

    func bootstrap() async {
        await logStartup("bootstrap begin")
        await loadProfiles()
        await loadDiagnostics()
        await loadSettings()
        await configureShortcuts()
        await refreshDependencyState()
        await refreshLoginItemState()
        startMonitoring()
        await refreshCurrentState(
            trigger: DisplayEvent(type: .manual, details: L10n.t("event.bootstrapCompleted")),
            allowAutomaticRestore: false,
            shouldRecordDecision: false
        )
        await logStartup(
            "bootstrap completed profiles=\(profiles.count) diagnostics=\(diagnostics.count) decisionContext=\(String(describing: latestDecision?.context)) menuState=\(String(describing: menuPrimaryState))"
        )

        if automaticUpdateChecksEnabled {
            Task { @MainActor [weak self] in
                await self?.checkForUpdates(userInitiated: false, promptIfAvailable: true)
            }
        }
    }
}

extension AppModel {
    func shortcutBinding(for action: ShortcutAction) -> ShortcutBinding? {
        shortcuts[action]
    }
}

extension AppModel {
    var store: any ProfileStoring { services.store }
    var settingsStore: any AppSettingsStoring { services.settingsStore }
    var diagnosticsStore: any DiagnosticsStoring { services.diagnosticsStore }
    var snapshotReader: any DisplaySnapshotReading { services.snapshotReader }
    var eventMonitor: any DisplayEventMonitoring { services.eventMonitor }
    var commandBuilder: any DisplayCommandBuilding { services.commandBuilder }
    var coordinator: RestoreCoordinator { services.coordinator }
    var executor: any RestoreExecuting { services.executor }
    var dependencyInstaller: any DependencyInstalling { services.dependencyInstaller }
    var verifier: any RestoreVerifying { services.verifier }
    var loginItemManager: any LoginItemManaging { services.loginItemManager }
    var shortcutManager: any ShortcutManaging { services.shortcutManager }
    var updateChecker: any AppUpdateChecking { services.updateChecker }
    var updateInstaller: any AppUpdateInstalling { services.updateInstaller }
    var updatePrompt: any AppUpdatePrompting { services.updatePrompt }
    var displayIdentifier: any DisplayIdentifying { services.displayIdentifier }
    var terminateApplication: @MainActor () -> Void { services.terminateApplication }
    var debounceNanoseconds: UInt64 { services.debounceNanoseconds }
    var restoreCooldown: TimeInterval { services.restoreCooldown }
    var shouldBootstrapOnLaunch: Bool { services.shouldBootstrapOnLaunch }

    var debounceTask: Task<Void, Never>? {
        get { taskState.debounceTask }
        set { taskState.debounceTask = newValue }
    }

    var restoreCooldownUntil: Date? {
        get { taskState.restoreCooldownUntil }
        set { taskState.restoreCooldownUntil = newValue }
    }

    var installationTask: Task<Void, Never>? {
        get { taskState.installationTask }
        set { taskState.installationTask = newValue }
    }

    var automaticInstallAttempted: Bool {
        get { taskState.automaticInstallAttempted }
        set { taskState.automaticInstallAttempted = newValue }
    }

    var promptedUpdateVersion: String? {
        get { taskState.promptedUpdateVersion }
        set { taskState.promptedUpdateVersion = newValue }
    }

    var hasBootstrapped: Bool {
        get { taskState.hasBootstrapped }
        set { taskState.hasBootstrapped = newValue }
    }

    var pendingTerminationTasks: [UUID: Task<Void, Never>] {
        get { taskState.pendingTerminationTasks }
        set { taskState.pendingTerminationTasks = newValue }
    }

    var manualRestoreExpectedOrigins: [DisplayOrigin]? {
        get { taskState.manualRestoreExpectedOrigins }
        set { taskState.manualRestoreExpectedOrigins = newValue }
    }

    var manualRestoreActionTaken: String? {
        get { taskState.manualRestoreActionTaken }
        set { taskState.manualRestoreActionTaken = newValue }
    }
}
