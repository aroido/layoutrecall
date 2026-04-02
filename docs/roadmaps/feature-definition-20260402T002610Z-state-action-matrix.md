# LayoutRecall State / Action Matrix

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: proposed definition set for PM + Designer + Engineer signoff before implementation

## Audit basis

Primary runtime state logic is defined in:

- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`
- `Sources/LayoutRecallApp/AppModel.swift`

## Canonical user-observable states

| Runtime state | Source of truth | What the user should understand |
| --- | --- | --- |
| No profiles | `menuPrimaryState == .noProfiles` | LayoutRecall cannot protect the desk until the first baseline is saved. |
| Installing restore tool | `menuPrimaryState == .installingDependency` | The app is preparing the external dependency and restore is temporarily unavailable. |
| Restore tool missing | `menuPrimaryState == .dependencyMissing` | Recovery is blocked because the restore engine is unavailable. |
| No confident match | `menuPrimaryState == .noMatch` | The current display set does not map cleanly to any saved profile. |
| Low confidence match | `menuPrimaryState == .lowConfidence` | A candidate profile exists, but auto-restore is not trusted enough to run. |
| Review before restore | `menuPrimaryState == .reviewBeforeRestore` | A confident match exists, but the app is intentionally waiting for confirmation. |
| Automatic restore off | `menuPrimaryState == .autoRestoreDisabled` | Profiles exist, but app-level automatic restore has been disabled. |
| Manual layout override | `menuPrimaryState == .manualLayoutOverride` | The current arrangement appears intentionally different from the saved baseline. |
| Manual recovery needed | fallback `menuPrimaryState == .manualRecovery` | The app has enough context to suggest recovery, but no safer automatic path applies. |
| Healthy / protected | `menuPrimaryState == .healthy` | Monitoring is ready and a saved baseline is available for safe recovery. |

## State / action matrix

| State | Allowed primary action | Allowed secondary actions | Blocked actions | Notes / decision intent |
| --- | --- | --- | --- | --- |
| No profiles | Save current layout as profile | Open Settings | Restore matched layout now; Apply saved profile; Identify displays; Swap side displays | First-run setup state. Keep the next step singular and explicit. |
| Installing restore tool | Show installation progress | Save current layout as profile; Open Settings | Any real restore action; repeat install trigger while already running | Installation is transitional, not a separate steady-state feature. |
| Restore tool missing | Install restore tool | Save current layout as profile; Open Settings | Restore matched layout now; Apply saved profile; Swap side displays | Save should remain available so users can prepare baselines before enabling restore. |
| No confident match | Save current layout as profile | Open Profiles; Open Diagnostics | Restore matched layout now from menu context; Identify displays for missing reference; automatic restore | Current menu disables `Fix Now` in this state; definition should keep restore blocked until a real reference exists. |
| Low confidence match | Restore matched layout now | Save current layout as profile; Identify displays; Open Diagnostics; Swap side displays | Automatic restore | This is the main trust-sensitive manual recovery state. |
| Review before restore | Restore matched layout now | Save current layout as profile; Identify displays; Open Diagnostics; Swap side displays | Automatic restore until user confirms | This should stay distinct from low-confidence even if both currently share `Fix Now`. |
| Automatic restore off | Enable automatic restore | Save current layout as profile; Apply saved profile; Identify displays; Open Diagnostics | Automatic restore until re-enabled | Keep manual recovery available while respecting the app-level off state. |
| Manual layout override | No automatic primary action today; proposed explicit choice set | Save current layout as profile; Apply saved profile; Identify displays; Open Diagnostics; Swap side displays | Automatic restore without user choice | Current code gives this state no primary action; definition should call that ambiguity out. |
| Manual recovery needed | Restore matched layout now | Save current layout as profile; Identify displays; Open Diagnostics; Swap side displays | Automatic restore | Catch-all degraded state after failure/requested manual action. |
| Healthy / protected | No interruptive primary action | Save current layout as profile; Apply saved profile; Identify displays; Swap side displays; Open Settings | None beyond dependency/runtime guards | Healthy state should feel calm, not like a dashboard demanding attention. |

## Action definitions

| Action | Purpose | Available in current code | Canonical scope |
| --- | --- | --- | --- |
| Save current layout as profile | Capture live layout as a baseline | Yes | first-run, degraded, and routine maintenance |
| Restore matched layout now | Run manual restore for the current inferred match | Yes (`Fix Now`) | degraded states and review confirmation |
| Apply saved profile | Run restore for a specific saved profile | Yes | profile management and multi-profile switching |
| Identify displays | Show mapping overlays | Yes | degraded states and profile inspection |
| Swap side displays | Limited fallback rearrangement | Yes | only supported layouts with dependency ready |
| Install restore tool | Enable restore engine | Yes | dependency-missing states |
| Enable automatic restore | Re-enable app-level automation | Yes | automatic-restore-off state |
| Open diagnostics | Review recent evidence | Yes | degraded or support states |

## Duplicate / contradictory behaviors found

1. **Low confidence vs review-before-restore both map to the same `Fix Now` CTA**
   - The underlying meanings differ: one is “not trusted enough,” the other is “trusted but waiting for confirmation.”
   - Definition decision: keep them as separate runtime states even if phase-1 implementation still shares a button.

2. **Manual layout override has no clear primary action**
   - `menuPrimaryAction` returns `nil` for `.manualLayoutOverride`.
   - Definition decision: treat this as an unresolved UX gap, not a finished model.

3. **Per-profile auto-restore exists in data but not in behavior**
   - `ProfileSettings.autoRestore` exists, but `AppModel.normalizeProfiles` forces it to `true` and `RestoreCoordinator` only checks app-level automatic restore.
   - Definition decision: remove it from the agreed feature catalog until a real behavior exists.

4. **Swap side displays availability messaging says “requires two” while logic allows 2 or 3 displays**
   - `canSwapDisplays` allows `detectedDisplayCount == 2 || detectedDisplayCount == 3`, but the runtime string still says “swap requires two.”
   - Definition decision: document the current inconsistency and resolve copy/behavior in phase 2.

## Proposed canonical state transitions

- `No profiles` -> `Healthy / protected` only after first saved profile exists and dependency is ready.
- `Restore tool missing` -> `Installing restore tool` -> `Healthy / protected` when dependency setup completes.
- `Healthy / protected` -> `Low confidence match`, `Review before restore`, `Manual layout override`, or `No confident match` depending on runtime evidence.
- `Review before restore` -> `Healthy / protected` after confirmed restore and verification.
- `Low confidence match` -> `Manual recovery needed` after failed manual restore or unresolved mismatch.
- Any restore-execution failure -> `Manual recovery needed` with diagnostics attention.

## Definition call for phase 1

The chosen model should preserve all ten runtime states above, but phase-2 implementation should reduce copy/action ambiguity by:

1. giving `manualLayoutOverride` an explicit user-choice set
2. differentiating low-confidence from review-before-restore in CTA language
3. eliminating dead per-profile auto-restore behavior or fully implementing it
