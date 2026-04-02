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

## Phase 1B usability pruning: keep / merge / remove recommendations

### Core problem reminder

LayoutRecall exists to help a user get back to a known-good monitor layout after macOS scrambles it. Any action that does not directly help the user:

1. understand whether the app can safely help,
2. restore the intended layout now, or
3. save/manage the intended layout for later,

should be demoted out of the primary recovery surface.

### Keep as primary actions

| Action | Recommendation | Rationale |
| --- | --- | --- |
| Restore Now | **KEEP** | This is the clearest primary recovery verb for the core problem. Keep it short and outcome-oriented. |
| Save Current Layout | **KEEP** | First-run and changed-desk recovery both need a direct way to define the intended baseline. |
| Install Restore Tool | **KEEP conditionally** | Keep as the only primary action when dependency is missing, because it directly unblocks the core product promise. |
| Enable Automatic Restore | **KEEP conditionally** | Keep only in the explicit disabled-policy state, because it restores the app's core operating mode. |

### Merge or rename overlapping actions

| Current overlap | Recommendation | Usability rationale |
| --- | --- | --- |
| `Fix Now` vs `Restore Now` | **MERGE** to `Restore Now` | `Fix Now` is vague and sounds like a repair utility, not a layout restore action. `Restore Now` says exactly what will happen. |
| `Apply Layout` / `Apply Profile` vs manual restore wording | **MERGE conceptually** under `Restore saved profile` in docs; allow shorter UI label `Apply` only inside a profile card | Users should not learn two near-identical restore verbs without context. Runtime surface should say `Restore Now`; profile-management surface should say `Restore saved profile` or short contextual `Apply`. |
| `Show Numbers` vs `Identify Displays` | **MERGE** into one feature with user-facing label `Show Display Numbers` | `Identify Displays` is internal/technical language. `Show Numbers` is friendly but too terse. `Show Display Numbers` balances clarity and immediacy. |
| `Swap Positions` vs `Swap` vs `Swap side displays` | **MERGE** to `Swap Side Displays` | This names both the scope and limit. It is clearer than the generic `Swap` and safer than the vague `Swap Positions`. |
| `Save first baseline` / `Save another baseline` / `Save` | **MERGE** to `Save Current Layout` | Contextual helper copy can explain whether it is first-time or additional, but the button label should stay stable. |

### Remove, hide, or demote from primary surfaces

| Action / surface behavior | Recommendation | Rationale |
| --- | --- | --- |
| Save action in the healthy-state primary area | **DEMOTE** | In the calm/healthy state, the product should reassure first. Saving another layout is management, not urgent recovery. |
| Diagnostics entry in the main recovery cluster | **DEMOTE** to secondary/support link | Diagnostics support trust, but they do not solve the user's immediate problem. Keep accessible, not primary. |
| Shortcuts as a peer concept in the feature model | **DEMOTE** to support preference only | Shortcuts help power users but are not part of the core product promise. |
| Update controls in the consensus feature core | **DEMOTE** to maintenance/support | Necessary app plumbing, but not part of the core layout-recall workflow. |
| Disabled install action shown as if it were still actionable during active install | **REMOVE from action framing**; show progress status instead | During installation, users should see status/progress, not a disabled repeat action. |

### Recommended simplified runtime action set

For usability, the runtime/menu surface should normalize to at most these five user-facing actions:

1. **Restore Now**
2. **Save Current Layout**
3. **Show Display Numbers**
4. **Swap Side Displays**
5. **Open Settings**

Conditional/system actions:

- **Install Restore Tool** only when dependency is missing
- **Enable Automatic Restore** only when the app-wide policy is disabled

Everything else should be contextual, nested, or settings-only.

### Recommended documentation language changes

- Replace `Fix Now` with `Restore Now` in PRD/SPEC/README.
- Replace `Apply Layout` in broad product docs with `Restore saved profile` unless the text is specifically about a profile card.
- Replace `Show Numbers` / `identify displays` drift with `Show Display Numbers`.
- Replace `Swap Positions` with `Swap Side Displays`.
- Reframe diagnostics, shortcuts, and updates as support capabilities rather than core recovery actions.

### Avoidable unresolved items to close in final packet

To keep the spec sharp, these should not remain fuzzy if worker-1 can resolve them now:

1. choose one primary restore verb: `Restore Now`
2. choose one display-identification label: `Show Display Numbers`
3. choose one swap label: `Swap Side Displays`
4. state clearly that healthy-state menu should demote save/diagnostics from the main attention path
