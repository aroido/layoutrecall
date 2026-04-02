import LayoutRecallKit
import Observation
import SwiftUI

struct SettingsShortcutsPane: View {
    @Bindable var model: AppModel

    private var configuredShortcuts: [(ShortcutAction, ShortcutBinding)] {
        ShortcutAction.allCases.compactMap { action in
            guard let binding = model.shortcutBinding(for: action) else {
                return nil
            }

            return (action, binding)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassCard(padding: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading(
                        title: L10n.t("shortcuts.summary.title"),
                        systemImage: "command"
                    )

                    Text(
                        L10n.t(
                            "shortcuts.summary.count",
                            configuredShortcuts.count,
                            ShortcutAction.allCases.count
                        )
                    )
                    .font(.headline)

                    if configuredShortcuts.isEmpty {
                        SettingsFormHint(text: L10n.t("shortcuts.summary.none"))
                    } else {
                        AdaptiveGroup {
                            ForEach(configuredShortcuts, id: \.0.rawValue) { action, binding in
                                StatusPill(
                                    text: "\(binding.displayString) · \(action.title)",
                                    systemImage: "keyboard"
                                )
                            }
                        }
                    }
                }
            }

            ForEach(ShortcutAction.allCases, id: \.rawValue) { action in
                let binding = model.shortcutBinding(for: action)

                GlassCard(padding: 16) {
                    ShortcutRecorderRow(
                        title: action.title,
                        detail: action.detail,
                        binding: binding,
                        onChange: { model.setShortcut($0, for: action) }
                    )
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(
                            binding == nil
                                ? Color.clear
                                : Color.accentColor.opacity(0.18),
                            lineWidth: 1
                        )
                )
            }
        }
    }
}
