import AppKit
import Foundation

public enum ShortcutAction: String, Codable, CaseIterable, Sendable {
    case fixNow
    case saveCurrentLayout
    case swapLeftRight

    public var title: String {
        switch self {
        case .fixNow:
            return L10n.t("shortcut.fixNow.title")
        case .saveCurrentLayout:
            return L10n.t("shortcut.saveCurrentLayout.title")
        case .swapLeftRight:
            return L10n.t("shortcut.swapLeftRight.title")
        }
    }

    public var detail: String {
        switch self {
        case .fixNow:
            return L10n.t("shortcut.fixNow.detail")
        case .saveCurrentLayout:
            return L10n.t("shortcut.saveCurrentLayout.detail")
        case .swapLeftRight:
            return L10n.t("shortcut.swapLeftRight.detail")
        }
    }
}

public struct ShortcutBinding: Codable, Equatable, Hashable, Sendable {
    public var keyCode: UInt16
    public var modifiersRawValue: UInt
    public var keyDisplay: String

    public init(keyCode: UInt16, modifiersRawValue: UInt, keyDisplay: String) {
        self.keyCode = keyCode
        self.modifiersRawValue = modifiersRawValue
        self.keyDisplay = keyDisplay
    }

    public var modifierFlags: NSEvent.ModifierFlags {
        NSEvent.ModifierFlags(rawValue: modifiersRawValue)
            .intersection([.command, .option, .control, .shift])
    }

    public var displayString: String {
        let symbols = [
            modifierFlags.contains(.control) ? "⌃" : nil,
            modifierFlags.contains(.option) ? "⌥" : nil,
            modifierFlags.contains(.shift) ? "⇧" : nil,
            modifierFlags.contains(.command) ? "⌘" : nil
        ]
        .compactMap { $0 }
        .joined()

        return symbols + keyDisplay
    }
}

public struct ShortcutSettings: Codable, Equatable, Sendable {
    public var fixNow: ShortcutBinding?
    public var saveCurrentLayout: ShortcutBinding?
    public var swapLeftRight: ShortcutBinding?

    public init(
        fixNow: ShortcutBinding? = nil,
        saveCurrentLayout: ShortcutBinding? = nil,
        swapLeftRight: ShortcutBinding? = nil
    ) {
        self.fixNow = fixNow
        self.saveCurrentLayout = saveCurrentLayout
        self.swapLeftRight = swapLeftRight
    }

    public subscript(action: ShortcutAction) -> ShortcutBinding? {
        get {
            switch action {
            case .fixNow:
                return fixNow
            case .saveCurrentLayout:
                return saveCurrentLayout
            case .swapLeftRight:
                return swapLeftRight
            }
        }
        set {
            switch action {
            case .fixNow:
                fixNow = newValue
            case .saveCurrentLayout:
                saveCurrentLayout = newValue
            case .swapLeftRight:
                swapLeftRight = newValue
            }
        }
    }
}

public struct IgnoredCurrentSetup: Codable, Equatable, Sendable {
    public var displayFingerprint: String
    public var expectedOrigins: [DisplayOrigin]

    public init(displayFingerprint: String, expectedOrigins: [DisplayOrigin]) {
        self.displayFingerprint = displayFingerprint
        self.expectedOrigins = expectedOrigins
    }
}

public enum AppLanguageOption: String, CaseIterable, Codable, Sendable, Identifiable {
    case system
    case english
    case korean

    public var id: Self { self }

    public init(preferredLanguageCode: String?) {
        switch preferredLanguageCode?.lowercased() {
        case "ko":
            self = .korean
        case "en":
            self = .english
        default:
            self = .system
        }
    }

    public var preferredLanguageCode: String? {
        switch self {
        case .system:
            return nil
        case .english:
            return "en"
        case .korean:
            return "ko"
        }
    }
}

public struct AppSettings: Codable, Equatable, Sendable {
    public var automaticRestoreEnabled: Bool
    public var askBeforeAutomaticRestore: Bool
    public var launchAtLogin: Bool
    public var shortcuts: ShortcutSettings
    public var automaticallyCheckForUpdates: Bool
    public var skippedReleaseVersion: String?
    public var preferredLanguageCode: String?
    public var ignoredCurrentSetup: IgnoredCurrentSetup?

    enum CodingKeys: String, CodingKey {
        case automaticRestoreEnabled
        case askBeforeAutomaticRestore
        case launchAtLogin
        case shortcuts
        case automaticallyCheckForUpdates
        case skippedReleaseVersion
        case preferredLanguageCode
        case ignoredCurrentSetup
    }

    public init(
        automaticRestoreEnabled: Bool = true,
        askBeforeAutomaticRestore: Bool = false,
        launchAtLogin: Bool = false,
        shortcuts: ShortcutSettings = ShortcutSettings(),
        automaticallyCheckForUpdates: Bool = true,
        skippedReleaseVersion: String? = nil,
        preferredLanguageCode: String? = nil,
        ignoredCurrentSetup: IgnoredCurrentSetup? = nil
    ) {
        self.automaticRestoreEnabled = automaticRestoreEnabled
        self.askBeforeAutomaticRestore = askBeforeAutomaticRestore
        self.launchAtLogin = launchAtLogin
        self.shortcuts = shortcuts
        self.automaticallyCheckForUpdates = automaticallyCheckForUpdates
        self.skippedReleaseVersion = skippedReleaseVersion
        self.preferredLanguageCode = preferredLanguageCode
        self.ignoredCurrentSetup = ignoredCurrentSetup
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        automaticRestoreEnabled = try container.decodeIfPresent(Bool.self, forKey: .automaticRestoreEnabled) ?? true
        askBeforeAutomaticRestore = try container.decodeIfPresent(Bool.self, forKey: .askBeforeAutomaticRestore) ?? false
        launchAtLogin = try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false
        shortcuts = try container.decodeIfPresent(ShortcutSettings.self, forKey: .shortcuts) ?? ShortcutSettings()
        automaticallyCheckForUpdates = try container.decodeIfPresent(Bool.self, forKey: .automaticallyCheckForUpdates) ?? true
        skippedReleaseVersion = try container.decodeIfPresent(String.self, forKey: .skippedReleaseVersion)
        preferredLanguageCode = try container.decodeIfPresent(String.self, forKey: .preferredLanguageCode)
        ignoredCurrentSetup = try container.decodeIfPresent(IgnoredCurrentSetup.self, forKey: .ignoredCurrentSetup)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(automaticRestoreEnabled, forKey: .automaticRestoreEnabled)
        try container.encode(askBeforeAutomaticRestore, forKey: .askBeforeAutomaticRestore)
        try container.encode(launchAtLogin, forKey: .launchAtLogin)
        try container.encode(shortcuts, forKey: .shortcuts)
        try container.encode(automaticallyCheckForUpdates, forKey: .automaticallyCheckForUpdates)
        try container.encodeIfPresent(skippedReleaseVersion, forKey: .skippedReleaseVersion)
        try container.encodeIfPresent(preferredLanguageCode, forKey: .preferredLanguageCode)
        try container.encodeIfPresent(ignoredCurrentSetup, forKey: .ignoredCurrentSetup)
    }
}
