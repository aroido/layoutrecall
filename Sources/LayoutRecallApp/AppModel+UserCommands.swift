import Foundation
import LayoutRecallKit

extension AppModel {
    func fixNow() {
        launchTrackedTask {
            await self.performManualRestore()
        }
    }

    func saveCurrentLayout() {
        launchTrackedTask {
            await self.performSaveCurrentLayout()
        }
    }

    func installDisplayplacer() {
        launchTrackedTask {
            await self.installDependency(trigger: "manual-install", automatic: false)
        }
    }

    func swapLeftRight() {
        launchTrackedTask {
            await self.performSwapLeftRight()
        }
    }

    func checkForUpdatesNow() {
        launchTrackedTask {
            await self.checkForUpdates(userInitiated: true, promptIfAvailable: false)
        }
    }

    func installAvailableUpdate() {
        guard let availableUpdate else {
            return
        }

        launchTrackedTask {
            await self.installUpdate(availableUpdate)
        }
    }

    func skipAvailableUpdateVersion() {
        guard let availableUpdate else {
            return
        }

        launchTrackedTask {
            await self.markSkippedRelease(availableUpdate)
        }
    }

    func clearSkippedUpdateVersion() {
        skippedReleaseVersion = nil

        launchTrackedTask {
            await self.persistSettings()
        }
    }

    func setShortcut(_ binding: ShortcutBinding?, for action: ShortcutAction) {
        if let binding {
            for candidate in ShortcutAction.allCases where candidate != action && shortcuts[candidate] == binding {
                shortcuts[candidate] = nil
            }
        }

        shortcuts[action] = binding

        launchTrackedTask {
            await self.persistSettings()
            await self.configureShortcuts()
        }
    }

    func setAutoRestore(_ enabled: Bool) {
        autoRestoreEnabled = enabled

        launchTrackedTask {
            await self.persistSettings()
            await self.refreshCurrentState(
                trigger: DisplayEvent(type: .manual, details: L10n.t("event.autoRestorePreferenceChanged")),
                allowAutomaticRestore: false,
                shouldRecordDecision: false
            )
        }
    }

    func setAskBeforeAutomaticRestore(_ enabled: Bool) {
        askBeforeAutomaticRestoreEnabled = enabled

        launchTrackedTask {
            await self.persistSettings()
            await self.refreshCurrentState(
                trigger: DisplayEvent(type: .manual, details: L10n.t("event.askBeforeRestorePreferenceChanged")),
                allowAutomaticRestore: false,
                shouldRecordDecision: false
            )
        }
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        launchAtLoginEnabled = enabled

        launchTrackedTask {
            do {
                try await self.settingsStore.saveSettings(self.currentSettings())
                let state = try await self.loginItemManager.setEnabled(enabled)
                self.loginItemLine = state.description
                self.statusLine = enabled
                    ? L10n.t("status.launchAtLoginSaved")
                    : L10n.t("status.launchAtLoginCleared")
            } catch {
                self.loginItemLine = L10n.t("status.launchAtLoginUpdateFailed")
                self.statusLine = L10n.t("status.failedUpdateLaunchAtLogin", error.localizedDescription)
            }
        }
    }

    func setAutomaticUpdateChecks(_ enabled: Bool) {
        automaticUpdateChecksEnabled = enabled

        if !enabled {
            updateState = .idle
        }

        launchTrackedTask {
            await self.persistSettings()

            if enabled {
                await self.checkForUpdates(userInitiated: false, promptIfAvailable: false)
            }
        }
    }

    func setPreferredLanguage(_ option: AppLanguageOption) {
        preferredLanguageOption = option
        L10n.setPreferredLanguageCodeOverride(option.preferredLanguageCode)

        launchTrackedTask {
            await self.persistSettings()
        }
    }

    func renameProfile(_ profileID: UUID, to name: String) {
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else {
            return
        }

        profiles[index].name = name

        launchTrackedTask {
            await self.persistProfiles()
        }
    }

    func setConfidenceThreshold(_ profileID: UUID, to threshold: Int) {
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else {
            return
        }

        profiles[index].settings.confidenceThreshold = threshold

        launchTrackedTask {
            await self.persistProfiles()
            await self.refreshCurrentState(
                trigger: DisplayEvent(type: .manual, details: L10n.t("event.confidenceThresholdChanged")),
                allowAutomaticRestore: false,
                shouldRecordDecision: false
            )
        }
    }

    func deleteProfile(_ profileID: UUID) {
        guard let index = profiles.firstIndex(where: { $0.id == profileID }) else {
            return
        }

        let deletedProfile = profiles.remove(at: index)

        if latestMatchedProfileName == deletedProfile.name {
            latestMatchedProfileName = nil
            latestMatchScore = nil
        }

        launchTrackedTask {
            await self.persistProfiles()
            await self.refreshCurrentState(
                trigger: DisplayEvent(type: .manual, details: L10n.t("event.profileDeleted", deletedProfile.name)),
                allowAutomaticRestore: false,
                shouldRecordDecision: false
            )
        }
    }

    func restoreProfile(_ profileID: UUID) {
        launchTrackedTask {
            await self.performRestoreProfile(profileID)
        }
    }

    func identifyDisplays(for profileID: UUID) {
        launchTrackedTask {
            await self.performDisplayIdentification(profileID)
        }
    }

    func perform(_ action: SurfaceAction) {
        switch action {
        case .installDependency:
            installDisplayplacer()
        case .fixNow:
            fixNow()
        case .enableAutoRestore:
            setAutoRestore(true)
        case .saveNewProfile:
            saveCurrentLayout()
        }
    }

    func launchTrackedTask(_ operation: @escaping @MainActor () async -> Void) {
        let taskID = UUID()
        let task = Task { @MainActor [weak self] in
            defer {
                self?.pendingTerminationTasks.removeValue(forKey: taskID)
            }

            await operation()
        }

        pendingTerminationTasks[taskID] = task
    }
}
