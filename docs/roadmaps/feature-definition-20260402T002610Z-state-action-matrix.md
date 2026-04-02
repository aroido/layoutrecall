# LayoutRecall State / Action Matrix

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Audit basis

This matrix is derived from:

- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppModel.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`
- `Sources/LayoutRecallKit/Models/AppSettings.swift`

## Model note

Two overlapping models exist today:

1. **Decision contexts** in `RestoreCoordinator` / `AppModel`
2. **User-visible menu states** in `AppPresentation`

This matrix normalizes them into a single user-observable state model and explicitly calls out contradictions.

## Current user-observable states

| Canonical state | Backing implementation signals | Meaning |
| --- | --- | --- |
| No Profiles | `profiles.isEmpty` or decision context `.noSavedProfile` | The app has nothing saved yet. |
| Installing Dependency | `installationInProgress == true` | `displayplacer` installation is currently running. |
| Dependency Missing | `dependencyAvailable == false` or decision context `.dependencyBlocked` | Real restore commands are unavailable until `displayplacer` is installed. |
| No Match | decision context `.noConfidentMatch` | Profiles exist, but none match the current live display set. |
| Low Confidence | decision context `.belowThreshold` | The best profile match exists but is not safe enough for automatic restore. |
| Review Before Restore | decision context `.awaitingUserConfirmation` | A high-confidence automatic restore was found, but the ask-before-restore trust gate requires manual confirmation. |
| Automatic Restore Disabled | decision context `.automaticRestoreDisabled` | A confident match exists, but the app-wide auto-restore toggle is off. |
| Manual Layout Override | decision context `.manualLayoutOverride` | The current arrangement is intentionally being treated as a temporary/manual override. |
| Manual Recovery | fallback menu state when no healthier explicit state applies | The app is operational, but the user should recover manually rather than trust automatic action. |
| Healthy / Ready | decision context `.ready` or `.savedProfileReady`, or latest action is successful auto restore | The app is ready, has a valid reference profile, or just completed a safe restore. |
| Restore Failed | decision context `.restoreFailed` | A restore attempt ran but did not succeed cleanly. In the current UI this collapses into Manual Recovery instead of a first-class top-level state. |
| No Displays | decision context `.noDisplays` | No active displays were readable. In the current UI this also collapses into Manual Recovery instead of a dedicated state. |

## Core actions

| State | Allowed actions | Blocked / discouraged actions | Notes |
| --- | --- | --- | --- |
| No Profiles | Save Current Layout; open Settings; quit | Fix Now; Apply Layout; Show Numbers; confidence tuning | First-run path is clear, but settings still exposes some controls that are disabled rather than hidden. |
| Installing Dependency | Wait; open Settings; quit | Install displayplacer again; real restore actions | The menu still shows an install-flavored primary action even though it is disabled during active install. |
| Dependency Missing | Install displayplacer; Save Current Layout; open Settings; quit | Fix Now; Apply Layout; Swap Positions | Save is still allowed because profile capture does not require restore execution. |
| No Match | Save Current Layout; open Settings; quit | Fix Now (explicitly disabled in menu); Apply Layout to unavailable reference profile | User should create a new baseline for the current desk. |
| Low Confidence | Fix Now; Save Current Layout; Swap Positions; open diagnostics/settings; choose Apply Layout manually | Automatic Restore | Manual recovery is available, but the difference between Fix Now and Apply Layout needs crisper copy. |
| Review Before Restore | Fix Now; Save Current Layout; Swap Positions; open diagnostics/settings | Automatic Restore without user confirmation | This state exists specifically to force a human decision. |
| Automatic Restore Disabled | Enable Automatic Restore; Save Current Layout; Apply Layout; Show Numbers; Swap Positions | Background automatic restore | The model assumes manual recovery is still allowed while policy is disabled. |
| Manual Layout Override | Save Current Layout; Apply Layout; Show Numbers; open settings/diagnostics | Automatic Restore | Current code path is present in the state enum but not clearly surfaced in docs. |
| Manual Recovery | Fix Now; Save Current Layout; Apply Layout; Show Numbers; Swap Positions; diagnostics/settings | Automatic Restore until state changes | Catch-all state that currently absorbs several distinct reasons. |
| Healthy / Ready | Save Current Layout; Apply Layout; Show Numbers; Swap Positions; open settings; optional diagnostics | None strictly blocked except context-specific dependency/display limits | This is the calm state where the menu should mostly reassure instead of warn. |
| Restore Failed | Fix Now retry; Apply Layout; Save Current Layout; diagnostics/support actions | Trusting automation until root cause is understood | Should become its own explicit surfaced state in a later implementation pass. |
| No Displays | Wait for hardware to settle; diagnostics/support review | Save Current Layout; Fix Now; Apply Layout | Currently not distinguished sharply enough from generic manual recovery. |

## Demoted actions

| Action | Current labels / entrypoints | Purpose | Canonical classification |
| --- | --- | --- | --- |
| Save current layout | Save Profile | `saveCurrentLayout()` / `.saveNewProfile` | Menu convenience + Profiles canonical home |
| Restore best match now | `Fix Now` / `Restore Now` (unresolved label) | `fixNow()` / `.fixNow` | Menu + Restore |
| Restore a specific profile | `Apply Layout` / `Apply Profile` (unresolved label) | `restoreProfile(_:)` | Profiles |
| Show overlay mapping | Show Numbers / Identify Displays | `identifyDisplays(for:)` | Menu utility + Restore reference context + Profiles canonical home |
| Reposition simple layouts | Swap display positions (label unresolved) | `swapLeftRight()` | Menu + Restore |
| Turn on automation | Enable Auto Restore | `setAutoRestore(true)` | Menu + Restore |
| Install dependency | Install Dependency | `installDisplayplacer()` | Menu + Restore |
| Open diagnostics context | Open Diagnostics | settings-navigation only | Menu shortcut + General > Diagnostics |

## Explicit contradictions and duplicate semantics

### 1. Five-pane docs vs three-pane implementation

### 2. `Fix Now` vs `Restore Now`
- **Why it exists:** code/tests and some docs center `Fix Now`, while some reviewers prefer `Restore Now` for future-facing clarity.
- **Consensus:** **Unresolved.** Keep the split explicit in the packet and treat rename work as phase 2.

### 2. `Fix Now` vs `Apply Layout`

### 4. Swap position control visible when unavailable
- **Why it exists:** `showsSwapDisplaysControl` returns true in many states to explain availability via help text.
- **Consensus:** Keep the control visible only when it teaches something useful; if later simplified, prefer a visible disabled control in Restore, not a surprise hidden action.

### 3. `Show Numbers` vs `identify displays`

- The menu/docs speak in direct user language (`Show Numbers`).
- Settings/model code use “identify displays.”
- These are the same feature and should be documented as such.

### 4. Missing first-class surfaced states

- `restoreFailed` and `noDisplays` exist in decision contexts.
- The menu-state mapping currently collapses them into `manualRecovery`.
- This reduces user trust because the reason for manual fallback is less explicit than the underlying model already knows.

### 5. Install state semantics are half action, half status

- While installing, the primary button still maps to the install action but is disabled.
- This works mechanically, but the IA should treat installation as a **status with progress** rather than as a fresh available action.

1. Add explicit UX copy for the `No Displays` substate.
2. Decide whether `Manual Recovery Available` needs a clearer user-facing name.
3. Remove or expose per-profile auto-restore so the state model stops implying both scopes.


## Additional reviewed contradictions to keep explicit

1. **Settings IA contradiction:** docs historically describe five conceptual areas, while shipped sidebar navigation is currently 3 top-level panes.
2. **Swap support contradiction:** some copy implies two-display-only behavior, while current code/UI logic allows 2 or 3 displays.
3. **NoDisplays / RestoreFailed surfacing:** current state model can collapse them into generic manual recovery, but reviewers asked to keep open whether they need first-class user-facing states.
