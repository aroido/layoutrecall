import AppKit
import LayoutRecallKit
import Observation
import SwiftUI

struct MenuContentView: View {
    @Bindable var model: AppModel
    let openSettings: (SettingsPane) -> Void
    @State private var hasAnimatedIn = false

    private var recoverySurface: RecoverySurfacePresentation {
        model.recoverySurfacePresentation
    }

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

                if let action = recoverySurface.primaryAction, shouldShowPrimaryActionButton(for: action) {
                    primaryActionButton(for: action)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                quickControlSection
                    .transition(.opacity.combined(with: .move(edge: .bottom)))

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
            Label(model.automaticRestoreControlTitle, systemImage: "sparkles")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)

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

                Divider()
                    .padding(.vertical, 2)

                directActionGrid
            }
        }
    }

    private func shouldShowPrimaryActionButton(for action: SurfaceActionPresentation) -> Bool {
        action.action == .installDependency
    }

    private var directActionGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(minimum: 0), spacing: 10),
                GridItem(.flexible(minimum: 0), spacing: 10)
            ],
            spacing: 10
        ) {
            directActionButton(
                title: model.surfaceActionPresentation(for: .fixNow).title,
                systemImage: model.surfaceActionPresentation(for: .fixNow).systemImage,
                accessibilityIdentifier: "menu.action.fixNow",
                isDisabled: model.surfaceActionPresentation(for: .fixNow).isDisabled,
                action: model.fixNow
            )

            directActionButton(
                title: L10n.t("action.save"),
                systemImage: SurfaceAction.saveNewProfile.systemImage,
                accessibilityIdentifier: "menu.action.save",
                isDisabled: false,
                action: model.saveCurrentLayout
            )

            directActionButton(
                title: L10n.t("action.identifyDisplays"),
                systemImage: "number.square",
                accessibilityIdentifier: "menu.action.identify",
                isDisabled: model.referenceProfile == nil,
                action: {
                    guard let profile = model.referenceProfile else { return }
                    model.identifyDisplays(for: profile.id)
                }
            )

            directActionButton(
                title: L10n.t("action.swap"),
                systemImage: "arrow.left.and.right.square",
                accessibilityIdentifier: "menu.action.swap",
                isDisabled: !model.canSwapDisplays,
                action: model.swapLeftRight
            )
        }
    }

    private func directActionButton(
        title: String,
        systemImage: String,
        accessibilityIdentifier: String,
        isDisabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            actionLabel(title, systemImage: systemImage)
        }
        .buttonStyle(ActionButtonStyle(role: .secondary))
        .disabled(isDisabled)
        .accessibilityIdentifier(accessibilityIdentifier)
    }

    private func actionLabel(_ title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .lineLimit(1)
            .minimumScaleFactor(0.9)
            .frame(maxWidth: .infinity)
    }

    private var footer: some View {
        AdaptiveActionGroup {
            Button {
                openSettings(.restore)
            } label: {
                Label(L10n.t("action.settings"), systemImage: "gearshape")
            }
            .buttonStyle(ActionButtonStyle(role: .secondary))
            .accessibilityIdentifier("menu.footer.settings")

            Button {
                NSApplication.shared.terminate(nil)
            } label: {
                Label(L10n.t("action.quit"), systemImage: "xmark.circle")
            }
            .buttonStyle(ActionButtonStyle(role: .secondary))
            .accessibilityIdentifier("menu.footer.quit")
        }
    }

    @ViewBuilder
    private func primaryActionButton(for action: SurfaceActionPresentation) -> some View {
        Button(action: { model.perform(action.action) }) {
            Label(action.title, systemImage: action.systemImage)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(ActionButtonStyle(role: .primary))
        .disabled(action.isDisabled)
        .accessibilityIdentifier("menu.primary.\(action.action.rawValue)")
    }
}
