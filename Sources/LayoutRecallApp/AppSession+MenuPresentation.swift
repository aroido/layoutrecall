import Foundation
import LayoutRecallKit

extension AppSession {
    var menuStatePresentation: MenuStatePresentation {
        switch menuPrimaryState {
        case .noProfiles:
            return .noProfiles
        case .installingDependency:
            return .installing
        case .dependencyMissing:
            return .dependencyMissing
        case .noMatch:
            return .noMatch
        case .lowConfidence:
            return .lowConfidence
        case .reviewBeforeRestore:
            return .reviewBeforeRestore
        case .autoRestoreDisabled:
            return .autoRestoreDisabled
        case .manualLayoutOverride:
            return .manualLayoutOverride
        case .manualRecovery:
            return .manualRecovery
        case .healthy:
            return .healthy
        }
    }

    var menuTransitionKey: String {
        [
            String(describing: menuPrimaryState),
            currentProfileName ?? "",
            latestDiagnosticSummary ?? "",
            latestDiagnosticDetails ?? "",
            dependencyAvailable ? "1" : "0",
            installationInProgress ? "1" : "0",
            String(activeDisplayCount)
        ].joined(separator: "|")
    }

    var menuRecentActivityLine: String? {
        guard let latestEntry = diagnostics.first else {
            return nil
        }

        return L10n.t(
            "menu.recentActivity",
            latestEntry.displayTitle,
            latestEntry.timestamp.formatted(date: .abbreviated, time: .shortened)
        )
    }

    var menuShowsRecentActivity: Bool {
        menuPrimaryState != .healthy
    }

    var menuShowsDependencyBadge: Bool {
        installationInProgress || !dependencyAvailable
    }

    var menuShowsDisplayBadge: Bool {
        menuPrimaryState != .healthy
    }

    var menuConfidenceBadgeTextForMenu: String? {
        guard let confidencePresentation else {
            return nil
        }

        guard menuPrimaryState != .healthy || confidencePresentation != .high else {
            return nil
        }

        return confidencePresentation.label
    }

    var menuShouldShowEvidencePills: Bool {
        menuShowsDependencyBadge
            || menuShowsDisplayBadge
            || menuConfidenceBadgeTextForMenu != nil
    }

    var menuReferenceMetadataLine: String? {
        var components: [String] = []

        if profiles.count > 1 {
            components.append(L10n.t("menu.meta.profileCount", profiles.count))
        }

        if installationInProgress {
            components.append(L10n.t("menu.meta.dependencyInstalling"))
        } else if !dependencyAvailable {
            components.append(L10n.t("menu.meta.dependencyMissing"))
        }

        if let confidenceLabel = menuConfidenceBadgeTextForMenu {
            components.append(confidenceLabel)
        }

        return components.isEmpty ? nil : components.joined(separator: " · ")
    }

    var menuPrimaryState: MenuPrimaryState {
        if profiles.isEmpty {
            return .noProfiles
        }

        if installationInProgress {
            return .installingDependency
        }

        if !dependencyAvailable {
            return .dependencyMissing
        }

        switch latestDecision?.context {
        case .noSavedProfile:
            return .noProfiles
        case .noConfidentMatch:
            return .noMatch
        case .belowThreshold:
            return .lowConfidence
        case .awaitingUserConfirmation:
            return .reviewBeforeRestore
        case .automaticRestoreDisabled:
            return .autoRestoreDisabled
        case .manualLayoutOverride:
            return .manualLayoutOverride
        case .dependencyBlocked:
            return .dependencyMissing
        case .ready, .savedProfileReady:
            return .healthy
        case .noDisplays, .manualRestoreRequested, .profileRestoreRequested, .restoreFailed, .none:
            break
        }

        if case .autoRestore = latestDecision?.action {
            return .healthy
        }

        return .manualRecovery
    }

    var menuStatusTitle: String {
        switch menuPrimaryState {
        case .noProfiles:
            return L10n.t("menu.state.noProfiles")
        case .installingDependency:
            return L10n.t("menu.state.installingDependency")
        case .dependencyMissing:
            return L10n.t("menu.state.dependencyRequired")
        case .noMatch:
            return L10n.t("menu.state.noMatch")
        case .lowConfidence:
            return L10n.t("menu.state.lowConfidence")
        case .reviewBeforeRestore:
            return L10n.t("menu.state.reviewBeforeRestore")
        case .autoRestoreDisabled:
            return L10n.t("menu.state.globalAutoRestoreDisabled")
        case .manualLayoutOverride:
            return L10n.t("menu.state.manualLayoutOverride")
        case .manualRecovery:
            return L10n.t("menu.state.manualRecovery")
        case .healthy:
            if let currentProfileName {
                return L10n.t("menu.state.readyProfile", currentProfileName)
            }

            return L10n.t("menu.state.ready")
        }
    }

    var menuStatusSubtitle: String {
        switch menuPrimaryState {
        case .noProfiles:
            return L10n.t("menu.subtitle.noProfiles")
        case .installingDependency:
            return L10n.t("menu.subtitle.installingDependency")
        case .dependencyMissing:
            return L10n.t("menu.subtitle.dependencyMissing")
        case .noMatch:
            return L10n.t("menu.subtitle.noMatch")
        case .lowConfidence:
            return L10n.t("menu.subtitle.lowConfidence")
        case .reviewBeforeRestore:
            return L10n.t("menu.subtitle.reviewBeforeRestore")
        case .autoRestoreDisabled:
            return L10n.t("menu.subtitle.globalAutoRestoreDisabled")
        case .manualLayoutOverride:
            return L10n.t("menu.subtitle.manualLayoutOverride")
        case .manualRecovery:
            return L10n.t("menu.subtitle.manualRecovery")
        case .healthy:
            return L10n.t("menu.subtitle.ready")
        }
    }

    var menuMetadataLine: String {
        var components: [String] = [
            L10n.t("menu.meta.profileCount", profiles.count)
        ]

        if installationInProgress {
            components.append(L10n.t("menu.meta.dependencyInstalling"))
        } else if dependencyAvailable {
            components.append(L10n.t("menu.meta.dependencyReady"))
        } else {
            components.append(L10n.t("menu.meta.dependencyMissing"))
        }

        if let confidencePresentation {
            components.append(confidencePresentation.label)
        }

        return components.joined(separator: " · ")
    }
}
