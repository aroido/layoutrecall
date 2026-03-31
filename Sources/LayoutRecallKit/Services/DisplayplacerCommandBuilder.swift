import Foundation

public struct DisplayplacerCommandBuilder: DisplayCommandBuilding {
    public init() {}

    public func restorePlan(for displays: [DisplaySnapshot]) throws -> GeneratedLayoutPlan {
        guard !displays.isEmpty else {
            throw LayoutRecallRuntimeError.noDisplaysDetected
        }

        let orderedDisplays = displays.sorted(by: DisplaySnapshot.positionComparator)
        let segments = try orderedDisplays.map { display in
            try makeCommandSegment(for: display, originX: display.bounds.x, originY: display.bounds.y)
        }

        return GeneratedLayoutPlan(
            command: "displayplacer " + segments.joined(separator: " "),
            expectedOrigins: orderedDisplays.map { display in
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: display),
                    x: display.bounds.x,
                    y: display.bounds.y
                )
            },
            primaryDisplayKey: orderedDisplays.mainDisplayKey
                ?? orderedDisplays.first.map { orderedDisplays.uniqueMatchKey(for: $0) }
                ?? "primary"
        )
    }

    public func swapLeftRightPlan(for displays: [DisplaySnapshot]) throws -> GeneratedLayoutPlan {
        let orderedDisplays = displays.sorted(by: DisplaySnapshot.positionComparator)

        guard orderedDisplays.count == 2 || orderedDisplays.count == 3 else {
            throw LayoutRecallRuntimeError.swapRequiresExactlyTwoDisplays
        }

        let mainDisplay = orderedDisplays.first(where: { $0.isMain == true }) ?? orderedDisplays[0]
        let nonMainDisplays = orderedDisplays.filter { $0.id != mainDisplay.id }
        guard nonMainDisplays.count == orderedDisplays.count - 1 else {
            throw LayoutRecallRuntimeError.swapRequiresExactlyTwoDisplays
        }

        let segments: [String]
        let expectedOrigins: [DisplayOrigin]

        if nonMainDisplays.count == 1, let secondaryDisplay = nonMainDisplays.first {
            let deltaX = secondaryDisplay.bounds.x - mainDisplay.bounds.x
            let deltaY = secondaryDisplay.bounds.y - mainDisplay.bounds.y
            let isHorizontalArrangement = abs(deltaX) >= abs(deltaY)

            let secondaryTargetX: Int
            let secondaryTargetY: Int
            if isHorizontalArrangement {
                if secondaryDisplay.bounds.x < mainDisplay.bounds.x {
                    secondaryTargetX = mainDisplay.bounds.x + mainDisplay.bounds.width
                } else {
                    secondaryTargetX = mainDisplay.bounds.x - secondaryDisplay.bounds.width
                }

                secondaryTargetY = secondaryDisplay.bounds.y
            } else {
                secondaryTargetX = secondaryDisplay.bounds.x

                if secondaryDisplay.bounds.y < mainDisplay.bounds.y {
                    secondaryTargetY = mainDisplay.bounds.y + mainDisplay.bounds.height
                } else {
                    secondaryTargetY = mainDisplay.bounds.y - secondaryDisplay.bounds.height
                }
            }

            expectedOrigins = [
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: mainDisplay),
                    x: mainDisplay.bounds.x,
                    y: mainDisplay.bounds.y
                ),
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: secondaryDisplay),
                    x: secondaryTargetX,
                    y: secondaryTargetY
                )
            ]

            segments = try [
                makeCommandSegment(for: mainDisplay, originX: expectedOrigins[0].x, originY: expectedOrigins[0].y),
                makeCommandSegment(for: secondaryDisplay, originX: expectedOrigins[1].x, originY: expectedOrigins[1].y)
            ]
        } else {
            let firstExternal = nonMainDisplays[0]
            let secondExternal = nonMainDisplays[1]

            expectedOrigins = [
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: mainDisplay),
                    x: mainDisplay.bounds.x,
                    y: mainDisplay.bounds.y
                ),
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: firstExternal),
                    x: secondExternal.bounds.x,
                    y: secondExternal.bounds.y
                ),
                DisplayOrigin(
                    key: orderedDisplays.uniqueMatchKey(for: secondExternal),
                    x: firstExternal.bounds.x,
                    y: firstExternal.bounds.y
                )
            ]

            segments = try [
                makeCommandSegment(for: mainDisplay, originX: expectedOrigins[0].x, originY: expectedOrigins[0].y),
                makeCommandSegment(for: firstExternal, originX: expectedOrigins[1].x, originY: expectedOrigins[1].y),
                makeCommandSegment(for: secondExternal, originX: expectedOrigins[2].x, originY: expectedOrigins[2].y)
            ]
        }

        return GeneratedLayoutPlan(
            command: "displayplacer " + segments.joined(separator: " "),
            expectedOrigins: expectedOrigins,
            primaryDisplayKey: orderedDisplays.mainDisplayKey
                ?? orderedDisplays.uniqueMatchKey(for: mainDisplay)
        )
    }

    private func makeCommandSegment(for display: DisplaySnapshot, originX: Int, originY: Int) throws -> String {
        guard let displayIdentifier = displayplacerIdentifier(for: display) else {
            throw LayoutRecallRuntimeError.invalidDisplayIdentifier(display.id)
        }

        let commandResolution = commandResolution(for: display)
        var parts = [
            "id:\(displayIdentifier)",
            "enabled:true",
            "origin:(\(originX),\(originY))",
            "res:\(commandResolution.width)x\(commandResolution.height)"
        ]

        if let refreshRate = display.refreshRate {
            parts.append("hz:\(refreshRate)")
        }

        if let scale = display.scale {
            parts.append("scaling:\(scale > 1.0 ? "on" : "off")")
        }

        return "'" + parts.joined(separator: " ") + "'"
    }

    private func displayplacerIdentifier(for display: DisplaySnapshot) -> String? {
        if let persistentID = display.persistentID, !persistentID.isEmpty {
            if let uuid = UUID(uuidString: persistentID) {
                return uuid.uuidString
            }

            return persistentID
        }

        if let contextualID = display.contextualID, !contextualID.isEmpty {
            return contextualID
        }

        if let serialNumber = display.serialNumber, !serialNumber.isEmpty {
            return serialNumber.hasPrefix("s") ? serialNumber : "s\(serialNumber)"
        }

        return Int(display.id).map(String.init)
    }

    private func commandResolution(for display: DisplaySnapshot) -> DisplayResolution {
        guard let scale = display.scale, scale > 1 else {
            return display.resolution
        }

        return DisplayResolution(
            width: max(1, Int((Double(display.resolution.width) / scale).rounded())),
            height: max(1, Int((Double(display.resolution.height) / scale).rounded()))
        )
    }
}
