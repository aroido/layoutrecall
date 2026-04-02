import Foundation
import LayoutRecallKit

extension AppModel {
    func startMonitoring() {
        eventMonitor.start { [weak self] event in
            Task { @MainActor in
                self?.handleDisplayEvent(event)
            }
        }
    }

    func handleDisplayEvent(_ event: DisplayEvent) {
        if let restoreCooldownUntil, restoreCooldownUntil > Date() {
            statusLine = L10n.t("status.ignoringEventCooldown", L10n.eventTypeName(event.type.rawValue))
            return
        }

        statusLine = L10n.t("status.detectedEvent", L10n.eventTypeName(event.type.rawValue))
        decisionLine = event.details ?? L10n.t("status.preparingCurrentLayout")

        debounceTask?.cancel()
        debounceTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: self?.debounceNanoseconds ?? 0)
            await self?.refreshCurrentState(trigger: event, allowAutomaticRestore: true, shouldRecordDecision: true)
        }
    }

    func refreshCurrentState(
        trigger: DisplayEvent,
        allowAutomaticRestore: Bool,
        shouldRecordDecision: Bool
    ) async {
        let dependency = await refreshDependencyState()

        do {
            let currentDisplays = try await snapshotReader.currentDisplays()
            let match = coordinator.matcher.bestMatch(for: currentDisplays, among: profiles)
            currentDisplaySnapshots = currentDisplays
            detectedDisplayCount = currentDisplays.count
            let decision = coordinator.decide(
                for: currentDisplays,
                profiles: profiles,
                automaticRestoreEnabled: autoRestoreEnabled,
                dependencyAvailable: dependency.isAvailable
            )
            let suppressAutomaticRestore = shouldSuppressAutomaticRestore(for: currentDisplays)

            lastCommand = {
                if case .autoRestore(let command) = decision.action {
                    return command
                }
                return match?.profile.layout.engine.command ?? ""
            }()

            latestDecision = decision
            latestMatchedProfileName = match?.profile.name
            latestMatchScore = match?.score
            decisionLine = decision.reason
            statusLine = L10n.connectedDisplayCount(currentDisplays.count)

            if allowAutomaticRestore,
               case .autoRestore(let command) = decision.action,
               let match
            {
                guard !suppressAutomaticRestore else {
                    return
                }

                guard !askBeforeAutomaticRestoreEnabled else {
                    latestDecision = RestoreDecision(
                        action: .offerManualFix,
                        profileName: match.profile.name,
                        score: match.score,
                        reason: L10n.t("restoreDecision.askBeforeAutomaticRestore"),
                        context: .awaitingUserConfirmation
                    )
                    decisionLine = L10n.t("restoreDecision.askBeforeAutomaticRestore")

                    if shouldRecordDecision {
                        await recordDiagnostic(
                            eventType: trigger.type.rawValue,
                            profileName: match.profile.name,
                            score: match.score,
                            actionTaken: "ask-before-restore",
                            executionResult: RestoreVerificationOutcome.skipped.rawValue,
                            verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                            details: L10n.t("restoreDecision.askBeforeAutomaticRestore")
                        )
                    }
                    return
                }

                await executeRestore(
                    command: command,
                    expectedOrigins: match.profile.layout.expectedOrigins,
                    trigger: trigger.type.rawValue,
                    actionTaken: "auto-restore",
                    profileName: match.profile.name,
                    score: match.score,
                    details: decision.reason
                )
                return
            }

            if shouldRecordDecision {
                await recordDiagnostic(
                    eventType: trigger.type.rawValue,
                    profileName: match?.profile.name,
                    score: match?.score,
                    actionTaken: decisionActionLabel(decision.action),
                    executionResult: dependency.isAvailable
                        ? RestoreVerificationOutcome.skipped.rawValue
                        : RestoreExecutionOutcome.dependencyMissing.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: decision.reason
                )
            }
        } catch {
            lastCommand = ""
            currentDisplaySnapshots = []
            detectedDisplayCount = 0
            latestDecision = nil
            latestMatchedProfileName = nil
            latestMatchScore = nil
            statusLine = L10n.t("status.failedReadCurrentDisplaySet")
            decisionLine = error.localizedDescription

            if shouldRecordDecision {
                await recordDiagnostic(
                    eventType: trigger.type.rawValue,
                    profileName: nil,
                    score: nil,
                    actionTaken: "snapshot-read",
                    executionResult: RestoreVerificationOutcome.skipped.rawValue,
                    verificationResult: RestoreVerificationOutcome.skipped.rawValue,
                    details: error.localizedDescription
                )
            }
        }
    }
}
