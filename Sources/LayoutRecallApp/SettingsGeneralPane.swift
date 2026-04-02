import Observation
import SwiftUI

struct SettingsGeneralPane: View {
    @Bindable var model: AppModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            SettingsLanguageSection(model: model)
            SettingsShortcutsPane(model: model)
            SettingsLaunchAtLoginSection(model: model)
            SettingsUpdateSection(model: model)
        }
    }
}
