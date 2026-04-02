import Foundation
import LayoutRecallKit

actor UITestRestoreExecutor: RestoreExecuting {
    func dependencyStatus() async -> RestoreDependencyStatus {
        RestoreDependencyStatus(
            isAvailable: true,
            location: "/opt/homebrew/bin/displayplacer",
            details: L10n.t("restoreExecutor.availableAt", "/opt/homebrew/bin/displayplacer")
        )
    }

    func execute(command: String) async -> RestoreExecutionResult {
        RestoreExecutionResult(
            outcome: .success,
            command: command,
            exitCode: 0,
            stdout: "",
            stderr: "",
            duration: 0.01,
            details: L10n.t("restoreExecutor.success")
        )
    }
}

actor UITestDependencyInstaller: DependencyInstalling {
    func installDisplayplacerIfNeeded() async -> DependencyInstallResult {
        DependencyInstallResult(
            outcome: .alreadyInstalled,
            dependency: "displayplacer",
            location: "/opt/homebrew/bin/displayplacer",
            details: L10n.t("dependencyInstaller.alreadyInstalled", "/opt/homebrew/bin/displayplacer")
        )
    }
}

actor UITestRestoreVerifier: RestoreVerifying {
    func verify(expectedOrigins: [DisplayOrigin], using reader: any DisplaySnapshotReading) async -> RestoreVerificationResult {
        RestoreVerificationResult(
            outcome: .success,
            attempts: 1,
            details: L10n.t("verification.success")
        )
    }
}

actor UITestLoginItemManager: LoginItemManaging {
    private var state: LaunchAtLoginState = .disabled

    func currentState() async -> LaunchAtLoginState {
        state
    }

    func setEnabled(_ enabled: Bool) async throws -> LaunchAtLoginState {
        state = enabled ? .enabled : .disabled
        return state
    }
}

actor UITestShortcutManager: ShortcutManaging {
    func configure(
        shortcuts: ShortcutSettings,
        handler: @escaping @Sendable (ShortcutAction) -> Void
    ) async throws {}
}

actor UITestUpdateChecker: AppUpdateChecking {
    func fetchLatestRelease() async throws -> AppRelease? {
        AppRelease(
            tagName: "v9.9.9",
            version: "9.9.9",
            assetName: "LayoutRecall-9.9.9-macos.zip",
            downloadURL: URL(string: "https://example.com/LayoutRecall-9.9.9-macos.zip")!,
            publishedAt: nil,
            releaseNotes: "UI automation test release."
        )
    }
}

actor UITestUpdateInstaller: AppUpdateInstalling {
    func prepareUpdateInstallation(release: AppRelease, replacing bundleURL: URL) async throws {}
}
