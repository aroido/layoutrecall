import Foundation

actor StartupTraceLogger {
    static let shared = StartupTraceLogger()

    private let fileURL: URL
    private let formatter: ISO8601DateFormatter

    init(fileURL: URL? = nil) {
        self.fileURL = fileURL ?? FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("LayoutRecall", isDirectory: true)
            .appendingPathComponent("startup.log", isDirectory: false)
        self.formatter = ISO8601DateFormatter()
    }

    func append(_ message: String) {
        let directoryURL = fileURL.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

        let line = [
            "[\(formatter.string(from: Date()))]",
            "pid=\(ProcessInfo.processInfo.processIdentifier)",
            "bundle=\(Bundle.main.bundleURL.path)",
            message
        ]
        .joined(separator: " ") + "\n"

        if FileManager.default.fileExists(atPath: fileURL.path),
           let handle = try? FileHandle(forWritingTo: fileURL)
        {
            _ = try? handle.seekToEnd()
            try? handle.write(contentsOf: Data(line.utf8))
            try? handle.close()
            return
        }

        try? Data(line.utf8).write(to: fileURL, options: .atomic)
    }
}
