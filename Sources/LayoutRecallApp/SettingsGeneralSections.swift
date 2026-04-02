import AppKit
import LayoutRecallKit
import Observation
import SwiftUI

struct SettingsGeneralSummaryCard: View {
    @Bindable var model: AppModel

    var body: some View {
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
    }
}

struct SettingsLanguageSection: View {
    @Bindable var model: AppModel

    var body: some View {
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

                SettingsFormHint(text: L10n.t("settings.language.hint"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(L10n.t("settings.language.title"), systemImage: "globe")
        }
    }

    private var preferredLanguageBinding: Binding<AppLanguageOption> {
        Binding(
            get: { model.preferredLanguageOption },
            set: { model.setPreferredLanguage($0) }
        )
    }
}

struct SettingsUpdateSection: View {
    @Bindable var model: AppModel

    var body: some View {
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

                AdaptiveActionGroup {
                    updateActionButtons
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(L10n.t("section.updates"), systemImage: "arrow.triangle.2.circlepath")
        }
    }

    private var automaticUpdateChecksBinding: Binding<Bool> {
        Binding(
            get: { model.automaticUpdateChecksEnabled },
            set: { model.setAutomaticUpdateChecks($0) }
        )
    }

    @ViewBuilder
    private var updateActionButtons: some View {
        SettingsActionButton(
            title: L10n.t("update.action.checkNow"),
            systemImage: "arrow.triangle.2.circlepath",
            role: .secondary,
            isDisabled: model.updateState.isBusy,
            accessibilityIdentifier: "settings.general.checkUpdates"
        ) {
            model.checkForUpdatesNow()
        }

        if model.canInstallAvailableUpdate {
            SettingsActionButton(
                title: L10n.t("update.action.install"),
                systemImage: "arrow.down.circle",
                role: .primary,
                accessibilityIdentifier: "settings.general.installUpdate"
            ) {
                model.installAvailableUpdate()
            }
        }

        if model.availableUpdate != nil {
            SettingsActionButton(
                title: L10n.t("update.action.skipVersion"),
                systemImage: "arrow.uturn.forward",
                role: .secondary,
                isDisabled: model.updateState.isBusy,
                accessibilityIdentifier: "settings.general.skipVersion"
            ) {
                model.skipAvailableUpdateVersion()
            }
        } else if model.skippedReleaseVersion != nil {
            SettingsActionButton(
                title: L10n.t("update.action.clearSkip"),
                systemImage: "arrow.counterclockwise",
                role: .secondary,
                isDisabled: model.updateState.isBusy,
                accessibilityIdentifier: "settings.general.clearSkip"
            ) {
                model.clearSkippedUpdateVersion()
            }
        }
    }
}

struct SettingsLaunchAtLoginSection: View {
    @Bindable var model: AppModel

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Toggle(L10n.t("toggle.launchAtLogin"), isOn: launchAtLoginBinding)
                    .toggleStyle(.switch)
                    .accessibilityIdentifier("settings.general.launchAtLogin")

                SettingsFormHint(text: model.loginItemLine)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } label: {
            Label(L10n.t("toggle.launchAtLogin"), systemImage: "switch.2")
        }
    }

    private var launchAtLoginBinding: Binding<Bool> {
        Binding(
            get: { model.launchAtLoginEnabled },
            set: { model.setLaunchAtLogin($0) }
        )
    }
}

struct SettingsAdvancedSection: View {
    @Bindable var model: AppModel
    @Binding var isShortcutsSectionExpanded: Bool
    @Binding var isDiagnosticsSectionExpanded: Bool

    var body: some View {
        GlassCard(padding: 18) {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeading(
                    title: L10n.t("settings.advanced.title"),
                    systemImage: "slider.horizontal.3"
                )

                SettingsFormHint(text: L10n.t("settings.advanced.hint"))

                askBeforeRestoreSection

                if model.showsSwapDisplaysControl {
                    Divider()
                    swapDisplaysSection
                }

                DisclosureGroup(
                    isExpanded: $isShortcutsSectionExpanded,
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            SettingsShortcutsPane(model: model)
                        }
                        .padding(.top, 12)
                    },
                    label: {
                        Label(SettingsPane.shortcuts.title, systemImage: SettingsPane.shortcuts.systemImage)
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)

                DisclosureGroup(
                    isExpanded: $isDiagnosticsSectionExpanded,
                    content: {
                        VStack(alignment: .leading, spacing: 16) {
                            SettingsDiagnosticsPane(model: model)
                        }
                        .padding(.top, 12)
                    },
                    label: {
                        Label(SettingsPane.diagnostics.title, systemImage: SettingsPane.diagnostics.systemImage)
                    }
                )
                .font(.subheadline.weight(.semibold))
                .tint(Color.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var askBeforeRestoreSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.askBeforeRestoreControlTitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Toggle(model.askBeforeRestoreToggleTitle, isOn: askBeforeRestoreBinding)
                .toggleStyle(.switch)
                .disabled(!model.autoRestoreEnabled || model.profiles.isEmpty)
                .accessibilityIdentifier("settings.general.askBeforeRestore")

            SettingsFormHint(text: L10n.t("settings.restore.askBeforeRestoreHint"))
        }
    }

    private var swapDisplaysSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.t("action.swap"))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            SettingsFormHint(text: model.swapAvailabilityLine)

            SettingsActionButton(
                title: L10n.t("action.swap"),
                systemImage: "arrow.left.and.right.square",
                role: .secondary,
                isDisabled: !model.canSwapDisplays,
                accessibilityIdentifier: "settings.general.swap"
            ) {
                model.swapLeftRight()
            }
        }
    }

    private var askBeforeRestoreBinding: Binding<Bool> {
        Binding(
            get: { model.askBeforeAutomaticRestoreEnabled },
            set: { model.setAskBeforeAutomaticRestore($0) }
        )
    }
}
