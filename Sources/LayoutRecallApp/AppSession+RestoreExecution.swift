import Foundation
import LayoutRecallKit

extension AppSession {
    func executeRestore(
        command: String,
        expectedOrigins: [DisplayOrigin],
        trigger: String,
        actionTaken: String,
        profileName: String?,
        score: Int?,
        details: String,
        displayFingerprint: String? = nil
    ) async {
        restoreCommandInProgress = true
        defer {
            restoreCommandInProgress = false
        }

        lastCommand = command
        statusLine = L10n.t("status.runningRestoreCommand")
        decisionLine = details
        await logStartup(
            "executeRestore start action=\(actionTaken) trigger=\(trigger) profile=\(profileName ?? "<none>") command=\(command) expectedOrigins=\(describeOrigins(expectedOrigins))"
        )

        let executionResult = await executor.execute(command: command)
        var verificationResult = RestoreVerificationResult.skipped

        if actionTaken == "swap-left-right" {
            restoreCooldownUntil = nil
        } else if executionResult.outcome != .dependencyMissing {
            restoreCooldownUntil = Date().addingTimeInterval(restoreCooldown)
        }

        if executionResult.outcome == .success {
            verificationResult = await verifier.verify(expectedOrigins: expectedOrigins, using: snapshotReader)
            updateManualRestoreSuppression(
                for: actionTaken,
                expectedOrigins: expectedOrigins,
                displayFingerprint: displayFingerprint
            )
        }
        await logStartup(
            "executeRestore finished action=\(actionTaken) execution=\(executionResult.outcome.rawValue) verification=\(verificationResult.outcome.rawValue) details=\(verificationResult.details)"
        )

        let executionSummary = executionResult.outcome.rawValue
        let verificationSummary = verificationResult.outcome.rawValue
        if executionResult.outcome == .success {
            latestDecision = RestoreDecision(
                action: .autoRestore(command: command),
                profileName: profileName,
                score: score,
                reason: verificationResult.details,
                context: .ready
            )
        } else {
            latestDecision = RestoreDecision(
                action: .offerManualFix,
                profileName: profileName,
                score: score,
                reason: executionResult.details,
                context: .restoreFailed
            )
        }
        latestMatchedProfileName = profileName
        latestMatchScore = score
        statusLine = executionResult.details
        decisionLine = latestDecision?.reason ?? verificationResult.details

        await recordDiagnostic(
            eventType: trigger,
            profileName: profileName,
            score: score,
            actionTaken: actionTaken,
            executionResult: executionSummary,
            verificationResult: verificationSummary,
            details: [
                details,
                executionResult.details,
                verificationResult.details
            ]
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        )
    }

    func decisionActionLabel(_ action: RestoreAction) -> String {
        switch action {
        case .autoRestore:
            return "auto-restore"
        case .offerManualFix:
            return "manual-recovery"
        case .saveNewProfile:
            return "save-new-profile"
        case .idle:
            return "idle"
        }
    }
}
