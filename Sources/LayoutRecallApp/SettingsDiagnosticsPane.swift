import AppKit
import LayoutRecallKit
import Observation
import SwiftUI

struct SettingsDiagnosticsPane: View {
    @Bindable var model: AppModel
    @State private var diagnosticsReportCopied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            latestDiagnosticsCard
            runtimeSnapshotGroup
            supportFilesGroup
            recentHistoryGroup
        }
    }

    @ViewBuilder
    private var latestDiagnosticsCard: some View {
        if let latestEntry = model.diagnostics.first {
            GlassCard(padding: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(alignment: .top, spacing: 12) {
                        SectionHeading(
                            title: L10n.t("diagnostics.latest"),
                            systemImage: "waveform.path.ecg"
                        )

                        Spacer(minLength: 0)

                        copyReportButton
                    }

                    Text(latestEntry.displayTitle)
                        .font(.title3.weight(.semibold))

                    Text(latestEntry.details)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    AdaptiveGroup {
                        DiagnosticBadge(
                            text: latestEntry.outcomeSummary,
                            tone: latestEntry.outcomeTone
                        )

                        if let profileName = latestEntry.profileName {
                            DiagnosticBadge(text: profileName)
                        }

                        if let confidenceSummary = latestEntry.confidenceSummary {
                            DiagnosticBadge(text: confidenceSummary)
                        }

                        DiagnosticBadge(text: L10n.eventTypeName(latestEntry.eventType))
                        DiagnosticBadge(text: latestEntry.timestamp.formatted(date: .abbreviated, time: .shortened))
                    }

                    if diagnosticsReportCopied {
                        SettingsFormHint(text: L10n.t("diagnostics.copyReportHint"))
                    }
                }
            }
        } else {
            HStack {
                Spacer(minLength: 0)
                copyReportButton
            }
        }
    }

    private var runtimeSnapshotGroup: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                KeyValueRow(label: L10n.t("section.status"), value: model.statusLine)
                KeyValueRow(label: L10n.t("settings.referenceDependency"), value: model.dependencyLine)
                KeyValueRow(label: L10n.t("settings.referenceDisplays"), value: model.activeDisplayCountLine)
                KeyValueRow(label: L10n.t("settings.referenceProfile"), value: model.referenceProfileLine)

                if !model.lastCommand.isEmpty {
                    DisclosureGroup(L10n.t("section.lastCommand")) {
                        ScrollView(.horizontal) {
                            Text(model.lastCommand)
                                .font(.system(size: 11, design: .monospaced))
                                .textSelection(.enabled)
                                .padding(.top, 6)
                        }
                        .frame(height: 44)
                    }
                    .font(.caption.weight(.semibold))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(L10n.t("diagnostics.runtimeSnapshot"), systemImage: "terminal")
        }
    }

    private var supportFilesGroup: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(supportFileDescriptors.enumerated()), id: \.element.id) { index, item in
                    SettingsSupportFileRow(item: item)

                    if index < supportFileDescriptors.count - 1 {
                        Divider()
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(L10n.t("diagnostics.supportFiles"), systemImage: "folder")
        }
    }

    private var recentHistoryGroup: some View {
        GroupBox {
            if model.diagnostics.isEmpty {
                Text(L10n.t("diagnostics.empty"))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(Array(model.diagnostics.prefix(5).enumerated()), id: \.element.id) { index, entry in
                        GlassCard(padding: 14) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .firstTextBaseline, spacing: 8) {
                                    Text(entry.displayTitle)
                                        .font(.headline)

                                    Spacer(minLength: 8)

                                    Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }

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
                                }

                                Text(entry.details)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }

                        if index < min(model.diagnostics.count, 5) - 1 {
                            Divider()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        } label: {
            Label(L10n.t("diagnostics.recentHistory"), systemImage: "stethoscope")
        }
    }

    private var copyReportButton: some View {
        Button {
            copyDiagnosticsReport()
        } label: {
            Label(
                diagnosticsReportCopied
                    ? L10n.t("diagnostics.copyReportCopied")
                    : L10n.t("diagnostics.copyReport"),
                systemImage: diagnosticsReportCopied ? "checkmark" : "doc.on.doc"
            )
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
    }

    private var supportFileDescriptors: [SettingsSupportFileDescriptor] {
        let supportDirectory = LayoutRecallStorage.baseDirectory()

        return [
            SettingsSupportFileDescriptor(
                title: L10n.t("diagnostics.supportFolder"),
                url: supportDirectory
            ),
            SettingsSupportFileDescriptor(
                title: L10n.t("diagnostics.supportProfiles"),
                url: LayoutRecallStorage.fileURL(named: "profiles.json")
            ),
            SettingsSupportFileDescriptor(
                title: L10n.t("diagnostics.supportSettings"),
                url: LayoutRecallStorage.fileURL(named: "settings.json")
            ),
            SettingsSupportFileDescriptor(
                title: L10n.t("diagnostics.supportHistory"),
                url: LayoutRecallStorage.fileURL(named: "diagnostics.json")
            ),
            SettingsSupportFileDescriptor(
                title: L10n.t("diagnostics.supportStartupLog"),
                url: supportDirectory.appendingPathComponent("startup.log", isDirectory: false)
            ),
        ]
    }

    private func copyDiagnosticsReport() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(model.diagnosticsReportText, forType: .string)

        diagnosticsReportCopied = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            diagnosticsReportCopied = false
        }
    }
}
