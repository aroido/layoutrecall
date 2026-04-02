import AppKit
import LayoutRecallKit
import SwiftUI

@MainActor
final class AppTerminationCoordinator: NSObject, NSApplicationDelegate {
    weak var model: AppSession?
    private var terminationReplyPending = false

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        guard let model, model.hasPendingTerminationWork else {
            return .terminateNow
        }

        guard !terminationReplyPending else {
            return .terminateLater
        }

        terminationReplyPending = true

        Task { @MainActor [weak self] in
            await model.prepareForTermination()
            sender.reply(toApplicationShouldTerminate: true)
            self?.terminationReplyPending = false
        }

        return .terminateLater
    }
}

@MainActor
final class BootstrapCoordinator {
    private var launchObserver: NSObjectProtocol?
    private var didRequestBootstrap = false

    func scheduleIfNeeded(model: AppSession) {
        guard model.shouldBootstrapOnLaunch, launchObserver == nil else { return }

        launchObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didFinishLaunchingNotification,
            object: nil,
            queue: .main
        ) { [weak self, weak model] _ in
            Task { @MainActor [weak self, weak model] in
                guard let self, let model else { return }
                guard !self.didRequestBootstrap else { return }
                self.didRequestBootstrap = true
                self.removeLaunchObserver()
                await model.bootstrapIfNeeded()
            }
        }
    }

    private func removeLaunchObserver() {
        guard let launchObserver else { return }
        NotificationCenter.default.removeObserver(launchObserver)
        self.launchObserver = nil
    }
}

@MainActor
final class ExistingInstanceCoordinator {
    private var launchObserver: NSObjectProtocol?
    private var revealObserver: NSObjectProtocol?
    private let revealCenter = DistributedNotificationCenter.default()

    func scheduleIfNeeded(
        launchMode: AppLaunchMode,
        settingsWindowPresenter: SettingsWindowPresenter
    ) {
        registerRevealObserverIfNeeded(settingsWindowPresenter: settingsWindowPresenter)

        guard launchMode == .standard, launchObserver == nil else { return }

        launchObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didFinishLaunchingNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.resolveDuplicateLaunchIfNeeded()
            }
        }
    }

    private func registerRevealObserverIfNeeded(
        settingsWindowPresenter: SettingsWindowPresenter
    ) {
        guard revealObserver == nil else { return }

        revealObserver = revealCenter.addObserver(
            forName: AppLaunchSignal.revealExistingInstance,
            object: Bundle.main.bundleIdentifier,
            queue: .main
        ) { notification in
            let senderPID = (notification.userInfo?["senderPID"] as? NSNumber)?.int32Value
            Task { @MainActor in
                guard senderPID != ProcessInfo.processInfo.processIdentifier else {
                    return
                }

                settingsWindowPresenter.show()
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    private func resolveDuplicateLaunchIfNeeded() {
        defer { removeLaunchObserver() }

        guard let bundleIdentifier = Bundle.main.bundleIdentifier,
              let existingInstance = AppInstanceResolver.existingPrimaryInstance(bundleIdentifier: bundleIdentifier)
        else {
            return
        }

        revealCenter.postNotificationName(
            AppLaunchSignal.revealExistingInstance,
            object: bundleIdentifier,
            userInfo: ["senderPID": NSNumber(value: ProcessInfo.processInfo.processIdentifier)],
            deliverImmediately: true
        )
        existingInstance.activate(options: [])
        NSApp.terminate(nil)
    }

    private func removeLaunchObserver() {
        guard let launchObserver else { return }
        NotificationCenter.default.removeObserver(launchObserver)
        self.launchObserver = nil
    }
}

@MainActor
final class MenuHarnessWindowCoordinator {
    private var windowController: NSWindowController?

    func show(model: AppSession, openSettings: @escaping (SettingsPane) -> Void) {
        let windowController = windowController ?? makeWindowController(model: model, openSettings: openSettings)
        self.windowController = windowController

        if let hostingController = windowController.contentViewController as? NSHostingController<MenuContentView> {
            hostingController.rootView = MenuContentView(model: model, openSettings: openSettings)
        }

        NSApp.activate(ignoringOtherApps: true)
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
    }

    private func makeWindowController(model: AppSession, openSettings: @escaping (SettingsPane) -> Void) -> NSWindowController {
        let hostingController = NSHostingController(rootView: MenuContentView(model: model, openSettings: openSettings))
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 336, height: 420),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "LayoutRecall Menu"
        window.contentViewController = hostingController
        window.isReleasedWhenClosed = false
        window.center()

        return NSWindowController(window: window)
    }
}

@MainActor
final class StartupWindowPresenter {
    private var launchObserver: NSObjectProtocol?
    private var didPresentStartupWindows = false

    func scheduleIfNeeded(
        launchMode: AppLaunchMode,
        openSettingsOnLaunch: Bool,
        model: AppSession,
        settingsWindowPresenter: SettingsWindowPresenter,
        menuHarnessWindowCoordinator: MenuHarnessWindowCoordinator
    ) {
        guard launchObserver == nil else { return }

        launchObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didFinishLaunchingNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.presentStartupWindowsIfNeeded(
                    launchMode: launchMode,
                    openSettingsOnLaunch: openSettingsOnLaunch,
                    model: model,
                    settingsWindowPresenter: settingsWindowPresenter,
                    menuHarnessWindowCoordinator: menuHarnessWindowCoordinator
                )
            }
        }
    }

    private func presentStartupWindowsIfNeeded(
        launchMode: AppLaunchMode,
        openSettingsOnLaunch: Bool,
        model: AppSession,
        settingsWindowPresenter: SettingsWindowPresenter,
        menuHarnessWindowCoordinator: MenuHarnessWindowCoordinator
    ) {
        guard !didPresentStartupWindows else { return }
        didPresentStartupWindows = true
        removeLaunchObserver()

        let openSettings: (SettingsPane) -> Void = { pane in
            settingsWindowPresenter.show(pane)
        }

        if launchMode == .uiAutomationHarness {
            menuHarnessWindowCoordinator.show(model: model, openSettings: openSettings)
        }

        guard openSettingsOnLaunch else { return }

        DispatchQueue.main.async {
            openSettings(.restore)
        }
    }

    private func removeLaunchObserver() {
        guard let launchObserver else { return }
        NotificationCenter.default.removeObserver(launchObserver)
        self.launchObserver = nil
    }
}

struct LayoutRecallCommands: Commands {
    let openSettings: () -> Void

    var body: some Commands {
        CommandGroup(replacing: .appSettings) {
            Button(L10n.t("action.settingsMenu")) {
                openSettings()
            }
            .keyboardShortcut(",", modifiers: .command)
        }
    }
}
