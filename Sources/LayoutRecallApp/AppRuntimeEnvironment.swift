import AppKit
import Foundation
import LayoutRecallKit

struct RunningApplicationSnapshot: Equatable {
    let processIdentifier: pid_t
    let launchDate: Date?
}

enum AppInstanceResolver {
    static func existingPrimaryInstance(
        in snapshots: [RunningApplicationSnapshot],
        currentPID: pid_t
    ) -> RunningApplicationSnapshot? {
        snapshots
            .filter { $0.processIdentifier != currentPID }
            .sorted { lhs, rhs in
                (normalizedDate(lhs.launchDate), lhs.processIdentifier) < (normalizedDate(rhs.launchDate), rhs.processIdentifier)
            }
            .first
    }

    @MainActor
    static func existingPrimaryInstance(
        bundleIdentifier: String,
        currentPID: pid_t = ProcessInfo.processInfo.processIdentifier
    ) -> NSRunningApplication? {
        let applications = NSRunningApplication.runningApplications(withBundleIdentifier: bundleIdentifier)
        let snapshots = applications.map {
            RunningApplicationSnapshot(
                processIdentifier: $0.processIdentifier,
                launchDate: $0.launchDate
            )
        }

        guard let resolved = existingPrimaryInstance(in: snapshots, currentPID: currentPID) else {
            return nil
        }

        return applications.first { $0.processIdentifier == resolved.processIdentifier }
    }

    private static func normalizedDate(_ date: Date?) -> Date {
        date ?? .distantPast
    }
}

enum AppLaunchSignal {
    static let revealExistingInstance = Notification.Name("com.aroido.layoutrecall.revealExistingInstance")
}

@MainActor
enum AppLaunchMode {
    case standard
    case uiAutomationHarness

    static var current: AppLaunchMode {
        RuntimeLaunchArguments.contains("--ui-test-harness")
            || ProcessInfo.processInfo.environment["LAYOUTRECALL_UI_TEST_HARNESS"] == "1"
            ? .uiAutomationHarness
            : .standard
    }

    var activationPolicy: NSApplication.ActivationPolicy {
        switch self {
        case .standard:
            return .accessory
        case .uiAutomationHarness:
            return .regular
        }
    }
}

enum RuntimeLaunchArguments {
    static func contains(_ flag: String) -> Bool {
        CommandLine.arguments.contains(flag)
    }

    static func value(for option: String) -> String? {
        if let exactMatch = CommandLine.arguments.first(where: { $0.hasPrefix("\(option)=") }) {
            return String(exactMatch.dropFirst(option.count + 1))
        }

        guard let index = CommandLine.arguments.firstIndex(of: option),
              CommandLine.arguments.indices.contains(index + 1)
        else {
            return nil
        }

        return CommandLine.arguments[index + 1]
    }
}

@MainActor
func makeAppModel(for launchMode: AppLaunchMode) -> AppSession {
    switch launchMode {
    case .standard:
        return AppModel(
            updateChecker: GitHubReleaseChecker(),
            updateInstaller: GitHubReleaseInstaller(),
            updatePrompt: NSAlertUpdatePrompt()
        )
    case .uiAutomationHarness:
        return AppModel(
            executor: UITestRestoreExecutor(),
            dependencyInstaller: UITestDependencyInstaller(),
            verifier: UITestRestoreVerifier(),
            loginItemManager: UITestLoginItemManager(),
            shortcutManager: UITestShortcutManager(),
            updateChecker: UITestUpdateChecker(),
            updateInstaller: UITestUpdateInstaller(),
            updatePrompt: NoopAppUpdatePrompt()
        )
    }
}
