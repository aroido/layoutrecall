import AppKit
import LayoutRecallKit
import SwiftUI

struct DisplayPresentationDescriptor: Identifiable, Equatable, Sendable {
    let id: String
    let display: DisplaySnapshot
    let index: Int
    let isPrimary: Bool
    let title: String
    let detail: String
}

struct DisplayIdentificationMarker: Identifiable, Equatable, Sendable {
    let id: String
    let displayID: String
    let index: Int
    let isPrimary: Bool
    let title: String
    let detail: String
}

enum DisplayPresentationBuilder {
    static func descriptors(
        for displays: [DisplaySnapshot],
        primaryDisplayKey: String?
    ) -> [DisplayPresentationDescriptor] {
        let sortedDisplays = displays.sorted(by: DisplaySnapshot.positionComparator(lhs:rhs:))
        let effectivePrimaryDisplayKey = primaryDisplayKey ?? sortedDisplays.mainDisplayKey
        let primaryDisplay = sortedDisplays.first { display in
            effectivePrimaryDisplayKey.map(display.allMatchKeys.contains) ?? false
        } ?? sortedDisplays.first

        return sortedDisplays.enumerated().map { index, display in
            let isPrimary = primaryDisplay.map { $0.id == display.id } ?? false
            return DisplayPresentationDescriptor(
                id: display.id,
                display: display,
                index: index + 1,
                isPrimary: isPrimary,
                title: title(for: display, primaryDisplay: primaryDisplay, isPrimary: isPrimary),
                detail: resolutionSummary(for: display)
            )
        }
    }

    static func resolvedPrimaryDisplayKey(
        for savedDisplays: [DisplaySnapshot],
        storedPrimaryDisplayKey: String?,
        currentDisplays: [DisplaySnapshot]
    ) -> String? {
        if savedDisplays.count == currentDisplays.count,
           let currentMainDisplay = currentDisplays.first(where: { $0.isMain == true }),
           let savedDisplayIndex = bestMatchIndex(for: currentMainDisplay, candidates: savedDisplays)
        {
            return savedDisplays.uniqueMatchKey(for: savedDisplays[savedDisplayIndex])
        }

        return storedPrimaryDisplayKey ?? savedDisplays.mainDisplayKey
    }

    static func identificationMarkers(
        for savedDisplays: [DisplaySnapshot],
        primaryDisplayKey: String?,
        currentDisplays: [DisplaySnapshot]
    ) -> [DisplayIdentificationMarker] {
        let descriptors = descriptors(for: savedDisplays, primaryDisplayKey: primaryDisplayKey)
        var remainingCurrentDisplays = currentDisplays

        return descriptors.compactMap { descriptor in
            guard let matchIndex = bestMatchIndex(
                for: descriptor.display,
                candidates: remainingCurrentDisplays
            ) else {
                return nil
            }

            let currentDisplay = remainingCurrentDisplays.remove(at: matchIndex)
            return DisplayIdentificationMarker(
                id: descriptor.id,
                displayID: currentDisplay.id,
                index: descriptor.index,
                isPrimary: descriptor.isPrimary,
                title: descriptor.title,
                detail: resolutionSummary(for: currentDisplay)
            )
        }
    }

    private static func title(
        for display: DisplaySnapshot,
        primaryDisplay: DisplaySnapshot?,
        isPrimary: Bool
    ) -> String {
        guard !isPrimary, let primaryDisplay else {
            return L10n.t("display.preview.role.primary")
        }

        let displayMidX = Double(display.bounds.x) + (Double(display.bounds.width) / 2)
        let displayMidY = Double(display.bounds.y) + (Double(display.bounds.height) / 2)
        let primaryMidX = Double(primaryDisplay.bounds.x) + (Double(primaryDisplay.bounds.width) / 2)
        let primaryMidY = Double(primaryDisplay.bounds.y) + (Double(primaryDisplay.bounds.height) / 2)
        let deltaX = displayMidX - primaryMidX
        let deltaY = displayMidY - primaryMidY

        if abs(deltaX) >= abs(deltaY) {
            if deltaX < 0 {
                return L10n.t("display.preview.role.left")
            }

            if deltaX > 0 {
                return L10n.t("display.preview.role.right")
            }
        } else {
            if deltaY > 0 {
                return L10n.t("display.preview.role.above")
            }

            if deltaY < 0 {
                return L10n.t("display.preview.role.below")
            }
        }

        return L10n.t("display.preview.role.center")
    }

    private static func resolutionSummary(for display: DisplaySnapshot) -> String {
        "\(display.resolution.width)\u{00D7}\(display.resolution.height)"
    }

    private static func bestMatchIndex(
        for savedDisplay: DisplaySnapshot,
        candidates: [DisplaySnapshot]
    ) -> Int? {
        candidates.enumerated()
            .map { candidate in
                (
                    index: candidate.offset,
                    score: matchScore(savedDisplay: savedDisplay, currentDisplay: candidate.element)
                )
            }
            .max { lhs, rhs in
                lhs.score < rhs.score
            }
            .flatMap { best in
                best.score > 0 ? best.index : nil
            }
    }

    private static func matchScore(
        savedDisplay: DisplaySnapshot,
        currentDisplay: DisplaySnapshot
    ) -> Int {
        var score = 0

        if savedDisplay.alphaSerialNumber == currentDisplay.alphaSerialNumber, savedDisplay.alphaSerialNumber != nil {
            score += 40
        }

        if savedDisplay.serialNumber == currentDisplay.serialNumber, savedDisplay.serialNumber != nil {
            score += 30
        }

        if savedDisplay.persistentID == currentDisplay.persistentID, savedDisplay.persistentID != nil {
            score += 18
        }

        if savedDisplay.contextualID == currentDisplay.contextualID, savedDisplay.contextualID != nil {
            score += 10
        }

        if savedDisplay.vendorID == currentDisplay.vendorID, savedDisplay.vendorID != nil {
            score += 3
        }

        if savedDisplay.productID == currentDisplay.productID, savedDisplay.productID != nil {
            score += 3
        }

        if savedDisplay.resolution == currentDisplay.resolution {
            score += 8
        }

        if savedDisplay.refreshRate == currentDisplay.refreshRate, savedDisplay.refreshRate != nil {
            score += 4
        }

        if savedDisplay.scale == currentDisplay.scale, savedDisplay.scale != nil {
            score += 4
        }

        return score
    }
}

@MainActor
protocol DisplayIdentifying {
    func showLabels(_ markers: [DisplayIdentificationMarker])
}

@MainActor
final class DisplayOverlayPresenter: DisplayIdentifying {
    private var windows: [NSWindow] = []
    private var dismissalTask: Task<Void, Never>?

    func showLabels(_ markers: [DisplayIdentificationMarker]) {
        dismiss()

        let screenPairs: [(String, NSScreen)] = NSScreen.screens.compactMap { screen in
            guard let displayNumber = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber else {
                return nil
            }

            return (String(displayNumber.uint32Value), screen)
        }
        let screensByDisplayID = Dictionary(uniqueKeysWithValues: screenPairs)

        windows = markers.compactMap { marker in
            guard let screen = screensByDisplayID[marker.displayID] else {
                return nil
            }

            let panel = NSPanel(
                contentRect: screen.frame,
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            panel.level = .screenSaver
            panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
            panel.isMovable = false
            panel.backgroundColor = .clear
            panel.hasShadow = false
            panel.isOpaque = false
            panel.hidesOnDeactivate = false
            panel.ignoresMouseEvents = true
            panel.isFloatingPanel = true
            panel.contentView = NSHostingView(
                rootView: DisplayOverlayView(marker: marker)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
            panel.setFrame(screen.frame, display: true)
            panel.orderFrontRegardless()
            return panel
        }

        dismissalTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 2_400_000_000)
            await MainActor.run {
                self?.dismiss()
            }
        }
    }

    private func dismiss() {
        dismissalTask?.cancel()
        dismissalTask = nil

        windows.forEach { window in
            window.orderOut(nil)
            window.close()
        }
        windows.removeAll()
    }
}

private struct DisplayOverlayView: View {
    let marker: DisplayIdentificationMarker

    var body: some View {
        ZStack {
            Color.black.opacity(0.14)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("\(marker.index)")
                    .font(.system(size: 112, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 180, height: 180)
                    .background(
                        Circle()
                            .fill(marker.isPrimary ? Color.accentColor.opacity(0.92) : Color.black.opacity(0.76))
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.16), lineWidth: 2)
                            )
                    )
                    .shadow(color: Color.black.opacity(0.18), radius: 22, y: 12)

                VStack(spacing: 6) {
                    Text(marker.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)

                    Text(marker.detail)
                        .font(.headline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.86))
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.black.opacity(0.56))
                )
            }
            .padding(40)
        }
        .allowsHitTesting(false)
    }
}
