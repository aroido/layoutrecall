import Foundation
import LayoutRecallKit

extension AppSession {
    var automaticRestoreControlTitle: String {
        L10n.t("menu.appAutomaticRestore")
    }

    var automaticRestoreToggleTitle: String {
        L10n.t("toggle.enableAppAutomaticRestore")
    }

    var canRestoreSavedProfiles: Bool {
        dependencyAvailable && !installationInProgress && !profiles.isEmpty
    }

    var autoRestoreDisabledContext: RestoreDecisionContext? {
        switch latestDecision?.context {
        case .automaticRestoreDisabled:
            return latestDecision?.context
        default:
            return nil
        }
    }

    var canEnableAutomaticRestoreAction: Bool {
        !autoRestoreEnabled && !profiles.isEmpty
    }

    var referenceProfile: DisplayProfile? {
        if let profileName = latestDecision?.profileName ?? latestMatchedProfileName,
           let matchedProfile = profiles.first(where: { $0.name == profileName })
        {
            return matchedProfile
        }

        return nil
    }

    var currentProfileName: String? {
        referenceProfile?.name
    }

    var confidencePresentation: ConfidencePresentation? {
        guard let latestMatchScore else {
            return nil
        }

        if latestMatchScore >= 85 {
            return .high
        }

        if latestMatchScore >= 70 {
            return .needsReview
        }

        return .low
    }

    var referenceDisplays: [DisplaySnapshot] {
        (referenceProfile?.displaySet.displays ?? [])
            .sorted(by: DisplaySnapshot.positionComparator(lhs:rhs:))
    }

    var liveDisplaysForPreview: [DisplaySnapshot] {
        currentDisplaySnapshots.sorted(by: DisplaySnapshot.positionComparator(lhs:rhs:))
    }

    var referencePrimaryDisplayKey: String? {
        referenceProfile.flatMap(primaryDisplayKey(for:))
    }

    var livePrimaryDisplayKey: String? {
        guard !liveDisplaysForPreview.isEmpty else {
            return nil
        }

        return liveDisplaysForPreview.mainDisplayKey
            ?? liveDisplaysForPreview.first.map { liveDisplaysForPreview.uniqueMatchKey(for: $0) }
    }

    func primaryDisplayKey(for profile: DisplayProfile) -> String? {
        DisplayPresentationBuilder.resolvedPrimaryDisplayKey(
            for: profile.displaySet.displays,
            storedPrimaryDisplayKey: profile.layout.primaryDisplayKey,
            currentDisplays: currentDisplaySnapshots
        )
    }

    var activeDisplayCount: Int {
        if detectedDisplayCount > 0 {
            return detectedDisplayCount
        }

        return referenceProfile?.displaySet.count ?? 0
    }

    var autoRestoreBadgeText: String {
        if !autoRestoreEnabled {
            return L10n.t("status.badge.autoRestoreOff")
        }

        if askBeforeAutomaticRestoreEnabled {
            return L10n.t("status.badge.askBeforeRestore")
        }

        return L10n.t("status.badge.autoRestoreOn")
    }

    var dependencyBadgeText: String {
        if installationInProgress {
            return L10n.t("status.badge.dependencyInstalling")
        }

        return dependencyAvailable
            ? L10n.t("status.badge.dependencyReady")
            : L10n.t("status.badge.dependencyMissing")
    }

    var displayBadgeText: String {
        L10n.t("status.badge.displays", activeDisplayCount)
    }

    var confidenceBadgeText: String? {
        confidencePresentation?.label
    }

    var activeDisplayCountLine: String {
        L10n.t("settings.profileDisplayCountCompact", activeDisplayCount)
    }

    var referenceProfileLine: String {
        guard let currentProfileName else {
            return profiles.isEmpty
                ? L10n.t("settings.referenceProfileMissing")
                : L10n.t("settings.referenceProfileUnmatched")
        }

        return currentProfileName
    }

    var referenceConfidenceLine: String {
        guard currentProfileName != nil else {
            return profiles.isEmpty
                ? L10n.t("settings.referenceConfidenceUnavailable")
                : L10n.t("settings.referenceConfidenceUnmatched")
        }

        guard let confidencePresentation else {
            return L10n.t("settings.referenceConfidenceUnavailable")
        }

        return confidencePresentation.label
    }

    var restoreModeLine: String {
        if !autoRestoreEnabled {
            return L10n.t("restore.manualOnly")
        }

        if askBeforeAutomaticRestoreEnabled {
            return L10n.t("restore.askBeforeAutomatic")
        }

        return L10n.t("restore.automatic")
    }

    var askBeforeRestoreControlTitle: String {
        L10n.t("settings.restore.askBeforeRestore")
    }

    var askBeforeRestoreToggleTitle: String {
        L10n.t("toggle.askBeforeAutomaticRestore")
    }

    var diagnosticsNeedsAttention: Bool {
        guard let latestEntry = diagnostics.first else {
            return false
        }

        switch latestEntry.outcomeTone {
        case .caution, .negative:
            return true
        case .positive, .neutral:
            return false
        }
    }

    var shouldOfferDiagnosticsShortcut: Bool {
        menuPrimaryState != .healthy || diagnosticsNeedsAttention
    }

    var appVersionDescription: String {
        let bundle = Bundle.main
        let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let build = bundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String

        switch (version, build) {
        case let (version?, build?) where !version.isEmpty && !build.isEmpty:
            return L10n.t("settings.versionAndBuild", version, build)
        case let (version?, _):
            return L10n.t("settings.versionOnly", version)
        default:
            return L10n.t("settings.versionUnavailable")
        }
    }

    var latestDiagnosticSummary: String? {
        diagnostics.first?.outcomeSummary
    }

    var latestDiagnosticDetails: String? {
        diagnostics.first?.details
    }

    var diagnosticsReportText: String {
        var lines: [String] = [
            L10n.t("diagnostics.report.title"),
            ""
        ]

        lines.append("\(L10n.t("section.status")): \(statusLine)")
        lines.append("\(L10n.t("settings.referenceDependency")): \(dependencyLine)")
        lines.append("\(L10n.t("settings.referenceDisplays")): \(activeDisplayCountLine)")
        lines.append("\(L10n.t("settings.referenceProfile")): \(referenceProfileLine)")

        if !lastCommand.isEmpty {
            lines.append("\(L10n.t("section.lastCommand")): \(lastCommand)")
        }

        lines.append("")
        lines.append("\(L10n.t("diagnostics.recentHistory")):")

        if diagnostics.isEmpty {
            lines.append(L10n.t("diagnostics.empty"))
        } else {
            for entry in diagnostics.prefix(5) {
                lines.append(entry.supportReportSummaryLine)
                lines.append("  \(entry.details)")
            }
        }

        return lines.joined(separator: "\n")
    }

    var updateStatusTitle: String {
        switch updateState {
        case .idle:
            return L10n.t("update.status.idle")
        case .checking:
            return L10n.t("update.status.checking")
        case .noPublishedReleases:
            return L10n.t("update.status.noPublishedReleases")
        case .upToDate:
            return L10n.t("update.status.upToDate")
        case .available(let release):
            return L10n.t("update.status.available", release.displayVersion)
        case .skipped(let release):
            return L10n.t("update.status.skipped", release.displayVersion)
        case .downloading(let release):
            return L10n.t("update.status.downloading", release.displayVersion)
        case .installing(let release):
            return L10n.t("update.status.installing", release.displayVersion)
        case .failed:
            return L10n.t("update.status.failed")
        }
    }

    var updateStatusDetail: String {
        switch updateState {
        case .idle:
            return automaticUpdateChecksEnabled
                ? L10n.t("update.detail.automaticEnabled")
                : L10n.t("update.detail.automaticDisabled")
        case .checking:
            return L10n.t("update.detail.checking")
        case .noPublishedReleases:
            return L10n.t("update.detail.noPublishedReleases")
        case .upToDate:
            return L10n.t("update.detail.upToDate")
        case .available(let release):
            if let publishedAt = release.publishedAt {
                return L10n.t(
                    "update.detail.availableWithDate",
                    release.displayVersion,
                    publishedAt.formatted(date: .abbreviated, time: .omitted)
                )
            }

            return L10n.t("update.detail.available", release.displayVersion)
        case .skipped(let release):
            return L10n.t("update.detail.skipped", release.displayVersion)
        case .downloading:
            return L10n.t("update.detail.downloading")
        case .installing:
            return L10n.t("update.detail.installing")
        case .failed(let message):
            return message
        }
    }

    var canInstallAvailableUpdate: Bool {
        availableUpdate != nil && !updateState.isBusy
    }
}
