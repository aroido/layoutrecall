import AppKit
import LayoutRecallKit
import SwiftUI

@MainActor
private final class SettingsWindowCoordinator: ObservableObject {
    private var windowController: NSWindowController?

    func show(model: AppModel, initialPane: SettingsPane = .restore) {
        let windowController = windowController ?? makeWindowController(model: model, initialPane: initialPane)
        self.windowController = windowController

        if let hostingController = windowController.contentViewController as? NSHostingController<SettingsView> {
            hostingController.rootView = SettingsView(model: model, initialPane: initialPane)
        }

        NSApp.activate(ignoringOtherApps: true)
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
    }

    private func makeWindowController(model: AppModel, initialPane: SettingsPane) -> NSWindowController {
        let hostingController = NSHostingController(rootView: SettingsView(model: model, initialPane: initialPane))
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 760, height: 560),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.t("action.settings")
        window.contentViewController = hostingController
        window.minSize = NSSize(width: 760, height: 560)
        window.isReleasedWhenClosed = false
        window.center()

        return NSWindowController(window: window)
    }
}

@MainActor
private final class MenuHarnessWindowCoordinator: ObservableObject {
    private var windowController: NSWindowController?

    func show(model: AppModel, openSettings: @escaping (SettingsPane) -> Void) {
        let windowController = windowController ?? makeWindowController(model: model, openSettings: openSettings)
        self.windowController = windowController

        if let hostingController = windowController.contentViewController as? NSHostingController<MenuContentView> {
            hostingController.rootView = MenuContentView(model: model, openSettings: openSettings)
        }

        NSApp.activate(ignoringOtherApps: true)
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
    }

    private func makeWindowController(model: AppModel, openSettings: @escaping (SettingsPane) -> Void) -> NSWindowController {
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
private final class StartupWindowPresenter: ObservableObject {
    private var launchObserver: NSObjectProtocol?
    private var didPresentStartupWindows = false

    func scheduleIfNeeded(
        launchMode: AppLaunchMode,
        openSettingsOnLaunch: Bool,
        model: AppModel,
        settingsWindowCoordinator: SettingsWindowCoordinator,
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
                    settingsWindowCoordinator: settingsWindowCoordinator,
                    menuHarnessWindowCoordinator: menuHarnessWindowCoordinator
                )
            }
        }
    }

    private func presentStartupWindowsIfNeeded(
        launchMode: AppLaunchMode,
        openSettingsOnLaunch: Bool,
        model: AppModel,
        settingsWindowCoordinator: SettingsWindowCoordinator,
        menuHarnessWindowCoordinator: MenuHarnessWindowCoordinator
    ) {
        guard !didPresentStartupWindows else { return }
        didPresentStartupWindows = true
        removeLaunchObserver()

        let openSettings: (SettingsPane) -> Void = { pane in
            settingsWindowCoordinator.show(model: model, initialPane: pane)
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

private struct LayoutRecallCommands: Commands {
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

@main
struct LayoutRecallApp: App {
    @StateObject private var model: AppModel
    @StateObject private var settingsWindowCoordinator: SettingsWindowCoordinator
    @StateObject private var menuHarnessWindowCoordinator: MenuHarnessWindowCoordinator
    @StateObject private var startupWindowPresenter: StartupWindowPresenter

    init() {
        let launchMode = AppLaunchMode.current
        NSApplication.shared.setActivationPolicy(launchMode.activationPolicy)
        let settingsWindowCoordinator = SettingsWindowCoordinator()
        let menuHarnessWindowCoordinator = MenuHarnessWindowCoordinator()
        let startupWindowPresenter = StartupWindowPresenter()
        let model = makeAppModel(for: launchMode)
        let openSettingsOnLaunch = RuntimeLaunchArguments.contains("--open-settings-on-launch")
            || ProcessInfo.processInfo.environment["LAYOUTRECALL_OPEN_SETTINGS_ON_LAUNCH"] == "1"

        _settingsWindowCoordinator = StateObject(wrappedValue: settingsWindowCoordinator)
        _menuHarnessWindowCoordinator = StateObject(wrappedValue: menuHarnessWindowCoordinator)
        _startupWindowPresenter = StateObject(wrappedValue: startupWindowPresenter)
        _model = StateObject(wrappedValue: model)

        if launchMode == .uiAutomationHarness || openSettingsOnLaunch {
            startupWindowPresenter.scheduleIfNeeded(
                launchMode: launchMode,
                openSettingsOnLaunch: openSettingsOnLaunch,
                model: model,
                settingsWindowCoordinator: settingsWindowCoordinator,
                menuHarnessWindowCoordinator: menuHarnessWindowCoordinator
            )
        }
    }

    var body: some Scene {
        MenuBarExtra {
            MenuContentView(
                model: model,
                openSettings: { pane in
                    settingsWindowCoordinator.show(model: model, initialPane: pane)
                }
            )
        } label: {
            LayoutRecallMenuBarIcon(state: model.menuStatePresentation)
        }
        .menuBarExtraStyle(.window)
        .commands {
            LayoutRecallCommands(
                openSettings: { settingsWindowCoordinator.show(model: model) }
            )
        }
    }
}
