import Foundation
import LayoutRecallKit

extension AppModel {
    func performManualRestore() async {
        let dependency = await refreshDependencyState()
        guard dependency.isAvailable else {
            let result = await installDependency(trigger: "manual-install", automatic: false)

            guard result.outcome == .installed || result.outcome == .alreadyInstalled else {
                latestDecision = RestoreDecision(
                    action: .offerManualFix,
                    reason: L10n.t("decision.manualRestoreRequiresDependency"),
                    context: .dependencyBlocked
                )
                latestMatchedProfileName = nil
                latestMatchScore = nil
                statusLine = dependency.details
                decisionLine = L10n.t("decision.manualRestoreRequiresDependency")
                await recordDiagnostic(
                    eventType: DisplayEventType.manual.rawValue,
                    profileName: nil,
                    score: nil,
                    actionTaken: "manual-fix",
                    executionResult: RestoreExecutionOutcome.dependencyMissing.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: dependency.details
                )
                return
            }

            await performManualRestore()
            return
        }

        do {
            let currentDisplays = try await snapshotReader.currentDisplays()
            detectedDisplayCount = currentDisplays.count

            guard let match = coordinator.matcher.bestMatch(for: currentDisplays, among: profiles) else {
                latestDecision = RestoreDecision(
                    action: .offerManualFix,
                    reason: L10n.t("decision.saveProfileBeforeManualRestore"),
                    context: .noConfidentMatch
                )
                latestMatchedProfileName = nil
                latestMatchScore = nil
                statusLine = L10n.t("status.noCompatibleSavedProfile")
                decisionLine = L10n.t("decision.saveProfileBeforeManualRestore")
                await recordDiagnostic(
                    eventType: DisplayEventType.manual.rawValue,
                    profileName: nil,
                    score: nil,
                    actionTaken: "manual-fix",
                    executionResult: RestoreVerificationOutcome.skipped.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: LayoutRecallRuntimeError.noCompatibleProfile.localizedDescription
                )
                return
            }

            latestDecision = RestoreDecision(
                action: .offerManualFix,
                profileName: match.profile.name,
                score: match.score,
                reason: L10n.t("details.userRequestedManualRestore"),
                context: .manualRestoreRequested
            )
            latestMatchedProfileName = match.profile.name
            latestMatchScore = match.score
            await executeRestore(
                command: match.profile.layout.engine.command,
                expectedOrigins: match.profile.layout.expectedOrigins,
                trigger: DisplayEventType.manual.rawValue,
                actionTaken: "manual-fix",
                profileName: match.profile.name,
                score: match.score,
                details: L10n.t("details.userRequestedManualRestore")
            )
        } catch {
            latestDecision = nil
            latestMatchedProfileName = nil
            latestMatchScore = nil
            statusLine = L10n.t("status.failedReadCurrentDisplaySetManual")
            decisionLine = error.localizedDescription
            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: nil,
                score: nil,
                actionTaken: "manual-fix",
                executionResult: RestoreVerificationOutcome.skipped.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: error.localizedDescription
            )
        }
    }

    func performSaveCurrentLayout() async {
        do {
            let currentDisplays = try await snapshotReader.currentDisplays()
            let layoutPlan = try commandBuilder.restorePlan(for: currentDisplays)

            if let existingProfile = existingProfileMatchingCurrentLayout(
                displays: currentDisplays,
                layoutPlan: layoutPlan
            ) {
                currentDisplaySnapshots = currentDisplays
                detectedDisplayCount = currentDisplays.count
                latestDecision = RestoreDecision(
                    action: .autoRestore(command: existingProfile.layout.engine.command),
                    profileName: existingProfile.name,
                    reason: L10n.t("decision.savedProfileAlreadyExists"),
                    context: .savedProfileReady
                )
                latestMatchedProfileName = existingProfile.name
                latestMatchScore = nil
                lastCommand = existingProfile.layout.engine.command
                statusLine = L10n.t("status.layoutAlreadySaved", existingProfile.name)
                decisionLine = L10n.t("decision.savedProfileAlreadyExists")

                await recordDiagnostic(
                    eventType: DisplayEventType.manual.rawValue,
                    profileName: existingProfile.name,
                    score: nil,
                    actionTaken: "save-profile-duplicate",
                    executionResult: RestoreVerificationOutcome.skipped.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: L10n.t("details.savedLayoutAlreadyExists", existingProfile.name)
                )
                return
            }

            let nextIndex = profiles.count + 1
            let profile = DisplayProfile.draft(
                name: L10n.workspaceName(nextIndex),
                displays: currentDisplays,
                layoutPlan: layoutPlan
            )

            profiles.append(profile)
            currentDisplaySnapshots = currentDisplays
            detectedDisplayCount = currentDisplays.count
            latestDecision = RestoreDecision(
                action: .autoRestore(command: profile.layout.engine.command),
                profileName: profile.name,
                reason: L10n.t("decision.savedProfileReady"),
                context: .savedProfileReady
            )
            latestMatchedProfileName = profile.name
            latestMatchScore = nil
            lastCommand = profile.layout.engine.command

            await persistProfiles()

            statusLine = L10n.t("status.capturedLayout", profile.name)
            decisionLine = L10n.t("decision.savedProfileReady")

            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: profile.name,
                score: nil,
                actionTaken: "save-profile",
                executionResult: RestoreVerificationOutcome.skipped.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: L10n.t("details.savedCurrentLayout")
            )
        } catch {
            statusLine = L10n.t("status.failedCaptureLayout")
            decisionLine = error.localizedDescription
        }
    }

    func existingProfileMatchingCurrentLayout(
        displays: [DisplaySnapshot],
        layoutPlan: GeneratedLayoutPlan
    ) -> DisplayProfile? {
        let expectedOrigins = normalizedExpectedOrigins(layoutPlan.expectedOrigins)

        return profiles.first { profile in
            profile.displaySet.count == displays.count
                && profile.displaySet.fingerprint == displays.fingerprint
                && profile.layout.primaryDisplayKey == layoutPlan.primaryDisplayKey
                && normalizedExpectedOrigins(profile.layout.expectedOrigins) == expectedOrigins
        }
    }

    func normalizedExpectedOrigins(_ origins: [DisplayOrigin]) -> [DisplayOrigin] {
        origins.sorted { lhs, rhs in
            if lhs.key != rhs.key {
                return lhs.key < rhs.key
            }

            if lhs.x != rhs.x {
                return lhs.x < rhs.x
            }

            return lhs.y < rhs.y
        }
    }

    func expectedOrigins(for displays: [DisplaySnapshot]) -> [DisplayOrigin] {
        let orderedDisplays = displays.sorted(by: DisplaySnapshot.positionComparator)
        return orderedDisplays.map { display in
            DisplayOrigin(
                key: orderedDisplays.uniqueMatchKey(for: display),
                x: display.bounds.x,
                y: display.bounds.y
            )
        }
    }

    func shouldSuppressAutomaticRestore(for displays: [DisplaySnapshot]) -> Bool {
        matchesManualRestoreSuppression(for: displays, clearWhenMismatch: true)
    }

    func matchesManualRestoreSuppression(
        for displays: [DisplaySnapshot],
        clearWhenMismatch: Bool
    ) -> Bool {
        guard let suppressedExpectedOrigins = manualRestoreExpectedOrigins else {
            return false
        }

        let currentOrigins = normalizedExpectedOrigins(expectedOrigins(for: displays))
        let suppressedOrigins = normalizedExpectedOrigins(suppressedExpectedOrigins)
        let matches = currentOrigins == suppressedOrigins

        if !matches && clearWhenMismatch {
            manualRestoreExpectedOrigins = nil
            manualRestoreActionTaken = nil
        }

        return matches
    }

    func updateManualRestoreSuppression(
        for actionTaken: String,
        expectedOrigins: [DisplayOrigin],
        displayFingerprint _: String?
    ) {
        switch actionTaken {
        case "manual-fix", "restore-profile":
            manualRestoreExpectedOrigins = expectedOrigins
            manualRestoreActionTaken = actionTaken
        default:
            manualRestoreExpectedOrigins = nil
            manualRestoreActionTaken = nil
        }
    }

    func performRestoreProfile(_ profileID: UUID) async {
        guard let profile = profiles.first(where: { $0.id == profileID }) else {
            return
        }

        let dependency = await refreshDependencyState()
        detectedDisplayCount = profile.displaySet.count

        guard dependency.isAvailable else {
            latestDecision = RestoreDecision(
                action: .offerManualFix,
                profileName: profile.name,
                reason: L10n.t("decision.manualRestoreRequiresDependency"),
                context: .dependencyBlocked
            )
            latestMatchedProfileName = profile.name
            latestMatchScore = nil
            statusLine = dependency.details
            decisionLine = L10n.t("decision.manualRestoreRequiresDependency")
            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: profile.name,
                score: nil,
                actionTaken: "restore-profile",
                executionResult: RestoreExecutionOutcome.dependencyMissing.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: dependency.details
            )
            return
        }

        latestDecision = RestoreDecision(
            action: .offerManualFix,
            profileName: profile.name,
            reason: L10n.t("details.userRequestedProfileRestore", profile.name),
            context: .profileRestoreRequested
        )
        latestMatchedProfileName = profile.name
        latestMatchScore = nil

        await executeRestore(
            command: profile.layout.engine.command,
            expectedOrigins: profile.layout.expectedOrigins,
            trigger: DisplayEventType.manual.rawValue,
            actionTaken: "restore-profile",
            profileName: profile.name,
            score: nil,
            details: L10n.t("details.userRequestedProfileRestore", profile.name)
        )
    }

    func performDisplayIdentification(_ profileID: UUID) async {
        guard let profile = profiles.first(where: { $0.id == profileID }) else {
            return
        }

        do {
            let currentDisplays = try await snapshotReader.currentDisplays()
            currentDisplaySnapshots = currentDisplays
            let resolvedPrimaryDisplayKey = DisplayPresentationBuilder.resolvedPrimaryDisplayKey(
                for: profile.displaySet.displays,
                storedPrimaryDisplayKey: profile.layout.primaryDisplayKey,
                currentDisplays: currentDisplays
            )
            let markers = DisplayPresentationBuilder.identificationMarkers(
                for: profile.displaySet.displays,
                primaryDisplayKey: resolvedPrimaryDisplayKey,
                currentDisplays: currentDisplays
            )

            detectedDisplayCount = currentDisplays.count

            guard !markers.isEmpty else {
                statusLine = L10n.t("status.displayIdentificationUnavailable")
                decisionLine = L10n.t("runtime.identifyNoMatchingDisplays")
                await recordDiagnostic(
                    eventType: DisplayEventType.manual.rawValue,
                    profileName: profile.name,
                    score: nil,
                    actionTaken: "identify-displays",
                    executionResult: RestoreVerificationOutcome.skipped.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: L10n.t("runtime.identifyNoMatchingDisplays")
                )
                return
            }

            displayIdentifier.showLabels(markers)
            statusLine = L10n.t("status.displayIdentificationShown", profile.name)
            decisionLine = L10n.t("details.userRequestedDisplayIdentification", profile.name)

            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: profile.name,
                score: nil,
                actionTaken: "identify-displays",
                executionResult: RestoreVerificationOutcome.skipped.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: L10n.t("details.userRequestedDisplayIdentification", profile.name)
            )
        } catch {
            statusLine = L10n.t("status.displayIdentificationUnavailable")
            decisionLine = error.localizedDescription

            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: profile.name,
                score: nil,
                actionTaken: "identify-displays",
                executionResult: RestoreVerificationOutcome.skipped.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: error.localizedDescription
            )
        }
    }

    func performSwapLeftRight() async {
        do {
            guard !restoreCommandInProgress else {
                statusLine = L10n.t("status.swapAlreadyRunning")
                decisionLine = L10n.t("details.swapAlreadyRunning")
                await logStartup("swapLeftRight ignored because restoreCommandInProgress=true")
                return
            }

            let currentDisplays = try await snapshotReader.currentDisplays()
            await logStartup("swapLeftRight currentDisplays=\(describeDisplays(currentDisplays))")
            let match = coordinator.matcher.bestMatch(for: currentDisplays, among: profiles)
            let layoutPlan = try commandBuilder.swapLeftRightPlan(for: currentDisplays)
            await logStartup(
                "swapLeftRight plan command=\(layoutPlan.command) expectedOrigins=\(describeOrigins(layoutPlan.expectedOrigins))"
            )
            detectedDisplayCount = currentDisplays.count
            latestDecision = RestoreDecision(
                action: .offerManualFix,
                profileName: match?.profile.name,
                score: match?.score,
                reason: L10n.t("details.userRequestedSwap")
            )
            latestMatchedProfileName = match?.profile.name
            latestMatchScore = match?.score

            await executeRestore(
                command: layoutPlan.command,
                expectedOrigins: layoutPlan.expectedOrigins,
                trigger: DisplayEventType.manual.rawValue,
                actionTaken: "swap-left-right",
                profileName: match?.profile.name,
                score: match?.score,
                details: L10n.t("details.userRequestedSwap"),
                displayFingerprint: currentDisplays.fingerprint
            )
        } catch {
            latestDecision = nil
            latestMatchedProfileName = nil
            latestMatchScore = nil
            statusLine = L10n.t("status.swapUnavailable")
            decisionLine = error.localizedDescription
            await recordDiagnostic(
                eventType: DisplayEventType.manual.rawValue,
                profileName: nil,
                score: nil,
                actionTaken: "swap-left-right",
                executionResult: RestoreVerificationOutcome.skipped.rawValue,
                verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                details: error.localizedDescription
            )
        }
    }
}
