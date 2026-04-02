# LayoutRecall Consensus Feature Catalog

_Date:_ 2026-04-02  
_Source audit:_ `README.md`, `docs/PRD.md`, `docs/SPEC.md`, `Sources/LayoutRecallApp/AppPresentation.swift`, `Sources/LayoutRecallApp/MenuContentView.swift`, `Sources/LayoutRecallApp/SettingsView.swift`, `Sources/LayoutRecallApp/AppModel.swift`, `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`

## Definition-sprint outcome

This catalog normalizes the current product into one canonical feature model for phase 1 definition work.

### Council agreement required for approval

| Role | Position |
| --- | --- |
| PM facilitator | Agrees with this catalog as the phase-1 scope baseline |
| Designer | Agrees with the naming cleanup and canonical surface ownership |
| Engineer | Agrees that every listed feature maps to existing code paths or explicit phase-2 follow-up |

## Audit summary

Current drift found during audit:

1. **Action naming drift:** docs say `Fix Now`, localization labels the primary action `Restore Now`, and profile actions use `Apply Layout`.
2. **Settings IA drift:** docs still describe a five-pane settings window, while the implemented sidebar exposes only **Restore / Profiles / General** and nests **Shortcuts / Diagnostics** under General.
3. **Profile terminology drift:** docs alternate between **profile**, **baseline**, **saved layout**, and **known-good layout**.
4. **State-model drift:** the product has a rich runtime state model in `menuPrimaryState`, but docs mostly describe only “automatic vs manual restore”.
5. **Hidden capability drift:** `DisplayProfile.settings.autoRestore` exists in the model, but the current decision/UI flow behaves as if auto restore is app-level only.

## Canonical terminology

| Old / drifting term | Canonical term | Rule |
| --- | --- | --- |
| baseline | profile | Use **profile** for the saved layout object everywhere user-facing |
| known-good layout | saved layout | Use in explanatory copy only, not as the object name |
| Fix Now | Restore Now | Canonical manual recovery CTA |
| Apply Layout | Apply Layout | Keep for profile-specific restore action |
| Show Numbers / Identify Displays | Show Numbers | Primary user-facing term; `identifyDisplays` stays internal/code-facing |
| automatic restore | Auto Restore | Capitalize when used as a named setting |
| swap left/right / swap displays | Swap Positions | Canonical manual rearrangement action |

## Normalized feature catalog

| Feature | One-line definition | Canonical home |
| --- | --- | --- |
| Runtime Status & Match Review | Show whether LayoutRecall is safe, ready, blocked, or waiting for user review | Menu + Restore |
| Save Profile | Capture the current connected display layout as a reusable profile | Menu + Profiles |
| Auto Restore | Automatically restore only when the live layout confidently matches a saved profile | Menu + Restore |
| Restore Now | Run the best available manual recovery immediately when the user wants control | Menu + Restore |
| Apply Layout | Apply a specific saved profile on demand | Profiles |
| Show Numbers | Overlay saved/display numbers on connected monitors to confirm mapping | Menu + Profiles + Restore |
| Swap Positions | Quickly rearrange supported simple layouts without changing saved profiles | Menu + Restore |
| Profile Management | Rename, delete, inspect, and tune saved profiles | Profiles |
| Diagnostics & Support Snapshot | Explain recent decisions, outcomes, and support-file state | General > Diagnostics |
| Dependency Setup | Install and validate `displayplacer` so real restores can run | Menu + Restore |
| Shortcuts | Bind keyboard shortcuts for the main recovery actions | General > Shortcuts |
| General Preferences | Control launch at login, updates, language, and restore confirmation behavior | General |

## Detailed feature definitions

### 1. Runtime Status & Match Review
- **User goal:** Understand whether the app is ready to restore and why it did or did not act.
- **Trigger:** App launch, wake, display reconfiguration, or manual refresh through normal runtime flow.
- **Preconditions:** App is running.
- **Success result:** Menu/Restore surface clearly communicates the current state, matched profile if any, and the next best action.
- **Blocked states:** No displays, no profiles, dependency missing, low confidence, auto restore disabled.
- **Where it appears:** **Both** (menu status card, restore overview card).

### 2. Save Profile
- **User goal:** Capture the current layout once so it can be restored later.
- **Trigger:** `Save Profile` from menu quick action or Profiles pane primary action.
- **Preconditions:** At least one display is currently detected.
- **Success result:** A new profile exists with stored display metadata, command, and confidence settings.
- **Blocked states:** No displays detected; save flow fails to read live snapshot.
- **Where it appears:** **Both**.

### 3. Auto Restore
- **User goal:** Let the app restore automatically only when it is safe.
- **Trigger:** Toggle `Auto Restore` on; runtime display-change events.
- **Preconditions:** At least one saved profile; dependency available; match score clears threshold.
- **Success result:** Best matching profile restores automatically and verification/diagnostics record the outcome.
- **Blocked states:** App-level auto restore off, ask-before-restore enabled, dependency missing, below threshold, no confident match.
- **Where it appears:** **Both**.

### 4. Restore Now
- **User goal:** Manually recover immediately when the user wants control or the app refuses auto restore.
- **Trigger:** Primary menu CTA or Restore pane CTA.
- **Preconditions:** At least one restorable profile and dependency available.
- **Success result:** The best available profile is applied and the outcome is logged.
- **Blocked states:** Dependency missing, no profiles, no displays, restore command already running.
- **Where it appears:** **Both**.

### 5. Apply Layout
- **User goal:** Apply one specific saved profile rather than the current best-match choice.
- **Trigger:** Profile card action or quick-switch submenu.
- **Preconditions:** Selected profile exists; dependency available.
- **Success result:** Chosen profile is restored and verified.
- **Blocked states:** Dependency missing, installation in progress, restore already running.
- **Where it appears:** **Settings** (Profiles) with menu quick-switch for multi-profile setups.

### 6. Show Numbers
- **User goal:** Confirm how saved profile displays map to the currently connected monitors.
- **Trigger:** Menu advanced action, Restore overview action, or Profile card action.
- **Preconditions:** Reference or selected profile exists; at least one display can be matched.
- **Success result:** Number overlays appear for matched displays and a diagnostics entry is recorded.
- **Blocked states:** No reference profile, no matching connected displays.
- **Where it appears:** **Both**.

### 7. Swap Positions
- **User goal:** Quickly change positions in supported simple desk layouts without editing the saved profile.
- **Trigger:** Menu quick control or Restore pane secondary action.
- **Preconditions:** `displayplacer` available; no restore command in progress; detected display count is 2 or 3.
- **Success result:** Main display stays fixed while the secondary displays change position; diagnostics records the manual override.
- **Blocked states:** Dependency missing, installation in progress, unsupported display count, command already running.
- **Where it appears:** **Both**.

### 8. Profile Management
- **User goal:** Maintain a usable set of saved profiles.
- **Trigger:** Open Profiles pane.
- **Preconditions:** None beyond app access; individual actions require at least one saved profile.
- **Success result:** User can rename/delete profiles, inspect layout previews, and tune confidence threshold.
- **Blocked states:** No profiles (empty state only).
- **Where it appears:** **Settings**.

### 9. Diagnostics & Support Snapshot
- **User goal:** Understand what happened recently and collect evidence for troubleshooting.
- **Trigger:** Open General > Diagnostics or diagnostics shortcut from blocked states.
- **Preconditions:** App has runtime state; recent history is optional.
- **Success result:** Latest diagnostic, runtime snapshot, support-file paths, and recent history are visible/copyable.
- **Blocked states:** None; empty history still shows support information.
- **Where it appears:** **Settings**.

### 10. Dependency Setup
- **User goal:** Enable real layout restore by installing `displayplacer` when missing.
- **Trigger:** Menu/Restore install CTA.
- **Preconditions:** Dependency not currently available.
- **Success result:** Installation completes, dependency state flips to ready, restore actions become available.
- **Blocked states:** Install already in progress, Homebrew/bootstrap failure.
- **Where it appears:** **Both**.

### 11. Shortcuts
- **User goal:** Run main recovery actions from the keyboard.
- **Trigger:** Open General > Shortcuts disclosure.
- **Preconditions:** App is installed and shortcut manager can register bindings.
- **Success result:** Bindings exist for Restore Now, Save Profile, and Swap Positions.
- **Blocked states:** Registration conflict or OS-level shortcut registration failure.
- **Where it appears:** **Settings**.

### 12. General Preferences
- **User goal:** Manage app-wide behavior that is not profile-specific.
- **Trigger:** Open General pane.
- **Preconditions:** None.
- **Success result:** User can manage launch at login, updates, language, and ask-before-restore behavior.
- **Blocked states:** Ask-before-restore is disabled when auto restore is off or no profiles exist.
- **Where it appears:** **Settings**.

## Explicitly hidden or non-canonical items

These exist in code or docs but should **not** be treated as first-class user-facing features in phase 1:

| Item | Status | Reason |
| --- | --- | --- |
| Per-profile auto-restore toggle | Hidden / unresolved | Present in model shape, but not surfaced consistently in current UI/decision flow |
| “five-pane settings window” as the canonical IA | Rejected | Does not match current sidebar behavior or menu-bar app simplicity goals |
| “Fix Now” as the primary user-facing CTA label | Rejected | Keep `Restore Now` as canonical label; retain legacy/internal references only until code cleanup |

## Phase 2 follow-up (not started here)

1. Remove remaining `Fix Now` / `baseline` wording drift from docs, localization keys, and tests.
2. Decide whether per-profile auto-restore is a real product feature or dead state that should be removed.
3. Align the docs and code around the chosen three-pane settings IA.
