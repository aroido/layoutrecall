import Foundation
import LayoutRecallKit

extension AppModel {
    func loadProfiles() async {
        await logStartup(
            "loadProfiles begin path=\(profileStorePath) exists=\(FileManager.default.fileExists(atPath: profileStorePath))"
        )
        do {
            let storedProfiles = try await store.loadProfiles()
            let normalizedProfiles = normalizeProfiles(storedProfiles)
            profiles = normalizedProfiles
            await logStartup(
                "loadProfiles success stored=\(storedProfiles.count) normalized=\(normalizedProfiles.count) names=\(normalizedProfiles.map { $0.name }.joined(separator: ","))"
            )

            if normalizedProfiles != storedProfiles {
                try await store.saveProfiles(normalizedProfiles)
                await logStartup("loadProfiles wrote normalized profiles back to disk")
            }
        } catch {
            statusLine = L10n.t("status.failedLoadProfiles")
            decisionLine = error.localizedDescription
            await logStartup("loadProfiles failed error=\(error.localizedDescription)")
        }
    }

    func normalizeProfiles(_ storedProfiles: [DisplayProfile]) -> [DisplayProfile] {
        storedProfiles.map { profile in
            guard let updatedPlan = try? commandBuilder.restorePlan(for: profile.displaySet.displays) else {
                return profile
            }

            var normalized = profile
            normalized.layout = LayoutDefinition(
                primaryDisplayKey: updatedPlan.primaryDisplayKey,
                expectedOrigins: updatedPlan.expectedOrigins,
                engine: LayoutEngineCommand(
                    type: profile.layout.engine.type,
                    command: updatedPlan.command
                )
            )
            return normalized
        }
    }

    func loadDiagnostics() async {
        do {
            diagnostics = try await diagnosticsStore.recentEntries()
        } catch {
            statusLine = L10n.t("status.failedLoadDiagnostics")
            decisionLine = error.localizedDescription
        }
    }

    func loadSettings() async {
        do {
            let settings = try await settingsStore.loadSettings()
            autoRestoreEnabled = settings.automaticRestoreEnabled
            askBeforeAutomaticRestoreEnabled = settings.askBeforeAutomaticRestore
            launchAtLoginEnabled = settings.launchAtLogin
            shortcuts = settings.shortcuts
            automaticUpdateChecksEnabled = settings.automaticallyCheckForUpdates
            skippedReleaseVersion = settings.skippedReleaseVersion
            preferredLanguageOption = AppLanguageOption(preferredLanguageCode: settings.preferredLanguageCode)
            L10n.setPreferredLanguageCodeOverride(settings.preferredLanguageCode)
        } catch {
            statusLine = L10n.t("status.failedLoadSettings")
            decisionLine = error.localizedDescription
        }
    }

    func persistProfiles() async {
        await logStartup("persistProfiles begin count=\(profiles.count) path=\(profileStorePath)")
        do {
            try await store.saveProfiles(profiles)
            await logStartup("persistProfiles success count=\(profiles.count)")
        } catch {
            statusLine = L10n.t("status.failedSaveProfiles")
            decisionLine = error.localizedDescription
            await logStartup("persistProfiles failed error=\(error.localizedDescription)")
        }
    }

    func persistSettings() async {
        do {
            try await settingsStore.saveSettings(currentSettings())
        } catch {
            statusLine = L10n.t("status.failedSaveSettings")
            decisionLine = error.localizedDescription
        }
    }

    func currentSettings() -> AppSettings {
        AppSettings(
            automaticRestoreEnabled: autoRestoreEnabled,
            askBeforeAutomaticRestore: askBeforeAutomaticRestoreEnabled,
            launchAtLogin: launchAtLoginEnabled,
            shortcuts: shortcuts,
            automaticallyCheckForUpdates: automaticUpdateChecksEnabled,
            skippedReleaseVersion: skippedReleaseVersion,
            preferredLanguageCode: preferredLanguageOption.preferredLanguageCode
        )
    }

    func configureShortcuts() async {
        do {
            try await shortcutManager.configure(shortcuts: shortcuts) { [weak self] action in
                Task { @MainActor in
                    await self?.handleShortcut(action)
                }
            }
        } catch {
            statusLine = L10n.t("status.failedConfigureShortcuts")
            decisionLine = error.localizedDescription
        }
    }

    func handleShortcut(_ action: ShortcutAction) async {
        switch action {
        case .fixNow:
            await performManualRestore()
        case .saveCurrentLayout:
            await performSaveCurrentLayout()
        case .swapLeftRight:
            await performSwapLeftRight()
        }
    }

    @discardableResult
    func refreshDependencyState() async -> RestoreDependencyStatus {
        let dependency = await executor.dependencyStatus()
        dependencyAvailable = dependency.isAvailable
        dependencyLine = dependency.details

        if !dependency.isAvailable, !automaticInstallAttempted {
            automaticInstallAttempted = true
            installationTask = Task { @MainActor [weak self] in
                guard let self else {
                    return
                }

                _ = await self.runDependencyInstall(trigger: "bootstrap-install", automatic: true)
                self.installationTask = nil
            }
        }

        return dependency
    }

    @discardableResult
    func installDependency(trigger: String, automatic: Bool) async -> DependencyInstallResult {
        if let installationTask {
            await installationTask.value
            let dependency = await executor.dependencyStatus()
            return DependencyInstallResult(
                outcome: dependency.isAvailable ? .alreadyInstalled : .failed,
                dependency: "displayplacer",
                location: dependency.location,
                details: dependency.details
            )
        }

        return await runDependencyInstall(trigger: trigger, automatic: automatic)
    }

    @discardableResult
    func runDependencyInstall(trigger: String, automatic: Bool) async -> DependencyInstallResult {
        installationInProgress = true
        statusLine = automatic ? L10n.t("status.installingDisplayplacerAuto") : L10n.t("status.installingDisplayplacer")
        decisionLine = automatic
            ? L10n.t("decision.backgroundDependencySetup")
            : L10n.t("decision.tryingInstallDependency")

        let result = await dependencyInstaller.installDisplayplacerIfNeeded()
        installationInProgress = false

        let dependency = await executor.dependencyStatus()
        dependencyAvailable = dependency.isAvailable
        dependencyLine = dependency.details
        statusLine = result.details

        if result.outcome == .installed || result.outcome == .alreadyInstalled {
            decisionLine = automatic
                ? L10n.t("decision.dependencyReadyAuto")
                : L10n.t("decision.dependencyReadyManual")
        } else {
            decisionLine = automatic
                ? L10n.t("decision.dependencySetupFailedAuto")
                : L10n.t("decision.dependencyInstallFailed")
        }

        await recordDiagnostic(
            eventType: DisplayEventType.manual.rawValue,
            profileName: nil,
            score: nil,
            actionTaken: trigger,
            executionResult: result.outcome.rawValue,
            verificationResult: RestoreVerificationOutcome.skipped.rawValue,
            details: result.details
        )

        return result
    }

    func refreshLoginItemState() async {
        let loginState = await loginItemManager.currentState()
        loginItemLine = loginState.description
    }
}
