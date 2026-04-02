import Foundation
import LayoutRecallKit

enum MenuPrimaryState: Equatable {
    case noProfiles
    case installingDependency
    case dependencyMissing
    case noMatch
    case lowConfidence
    case reviewBeforeRestore
    case autoRestoreDisabled
    case manualLayoutOverride
    case manualRecovery
    case healthy
}

enum MenuStatePresentation: Equatable {
    case noProfiles
    case installing
    case dependencyMissing
    case noMatch
    case lowConfidence
    case reviewBeforeRestore
    case autoRestoreDisabled
    case manualLayoutOverride
    case manualRecovery
    case healthy

    var badgeText: String {
        switch self {
        case .noProfiles:
            return L10n.t("menu.state.badge.noProfiles")
        case .installing:
            return L10n.t("menu.state.badge.installing")
        case .dependencyMissing:
            return L10n.t("menu.state.badge.dependencyMissing")
        case .noMatch:
            return L10n.t("menu.state.badge.noMatch")
        case .lowConfidence:
            return L10n.t("menu.state.badge.lowConfidence")
        case .reviewBeforeRestore:
            return L10n.t("menu.state.badge.reviewBeforeRestore")
        case .autoRestoreDisabled:
            return L10n.t("menu.state.badge.autoRestoreDisabled")
        case .manualLayoutOverride:
            return L10n.t("menu.state.badge.manualLayoutOverride")
        case .manualRecovery:
            return L10n.t("menu.state.badge.manualRecovery")
        case .healthy:
            return L10n.t("menu.state.badge.healthy")
        }
    }

    var systemImage: String {
        switch self {
        case .noProfiles:
            return "square.and.arrow.down"
        case .installing:
            return "hourglass"
        case .dependencyMissing:
            return "shippingbox"
        case .noMatch:
            return "questionmark.folder"
        case .lowConfidence:
            return "checkmark.seal"
        case .reviewBeforeRestore:
            return "questionmark.circle"
        case .autoRestoreDisabled:
            return "sparkles"
        case .manualLayoutOverride:
            return "arrow.left.and.right.square"
        case .manualRecovery:
            return "bolt.badge.clock"
        case .healthy:
            return "checkmark.circle.fill"
        }
    }
}

enum ConfidencePresentation: Equatable {
    case high
    case needsReview
    case low

    var label: String {
        switch self {
        case .high:
            return L10n.t("confidence.high")
        case .needsReview:
            return L10n.t("confidence.review")
        case .low:
            return L10n.t("confidence.low")
        }
    }
}

enum SurfaceAction: String, CaseIterable, Identifiable {
    case installDependency
    case fixNow
    case enableAutoRestore
    case saveNewProfile

    var id: Self { self }

    var title: String {
        switch self {
        case .installDependency:
            return L10n.t("dependency.installDisplayplacer")
        case .fixNow:
            return L10n.t("action.fixNow")
        case .enableAutoRestore:
            return L10n.t("action.enableAppAutoRestore")
        case .saveNewProfile:
            return L10n.t("action.save")
        }
    }

    var systemImage: String {
        switch self {
        case .installDependency:
            return "arrow.down.circle.fill"
        case .fixNow:
            return "bolt.fill"
        case .enableAutoRestore:
            return "sparkles"
        case .saveNewProfile:
            return "square.and.arrow.down"
        }
    }
}

enum SettingsPane: String, CaseIterable, Hashable, Identifiable {
    case restore
    case profiles
    case shortcuts
    case diagnostics
    case general

    var id: Self { self }

    static var primaryNavigationPanes: [SettingsPane] {
        [.restore, .profiles, .general]
    }

    var navigationPane: SettingsPane {
        switch self {
        case .shortcuts, .diagnostics:
            return .general
        case .restore, .profiles, .general:
            return self
        }
    }

    var title: String {
        switch self {
        case .restore:
            return L10n.t("section.restore")
        case .profiles:
            return L10n.t("section.profiles")
        case .shortcuts:
            return L10n.t("section.shortcuts")
        case .diagnostics:
            return L10n.t("section.diagnostics")
        case .general:
            return L10n.t("section.general")
        }
    }

    var subtitle: String {
        switch self {
        case .restore:
            return L10n.t("settings.restore.subtitle")
        case .profiles:
            return L10n.t("settings.profiles.subtitle")
        case .shortcuts:
            return L10n.t("settings.shortcuts.subtitle")
        case .diagnostics:
            return L10n.t("settings.diagnostics.subtitle")
        case .general:
            return L10n.t("settings.general.subtitle")
        }
    }

    var systemImage: String {
        switch self {
        case .restore:
            return "sparkles.rectangle.stack"
        case .profiles:
            return "square.stack.3d.up.fill"
        case .shortcuts:
            return "command"
        case .diagnostics:
            return "stethoscope"
        case .general:
            return "gearshape"
        }
    }
}

struct ProfileCardActionState: Equatable {
    let canApplyLayout: Bool
    let canIdentifyDisplays: Bool
    let applyTitle: String
    let identifyTitle: String
    let applyHelp: String
    let identifyHelp: String
}

struct SurfaceActionPresentation: Equatable, Identifiable {
    let action: SurfaceAction
    let title: String
    let systemImage: String
    let isDisabled: Bool

    var id: SurfaceAction { action }
}

struct RecoverySurfacePresentation: Equatable {
    let primaryAction: SurfaceActionPresentation?
    let quickActions: [SurfaceActionPresentation]
    let showsInlineFixNow: Bool
    let showsAdvancedMenu: Bool
    let restoreHint: String
    let diagnosticsShortcutHint: String
}
