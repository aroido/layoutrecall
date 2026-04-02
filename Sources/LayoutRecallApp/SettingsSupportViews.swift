import Foundation
import LayoutRecallKit
import SwiftUI

struct SettingsPaneHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.title2.weight(.semibold))

            Text(subtitle)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct SettingsFormHint: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct AdaptivePairLayout<Primary: View, Secondary: View>: View {
    var horizontalAlignment: VerticalAlignment = .top
    var horizontalSpacing: CGFloat = 14
    var verticalSpacing: CGFloat = 14
    var horizontalPrimaryWidth: CGFloat?
    @ViewBuilder let primary: () -> Primary
    @ViewBuilder let secondary: () -> Secondary

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: horizontalAlignment, spacing: horizontalSpacing) {
                primary()
                    .frame(width: horizontalPrimaryWidth)
                secondary()
            }

            VStack(alignment: .leading, spacing: verticalSpacing) {
                primary()
                secondary()
            }
        }
    }
}

struct SettingsActionButton: View {
    let title: String
    let systemImage: String
    let role: ActionButtonStyle.Role
    var isDisabled = false
    var accessibilityIdentifier: String?
    var helpText: String?
    var expandsToFillWidth = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .frame(maxWidth: expandsToFillWidth ? .infinity : nil)
        }
        .buttonStyle(ActionButtonStyle(role: role))
        .disabled(isDisabled)
        .modifier(AccessibilityIdentifierModifier(identifier: accessibilityIdentifier))
        .modifier(HelpTextModifier(helpText: helpText))
    }
}

struct DiagnosticEntrySummaryView: View {
    enum Style {
        case featured
        case history
    }

    let entry: DiagnosticsEntry
    let style: Style

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            switch style {
            case .featured:
                Text(entry.displayTitle)
                    .font(.title3.weight(.semibold))
            case .history:
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(entry.displayTitle)
                        .font(.headline)

                    Spacer(minLength: 8)

                    Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(entry.details)
                .font(style == .history ? .caption : .body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            AdaptiveGroup {
                DiagnosticBadge(
                    text: entry.outcomeSummary,
                    tone: entry.outcomeTone
                )

                if let profileName = entry.profileName {
                    DiagnosticBadge(text: profileName)
                }

                if let confidenceSummary = entry.confidenceSummary {
                    DiagnosticBadge(text: confidenceSummary)
                }

                DiagnosticBadge(text: L10n.eventTypeName(entry.eventType))

                if style == .featured {
                    DiagnosticBadge(text: entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                }
            }
        }
    }
}

struct SettingsSupportFileDescriptor: Identifiable {
    let title: String
    let url: URL

    var id: String { title }
    var exists: Bool { FileManager.default.fileExists(atPath: url.path) }
}

private struct AccessibilityIdentifierModifier: ViewModifier {
    let identifier: String?

    func body(content: Content) -> some View {
        if let identifier {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
}

private struct HelpTextModifier: ViewModifier {
    let helpText: String?

    func body(content: Content) -> some View {
        if let helpText {
            content.help(helpText)
        } else {
            content
        }
    }
}

struct SettingsSupportFileRow: View {
    let item: SettingsSupportFileDescriptor

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 8) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))

                DiagnosticBadge(
                    text: item.exists
                        ? L10n.t("diagnostics.fileAvailable")
                        : L10n.t("diagnostics.fileMissing"),
                    tone: item.exists ? .positive : .caution
                )

                Spacer(minLength: 0)
            }

            Text(item.url.path)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
