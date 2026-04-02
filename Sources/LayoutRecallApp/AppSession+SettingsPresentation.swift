import Foundation
import LayoutRecallKit

extension AppSession {
    var recoverySurfacePresentation: RecoverySurfacePresentation {
        let primaryAction: SurfaceActionPresentation? = switch menuPrimaryState {
        case .noProfiles:
            surfaceActionPresentation(for: .saveNewProfile)
        case .installingDependency, .dependencyMissing:
            surfaceActionPresentation(for: .installDependency)
        case .noMatch:
            surfaceActionPresentation(for: .saveNewProfile)
        case .lowConfidence, .reviewBeforeRestore, .manualRecovery:
            surfaceActionPresentation(for: .fixNow)
        case .autoRestoreDisabled:
            surfaceActionPresentation(for: .enableAutoRestore)
        case .manualLayoutOverride, .healthy:
            nil
        }

        let quickActions: [SurfaceActionPresentation] = switch menuPrimaryState {
        case .healthy,
             .lowConfidence,
             .reviewBeforeRestore,
             .autoRestoreDisabled,
             .manualLayoutOverride,
             .manualRecovery,
             .installingDependency,
             .dependencyMissing:
            [surfaceActionPresentation(for: .saveNewProfile)]
        case .noProfiles, .noMatch:
            []
        }

        let showsInlineFixNow = shouldShowInlineFixNow(primaryAction: primaryAction)
        let showsAdvancedMenu =
            (!showsInlineFixNow && canRestoreSavedProfiles)
            || !quickActions.isEmpty
            || showsSwapDisplaysControl
            || profiles.count > 1
            || referenceProfile != nil
            || shouldOfferDiagnosticsShortcut

        return RecoverySurfacePresentation(
            primaryAction: primaryAction,
            quickActions: quickActions,
            showsInlineFixNow: showsInlineFixNow,
            showsAdvancedMenu: showsAdvancedMenu,
            restoreHint: restoreActionHint,
            diagnosticsShortcutHint: diagnosticsShortcutHint
        )
    }

    func profileCardActionState(for profile: DisplayProfile) -> ProfileCardActionState {
        ProfileCardActionState(
            canApplyLayout: canRestoreSavedProfiles,
            canIdentifyDisplays: !profile.displaySet.displays.isEmpty,
            applyTitle: L10n.t("action.applyProfile"),
            identifyTitle: L10n.t("action.identifyDisplays"),
            applyHelp: L10n.t("profiles.apply.hint", profile.name),
            identifyHelp: L10n.t("profiles.identify.hint", profile.name)
        )
    }

    func shouldShowInlineFixNow(primaryAction: SurfaceActionPresentation?) -> Bool {
        guard primaryAction?.action != .fixNow, canRestoreSavedProfiles else {
            return false
        }

        switch menuPrimaryState {
        case .lowConfidence, .reviewBeforeRestore, .autoRestoreDisabled, .manualRecovery:
            return true
        case .noProfiles, .installingDependency, .dependencyMissing, .noMatch, .manualLayoutOverride, .healthy:
            return false
        }
    }

    func surfaceActionPresentation(for action: SurfaceAction) -> SurfaceActionPresentation {
        let title: String = switch action {
        case .installDependency:
            installationInProgress
                ? L10n.t("dependency.installingDisplayplacer")
                : action.title
        case .fixNow:
            action.title
        case .enableAutoRestore:
            L10n.t("action.enableAppAutoRestore")
        case .saveNewProfile:
            switch menuPrimaryState {
            case .noProfiles:
                L10n.t("menu.action.saveFirstBaseline")
            case .installingDependency,
                 .dependencyMissing,
                 .noMatch,
                 .lowConfidence,
                 .reviewBeforeRestore,
                 .autoRestoreDisabled,
                 .manualLayoutOverride,
                 .manualRecovery,
                 .healthy:
                L10n.t("menu.action.saveAnotherBaseline")
            }
        }

        let systemImage: String = switch action {
        case .installDependency:
            installationInProgress ? "hourglass" : action.systemImage
        case .fixNow, .enableAutoRestore, .saveNewProfile:
            action.systemImage
        }

        let isDisabled: Bool = switch action {
        case .installDependency:
            installationInProgress
        case .fixNow:
            !canRestoreSavedProfiles || menuPrimaryState == .noMatch
        case .saveNewProfile:
            false
        case .enableAutoRestore:
            !canEnableAutomaticRestoreAction
        }

        return SurfaceActionPresentation(
            action: action,
            title: title,
            systemImage: systemImage,
            isDisabled: isDisabled
        )
    }

    var restoreActionHint: String {
        switch menuPrimaryState {
        case .noProfiles:
            return L10n.t("settings.restore.noProfileHint")
        case .installingDependency:
            return L10n.t("settings.restore.installingHint")
        case .dependencyMissing:
            return L10n.t("settings.restore.dependencyHint")
        case .noMatch:
            return L10n.t("settings.restore.noMatchHint")
        case .lowConfidence:
            return L10n.t("settings.restore.lowConfidenceHint")
        case .reviewBeforeRestore:
            return L10n.t("settings.restore.reviewBeforeRestoreHint")
        case .autoRestoreDisabled:
            return L10n.t("settings.restore.globalAutoRestoreDisabledHint")
        case .manualLayoutOverride:
            return L10n.t("settings.restore.manualLayoutOverrideHint")
        case .manualRecovery:
            return L10n.t("settings.restore.manualHint")
        case .healthy:
            return L10n.t("settings.restore.noImmediateAction")
        }
    }

    var diagnosticsShortcutHint: String {
        diagnosticsNeedsAttention
            ? L10n.t("settings.restore.reviewDiagnosticsHint")
            : L10n.t("settings.restore.openDiagnosticsHint")
    }

    var dependencySummaryLine: String {
        if installationInProgress {
            return L10n.t("restore.dependency.installing")
        }

        return dependencyAvailable
            ? L10n.t("restore.dependency.ready")
            : L10n.t("restore.dependency.missing")
    }

    var canSwapDisplays: Bool {
        dependencyAvailable
            && !installationInProgress
            && !restoreCommandInProgress
            && (detectedDisplayCount == 2 || detectedDisplayCount == 3)
    }

    var showsSwapDisplaysControl: Bool {
        restoreCommandInProgress
            || installationInProgress
            || dependencyAvailable
            || detectedDisplayCount > 0
    }

    var swapAvailabilityLine: String {
        if installationInProgress {
            return L10n.t("settings.swap.installingHint")
        }

        if !dependencyAvailable {
            return L10n.t("settings.swap.dependencyHint")
        }

        if detectedDisplayCount != 2 && detectedDisplayCount != 3 {
            return L10n.t("runtime.swapRequiresTwo")
        }

        return L10n.t("settings.swap.ready")
    }
}
