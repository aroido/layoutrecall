import Foundation
import Testing
@testable import LayoutRecallKit

@Test
func appSettingsDecodeLegacyPayloadWithNewRestoreControlsDisabledByDefault() throws {
    let data = Data(
        """
        {
          "automaticRestoreEnabled": true,
          "launchAtLogin": false,
          "shortcuts": {},
          "automaticallyCheckForUpdates": true
        }
        """.utf8
    )

    let settings = try JSONDecoder().decode(AppSettings.self, from: data)

    #expect(settings.askBeforeAutomaticRestore == false)
    #expect(settings.ignoredCurrentSetup == nil)
}

@Test
func appSettingsRoundTripRestoreConfirmationAndIgnoredSetup() throws {
    let original = AppSettings(
        automaticRestoreEnabled: true,
        askBeforeAutomaticRestore: true,
        launchAtLogin: false,
        shortcuts: ShortcutSettings(),
        automaticallyCheckForUpdates: true,
        skippedReleaseVersion: nil,
        preferredLanguageCode: "en",
        ignoredCurrentSetup: IgnoredCurrentSetup(
            displayFingerprint: DisplaySnapshot.developmentDesk.fingerprint,
            expectedOrigins: DisplayProfile.officeDock.layout.expectedOrigins
        )
    )

    let data = try JSONEncoder().encode(original)
    let decoded = try JSONDecoder().decode(AppSettings.self, from: data)

    #expect(decoded == original)
}
