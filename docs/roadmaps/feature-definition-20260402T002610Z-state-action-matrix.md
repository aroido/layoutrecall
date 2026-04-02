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

## Allowed and blocked actions by state

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

## Action inventory

| Action | Current labels / entrypoints | Purpose | Canonical classification |
| --- | --- | --- | --- |
| Save Current Layout | `Save`, `Save Current Layout`, `Save first baseline`, `Save another baseline` | Capture the current display arrangement as a profile. | Core runtime action |
| Fix Now | `Fix Now` | Run the best-match manual restore immediately. | Core runtime action |
| Apply Layout | profile `Apply Layout`, quick-switch profile restore | Restore a specific saved profile. | Core runtime action |
| Show Numbers | `Show Numbers`, identify displays | Overlay display identifiers for mapping/verification. | Core runtime action |
| Swap Positions | `Swap Positions`, `Swap` | Apply a simple swap plan for supported layouts. | Core runtime action |
| Install displayplacer | `Install displayplacer` | Unblock real restore execution. | Support action |
| Enable Automatic Restore | `Enable Automatic Restore` | Re-enable the app-wide automatic restore policy. | Policy action |
| Toggle Ask Before Restore | `Ask Before Restore` | Require manual confirmation before a safe auto restore proceeds. | Policy action |
| Rename Profile | rename profile UI | Improve profile clarity. | Management action |
| Delete Profile | delete profile UI | Remove a no-longer-needed profile. | Management action |
| Adjust Confidence Threshold | profile threshold slider | Tune match strictness per profile. | Management action |
| Set Shortcuts | shortcuts pane | Bind hotkeys for common recovery actions. | Support action |
| Toggle Launch at Login | general pane toggle | Make the app available automatically after login. | Support action |
| Check / Install / Skip Update | updates controls | Manage in-app updates. | Support action |
| Open Diagnostics | restore shortcut / embedded diagnostics section | Inspect evidence and support files. | Support action |

## Explicit contradictions and duplicate semantics

### 1. Five-pane docs vs three-pane implementation

- Docs (`README`, `PRD`, `SPEC`) still describe a **five-pane settings window**.
- Implementation exposes only **three primary panes** in the sidebar and nests **Shortcuts** + **Diagnostics** under **General**.
- Result: the mental model for where features live is inconsistent before a user even opens settings.

### 2. `Fix Now` vs `Apply Layout`

- `Fix Now` means “restore the best inferred current match.”
- `Apply Layout` means “restore this specific saved profile.”
- Both ultimately execute restore commands, but the difference in intent is not stated clearly enough in docs.

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

## Chosen normalized state model for future work

### Primary runtime states to keep

- No Profiles
- Dependency Missing
- No Match
- Low Confidence
- Review Before Restore
- Automatic Restore Disabled
- Manual Layout Override
- Ready
- Restore Failed

### Secondary diagnostic states to retain internally and expose contextually

- Installing Dependency
- No Displays

## Phase 2 follow-up candidates (not part of definition approval)

- Promote `Restore Failed` and `No Displays` into first-class visible states instead of collapsing both into generic manual recovery.
- Rewrite menu/help copy so each runtime state has one unique recommended next action.
- Align diagnostics labels with the chosen canonical action names.
