import Foundation
import Testing
@testable import LayoutRecallApp

@Test
func existingPrimaryInstancePrefersOldestLaunchDate() {
    let now = Date()
    let snapshots = [
        RunningApplicationSnapshot(processIdentifier: 101, launchDate: now),
        RunningApplicationSnapshot(processIdentifier: 202, launchDate: now.addingTimeInterval(-15)),
        RunningApplicationSnapshot(processIdentifier: 303, launchDate: now.addingTimeInterval(-5))
    ]

    let resolved = AppInstanceResolver.existingPrimaryInstance(in: snapshots, currentPID: 101)

    #expect(resolved?.processIdentifier == 202)
}

@Test
func existingPrimaryInstanceFallsBackToPidOrderingWhenLaunchDateMatches() {
    let launchDate = Date()
    let snapshots = [
        RunningApplicationSnapshot(processIdentifier: 501, launchDate: launchDate),
        RunningApplicationSnapshot(processIdentifier: 409, launchDate: launchDate),
        RunningApplicationSnapshot(processIdentifier: 612, launchDate: launchDate)
    ]

    let resolved = AppInstanceResolver.existingPrimaryInstance(in: snapshots, currentPID: 612)

    #expect(resolved?.processIdentifier == 409)
}

@Test
func existingPrimaryInstanceIgnoresCurrentProcessWhenItIsOnlyInstance() {
    let snapshots = [
        RunningApplicationSnapshot(processIdentifier: 777, launchDate: Date())
    ]

    let resolved = AppInstanceResolver.existingPrimaryInstance(in: snapshots, currentPID: 777)

    #expect(resolved == nil)
}
