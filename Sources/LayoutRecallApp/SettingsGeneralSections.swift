import LayoutRecallKit
import Observation
import SwiftUI

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

                SettingsFormHint(text: model.appVersionDescription)
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
