import LayoutRecallKit
import Observation
import SwiftUI

struct SettingsRestorePane: View {
    @Bindable var model: AppModel
    @Binding var isDiagnosticsSectionExpanded: Bool
    @State private var isLayoutComparisonExpanded = false
    @State private var hasPrimedDisclosureState = false
    let openDiagnostics: () -> Void

    private var recoverySurface: RecoverySurfacePresentation {
        model.recoverySurfacePresentation
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            restoreHeroCard
            layoutComparisonSection
            recoverySettingsCard
            diagnosticsSection
        }
        .onAppear(perform: primeDisclosureStateIfNeeded)
        .onChange(of: model.menuPrimaryState) { _, _ in
            promoteDisclosureStateIfNeeded()
        }
        .onChange(of: model.diagnosticsNeedsAttention) { _, _ in
            promoteDisclosureStateIfNeeded()
        }
    }

    private var restoreHeroCard: some View {
        GlassCard(padding: 18) {
            AdaptivePairLayout(horizontalAlignment: .top, horizontalSpacing: 20, verticalSpacing: 18, horizontalPrimaryWidth: 380) {
                restoreOverviewContent
            } secondary: {
                restoreActionPanel
            }
        }
    }

    private var layoutComparisonSection: some View {
        GlassCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeading(
                    title: L10n.t("settings.restore.comparison.title"),
                    systemImage: "rectangle.split.2x1"
                )

                Text(L10n.t("settings.restore.comparison.hint"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                DisclosureGroup(
                    isExpanded: $isLayoutComparisonExpanded,
                    content: {
                        AdaptivePairLayout(horizontalAlignment: .top, horizontalSpacing: 14, verticalSpacing: 14) {
                            currentLayoutPreviewCard
                        } secondary: {
                            savedLayoutPreviewCard
                        }
                        .padding(.top, 12)
                    },
                    label: {
                        Label(L10n.t("settings.restore.comparison.label"), systemImage: "rectangle.3.group")
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var currentLayoutPreviewCard: some View {
        SettingsLayoutPreviewCard(
            title: L10n.t("settings.preview.currentLayout"),
            subtitle: model.activeDisplayCountLine,
            displays: model.liveDisplaysForPreview,
            primaryDisplayKey: model.livePrimaryDisplayKey,
            emptyMessage: L10n.t("settings.preview.currentLayoutEmpty")
        )
    }

    private var savedLayoutPreviewCard: some View {
        let subtitle: String
        if let profile = model.referenceProfile {
            subtitle = "\(profile.name) · \(L10n.t("settings.profileDisplayCountCompact", profile.displaySet.count))"
        } else {
            subtitle = model.referenceProfileLine
        }

        return SettingsLayoutPreviewCard(
            title: L10n.t("settings.preview.savedLayout"),
            subtitle: subtitle,
            displays: model.referenceDisplays,
            primaryDisplayKey: model.referencePrimaryDisplayKey,
            emptyMessage: model.referenceProfileLine
        )
    }

    private var restoreOverviewContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeading(
                    title: L10n.t("settings.currentState"),
                    systemImage: "checkmark.circle"
                )

                Text(model.menuStatusTitle)
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)

                Text(model.menuStatusSubtitle)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            AdaptiveGroup {
                StatusPill(
                    text: model.autoRestoreBadgeText,
                    systemImage: "sparkles",
                    emphasis: model.autoRestoreEnabled
                )

                StatusPill(
                    text: model.dependencyBadgeText,
                    systemImage: model.installationInProgress ? "hourglass" : "shippingbox",
                    emphasis: model.dependencyAvailable
                )

                StatusPill(
                    text: model.displayBadgeText,
                    systemImage: "rectangle.on.rectangle"
                )

                if let confidenceBadgeText = model.confidenceBadgeText {
                    StatusPill(
                        text: confidenceBadgeText,
                        systemImage: "checkmark.seal",
                        emphasis: model.confidencePresentation == .high
                    )
                }
            }

            if let profile = model.referenceProfile {
                restoreMatchedBaselineSummary(profile: profile)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text(L10n.t("settings.referenceProfile"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Text(model.referenceProfileLine)
                        .font(.subheadline.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(model.referenceConfidenceLine)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var restoreActionPanel: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(
                title: L10n.t("settings.actions"),
                systemImage: "sparkles.rectangle.stack"
            )

            Text(recoverySurface.restoreHint)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if let action = recoverySurface.primaryAction {
                actionButton(for: action, role: .primary)
            }

            if !recoverySurface.quickActions.isEmpty {
                AdaptiveActionGroup {
                    ForEach(recoverySurface.quickActions) { action in
                        actionButton(for: action, role: .secondary)
                    }
                }
            }

            if model.shouldOfferDiagnosticsShortcut {
                Divider()
                    .padding(.vertical, 2)

                VStack(alignment: .leading, spacing: 8) {
                    Text(recoverySurface.diagnosticsShortcutHint)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button(action: openDiagnostics) {
                        Label(L10n.t("action.openDiagnostics"), systemImage: "stethoscope")
                    }
                    .buttonStyle(InlineActionButtonStyle())
                    .accessibilityIdentifier("settings.restore.diagnostics")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var autoRestoreBinding: Binding<Bool> {
        Binding(
            get: { model.autoRestoreEnabled },
            set: { model.setAutoRestore($0) }
        )
    }

    private var askBeforeRestoreBinding: Binding<Bool> {
        Binding(
            get: { model.askBeforeAutomaticRestoreEnabled },
            set: { model.setAskBeforeAutomaticRestore($0) }
        )
    }

    private var recoverySettingsCard: some View {
        GlassCard(padding: 16) {
            VStack(alignment: .leading, spacing: 14) {
                SectionHeading(
                    title: L10n.t("settings.restore.behavior.title"),
                    systemImage: "slider.horizontal.3"
                )

                Text(L10n.t("settings.restore.behavior.hint"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 8) {
                    Text(model.automaticRestoreControlTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Toggle(model.automaticRestoreToggleTitle, isOn: autoRestoreBinding)
                        .toggleStyle(.switch)
                        .accessibilityIdentifier("settings.restore.autoRestore")

                    SettingsFormHint(text: model.dependencySummaryLine)
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text(model.askBeforeRestoreControlTitle)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Toggle(model.askBeforeRestoreToggleTitle, isOn: askBeforeRestoreBinding)
                        .toggleStyle(.switch)
                        .disabled(!model.autoRestoreEnabled || model.profiles.isEmpty)
                        .accessibilityIdentifier("settings.restore.askBeforeRestore")

                    SettingsFormHint(text: L10n.t("settings.restore.askBeforeRestoreHint"))
                }

                if model.showsSwapDisplaysControl {
                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.t("settings.restore.quickAdjustments.title"))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)

                        SettingsFormHint(text: model.swapAvailabilityLine)

                        SettingsActionButton(
                            title: L10n.t("action.swap"),
                            systemImage: "arrow.left.and.right.square",
                            role: .secondary,
                            isDisabled: !model.canSwapDisplays,
                            accessibilityIdentifier: "settings.restore.swap"
                        ) {
                            model.swapLeftRight()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var diagnosticsSection: some View {
        GlassCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeading(
                    title: L10n.t("section.diagnostics"),
                    systemImage: "stethoscope"
                )

                Text(L10n.t("settings.restore.diagnostics.hint"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                DisclosureGroup(
                    isExpanded: $isDiagnosticsSectionExpanded,
                    content: {
                        SettingsDiagnosticsPane(model: model)
                            .padding(.top, 12)
                    },
                    label: {
                        Label(L10n.t("settings.restore.diagnostics.label"), systemImage: "waveform.path.ecg")
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var shouldAutoExpandLayoutComparison: Bool {
        model.menuPrimaryState != .healthy || model.referenceProfile == nil
    }

    private var shouldAutoExpandDiagnostics: Bool {
        model.diagnosticsNeedsAttention
            || model.menuPrimaryState == .lowConfidence
            || model.menuPrimaryState == .manualRecovery
    }

    private func primeDisclosureStateIfNeeded() {
        guard !hasPrimedDisclosureState else { return }
        hasPrimedDisclosureState = true
        isLayoutComparisonExpanded = shouldAutoExpandLayoutComparison

        if shouldAutoExpandDiagnostics {
            isDiagnosticsSectionExpanded = true
        }
    }

    private func promoteDisclosureStateIfNeeded() {
        if shouldAutoExpandLayoutComparison {
            isLayoutComparisonExpanded = true
        }

        if shouldAutoExpandDiagnostics {
            isDiagnosticsSectionExpanded = true
        }
    }

    private func restoreMatchedBaselineSummary(profile: DisplayProfile) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.t("settings.referenceProfile"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(profile.name)
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Text(model.activeDisplayCountLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("·")
                    .font(.caption)
                    .foregroundStyle(.tertiary)

                Text(model.referenceConfidenceLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    @ViewBuilder
    private func actionButton(for action: SurfaceActionPresentation, role: ActionButtonStyle.Role) -> some View {
        SettingsActionButton(
            title: action.title,
            systemImage: action.systemImage,
            role: role,
            isDisabled: action.isDisabled,
            accessibilityIdentifier: "settings.action.\(role.identifier).\(action.action.rawValue)",
            action: {
                model.perform(action.action)
            }
        )
    }
}

private struct SettingsLayoutPreviewCard: View {
    let title: String
    let subtitle: String
    let displays: [DisplaySnapshot]
    let primaryDisplayKey: String?
    let emptyMessage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(subtitle)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
            }

            Group {
                if displays.isEmpty {
                    Text(emptyMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
                        .padding(12)
                } else {
                    DisplayLayoutPreview(
                        displays: displays,
                        primaryDisplayKey: primaryDisplayKey
                    )
                    .frame(height: 112)
                }
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(nsColor: .underPageBackgroundColor).opacity(0.72))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color(nsColor: .separatorColor).opacity(0.24), lineWidth: 1)
                    )
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension ActionButtonStyle.Role {
    var identifier: String {
        switch self {
        case .primary:
            return "primary"
        case .secondary:
            return "secondary"
        case .quiet:
            return "quiet"
        }
    }
}
