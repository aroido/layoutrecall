import AppKit
import SwiftUI

@main
struct LayoutRecallApp: App {
    @NSApplicationDelegateAdaptor(AppTerminationCoordinator.self) private var terminationCoordinator
    @State private var model: AppModel

    private let launchMode: AppLaunchMode
    private let bootstrapCoordinator: BootstrapCoordinator
    private let existingInstanceCoordinator: ExistingInstanceCoordinator
    private let settingsNavigation: SettingsNavigationState
    private let settingsWindowPresenter: SettingsWindowPresenter
    private let menuHarnessWindowCoordinator: MenuHarnessWindowCoordinator
    private let startupWindowPresenter: StartupWindowPresenter

    init() {
        let launchMode = AppLaunchMode.current
        NSApplication.shared.setActivationPolicy(launchMode.activationPolicy)
        let model = makeAppModel(for: launchMode)
        let bootstrapCoordinator = BootstrapCoordinator()
        let existingInstanceCoordinator = ExistingInstanceCoordinator()
        let settingsNavigation = SettingsNavigationState()
        let settingsWindowPresenter = SettingsWindowPresenter(model: model, navigation: settingsNavigation)
        let menuHarnessWindowCoordinator = MenuHarnessWindowCoordinator()
        let startupWindowPresenter = StartupWindowPresenter()
        let openSettingsOnLaunch = RuntimeLaunchArguments.contains("--open-settings-on-launch")
            || ProcessInfo.processInfo.environment["LAYOUTRECALL_OPEN_SETTINGS_ON_LAUNCH"] == "1"

        self.launchMode = launchMode
        self.bootstrapCoordinator = bootstrapCoordinator
        self.existingInstanceCoordinator = existingInstanceCoordinator
        self.settingsNavigation = settingsNavigation
        self.settingsWindowPresenter = settingsWindowPresenter
        self.menuHarnessWindowCoordinator = menuHarnessWindowCoordinator
        self.startupWindowPresenter = startupWindowPresenter
        _model = State(initialValue: model)

        terminationCoordinator.model = model

        existingInstanceCoordinator.scheduleIfNeeded(
            launchMode: launchMode,
            settingsWindowPresenter: settingsWindowPresenter
        )
        bootstrapCoordinator.scheduleIfNeeded(model: model)

        if launchMode == .uiAutomationHarness || openSettingsOnLaunch {
            startupWindowPresenter.scheduleIfNeeded(
                launchMode: launchMode,
                openSettingsOnLaunch: openSettingsOnLaunch,
                model: model,
                settingsWindowPresenter: settingsWindowPresenter,
                menuHarnessWindowCoordinator: menuHarnessWindowCoordinator
            )
        }
    }

    var body: some Scene {
        MenuBarExtra {
            MenuContentView(
                model: model,
                openSettings: { pane in
                    settingsWindowPresenter.show(pane)
                }
            )
        } label: {
            LayoutRecallMenuBarIcon(state: model.menuStatePresentation)
        }
        .menuBarExtraStyle(.window)
        .commands {
            LayoutRecallCommands(
                openSettings: { settingsWindowPresenter.show() }
            )
        }
    }
}
