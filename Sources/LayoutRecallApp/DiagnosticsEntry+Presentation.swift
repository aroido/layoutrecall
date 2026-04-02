import Foundation
import LayoutRecallKit

extension DiagnosticsEntry {
    var confidenceSummary: String? {
        guard let score else {
            return nil
        }

        if score >= 85 {
            return L10n.t("confidence.high")
        }

        if score >= 70 {
            return L10n.t("confidence.review")
        }

        return L10n.t("confidence.low")
    }

    var displayTitle: String {
        switch actionTaken {
        case "auto-restore":
            return L10n.t("diagnostic.title.autoRestore")
        case "manual-fix":
            return L10n.t("diagnostic.title.fixNow")
        case "manual-recovery":
            return L10n.t("diagnostic.title.manualRecovery")
        case "manual-layout-override":
            return L10n.t("diagnostic.title.manualLayoutOverride")
        case "save-profile":
            return L10n.t("diagnostic.title.saveNewProfile")
        case "save-new-profile":
            return L10n.t("diagnostic.title.saveNewProfile")
        case "restore-profile":
            return L10n.t("diagnostic.title.profileRestore")
        case "identify-displays":
            return L10n.t("diagnostic.title.identifyDisplays")
        case "swap-left-right":
            return L10n.t("diagnostic.title.swappedLeftRight")
        case "bootstrap-install":
            return L10n.t("diagnostic.title.dependencySetup")
        case "snapshot-read":
            return L10n.t("diagnostic.title.displayReadFailed")
        case "idle":
            return L10n.t("diagnostic.title.monitoring")
        default:
            return actionTaken
                .replacingOccurrences(of: "-", with: " ")
                .capitalized
        }
    }

    var outcomeSummary: String {
        switch (executionResult, verificationResult) {
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.success.rawValue):
            return L10n.t("diagnostic.outcome.appliedVerified")
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.failed.rawValue):
            return L10n.t("diagnostic.outcome.appliedVerificationFailed")
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.unverified.rawValue):
            return L10n.t("diagnostic.outcome.appliedVerificationIncomplete")
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.skipped.rawValue):
            switch actionTaken {
            case "save-profile":
                return L10n.t("diagnostic.outcome.savedSuccessfully")
            case "bootstrap-install":
                return L10n.t("diagnostic.outcome.dependencyReady")
            default:
                return L10n.t("diagnostic.outcome.completedSuccessfully")
            }
        case (RestoreExecutionOutcome.dependencyMissing.rawValue, _):
            return L10n.t("diagnostic.outcome.dependencyNeeded")
        case (RestoreExecutionOutcome.timedOut.rawValue, _):
            return L10n.t("diagnostic.outcome.timedOut")
        case (RestoreExecutionOutcome.failure.rawValue, _):
            return L10n.t("diagnostic.outcome.actionFailed")
        case (DependencyInstallOutcome.installed.rawValue, _),
             (DependencyInstallOutcome.alreadyInstalled.rawValue, _):
            return L10n.t("diagnostic.outcome.dependencyReady")
        case (DependencyInstallOutcome.failed.rawValue, _):
            return L10n.t("diagnostic.outcome.installFailed")
        case (RestoreVerificationOutcome.skipped.rawValue, RestoreVerificationOutcome.skipped.rawValue):
            return actionTaken == "identify-displays"
                ? L10n.t("diagnostic.outcome.completedSuccessfully")
                : L10n.t("diagnostic.outcome.monitoringOnly")
        default:
            return L10n.t("diagnostic.outcome.statusUpdated")
        }
    }

    var outcomeTone: DiagnosticBadge.Tone {
        switch (executionResult, verificationResult) {
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.success.rawValue),
             (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.skipped.rawValue),
             (DependencyInstallOutcome.installed.rawValue, _),
             (DependencyInstallOutcome.alreadyInstalled.rawValue, _):
            return .positive
        case (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.unverified.rawValue),
             (RestoreExecutionOutcome.dependencyMissing.rawValue, _),
             (RestoreExecutionOutcome.timedOut.rawValue, _):
            return .caution
        case (RestoreVerificationOutcome.skipped.rawValue, RestoreVerificationOutcome.skipped.rawValue)
            where actionTaken == "identify-displays":
            return .positive
        case (RestoreExecutionOutcome.failure.rawValue, _),
             (DependencyInstallOutcome.failed.rawValue, _),
             (RestoreExecutionOutcome.success.rawValue, RestoreVerificationOutcome.failed.rawValue):
            return .negative
        default:
            return .neutral
        }
    }

    var supportReportSummaryLine: String {
        var components: [String] = [
            "- \(timestamp.formatted(date: .abbreviated, time: .shortened))",
            displayTitle,
            outcomeSummary
        ]

        if let profileName, !profileName.isEmpty {
            components.append(profileName)
        }

        if let confidenceSummary {
            components.append(confidenceSummary)
        }

        return components.joined(separator: " · ")
    }
}
