import Foundation

enum PersistenceTraceLogger {
    static func append(message: String, directoryURL: URL) {
        let fileURL = directoryURL.appendingPathComponent("startup.log", isDirectory: false)
        let formatter = ISO8601DateFormatter()
        let line = [
            "[\(formatter.string(from: Date()))]",
            "pid=\(ProcessInfo.processInfo.processIdentifier)",
            "persistence",
            message
        ]
        .joined(separator: " ") + "\n"

        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)

            if FileManager.default.fileExists(atPath: fileURL.path),
               let handle = try? FileHandle(forWritingTo: fileURL)
            {
                try handle.seekToEnd()
                try handle.write(contentsOf: Data(line.utf8))
                try handle.close()
                return
            }

            try Data(line.utf8).write(to: fileURL, options: .atomic)
        } catch {
            // Debug tracing must never interfere with app persistence.
        }
    }

    static func preview(for data: Data, limit: Int = 180) -> String {
        String(decoding: data.prefix(limit), as: UTF8.self)
            .replacingOccurrences(of: "\n", with: "\\n")
            .replacingOccurrences(of: "\r", with: "\\r")
    }

    static func describe(_ error: Error) -> String {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let type, let context):
                return "typeMismatch(\(type), path=\(codingPath(context.codingPath)), debug=\(context.debugDescription))"
            case .valueNotFound(let type, let context):
                return "valueNotFound(\(type), path=\(codingPath(context.codingPath)), debug=\(context.debugDescription))"
            case .keyNotFound(let key, let context):
                return "keyNotFound(\(key.stringValue), path=\(codingPath(context.codingPath)), debug=\(context.debugDescription))"
            case .dataCorrupted(let context):
                return "dataCorrupted(path=\(codingPath(context.codingPath)), debug=\(context.debugDescription))"
            @unknown default:
                return String(describing: decodingError)
            }
        }

        return String(describing: error)
    }

    private static func codingPath(_ codingPath: [CodingKey]) -> String {
        if codingPath.isEmpty {
            return "<root>"
        }

        return codingPath.map(\.stringValue).joined(separator: ".")
    }
}
