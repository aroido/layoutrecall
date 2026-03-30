import LayoutRecallKit
import SwiftUI

private struct PaneHeader: View {
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

private struct FormHint: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct SidebarPaneButton: View {
    let pane: SettingsPane
    let selected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: pane.systemImage)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(selected ? Color.accentColor : Color.secondary)
                    .frame(width: 16)

                Text(pane.title)
                    .font(.subheadline.weight(selected ? .semibold : .medium))
                    .foregroundStyle(selected ? Color.primary : Color.secondary)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .fill(
                        selected
                            ? Color.accentColor.opacity(0.18)
                            : Color(nsColor: .controlBackgroundColor).opacity(0.001)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 11, style: .continuous)
                    .strokeBorder(
                        selected
                            ? Color.accentColor.opacity(0.18)
                            : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("settings.sidebar.\(pane.rawValue)")
    }
}

struct SettingsView: View {
    @ObservedObject var model: AppModel
    @State private var selectedPane: SettingsPane = .restore
    @State private var dangerousRestoreAction: DangerousRestoreAction?
    @State private var profilePendingDeletion: DisplayProfile?
    @State private var expandedProfileIDs: Set<UUID> = []

    init(model: AppModel, initialPane: SettingsPane = .restore) {
        self.model = model
        _selectedPane = State(initialValue: initialPane)
    }

    private var autoRestoreBinding: Binding<Bool> {
        Binding(
            get: { model.autoRestoreEnabled },
            set: { newValue in
                model.setAutoRestore(newValue)
            }
        )
    }

    private var launchAtLoginBinding: Binding<Bool> {
        Binding(
            get: { model.launchAtLoginEnabled },
            set: { newValue in
                model.setLaunchAtLogin(newValue)
            }
        )
    }

    private var automaticUpdateChecksBinding: Binding<Bool> {
        Binding(
            get: { model.automaticUpdateChecksEnabled },
            set: { newValue in
                model.setAutomaticUpdateChecks(newValue)
            }
        )
    }

    private var preferredLanguageBinding: Binding<AppLanguageOption> {
        Binding(
            get: { model.preferredLanguageOption },
            set: { newValue in
                model.setPreferredLanguage(newValue)
            }
        )
    }

    var body: some View {
        HStack(spacing: 0) {
            sidebar

            Divider()

            detailPane(for: selectedPane)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(width: 760, height: 560)
        .alert(item: $dangerousRestoreAction) { action in
            Alert(
                title: Text(action.title),
                message: Text(action.message),
                primaryButton: .default(Text(action.confirmationTitle)) {
                    model.perform(action)
                },
                secondaryButton: .cancel()
            )
        }
        .alert(item: $profilePendingDeletion) { profile in
            Alert(
                title: Text(L10n.t("profiles.delete.title")),
                message: Text(L10n.t("profiles.delete.message", profile.name)),
                primaryButton: .destructive(Text(L10n.t("profiles.delete.confirm"))) {
                    model.deleteProfile(profile.id)
                },
                secondaryButton: .cancel()
            )
        }
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(SettingsPane.allCases) { pane in
                SidebarPaneButton(
                    pane: pane,
                    selected: selectedPane == pane,
                    action: { selectedPane = pane }
                )
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(width: 220)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color(nsColor: .underPageBackgroundColor))
    }

    @ViewBuilder
    private func detailPane(for pane: SettingsPane) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PaneHeader(title: pane.title, subtitle: pane.subtitle)

                switch pane {
                case .restore:
                    restorePane
                case .profiles:
                    profilesPane
                case .shortcuts:
                    shortcutsPane
                case .diagnostics:
                    diagnosticsPane
                case .general:
                    generalPane
                }
            }
            .padding(24)
            .frame(maxWidth: 720, alignment: .leading)
        }
    }

    private var restorePane: some View {
        VStack(alignment: .leading, spacing: 18) {
            restoreOverviewCard

            restoreControlCards
        }
    }

    private var restoreControlCards: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 16) {
                autoRestoreCard
                recommendedActionsCard
            }

            VStack(alignment: .leading, spacing: 16) {
                autoRestoreCard
                recommendedActionsCard
            }
        }
    }

    private var autoRestoreCard: some View {
        GlassCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeading(
                    title: L10n.t("menu.automaticRestore"),
                    systemImage: "sparkles"
                )

                Text(model.dependencySummaryLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Toggle(L10n.t("toggle.enableAutomaticRestore"), isOn: autoRestoreBinding)
                    .toggleStyle(.switch)
                    .accessibilityIdentifier("settings.restore.autoRestore")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var recommendedActionsCard: some View {
        GlassCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeading(
                    title: L10n.t("settings.recommendedActions"),
                    systemImage: "sparkles.rectangle.stack"
                )

                Text(model.restoreActionHint)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if let action = model.restorePrimaryAction {
                    actionButton(for: action, role: .primary)
                }

                if !model.restoreSecondaryActions.isEmpty {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 10) {
                            ForEach(model.restoreSecondaryActions) { action in
                                actionButton(for: action, role: .secondary)
                            }
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(model.restoreSecondaryActions) { action in
                                actionButton(for: action, role: .secondary)
                            }
                        }
                    }
                }

                if model.canSwapDisplays {
                    Button {
                        dangerousRestoreAction = .swapLeftRight
                    } label: {
                        Label(L10n.t("action.swap"), systemImage: "arrow.left.and.right.square")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ActionButtonStyle(role: .secondary))
                    .accessibilityIdentifier("settings.restore.swap")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var restoreOverviewCard: some View {
        GlassCard(padding: 18) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 18) {
                    restoreOverviewContent

                    if !model.referenceDisplays.isEmpty {
                        DisplayLayoutPreview(
                            displays: model.referenceDisplays,
                            primaryDisplayKey: model.referencePrimaryDisplayKey
                        )
                        .frame(width: 160, height: 100)
                    }
                }

                VStack(alignment: .leading, spacing: 16) {
                    restoreOverviewContent

                    if !model.referenceDisplays.isEmpty {
                        DisplayLayoutPreview(
                            displays: model.referenceDisplays,
                            primaryDisplayKey: model.referencePrimaryDisplayKey
                        )
                        .frame(height: 112)
                    }
                }
            }
        }
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
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .center, spacing: 12) {
                        restoreMatchedBaselineSummary(profile: profile)

                        Spacer(minLength: 0)

                        Button {
                            model.identifyDisplays(for: profile.id)
                        } label: {
                            Label(L10n.t("action.identifyDisplays"), systemImage: "number.square")
                                .lineLimit(1)
                                .minimumScaleFactor(0.9)
                        }
                        .buttonStyle(ActionButtonStyle(role: .secondary))
                    }
                }
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

    private var profilesPane: some View {
        VStack(alignment: .leading, spacing: 16) {
            GlassCard(padding: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeading(
                        title: L10n.t("action.save"),
                        systemImage: "square.and.arrow.down"
                    )

                    Text(L10n.t("profiles.save.hint"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Button {
                        model.saveCurrentLayout()
                    } label: {
                        Label(L10n.t("action.save"), systemImage: "square.and.arrow.down")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(ActionButtonStyle(role: .primary))
                    .accessibilityIdentifier("settings.profiles.save")
                }
            }

            if model.profiles.isEmpty {
                GroupBox {
                    Text(L10n.t("profiles.empty"))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } label: {
                    Label(L10n.t("section.profiles"), systemImage: "square.stack.3d.up.fill")
                }
            } else {
                ForEach(model.profiles) { profile in
                    profileCard(for: profile)
                }
            }
        }
        .onAppear(perform: primeExpandedProfilesIfNeeded)
    }

    private func profileCard(for profile: DisplayProfile) -> some View {
        let isReferenceProfile = model.referenceProfile?.id == profile.id
        let sortedDisplays = profile.displaySet.displays.sorted(by: DisplaySnapshot.positionComparator(lhs:rhs:))

        return GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .center, spacing: 10) {
                        profileNameField(for: profile)

                        if isReferenceProfile {
                            StatusPill(
                                text: L10n.t("profiles.badge.reference"),
                                systemImage: "checkmark.circle.fill",
                                emphasis: true
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        profileNameField(for: profile)

                        if isReferenceProfile {
                            StatusPill(
                                text: L10n.t("profiles.badge.reference"),
                                systemImage: "checkmark.circle.fill",
                                emphasis: true
                            )
                        }
                    }
                }

                Text(L10n.t("profiles.savedAt", profile.createdAt.formatted(date: .abbreviated, time: .omitted)))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                AdaptiveGroup {
                    StatusPill(
                        text: L10n.t("settings.profileDisplayCountCompact", profile.displaySet.count),
                        systemImage: "rectangle.on.rectangle"
                    )

                    StatusPill(
                        text: profile.settings.autoRestore
                            ? L10n.t("status.badge.autoRestoreOn")
                            : L10n.t("status.badge.autoRestoreOff"),
                        systemImage: "sparkles",
                        emphasis: profile.settings.autoRestore
                    )

                    StatusPill(
                        text: L10n.t("confidence.threshold.short", profile.settings.confidenceThreshold),
                        systemImage: "dial.medium"
                    )
                }

                DisclosureGroup(
                    isExpanded: profileExpansionBinding(for: profile),
                    content: {
                        ViewThatFits(in: .horizontal) {
                            HStack(alignment: .top, spacing: 18) {
                                DisplayLayoutPreview(
                                    displays: sortedDisplays,
                                    primaryDisplayKey: model.primaryDisplayKey(for: profile)
                                )
                                .frame(width: 214, height: 132)

                                profileLayoutDetails(for: profile, displays: sortedDisplays)
                            }

                            VStack(alignment: .leading, spacing: 16) {
                                DisplayLayoutPreview(
                                    displays: sortedDisplays,
                                    primaryDisplayKey: model.primaryDisplayKey(for: profile)
                                )
                                .frame(height: 132)

                                profileLayoutDetails(for: profile, displays: sortedDisplays)
                            }
                        }
                        .padding(.top, 8)
                    },
                    label: {
                        Label(L10n.t("profiles.details"), systemImage: "rectangle.3.group")
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)
                .contentShape(Rectangle())
                .accessibilityIdentifier("settings.profile.disclosure.\(profile.id.uuidString)")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    isReferenceProfile
                        ? Color.accentColor.opacity(0.22)
                        : Color.clear,
                    lineWidth: 1
                )
        )
    }

    private func primeExpandedProfilesIfNeeded() {
        guard expandedProfileIDs.isEmpty else { return }

        if model.profiles.count == 1, let onlyProfile = model.profiles.first {
            expandedProfileIDs.insert(onlyProfile.id)
        }

        if let referenceProfile = model.referenceProfile {
            expandedProfileIDs.insert(referenceProfile.id)
        }
    }

    private func profileExpansionBinding(for profile: DisplayProfile) -> Binding<Bool> {
        Binding(
            get: { expandedProfileIDs.contains(profile.id) },
            set: { isExpanded in
                if isExpanded {
                    expandedProfileIDs.insert(profile.id)
                } else {
                    expandedProfileIDs.remove(profile.id)
                }
            }
        )
    }

    private func profileLayoutDetails(
        for profile: DisplayProfile,
        displays: [DisplaySnapshot]
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                FormHint(text: L10n.t("profiles.preview.hint"))

                DisplayLegendList(
                    displays: displays,
                    primaryDisplayKey: model.primaryDisplayKey(for: profile)
                )
            }

            profileControls(for: profile)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func profileNameField(for profile: DisplayProfile) -> some View {
        TextField(
            L10n.t("field.profileName"),
            text: Binding(
                get: { profile.name },
                set: { model.renameProfile(profile.id, to: $0) }
            )
        )
        .textFieldStyle(.roundedBorder)
        .frame(maxWidth: .infinity)
    }

    private func profileControls(for profile: DisplayProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Button {
                model.identifyDisplays(for: profile.id)
            } label: {
                Label(L10n.t("action.identifyDisplays"), systemImage: "number.square.fill")
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(ActionButtonStyle(role: .secondary))
            .disabled(profile.displaySet.displays.isEmpty)

            Toggle(
                L10n.t("profiles.autoRestore.toggle"),
                isOn: Binding(
                    get: { profile.settings.autoRestore },
                    set: { model.setProfileAutoRestore(profile.id, to: $0) }
                )
            )
            .toggleStyle(.switch)

            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.t("profiles.confidence.label"))
                    .font(.subheadline.weight(.semibold))

                HStack(spacing: 12) {
                    Slider(
                        value: Binding(
                            get: { Double(profile.settings.confidenceThreshold) },
                            set: { model.setConfidenceThreshold(profile.id, to: Int($0.rounded())) }
                        ),
                        in: 50...100,
                        step: 1
                    )

                    Text(L10n.t("confidence.threshold.short", profile.settings.confidenceThreshold))
                        .font(.caption.weight(.semibold))
                        .monospacedDigit()
                        .frame(width: 52, alignment: .trailing)
                }

                FormHint(text: L10n.t("profiles.confidence.hint"))
            }

            HStack {
                Spacer(minLength: 0)

                Button(role: .destructive) {
                    profilePendingDeletion = profile
                } label: {
                    Label(L10n.t("profiles.delete.button"), systemImage: "trash")
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var configuredShortcuts: [(ShortcutAction, ShortcutBinding)] {
        ShortcutAction.allCases.compactMap { action in
            guard let binding = model.shortcutBinding(for: action) else {
                return nil
            }

            return (action, binding)
        }
    }

    private var shortcutsPane: some View {
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
                        FormHint(text: L10n.t("shortcuts.summary.none"))
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

    private var diagnosticsPane: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let latestEntry = model.diagnostics.first {
                GlassCard(padding: 18) {
                    VStack(alignment: .leading, spacing: 14) {
                        SectionHeading(
                            title: L10n.t("diagnostics.latest"),
                            systemImage: "waveform.path.ecg"
                        )

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
                    }
                }
            }

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
    }

    private var generalPane: some View {
        VStack(alignment: .leading, spacing: 18) {
            GlassCard(padding: 18) {
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeading(
                        title: L10n.t("general.summary.title"),
                        systemImage: "gearshape"
                    )

                    AdaptiveGroup {
                        StatusPill(
                            text: model.automaticUpdateChecksEnabled
                                ? L10n.t("general.badge.updatesOn")
                                : L10n.t("general.badge.updatesOff"),
                            systemImage: "arrow.triangle.2.circlepath",
                            emphasis: model.automaticUpdateChecksEnabled
                        )

                        StatusPill(
                            text: model.launchAtLoginEnabled
                                ? L10n.t("general.badge.launchOn")
                                : L10n.t("general.badge.launchOff"),
                            systemImage: "switch.2",
                            emphasis: model.launchAtLoginEnabled
                        )

                        if let skippedReleaseVersion = model.skippedReleaseVersion {
                            StatusPill(
                                text: L10n.t("general.badge.skipped", skippedReleaseVersion),
                                systemImage: "arrow.uturn.forward"
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        KeyValueRow(label: L10n.t("section.updates"), value: model.updateStatusTitle)
                        KeyValueRow(label: L10n.t("toggle.launchAtLogin"), value: model.loginItemLine)
                        KeyValueRow(label: L10n.t("settings.appInfo"), value: model.appVersionDescription)
                    }
                }
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Picker(L10n.t("settings.language.label"), selection: preferredLanguageBinding) {
                        Text(L10n.t("settings.language.system"))
                            .tag(AppLanguageOption.system)
                        Text(L10n.t("settings.language.korean"))
                            .tag(AppLanguageOption.korean)
                        Text(L10n.t("settings.language.english"))
                            .tag(AppLanguageOption.english)
                    }
                    .pickerStyle(.segmented)

                    FormHint(text: L10n.t("settings.language.hint"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                Label(L10n.t("settings.language.title"), systemImage: "globe")
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(L10n.t("toggle.automaticUpdates"), isOn: automaticUpdateChecksBinding)
                        .toggleStyle(.switch)
                        .accessibilityIdentifier("settings.general.automaticUpdates")

                    VStack(alignment: .leading, spacing: 4) {
                        Text(model.updateStatusTitle)
                            .font(.headline)

                        Text(model.updateStatusDetail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        if let release = model.availableUpdate,
                           let summary = release.promptSummary,
                           !summary.isEmpty
                        {
                            Text(summary)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 4)
                        }
                    }

                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 10) {
                            updateActionButtons
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            updateActionButtons
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                Label(L10n.t("section.updates"), systemImage: "arrow.triangle.2.circlepath")
            }

            GroupBox {
                VStack(alignment: .leading, spacing: 12) {
                    Toggle(L10n.t("toggle.launchAtLogin"), isOn: launchAtLoginBinding)
                        .toggleStyle(.switch)
                        .accessibilityIdentifier("settings.general.launchAtLogin")

                    FormHint(text: model.loginItemLine)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } label: {
                Label(L10n.t("toggle.launchAtLogin"), systemImage: "switch.2")
            }
        }
    }

    @ViewBuilder
    private var updateActionButtons: some View {
        Button(L10n.t("update.action.checkNow")) {
            model.checkForUpdatesNow()
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(model.updateState.isBusy)
        .accessibilityIdentifier("settings.general.checkUpdates")

        if model.canInstallAvailableUpdate {
            Button(L10n.t("update.action.install")) {
                model.installAvailableUpdate()
            }
            .buttonStyle(ActionButtonStyle(role: .primary))
            .accessibilityIdentifier("settings.general.installUpdate")
        }

        if model.availableUpdate != nil {
            Button(L10n.t("update.action.skipVersion")) {
                model.skipAvailableUpdateVersion()
            }
            .buttonStyle(ActionButtonStyle(role: .secondary))
            .disabled(model.updateState.isBusy)
            .accessibilityIdentifier("settings.general.skipVersion")
        } else if model.skippedReleaseVersion != nil {
            Button(L10n.t("update.action.clearSkip")) {
                model.clearSkippedUpdateVersion()
            }
            .buttonStyle(ActionButtonStyle(role: .secondary))
            .disabled(model.updateState.isBusy)
            .accessibilityIdentifier("settings.general.clearSkip")
        }
    }

    @ViewBuilder
    private func actionButton(for action: SurfaceAction, role: ActionButtonStyle.Role) -> some View {
        Button(action: { model.perform(action) }) {
            Label(title(for: action), systemImage: systemImage(for: action))
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: role))
        .disabled(isDisabled(action))
        .accessibilityIdentifier("settings.action.\(roleIdentifier(for: role)).\(action.rawValue)")
    }

    private func roleIdentifier(for role: ActionButtonStyle.Role) -> String {
        switch role {
        case .primary:
            return "primary"
        case .secondary:
            return "secondary"
        case .quiet:
            return "quiet"
        }
    }

    private func title(for action: SurfaceAction) -> String {
        switch action {
        case .installDependency:
            return model.installationInProgress
                ? L10n.t("dependency.installingDisplayplacer")
                : action.title
        case .fixNow, .enableAutoRestore, .saveNewProfile:
            return action.title
        }
    }

    private func systemImage(for action: SurfaceAction) -> String {
        switch action {
        case .installDependency:
            return model.installationInProgress ? "hourglass" : action.systemImage
        case .fixNow, .enableAutoRestore, .saveNewProfile:
            return action.systemImage
        }
    }

    private func isDisabled(_ action: SurfaceAction) -> Bool {
        switch action {
        case .installDependency:
            return model.installationInProgress
        case .fixNow, .saveNewProfile:
            return false
        case .enableAutoRestore:
            return !model.canEnableAutomaticRestoreAction
        }
    }
}
