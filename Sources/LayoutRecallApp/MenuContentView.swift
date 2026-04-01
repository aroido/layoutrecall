import AppKit
import LayoutRecallKit
import SwiftUI

struct MenuContentView: View {
    @ObservedObject var model: AppModel
    let openSettings: (SettingsPane) -> Void
    @State private var hasAnimatedIn = false

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
            VStack(alignment: .leading, spacing: 10) {
                StatusPill(
                    text: model.menuStatePresentation.badgeText,
                    systemImage: model.menuStatePresentation.systemImage,
                    emphasis: model.menuPrimaryState != .healthy
                )

                VStack(alignment: .leading, spacing: 6) {
                    Text(model.menuStatusTitle)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)

                    Text(model.menuStatusSubtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                if let profile = model.referenceProfile, model.menuPrimaryState != .healthy {
                    compactReferenceSummary(for: profile)
                }
            }
            .id(model.menuTransitionKey)
            .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity), removal: .opacity))
        }
    }

    private var autoRestoreControl: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(model.automaticRestoreControlTitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(model.restoreModeLine)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Toggle(model.automaticRestoreToggleTitle, isOn: autoRestoreBinding)
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

    private func compactReferenceSummary(for profile: DisplayProfile) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(L10n.t("menu.reference"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(profile.name)
                .font(.subheadline.weight(.semibold))
                .fixedSize(horizontal: false, vertical: true)

        }
    }

    private var quickControlSection: some View {
        GlassCard(padding: 14) {
            VStack(alignment: .leading, spacing: 12) {
                autoRestoreControl

                if shouldShowSecondaryActionsRow {
                    Divider()
                        .padding(.vertical, 2)

                    compactActionRow
                }
            }
        }
    }

    private var shouldShowQuickControlSection: Bool {
        !model.profiles.isEmpty
    }

    private var shouldShowSecondaryActionsRow: Bool {
        shouldShowInlineFixNowButton
            || model.showsSwapDisplaysControl
            || shouldShowAdvancedActionsMenu
    }

    private var shouldShowInlineFixNowButton: Bool {
        model.menuPrimaryAction != .fixNow && model.canRestoreSavedProfiles
    }

    private var shouldShowAdvancedActionsMenu: Bool {
        !model.menuQuickActions.isEmpty
            || model.profiles.count > 1
            || model.referenceProfile != nil
            || model.shouldOfferDiagnosticsShortcut
    }

    private var compactActionRow: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 10) {
                if shouldShowInlineFixNowButton {
                    fixNowButton
                }

                if model.showsSwapDisplaysControl {
                    swapPositionsButton
                }

                if shouldShowAdvancedActionsMenu {
                    advancedActionsMenu
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                if shouldShowInlineFixNowButton {
                    fixNowButton
                }

                if model.showsSwapDisplaysControl {
                    swapPositionsButton
                }

                if shouldShowAdvancedActionsMenu {
                    advancedActionsMenu
                }
            }
        }
    }

    private var fixNowButton: some View {
        Button {
            model.fixNow()
        } label: {
            actionLabel(L10n.t("action.fixNow"), systemImage: "bolt.fill")
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
            actionLabel(L10n.t("action.identifyDisplays"), systemImage: "number.square")
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(model.referenceProfile == nil)
        .accessibilityIdentifier("menu.action.identify")
    }

    private var identifyDisplaysMenuItem: some View {
        Button {
            if let profile = model.referenceProfile {
                model.identifyDisplays(for: profile.id)
            }
        } label: {
            Label(L10n.t("action.identifyDisplays"), systemImage: "number.square")
        }
        .disabled(model.referenceProfile == nil)
    }

    private var swapPositionsButton: some View {
        Button {
            model.swapLeftRight()
        } label: {
            actionLabel(L10n.t("menu.swapShortcut"), systemImage: "arrow.left.and.right.square")
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(!model.canSwapDisplays)
        .help(model.swapAvailabilityLine)
        .accessibilityIdentifier("menu.action.swap")
    }

    private var advancedActionsMenu: some View {
        Menu {
            ForEach(model.menuQuickActions) { action in
                Button {
                    model.perform(action)
                } label: {
                    Label(model.menuTitle(for: action), systemImage: action.systemImage)
                }
                .disabled(isDisabled(action))
            }

            if model.profiles.count > 1 {
                Divider()

                Menu(L10n.t("menu.quickSwitch")) {
                    ForEach(model.profiles) { profile in
                        Button {
                            model.restoreProfile(profile.id)
                        } label: {
                            if model.referenceProfile?.id == profile.id {
                                Label(profile.name, systemImage: "checkmark.circle.fill")
                            } else {
                                Text(profile.name)
                            }
                        }
                        .disabled(!model.canRestoreSavedProfiles)
                    }

                    Divider()

                    Button(L10n.t("menu.quickSwitch.manageProfiles")) {
                        openSettings(.profiles)
                    }
                }
            }

            let showsUtilityActions =
                model.referenceProfile != nil
                || model.shouldOfferDiagnosticsShortcut

            if showsUtilityActions && (!model.menuQuickActions.isEmpty || model.profiles.count > 1) {
                Divider()
            }

            if model.referenceProfile != nil {
                identifyDisplaysMenuItem
            }

            if model.shouldOfferDiagnosticsShortcut {
                if model.referenceProfile != nil {
                    Divider()
                }

                Button {
                    openSettings(.diagnostics)
                } label: {
                    Label(L10n.t("action.openDiagnostics"), systemImage: "stethoscope")
                }
            }
        }
        label: {
            actionLabel(L10n.t("menu.moreActions"), systemImage: "ellipsis.circle")
        }
        .menuStyle(.borderlessButton)
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .accessibilityIdentifier("menu.action.more")
    }

    private func actionLabel(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .frame(maxWidth: .infinity)
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
            return !model.canEnableAutomaticRestoreAction
        }
    }
}
