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

struct SettingsSupportFileDescriptor: Identifiable {
    let title: String
    let url: URL

    var id: String { title }
    var exists: Bool { FileManager.default.fileExists(atPath: url.path) }
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
