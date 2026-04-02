import Testing
@testable import LayoutRecallApp
@testable import LayoutRecallKit

@Test
func settingsNavigationKeepsAcceptedThreePaneIA() {
    #expect(SettingsPane.primaryNavigationPanes == [.restore, .profiles, .general])
    #expect(SettingsPane.restore.navigationPane == .restore)
    #expect(SettingsPane.profiles.navigationPane == .profiles)
    #expect(SettingsPane.general.navigationPane == .general)
    #expect(SettingsPane.shortcuts.navigationPane == .general)
    #expect(SettingsPane.diagnostics.navigationPane == .general)
}

@Test
func coreSurfaceActionsExposePhaseTwoRecoveryLoopCopy() {
    #expect(SurfaceAction.installDependency.title == L10n.t("dependency.installDisplayplacer"))
    #expect(SurfaceAction.fixNow.title == L10n.t("action.fixNow"))
    #expect(SurfaceAction.enableAutoRestore.title == L10n.t("action.enableAppAutoRestore"))
    #expect(SurfaceAction.saveNewProfile.title == L10n.t("action.save"))
}

@Test
func recoverySurfacePresentationCarriesResolvedActionMetadata() {
    let install = SurfaceActionPresentation(
        action: .installDependency,
        title: L10n.t("dependency.installingDisplayplacer"),
        systemImage: "hourglass",
        isDisabled: true
    )
    let save = SurfaceActionPresentation(
        action: .saveNewProfile,
        title: L10n.t("menu.action.saveAnotherBaseline"),
        systemImage: SurfaceAction.saveNewProfile.systemImage,
        isDisabled: false
    )
    let presentation = RecoverySurfacePresentation(
        primaryAction: install,
        quickActions: [save],
        showsInlineFixNow: false,
        showsAdvancedMenu: true,
        restoreHint: L10n.t("settings.restore.installingHint"),
        diagnosticsShortcutHint: L10n.t("settings.restore.openDiagnosticsHint")
    )

    #expect(presentation.primaryAction?.action == .installDependency)
    #expect(presentation.primaryAction?.title == L10n.t("dependency.installingDisplayplacer"))
    #expect(presentation.quickActions.map(\.action) == [.saveNewProfile])
    #expect(presentation.showsAdvancedMenu == true)
}

@Test
func diagnosticsPresentationMapsKnownActionsAndOutcomes() {
    let entry = DiagnosticsEntry(
        eventType: DisplayEventType.manual.rawValue,
        profileName: "Office Dock",
        score: 92,
        actionTaken: "manual-fix",
        executionResult: RestoreExecutionOutcome.success.rawValue,
        verificationResult: RestoreVerificationOutcome.success.rawValue,
        details: "Restored both displays."
    )

    #expect(entry.displayTitle == L10n.t("diagnostic.title.fixNow"))
    #expect(entry.confidenceSummary == L10n.t("confidence.high"))
    #expect(entry.outcomeSummary == L10n.t("diagnostic.outcome.appliedVerified"))
    #expect(entry.outcomeTone == .positive)
    #expect(entry.supportReportSummaryLine.contains("Office Dock"))
}
