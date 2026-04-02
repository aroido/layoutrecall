import Observation
import SwiftUI

struct SettingsGeneralPane: View {
    @Bindable var model: AppModel
    @Binding var isShortcutsSectionExpanded: Bool
    @Binding var isDiagnosticsSectionExpanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            SettingsGeneralSummaryCard(model: model)
            SettingsLanguageSection(model: model)
            SettingsUpdateSection(model: model)
            SettingsLaunchAtLoginSection(model: model)
            SettingsAdvancedSection(
                model: model,
                isShortcutsSectionExpanded: $isShortcutsSectionExpanded,
                isDiagnosticsSectionExpanded: $isDiagnosticsSectionExpanded
            )
        }
    }
}
