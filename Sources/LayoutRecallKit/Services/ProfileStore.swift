import Foundation

public actor ProfileStore: ProfileStoring {
    public let fileURL: URL

    public init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? LayoutRecallStorage.fileURL(named: "profiles.json")
    }

    public func loadProfiles() async throws -> [DisplayProfile] {
        let exists = FileManager.default.fileExists(atPath: fileURL.path)
        trace(
            "ProfileStore.loadProfiles begin path=\(fileURL.path) exists=\(exists) args=\(CommandLine.arguments.joined(separator: " ")) storageRootEnv=\(ProcessInfo.processInfo.environment["LAYOUTRECALL_STORAGE_ROOT"] ?? "<nil>")"
        )

        guard exists else {
            trace("ProfileStore.loadProfiles returning [] because file is missing")
            return []
        }

        let data = try Data(contentsOf: fileURL)
        trace(
            "ProfileStore.loadProfiles read bytes=\(data.count) preview=\(PersistenceTraceLogger.preview(for: data))"
        )
        let iso8601Decoder = JSONDecoder()
        iso8601Decoder.dateDecodingStrategy = .iso8601

        do {
            let profiles = try iso8601Decoder.decode([DisplayProfile].self, from: data)
            trace("ProfileStore.loadProfiles iso8601 decode success count=\(profiles.count)")
            return profiles
        } catch {
            trace("ProfileStore.loadProfiles iso8601 decode failed error=\(PersistenceTraceLogger.describe(error))")
        }

        do {
            let profiles = try JSONDecoder().decode([DisplayProfile].self, from: data)
            trace("ProfileStore.loadProfiles fallback decode success count=\(profiles.count)")
            return profiles
        } catch {
            trace("ProfileStore.loadProfiles fallback decode failed error=\(PersistenceTraceLogger.describe(error))")
            throw error
        }
    }

    public func saveProfiles(_ profiles: [DisplayProfile]) async throws {
        trace("ProfileStore.saveProfiles begin count=\(profiles.count) path=\(fileURL.path)")
        try FileManager.default.createDirectory(
            at: fileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(profiles)
        try data.write(to: fileURL, options: .atomic)
        trace(
            "ProfileStore.saveProfiles wrote bytes=\(data.count) count=\(profiles.count) preview=\(PersistenceTraceLogger.preview(for: data))"
        )
    }

    private func trace(_ message: String) {
        PersistenceTraceLogger.append(
            message: message,
            directoryURL: fileURL.deletingLastPathComponent()
        )
    }
}
