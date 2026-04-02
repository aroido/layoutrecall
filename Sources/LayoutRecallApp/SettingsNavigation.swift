import AppKit
import Observation

@MainActor
@Observable
final class SettingsNavigationState {
    var selectedPane: SettingsPane
    var isShortcutsSectionExpanded: Bool
    var isDiagnosticsSectionExpanded: Bool

    init(initialPane: SettingsPane = .restore) {
        selectedPane = initialPane.navigationPane
        isShortcutsSectionExpanded = initialPane == .shortcuts
        isDiagnosticsSectionExpanded = initialPane == .diagnostics
    }

    func present(_ pane: SettingsPane) {
        selectedPane = pane.navigationPane
        isShortcutsSectionExpanded = pane == .shortcuts
        isDiagnosticsSectionExpanded = pane == .diagnostics
    }
}

@MainActor
final class SettingsWindowPresenter {
    private let navigation: SettingsNavigationState

    init(navigation: SettingsNavigationState) {
        self.navigation = navigation
    }

    func show(_ pane: SettingsPane = .restore) {
        navigation.present(pane)
        NSApp.activate(ignoringOtherApps: true)
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
}
