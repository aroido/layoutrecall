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
    let data = Data(
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

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let profiles = try decoder.decode([DisplayProfile].self, from: data)

    #expect(profiles.count == 1)
    #expect(profiles.first?.name == "작업공간 1")
    #expect(profiles.first?.displaySet.displays.count == 2)
    #expect(profiles.first?.displaySet.displays.first?.scale == 2)
}
