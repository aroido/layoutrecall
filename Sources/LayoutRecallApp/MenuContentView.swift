import AppKit
import LayoutRecallKit
import SwiftUI

struct MenuContentView: View {
    @ObservedObject var model: AppModel
    let openSettings: (SettingsPane) -> Void
    @State private var hasAnimatedIn = false
    @State private var quickSwitchExpanded = false
    @State private var dangerousRestoreAction: DangerousRestoreAction?
    private let quickSwitchVisibleLimit = 4

    private var autoRestoreBinding: Binding<Bool> {
        Binding(
            get: { model.autoRestoreEnabled },
            set: { newValue in
                model.setAutoRestore(newValue)
            }
        )
    }

    var body: some View {
        ZStack {
            AppChromeBackground()

            VStack(alignment: .leading, spacing: 12) {
                header
                statusBlock

                if let action = model.menuPrimaryAction {
                    primaryActionButton(for: action)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                if shouldShowQuickControlSection {
                    quickControlSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if model.profiles.count > 1 {
                    quickSwitchSection
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                if let action = dangerousRestoreAction {
                    inlineDangerousActionConfirmation(for: action)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Divider()
                    .padding(.top, 2)

                footer
            }
            .padding(14)
            .offset(y: hasAnimatedIn ? 0 : 6)
            .opacity(hasAnimatedIn ? 1 : 0.96)
        }
        .frame(width: 316)
        .onAppear {
            guard !hasAnimatedIn else { return }
            withAnimation(.spring(response: 0.34, dampingFraction: 0.88)) {
                hasAnimatedIn = true
            }
        }
        .animation(.spring(response: 0.30, dampingFraction: 0.84), value: model.menuTransitionKey)
    }

    private var header: some View {
        HStack(spacing: 10) {
            Text(L10n.t("app.name"))
                .font(.headline.weight(.semibold))

            Spacer(minLength: 0)

            LayoutRecallSymbol(
                tone: model.menuPrimaryState == .healthy ? .brand : .template,
                lineWidth: 1.9
            )
                .frame(width: 20, height: 20)
                .opacity(model.menuPrimaryState == .healthy ? 0.94 : 0.76)
        }
    }

    private var statusBlock: some View {
        GlassCard(padding: 14) {
            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 12) {
                    statusBanner

                    VStack(alignment: .leading, spacing: 6) {
                        Text(model.menuStatusTitle)
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)

                        Text(model.menuStatusSubtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        if let profile = model.referenceProfile {
                            compactReferenceSummary(for: profile)
                                .padding(.top, 4)
                        }
                    }

                    if model.menuShouldShowEvidencePills {
                        evidencePills
                    }

                    if let metadataLine = model.menuReferenceMetadataLine,
                       model.referenceProfile == nil
                    {
                        Text(metadataLine)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .id(model.menuTransitionKey)
                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .opacity))
            }
        }
    }

    private var autoRestoreControl: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(L10n.t("menu.automaticRestore"))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(model.restoreModeLine)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Toggle("", isOn: autoRestoreBinding)
                .labelsHidden()
                .toggleStyle(.switch)
                .disabled(model.profiles.isEmpty)
                .accessibilityIdentifier("menu.toggle.autoRestore")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(nsColor: .underPageBackgroundColor).opacity(0.72))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color(nsColor: .separatorColor).opacity(0.24), lineWidth: 1)
                )
        )
    }

    private var statusBanner: some View {
        HStack(alignment: .center, spacing: 10) {
            StatusPill(
                text: model.menuStatePresentation.badgeText,
                systemImage: model.menuStatePresentation.systemImage,
                emphasis: model.menuPrimaryState != .healthy
            )

            Spacer(minLength: 0)

            if model.menuShowsRecentActivity,
               let recentActivityLine = model.menuRecentActivityLine
            {
                Text(recentActivityLine)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private func compactReferenceSummary(for profile: DisplayProfile) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L10n.t("menu.reference"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(profile.name)
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

            if model.profiles.count > 1 {
                Text(L10n.t("menu.meta.profileCount", model.profiles.count))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var evidencePills: some View {
        AdaptiveGroup {
            if model.menuShowsDependencyBadge {
                StatusPill(
                    text: model.dependencyBadgeText,
                    systemImage: model.installationInProgress ? "hourglass" : "shippingbox",
                    emphasis: false
                )
            }

            if model.menuShowsDisplayBadge {
                StatusPill(
                    text: model.displayBadgeText,
                    systemImage: "rectangle.on.rectangle"
                )
            }

            if let confidenceBadgeText = model.menuConfidenceBadgeTextForMenu {
                StatusPill(
                    text: confidenceBadgeText,
                    systemImage: "checkmark.seal",
                    emphasis: model.confidencePresentation == .high
                )
            }
        }
    }

    private var quickControlSection: some View {
        GlassCard(padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                autoRestoreControl

                if shouldShowSecondaryActions {
                    Divider()
                        .padding(.vertical, 2)

                    SectionHeading(
                        title: L10n.t("menu.actions"),
                        systemImage: "bolt.circle"
                    )

                    LazyVGrid(
                        columns: mainActionColumns,
                        alignment: .leading,
                        spacing: 10
                    ) {
                        ForEach(model.menuQuickActions) { action in
                            secondaryActionButton(for: action)
                        }

                        if shouldShowInlineFixNowButton {
                            fixNowButton
                        }

                        if model.referenceProfile != nil {
                            identifyDisplaysButton
                        }

                        if model.canSwapDisplays {
                            swapDisplaysButton
                        }
                    }
                }
            }
        }
    }

    private var mainActionColumns: [GridItem] {
        let secondaryActionCount =
            model.menuQuickActions.count
            + (shouldShowInlineFixNowButton ? 1 : 0)
            + (model.referenceProfile == nil ? 0 : 1)
            + (model.canSwapDisplays ? 1 : 0)
        let columnCount = max(1, min(2, secondaryActionCount))
        return Array(repeating: GridItem(.flexible(minimum: 120), spacing: 10), count: columnCount)
    }

    private var shouldShowQuickControlSection: Bool {
        !model.profiles.isEmpty
    }

    private var shouldShowSecondaryActions: Bool {
        !model.menuQuickActions.isEmpty
            || shouldShowInlineFixNowButton
            || model.referenceProfile != nil
            || model.canSwapDisplays
    }

    private var shouldShowInlineFixNowButton: Bool {
        model.menuPrimaryAction != .fixNow && model.canRestoreSavedProfiles
    }

    @ViewBuilder
    private func secondaryActionButton(for action: SurfaceAction) -> some View {
        Button(action: { model.perform(action) }) {
            Label(model.menuTitle(for: action), systemImage: action.systemImage)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(isDisabled(action))
        .accessibilityIdentifier(secondaryActionIdentifier(for: action))
    }

    private func secondaryActionIdentifier(for action: SurfaceAction) -> String {
        switch action {
        case .installDependency:
            return "menu.action.installDependency"
        case .fixNow:
            return "menu.action.fixNow"
        case .enableAutoRestore:
            return "menu.action.enableAutoRestore"
        case .saveNewProfile:
            return "menu.action.save"
        }
    }

    private var fixNowButton: some View {
        Button {
            model.fixNow()
        } label: {
            Label(L10n.t("action.fixNow"), systemImage: "bolt.fill")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(!model.canRestoreSavedProfiles || model.menuPrimaryState == .noMatch)
        .accessibilityIdentifier("menu.action.fixNow")
    }

    private var identifyDisplaysButton: some View {
        Button {
            if let profile = model.referenceProfile {
                model.identifyDisplays(for: profile.id)
            }
        } label: {
            Label(L10n.t("action.identifyDisplays"), systemImage: "number.square")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(model.referenceProfile == nil)
        .accessibilityIdentifier("menu.action.identify")
    }

    private var swapDisplaysButton: some View {
        Button {
            dangerousRestoreAction = .swapLeftRight
        } label: {
            Label(L10n.t("menu.swapShortcut"), systemImage: "arrow.left.and.right.square")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(!model.canSwapDisplays)
        .accessibilityIdentifier("menu.action.swap")
    }

    private var quickSwitchSection: some View {
        GlassCard(padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        SectionHeading(
                            title: L10n.t("menu.quickSwitch"),
                            systemImage: "rectangle.2.swap"
                        )

                        Text(L10n.t("menu.meta.profileCount", model.profiles.count))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 0)

                    Button(L10n.t("menu.quickSwitch.manageProfiles")) {
                        openSettings(.profiles)
                    }
                    .buttonStyle(InlineActionButtonStyle(accent: true))
                }

                DisclosureGroup(isExpanded: $quickSwitchExpanded) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(visibleQuickSwitchEntries, id: \.element.id) { index, profile in
                            Button {
                                model.restoreProfile(profile.id)
                            } label: {
                                HStack(spacing: 10) {
                                    Text("\(index + 1)")
                                        .font(.caption2.weight(.bold))
                                        .monospacedDigit()
                                        .foregroundStyle(.secondary)
                                        .frame(width: 18)

                                    Text(L10n.t("menu.profileShortcut", index + 1, profile.name))
                                        .lineLimit(1)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    if model.referenceProfile?.id == profile.id {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(Color.accentColor)
                                    }
                                }
                            }
                            .buttonStyle(ActionButtonStyle(role: .secondary))
                            .disabled(!model.canRestoreSavedProfiles)
                            .accessibilityIdentifier("menu.profile.\(profile.id.uuidString)")
                        }

                        if hiddenQuickSwitchCount > 0 {
                            Label(
                                L10n.t("menu.quickSwitch.moreProfiles", hiddenQuickSwitchCount),
                                systemImage: "ellipsis.circle"
                            )
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 8)
                } label: {
                    Text(L10n.t("section.profiles"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var visibleQuickSwitchEntries: [(offset: Int, element: DisplayProfile)] {
        Array(model.profiles.enumerated().prefix(quickSwitchVisibleLimit))
    }

    private var hiddenQuickSwitchCount: Int {
        max(0, model.profiles.count - visibleQuickSwitchEntries.count)
    }

    private func inlineDangerousActionConfirmation(for action: DangerousRestoreAction) -> some View {
        GlassCard(padding: 14) {
            VStack(alignment: .leading, spacing: 10) {
                Text(action.title)
                    .font(.headline.weight(.semibold))

                Text(action.message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    Button(L10n.t("action.cancel")) {
                        dangerousRestoreAction = nil
                    }
                    .buttonStyle(ActionButtonStyle(role: .secondary))

                    Button(action.confirmationTitle) {
                        model.perform(action)
                        dangerousRestoreAction = nil
                    }
                    .buttonStyle(ActionButtonStyle(role: .primary))
                }
            }
        }
    }

    private var footer: some View {
        HStack {
            Button(L10n.t("action.settings")) {
                openSettings(.restore)
            }
            .buttonStyle(InlineActionButtonStyle())
            .accessibilityIdentifier("menu.footer.settings")

            Spacer()

            Button(L10n.t("action.quit")) {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(InlineActionButtonStyle())
            .accessibilityIdentifier("menu.footer.quit")
        }
    }

    @ViewBuilder
    private func primaryActionButton(for action: SurfaceAction) -> some View {
        Button(action: { model.perform(action) }) {
            Label(
                model.menuTitle(for: action),
                systemImage: action == .installDependency && model.installationInProgress
                    ? "hourglass"
                    : action.systemImage
            )
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .primary))
        .disabled(isDisabled(action))
        .accessibilityIdentifier("menu.primary.\(action.rawValue)")
    }

    private func isDisabled(_ action: SurfaceAction) -> Bool {
        switch action {
        case .installDependency:
            return model.installationInProgress
        case .fixNow, .saveNewProfile:
            return false
        case .enableAutoRestore:
            return model.autoRestoreEnabled || model.profiles.isEmpty
        }
    }
}
