import AppKit
import ApplicationServices
import CoreGraphics
import Foundation
import Testing

@Test
func liveUIHarnessShowsMenuWindow() async throws {
    guard let appBundlePath = configuredLiveUIAppBundlePath() else {
        return
    }

    let runningApp = try await launchUIHarness(
        appBundlePath: appBundlePath,
        openSettingsOnLaunch: false
    )
    defer {
        runningApp.terminate()
    }

    _ = try await waitForWindowBounds(
        ownerPID: runningApp.processIdentifier,
        description: "menu harness window"
    ) { bounds in
        bounds.width >= 280 && bounds.width <= 340 && bounds.height >= 220 && bounds.height <= 400
    }
}

@Test
func liveUIHarnessOpensSettingsWindowOnLaunch() async throws {
    guard let appBundlePath = configuredLiveUIAppBundlePath() else {
        return
    }

    let runningApp = try await launchUIHarness(
        appBundlePath: appBundlePath,
        openSettingsOnLaunch: true
    )
    defer {
        runningApp.terminate()
    }

    _ = try await waitForWindowBounds(
        ownerPID: runningApp.processIdentifier,
        description: "settings window"
    ) { bounds in
        bounds.width >= 700 && bounds.height >= 500
    }
}

private final class LiveUIHarnessHandle {
    let processIdentifier: pid_t
    private let runningApplication: NSRunningApplication
    private let temporaryRoot: URL

    init(runningApplication: NSRunningApplication, temporaryRoot: URL) {
        self.processIdentifier = runningApplication.processIdentifier
        self.runningApplication = runningApplication
        self.temporaryRoot = temporaryRoot
    }

    func terminate() {
        if !runningApplication.terminate() {
            runningApplication.forceTerminate()
        }

        try? FileManager.default.removeItem(at: temporaryRoot)
    }
}

private func configuredLiveUIAppBundlePath() -> String? {
    guard ProcessInfo.processInfo.environment["LAYOUTRECALL_RUN_LIVE_UI_TESTS"] == "1" else {
        return nil
    }

    guard AXIsProcessTrusted() else {
        Issue.record("Accessibility access is required for live UI automation tests.")
        return nil
    }

    return NSString(
        string: ProcessInfo.processInfo.environment["LAYOUTRECALL_UI_APP_BUNDLE_PATH"]
            ?? "~/Applications/LayoutRecall.app"
    ).expandingTildeInPath
}

private func launchUIHarness(
    appBundlePath: String,
    openSettingsOnLaunch: Bool
) async throws -> LiveUIHarnessHandle {
    let temporaryRoot = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
    try FileManager.default.createDirectory(at: temporaryRoot, withIntermediateDirectories: true)

    let launchStart = Date()
    let openProcess = Process()
    openProcess.executableURL = URL(fileURLWithPath: "/usr/bin/open")
    openProcess.arguments = [
        "-n",
        appBundlePath,
        "--args",
        "--ui-test-harness"
    ]

    if openSettingsOnLaunch {
        openProcess.arguments?.append("--open-settings-on-launch")
    }

    openProcess.arguments?.append(contentsOf: [
        "--storage-root",
        temporaryRoot.path
    ])

    try openProcess.run()
    openProcess.waitUntilExit()

    let runningApplication = try await waitForRunningApplication(
        bundleIdentifier: "com.aroido.layoutrecall",
        launchedAfter: launchStart
    )

    return LiveUIHarnessHandle(
        runningApplication: runningApplication,
        temporaryRoot: temporaryRoot
    )
}

private func waitForRunningApplication(
    bundleIdentifier: String,
    launchedAfter launchDate: Date,
    timeoutNanoseconds: UInt64 = 10_000_000_000,
    pollNanoseconds: UInt64 = 100_000_000
) async throws -> NSRunningApplication {
    let attempts = max(1, Int(timeoutNanoseconds / pollNanoseconds))

    for _ in 0..<attempts {
        if let app = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
            .filter({ ($0.launchDate ?? .distantPast) >= launchDate.addingTimeInterval(-1) })
            .sorted(by: { ($0.launchDate ?? .distantPast) > ($1.launchDate ?? .distantPast) })
            .first
        {
            return app
        }

        try? await Task.sleep(nanoseconds: pollNanoseconds)
    }

    throw UIAutomationError.timedOut("application \(bundleIdentifier) to launch")
}

private func waitForWindowBounds(
    ownerPID: pid_t,
    description: String,
    timeoutNanoseconds: UInt64 = 10_000_000_000,
    pollNanoseconds: UInt64 = 100_000_000,
    where matches: (CGRect) -> Bool
) async throws -> CGRect {
    let attempts = max(1, Int(timeoutNanoseconds / pollNanoseconds))

    for _ in 0..<attempts {
        if let bounds = currentWindowBounds(ownerPID: ownerPID).first(where: matches) {
            return bounds
        }

        try? await Task.sleep(nanoseconds: pollNanoseconds)
    }

    throw UIAutomationError.timedOut(description)
}

private enum UIAutomationError: LocalizedError {
    case timedOut(String)

    var errorDescription: String? {
        switch self {
        case .timedOut(let description):
            return description
        }
    }
}

private func currentWindowBounds(ownerPID: pid_t) -> [CGRect] {
    let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []

    return windows.compactMap { window in
        guard let pid = window[kCGWindowOwnerPID as String] as? pid_t,
              pid == ownerPID,
              let bounds = window[kCGWindowBounds as String] as? [String: Any],
              let x = bounds["X"] as? CGFloat,
              let y = bounds["Y"] as? CGFloat,
              let width = bounds["Width"] as? CGFloat,
              let height = bounds["Height"] as? CGFloat
        else {
            return nil
        }

        return CGRect(x: x, y: y, width: width, height: height)
    }
}
