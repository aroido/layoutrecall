import Foundation
import Testing
@testable import LayoutRecallKit

@Test
func preferredLanguageCodeHonorsExplicitEnvironmentOverride() {
    let languageCode = L10n.preferredLanguageCode(
        preferredLanguageOverride: nil,
        environment: ["AppleLanguages": "(en)"],
        preferredLanguages: ["ko-KR"],
        storedAppleLanguages: ["ko-KR"]
    )

    #expect(languageCode == "en")
}

@Test
func preferredLanguageCodeFallsBackToPreferredLanguages() {
    let languageCode = L10n.preferredLanguageCode(
        preferredLanguageOverride: nil,
        environment: [:],
        preferredLanguages: ["ko-KR"],
        storedAppleLanguages: ["en-US"]
    )

    #expect(languageCode == "ko")
}

@Test
func preferredLanguageCodeDefaultsToEnglishForUnsupportedValues() {
    let languageCode = L10n.preferredLanguageCode(
        preferredLanguageOverride: nil,
        environment: ["AppleLanguages": "(ja-JP)"],
        preferredLanguages: ["fr-FR"],
        storedAppleLanguages: ["de-DE"]
    )

    #expect(languageCode == "en")
}

@Test
func preferredLanguageCodeHonorsStoredAppOverride() {
    let languageCode = L10n.preferredLanguageCode(
        preferredLanguageOverride: "ko",
        environment: ["AppleLanguages": "(en)"],
        preferredLanguages: ["en-US"],
        storedAppleLanguages: ["en-US"]
    )

    #expect(languageCode == "ko")
}

@Test
func localizationKeysStayInSyncAcrossSupportedLanguages() throws {
    let entriesByLanguage = try supportedLanguageCodes.reduce(into: [String: [String: String]]()) { result, languageCode in
        result[languageCode] = try localizationEntries(for: languageCode)
    }

    let baseKeys = Set(entriesByLanguage["en", default: [:]].keys)

    for languageCode in supportedLanguageCodes where languageCode != "en" {
        let localizedKeys = Set(entriesByLanguage[languageCode, default: [:]].keys)
        #expect(localizedKeys == baseKeys)
    }
}

@Test
func localizationFormatSpecifiersStayAlignedAcrossSupportedLanguages() throws {
    let englishEntries = try localizationEntries(for: "en")

    for languageCode in supportedLanguageCodes where languageCode != "en" {
        let localizedEntries = try localizationEntries(for: languageCode)

        for key in englishEntries.keys.sorted() {
            let englishTokens = formatTokens(in: englishEntries[key, default: ""])
            let localizedTokens = formatTokens(in: localizedEntries[key, default: ""])
            #expect(
                localizedTokens == englishTokens,
                "Format tokens for \(key) differ between en and \(languageCode)."
            )
        }
    }
}

private let supportedLanguageCodes = ["en", "ko"]

private func localizationEntries(for languageCode: String) throws -> [String: String] {
    let fileURL = resourceDirectory()
        .appendingPathComponent("\(languageCode).lproj", isDirectory: true)
        .appendingPathComponent("Localizable.strings", isDirectory: false)
    let contents = try String(contentsOf: fileURL, encoding: .utf8)
    let pattern = try NSRegularExpression(pattern: #"^"([^"]+)"\s*=\s*"(.*)";$"#)

    return contents
        .split(separator: "\n", omittingEmptySubsequences: false)
        .reduce(into: [String: String]()) { result, rawLine in
            let line = rawLine.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !line.isEmpty else {
                return
            }

            let nsLine = line as NSString
            let fullRange = NSRange(location: 0, length: nsLine.length)

            guard let match = pattern.firstMatch(in: line, range: fullRange), match.numberOfRanges == 3 else {
                return
            }

            let key = nsLine.substring(with: match.range(at: 1))
            let value = nsLine.substring(with: match.range(at: 2))
            result[key] = value
        }
}

private func formatTokens(in value: String) -> [String] {
    let pattern = try! NSRegularExpression(pattern: #"%(?:\d+\$)?(?:lld|ld|d|@|f)"#)
    let nsValue = value as NSString
    let fullRange = NSRange(location: 0, length: nsValue.length)

    return pattern.matches(in: value, range: fullRange).map { match in
        nsValue.substring(with: match.range)
    }
}

private func resourceDirectory(filePath: StaticString = #filePath) -> URL {
    URL(fileURLWithPath: "\(filePath)")
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Sources", isDirectory: true)
        .appendingPathComponent("LayoutRecallKit", isDirectory: true)
        .appendingPathComponent("Resources", isDirectory: true)
}
