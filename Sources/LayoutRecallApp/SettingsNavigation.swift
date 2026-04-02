import AppKit
import LayoutRecallKit
import Observation
import SwiftUI

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
    private let model: AppModel
    private let navigation: SettingsNavigationState
    private var windowController: NSWindowController?

    init(model: AppModel, navigation: SettingsNavigationState) {
        self.model = model
        self.navigation = navigation
    }

    func show(_ pane: SettingsPane = .restore) {
        navigation.present(pane)
        let windowController = windowController ?? makeWindowController()
        self.windowController = windowController

        if let hostingController = windowController.contentViewController as? NSHostingController<SettingsView> {
            hostingController.rootView = SettingsView(model: model, navigation: navigation)
        }

        NSApp.activate(ignoringOtherApps: true)
        windowController.showWindow(nil)
        windowController.window?.makeKeyAndOrderFront(nil)
    }

    var window: NSWindow? {
        windowController?.window
    }

    private func makeWindowController() -> NSWindowController {
        let hostingController = NSHostingController(rootView: SettingsView(model: model, navigation: navigation))
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 760, height: 560),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = L10n.t("action.settings")
        window.contentViewController = hostingController
        window.isReleasedWhenClosed = false
        window.setFrameAutosaveName("LayoutRecallSettingsWindow")
        window.center()

        return NSWindowController(window: window)
    }
}
