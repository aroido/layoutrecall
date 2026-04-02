import Observation
import SwiftUI

struct SettingsView: View {
    @Bindable var model: AppModel
    @Bindable var navigation: SettingsNavigationState

    init(model: AppModel, navigation: SettingsNavigationState) {
        self.model = model
        self.navigation = navigation
    }

    init(model: AppModel, initialPane: SettingsPane = .restore) {
        self.init(
            model: model,
            navigation: SettingsNavigationState(initialPane: initialPane)
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar

            Divider()

            detailPane(for: navigation.selectedPane)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(width: 760, height: 560)
    }

    private var sidebarSelection: Binding<SettingsPane?> {
        Binding(
            get: { navigation.selectedPane },
            set: { newValue in
                guard let newValue else { return }
                navigation.present(newValue)
            }
        )
    }

    private var sidebar: some View {
        List(selection: sidebarSelection) {
            ForEach(SettingsPane.primaryNavigationPanes) { pane in
                Label(pane.title, systemImage: pane.systemImage)
                    .tag(Optional(pane))
                    .accessibilityIdentifier("settings.sidebar.\(pane.rawValue)")
            }
        }
        .listStyle(.sidebar)
        .scrollContentBackground(.hidden)
        .frame(width: 220)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(nsColor: .underPageBackgroundColor))
    }

    @ViewBuilder
    private func detailPane(for pane: SettingsPane) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                SettingsPaneHeader(title: pane.title, subtitle: pane.subtitle)

                switch pane {
                case .restore, .diagnostics:
                    SettingsRestorePane(
                        model: model,
                        isDiagnosticsSectionExpanded: $navigation.isDiagnosticsSectionExpanded,
                        openDiagnostics: openDiagnosticsSection
                    )
                case .profiles:
                    SettingsProfilesPane(model: model)
                case .general, .shortcuts:
                    SettingsGeneralPane(model: model)
                }
            }
            .padding(24)
            .frame(maxWidth: 720, alignment: .leading)
        }
    }

    private func openDiagnosticsSection() {
        navigation.present(.diagnostics)
    }
}
