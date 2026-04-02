import Foundation
import Testing
@testable import LayoutRecallKit

@Test
func layoutRecallStorageDefaultsToCanonicalUserApplicationSupportDirectory() {
    let environmentKey = "LAYOUTRECALL_STORAGE_ROOT"
    let previousValue = ProcessInfo.processInfo.environment[environmentKey]

    unsetenv(environmentKey)
    defer {
        if let previousValue {
            setenv(environmentKey, previousValue, 1)
        }
    }

    let expectedDirectory = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent("Library", isDirectory: true)
        .appendingPathComponent("Application Support", isDirectory: true)
        .appendingPathComponent("LayoutRecall", isDirectory: true)

    #expect(LayoutRecallStorage.baseDirectory().path == expectedDirectory.path)
}

@Test
func layoutRecallStorageBuildsNamedFilesInsideBaseDirectory() {
    let baseDirectory = LayoutRecallStorage.baseDirectory()

    #expect(LayoutRecallStorage.fileURL(named: "profiles.json").path == baseDirectory.appendingPathComponent("profiles.json").path)
    #expect(LayoutRecallStorage.fileURL(named: "settings.json").path == baseDirectory.appendingPathComponent("settings.json").path)
    #expect(LayoutRecallStorage.fileURL(named: "diagnostics.json").path == baseDirectory.appendingPathComponent("diagnostics.json").path)
}

@Test
func profileStoreReloadsProfilesSavedWithIso8601Dates() async throws {
    let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    let fileURL = tempDirectory.appendingPathComponent("profiles.json", isDirectory: false)
    let store = ProfileStore(fileURL: fileURL)

    defer {
        try? FileManager.default.removeItem(at: tempDirectory)
    }

    try await store.saveProfiles([.officeDock])
    let profiles = try await store.loadProfiles()

    #expect(profiles.count == 1)
    #expect(profiles.first?.name == DisplayProfile.officeDock.name)
    #expect(
        abs((profiles.first?.createdAt.timeIntervalSince1970 ?? 0) - DisplayProfile.officeDock.createdAt.timeIntervalSince1970) < 1
    )
    #expect(profiles.first?.layout.engine.command == DisplayProfile.officeDock.layout.engine.command)
}

@Test
func displayProfilesDecodeFromPersistedAppSchema() throws {
    let data = persistedAppSchemaFixtureData()

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let profiles = try decoder.decode([DisplayProfile].self, from: data)

    #expect(profiles.count == 1)
    #expect(profiles.first?.name == "작업공간 1")
    #expect(profiles.first?.displaySet.displays.count == 2)
    #expect(profiles.first?.displaySet.displays.first?.scale == 2)
    #expect(profiles.first?.settings.confidenceThreshold == 70)
}

@Test
func displayProfilesReencodeWithoutLegacyAutoRestoreField() throws {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let profiles = try decoder.decode([DisplayProfile].self, from: persistedAppSchemaFixtureData())

    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encoded = try encoder.encode(profiles)
    let encodedString = String(decoding: encoded, as: UTF8.self)

    #expect(encodedString.contains("\"confidenceThreshold\""))
    #expect(!encodedString.contains("\"autoRestore\""))
}

@Test
func profileStoreLoadsPersistedAppSchemaFixture() async throws {
    let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    let fileURL = tempDirectory.appendingPathComponent("profiles.json", isDirectory: false)
    let store = ProfileStore(fileURL: fileURL)

    defer {
        try? FileManager.default.removeItem(at: tempDirectory)
    }

    try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    try persistedAppSchemaFixtureData().write(to: fileURL, options: .atomic)

    let profiles = try await store.loadProfiles()

    #expect(profiles.count == 1)
    #expect(profiles.first?.name == "작업공간 1")
    #expect(profiles.first?.displaySet.fingerprint == "1962f01e-5158-401f-8ba4-9480cd7dc215|4e747025-110e-4dcd-bd2f-cd0f28d043d5")
}

@Test
func storesLoadDataFromFileURLsWithSpacesInPath() async throws {
    let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    let storageDirectory = tempDirectory.appendingPathComponent("Application Support", isDirectory: true)

    defer {
        try? FileManager.default.removeItem(at: tempDirectory)
    }

    let profileStore = ProfileStore(fileURL: storageDirectory.appendingPathComponent("profiles.json", isDirectory: false))
    let settingsStore = AppSettingsStore(fileURL: storageDirectory.appendingPathComponent("settings.json", isDirectory: false))
    let diagnosticsStore = DiagnosticsLogger(fileURL: storageDirectory.appendingPathComponent("diagnostics.json", isDirectory: false))

    try await profileStore.saveProfiles([.officeDock])
    try await settingsStore.saveSettings(
        AppSettings(
            launchAtLogin: true,
            shortcuts: ShortcutSettings(
                fixNow: ShortcutBinding(keyCode: 15, modifiersRawValue: 1 << 20, keyDisplay: "R")
            ),
            automaticallyCheckForUpdates: false,
            skippedReleaseVersion: "9.9.9",
            preferredLanguageCode: "ko"
        )
    )
    try await diagnosticsStore.append(
        DiagnosticsEntry(
            eventType: "manual",
            profileName: "Office Dock",
            score: 90,
            actionTaken: "save-profile",
            executionResult: "skipped",
            verificationResult: "skipped",
            details: "saved"
        )
    )

    let profiles = try await profileStore.loadProfiles()
    let settings = try await settingsStore.loadSettings()
    let diagnostics = try await diagnosticsStore.recentEntries()

    #expect(profiles.count == 1)
    #expect(settings.launchAtLogin == true)
    #expect(settings.preferredLanguageCode == "ko")
    #expect(diagnostics.count == 1)
    #expect(diagnostics.first?.profileName == "Office Dock")
}

private func persistedAppSchemaFixtureData() -> Data {
    Data(
        """
        [
          {
            "createdAt" : "2026-03-30T13:00:25Z",
            "displaySet" : {
              "count" : 2,
              "displays" : [
                {
                  "bounds" : {
                    "height" : 1080,
                    "width" : 1920,
                    "x" : -1920,
                    "y" : 0
                  },
                  "id" : "1",
                  "isMain" : false,
                  "persistentID" : "1962f01e-5158-401f-8ba4-9480cd7dc215",
                  "productID" : 9984,
                  "refreshRate" : 60,
                  "resolution" : {
                    "height" : 2160,
                    "width" : 3840
                  },
                  "scale" : 2,
                  "serialNumber" : "1",
                  "vendorID" : 13924
                },
                {
                  "bounds" : {
                    "height" : 1080,
                    "width" : 1920,
                    "x" : 0,
                    "y" : 0
                  },
                  "contextualID" : "2",
                  "id" : "3",
                  "isMain" : true,
                  "persistentID" : "4e747025-110e-4dcd-bd2f-cd0f28d043d5",
                  "productID" : 9984,
                  "refreshRate" : 60,
                  "resolution" : {
                    "height" : 2160,
                    "width" : 3840
                  },
                  "scale" : 2,
                  "serialNumber" : "1",
                  "vendorID" : 13924
                }
              ],
              "fingerprint" : "1962f01e-5158-401f-8ba4-9480cd7dc215|4e747025-110e-4dcd-bd2f-cd0f28d043d5"
            },
            "id" : "F8625A45-FC27-4346-8B76-FEC8E4400484",
            "layout" : {
              "engine" : {
                "command" : "displayplacer 'id:1962F01E-5158-401F-8BA4-9480CD7DC215 enabled:true origin:(-1920,0) res:1920x1080 hz:60 scaling:on' 'id:4E747025-110E-4DCD-BD2F-CD0F28D043D5 enabled:true origin:(0,0) res:1920x1080 hz:60 scaling:on'",
                "type" : "displayplacer"
              },
              "expectedOrigins" : [
                {
                  "key" : "1962f01e-5158-401f-8ba4-9480cd7dc215",
                  "x" : -1920,
                  "y" : 0
                },
                {
                  "key" : "4e747025-110e-4dcd-bd2f-cd0f28d043d5",
                  "x" : 0,
                  "y" : 0
                }
              ],
              "primaryDisplayKey" : "4e747025-110e-4dcd-bd2f-cd0f28d043d5"
            },
            "name" : "작업공간 1",
            "settings" : {
              "autoRestore" : true,
              "confidenceThreshold" : 70
            }
          }
        ]
        """.utf8
    )
}
