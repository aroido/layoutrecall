import Foundation

public enum RestoreAction: Equatable, Sendable {
    case autoRestore(command: String)
    case offerManualFix
    case saveNewProfile
    case idle
}

public enum RestoreDecisionContext: Equatable, Sendable {
    case noDisplays
    case noSavedProfile
    case noConfidentMatch
    case belowThreshold
    case automaticRestoreDisabled
    case manualLayoutOverride
    case dependencyBlocked
    case awaitingUserConfirmation
    case currentSetupIgnored
    case ready
    case savedProfileReady
    case manualRestoreRequested
    case profileRestoreRequested
    case restoreFailed
}

public struct RestoreDecision: Equatable, Sendable {
    public var action: RestoreAction
    public var profileName: String?
    public var score: Int?
    public var reason: String
    public var context: RestoreDecisionContext?

    public init(
        action: RestoreAction,
        profileName: String? = nil,
        score: Int? = nil,
        reason: String,
        context: RestoreDecisionContext? = nil
    ) {
        self.action = action
        self.profileName = profileName
        self.score = score
        self.reason = reason
        self.context = context
    }
}

public struct RestoreCoordinator: Sendable {
    public var matcher: ProfileMatcher

    public init(matcher: ProfileMatcher = ProfileMatcher()) {
        self.matcher = matcher
    }

    public func decide(
        for currentDisplays: [DisplaySnapshot],
        profiles: [DisplayProfile],
        automaticRestoreEnabled: Bool = true,
        dependencyAvailable: Bool = true
    ) -> RestoreDecision {
        guard !currentDisplays.isEmpty else {
            return RestoreDecision(
                action: .idle,
                reason: L10n.t("restoreDecision.noDisplaysDetected"),
                context: .noDisplays
            )
        }

        guard let match = matcher.bestMatch(for: currentDisplays, among: profiles) else {
            return RestoreDecision(
                action: profiles.isEmpty ? .saveNewProfile : .offerManualFix,
                reason: profiles.isEmpty ? L10n.t("restoreDecision.noSavedProfile") : L10n.t("restoreDecision.noConfidentProfileMatch"),
                context: profiles.isEmpty ? .noSavedProfile : .noConfidentMatch
            )
        }

        let threshold = max(match.profile.settings.confidenceThreshold, matcher.threshold)

        guard match.score >= threshold else {
            return RestoreDecision(
                action: .offerManualFix,
                profileName: match.profile.name,
                score: match.score,
                reason: L10n.t("restoreDecision.belowThreshold"),
                context: .belowThreshold
            )
        }

        guard automaticRestoreEnabled else {
            return RestoreDecision(
                action: .offerManualFix,
                profileName: match.profile.name,
                score: match.score,
                reason: L10n.t("restoreDecision.globalAutoRestoreDisabled"),
                context: .automaticRestoreDisabled
            )
        }

        guard dependencyAvailable else {
            return RestoreDecision(
                action: .offerManualFix,
                profileName: match.profile.name,
                score: match.score,
                reason: L10n.t("restoreDecision.dependencyBlocked"),
                context: .dependencyBlocked
            )
        }

        return RestoreDecision(
            action: .autoRestore(command: match.profile.layout.engine.command),
            profileName: match.profile.name,
            score: match.score,
            reason: L10n.t("restoreDecision.confidentMatch"),
            context: .ready
        )
    }
}
