import Foundation
import LayoutRecallKit

extension AppModel {
    func checkForUpdates(userInitiated: Bool, promptIfAvailable: Bool) async {
        guard !updateState.isBusy else {
            return
        }

        updateState = .checking

        do {
            guard let release = try await updateChecker.fetchLatestRelease() else {
                availableUpdate = nil
                updateState = .noPublishedReleases
                return
            }

            guard AppVersionComparator.isNewer(release.versionIdentifier, than: AppRuntimeMetadata.currentVersion) else {
                availableUpdate = nil
                updateState = .upToDate
                return
            }

            availableUpdate = release

            if !userInitiated, skippedReleaseVersion == release.versionIdentifier {
                updateState = .skipped(release)
                return
            }

            updateState = .available(release)

            guard promptIfAvailable,
                  promptedUpdateVersion != release.versionIdentifier else {
                return
            }

            promptedUpdateVersion = release.versionIdentifier

            let promptResponse = await updatePrompt.promptToInstall(
                release: release,
                currentVersion: AppRuntimeMetadata.currentVersion
            )

            switch promptResponse {
            case .install:
                await installUpdate(release)
            case .skipThisVersion:
                await markSkippedRelease(release)
            case .later:
                updateState = .available(release)
            }
        } catch let error as AppUpdateError {
            availableUpdate = nil
            updateState = error == .noPublishedReleases
                ? .noPublishedReleases
                : .failed(error.localizedDescription)
        } catch {
            availableUpdate = nil
            updateState = .failed(error.localizedDescription)
        }
    }

    func markSkippedRelease(_ release: AppRelease) async {
        skippedReleaseVersion = release.versionIdentifier
        availableUpdate = release
        updateState = .skipped(release)
        await persistSettings()
    }

    func installUpdate(_ release: AppRelease) async {
        updateState = .downloading(release)

        do {
            try await updateInstaller.prepareUpdateInstallation(
                release: release,
                replacing: Bundle.main.bundleURL
            )
            updateState = .installing(release)
            terminateApplication()
        } catch {
            availableUpdate = release
            updateState = .failed(error.localizedDescription)
        }
    }

    func recordDiagnostic(
        eventType: String,
        profileName: String?,
        score: Int?,
        actionTaken: String,
        executionResult: String,
        verificationResult: String,
        details: String
    ) async {
        let entry = DiagnosticsEntry(
            eventType: eventType,
            profileName: profileName,
            score: score,
            actionTaken: actionTaken,
            executionResult: executionResult,
            verificationResult: verificationResult,
            details: details
        )

        do {
            try await diagnosticsStore.append(entry)
            diagnostics = try await diagnosticsStore.recentEntries()
        } catch {
            statusLine = L10n.t("status.failedSaveDiagnostics")
            decisionLine = error.localizedDescription
        }
    }
}

extension AppModel {
    var profileStorePath: String {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("LayoutRecall", isDirectory: true)
            .appendingPathComponent("profiles.json", isDirectory: false)
            .path
    }

    var settingsStorePath: String {
        FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Application Support", isDirectory: true)
            .appendingPathComponent("LayoutRecall", isDirectory: true)
            .appendingPathComponent("settings.json", isDirectory: false)
            .path
    }

    func logStartup(_ message: String) async {
        await StartupTraceLogger.shared.append(message)
    }

    func describeDisplays(_ displays: [DisplaySnapshot]) -> String {
        displays
            .sorted(by: DisplaySnapshot.positionComparator)
            .map { display in
                let identifier = display.persistentID ?? display.contextualID ?? display.id
                let mainMarker = display.isMain == true ? ":main" : ""
                return "\(identifier)@(\(display.bounds.x),\(display.bounds.y))\(mainMarker)"
            }
            .joined(separator: ",")
    }

    func describeOrigins(_ origins: [DisplayOrigin]) -> String {
        origins
            .sorted {
                if $0.x != $1.x {
                    return $0.x < $1.x
                }

                if $0.y != $1.y {
                    return $0.y < $1.y
                }

                return $0.key < $1.key
            }
            .map { "\($0.key)@(\($0.x),\($0.y))" }
            .joined(separator: ",")
    }
}
