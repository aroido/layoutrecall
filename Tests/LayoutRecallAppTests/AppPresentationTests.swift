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
