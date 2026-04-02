# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1B simplification pass)

## Core user problem

This catalog now reflects an internal multi-worker review pass. Items with clear agreement are normalized below. Items with split review remain explicitly unresolved and are not presented as settled canon.

> After sleep, wake, dock reconnect, or identical-monitor reshuffling, macOS brings back the **wrong physical display arrangement**, and the user wants their **previously saved known-good layout restored safely** without having to rebuild it manually every time.

This is **not** a general display-management suite. It is a trust-first recovery utility for people who already know the layout they want back.

## Smallest required user jobs

If LayoutRecall is reduced to the minimum useful product, it must still let the user do these jobs:

1. **Save one known-good layout** so the app has a baseline to recover.
2. **Notice when the current display arrangement drifted** enough that recovery may be needed.
3. **Restore the saved layout safely**:
   - automatically when confidence is high, or
   - with one clear manual recovery action when confidence is not high enough.
4. **Explain why restore did or did not happen** so the user can trust the behavior.

Anything that does not directly support one of those jobs should be demoted to a supporting surface or made an explicit non-goal.

## Simplicity filter used in this pass

1. Keep only features that directly support the core desk-recovery problem.
2. Treat duplicate recovery actions as debt unless their user intent is meaningfully different.
3. Keep runtime surfaces focused on **status, trust, and next action**.
4. Demote support, convenience, and platform-management features below core product definition.

## Keep / demote / non-goal framing

### Keep as core product features

| Feature | Why it stays core | Canonical home |
| --- | --- | --- |
| baseline | profile | Use **profile** for the saved layout object everywhere user-facing |
| known-good layout | saved layout | Use in explanatory copy only, not as the object name |
| Fix Now / Restore Now | **Unresolved** | Split review: current code/docs center `Fix Now`, while some reviewers prefer `Restore Now` as clearer future-facing copy |
| Apply Layout / Apply Profile | **Unresolved** | Current code uses `Apply Layout`; some reviewers want the intent model separated more explicitly |
| Show Numbers / Identify Displays | Show Numbers (user-facing) / Identify Displays (descriptive/internal) | Keep `Show Numbers` as the visible command while acknowledging `identifyDisplays` in implementation and support copy |
| automatic restore | Auto Restore | Capitalize when used as a named setting |
| swap left/right / swap displays / Swap Positions | **Unresolved** | Naming is not stable enough to treat as final canon yet |

### Keep, but demote to supporting features

| Feature | Why it is supporting, not core | Canonical home |
| --- | --- | --- |
| Runtime Status & Match Review | Show whether LayoutRecall is safe, ready, blocked, or waiting for user review | Menu + Restore |
| Save Profile | Capture the current connected display layout as a reusable profile | Menu + Profiles |
| Auto Restore | Automatically restore only when the live layout confidently matches a saved profile | Menu + Restore |
| Manual recovery CTA (`Fix Now` / `Restore Now`) | Run the best available manual recovery immediately when the user wants control | Menu + Restore |
| Apply Layout | Apply a specific saved profile on demand | Profiles |
| Show Numbers / Identify Displays | Overlay saved/display numbers on connected monitors to confirm mapping | Menu utility + Profiles + Restore reference context |
| Swap display positions | Quickly rearrange supported simple layouts without changing saved profiles | Menu + Restore |
| Profile Management | Rename, delete, inspect, and tune saved profiles | Profiles |
| Diagnostics & Support Snapshot | Explain recent decisions, outcomes, and support-file state | General > Diagnostics |
| Dependency Setup | Install and validate `displayplacer` so real restores can run | Menu + Restore |
| Shortcuts | Bind keyboard shortcuts for the main recovery actions | General > Shortcuts |
| General Preferences | Control launch at login, updates, language, and restore confirmation behavior | General |

### Candidate features to demote hard or treat as convenience only

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
- **Where it appears:** **Both**, with Profiles as the clearest canonical management home and menu access retained as a utility shortcut.

### 3. Auto Restore
- **User goal:** Let the app restore automatically only when it is safe.
- **Trigger:** Toggle `Auto Restore` on; runtime display-change events.
- **Preconditions:** At least one saved profile; dependency available; match score clears threshold.
- **Success result:** Best matching profile restores automatically and verification/diagnostics record the outcome.
- **Blocked states:** App-level auto restore off, ask-before-restore enabled, dependency missing, below threshold, no confident match.
- **Where it appears:** **Both**.

### 4. Manual recovery CTA (`Fix Now` / `Restore Now`)
- **User goal:** Manually recover immediately when the user wants control or the app refuses auto restore.
- **Trigger:** Primary menu CTA or Restore pane CTA; final user-facing label remains unresolved.
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

### 6. Show Numbers / Identify Displays
- **User goal:** Confirm how saved profile displays map to the currently connected monitors.
- **Trigger:** Menu advanced action, Restore overview action, or Profile card action.
- **Preconditions:** Reference or selected profile exists; at least one display can be matched.
- **Success result:** Number overlays appear for matched displays and a diagnostics entry is recorded.
- **Blocked states:** No reference profile, no matching connected displays.
- **Where it appears:** **Both**.

### 7. Swap display positions
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

## Reviewed cautions from peer pushback

1. **Do not normalize a degraded desk as the new truth by accident.** If `Save Profile` remains visible in degraded states, the docs must warn that this is an expert escape hatch, not the default recommendation.
2. **Do not present contested copy as settled canon.** CTA labels and swap terminology remain open.
3. **Do not claim the current 3-pane implementation resolves the IA debate by itself.** It is current-state evidence, not unanimous design agreement.

## Explicitly hidden or non-canonical items

These exist in code or docs but should **not** be treated as first-class user-facing features in phase 1:

| Item | Status | Reason |
| --- | --- | --- |
| Per-profile auto-restore toggle | Hidden / unresolved | Present in model shape, but not surfaced consistently in current UI/decision flow |
| “five-pane settings window” as already-resolved history | Rejected as a factual claim | The product currently ships a 3-pane sidebar, but reviewers are split on whether the long-term canonical IA should stay 3-pane or return to 5-pane |
| Any single final manual-recovery CTA label | Unresolved | Review split remains between `Fix Now` and `Restore Now` |

### Explicit non-goals

These should be described clearly as non-goals in PRD/SPEC language:

- Full display-management suite behavior
- Arbitrary layout editing / general monitor choreography
- Broad automatic heuristics for complex 4+ display setups
- Cloud sync or cross-machine profile sync
- Per-app window placement
- Rule engine for choosing different profiles by many contexts
- Replacing `displayplacer` with a native restore engine in this phase

## Canonical terminology map after pruning

| Variants seen | Chosen term | Keep / demote note |
| --- | --- | --- |
| Save, Save Current Layout, save baseline | **Save Current Layout** | Keep |
| automatic restore | **Automatic Restore** | Keep |
| Fix Now, manual restore, manual recovery | **Fix Now** | Keep |
| Apply Layout, restore profile | **Apply Layout** | Demote to profile-management action |
| Show Numbers, identify displays | **Show Numbers** | Demote to support utility |
| swap left/right, Swap Positions | **Swap Positions** | Demote hard; utility only |
| install dependency, install displayplacer | **Install displayplacer** | Keep because restore depends on it |

## Strict feature catalog

| Feature | One-line definition | User goal | Preconditions | Success result | Keep class | Canonical home |
| --- | --- | --- | --- | --- | --- | --- |
| Save Current Layout | Capture the current arrangement as a reusable baseline profile. | Save the desk the user wants back. | Display snapshot is readable. | Profile is stored and available for future recovery. | **Core** | Both |
| Automatic Restore | Recover the saved layout automatically when the live display set is a strong match. | Avoid manual repair when the app is confident. | Profiles exist, dependency available, auto-restore on, confidence high. | Restore executes and verifies. | **Core** | Restore policy |
| Fix Now | Recover immediately using the best current match when the user wants manual control. | Get the desk back now. | Dependency available and a valid recovery path exists. | Restore executes and verifies. | **Core** | Menu |
| Restore Status & Evidence | Show current state, confidence, dependency, and reason for acting or not acting. | Decide whether to trust the app and what to do next. | Runtime state evaluated. | User sees clear next-step guidance. | **Core** | Both |
| Install displayplacer | Unblock restore execution when the required dependency is missing. | Make restore actually work. | Install flow available. | Dependency becomes available or failure is explained. | **Core** | Both |
| Ask Before Restore | Require user confirmation before an otherwise-safe automatic restore. | Add a trust gate without disabling recovery. | Profiles exist and automatic restore is enabled. | Recovery is held for confirmation instead of auto-executing. | Supporting | Settings |
| Apply Layout | Run one specific saved profile manually. | Choose a specific baseline instead of the inferred best match. | Selected profile exists; dependency available. | Chosen profile restore runs. | Supporting | Settings |
| Show Numbers | Label displays so the user can confirm physical-to-profile mapping. | Verify screen identity before or after recovery. | Profile/display markers resolve. | Overlays appear. | Supporting | Settings |
| Profile Management | Rename, delete, inspect, and tune profiles. | Keep saved layouts usable over time. | Profiles exist. | Profile metadata persists. | Supporting | Settings |
| Confidence Threshold Tuning | Adjust per-profile confidence cutoff. | Control how conservative restore matching should be. | Profile exists. | New threshold persists. | Supporting | Settings |
| Diagnostics History | Review recent actions, outcomes, and support files. | Troubleshoot or understand prior behavior. | Diagnostics persistence works. | Recent history is visible/copyable. | Supporting | Settings |
| Swap Positions | Run a limited 2–3 display swap fallback. | Try a quick utility fallback for simple desk cases. | Dependency available; supported display count. | Swap executes and verifies. | Convenience only | Secondary utility |
| Keyboard Shortcuts | Bind quick triggers for common actions. | Access recovery actions faster. | Shortcut registration works. | Shortcuts persist and invoke correctly. | Convenience only | Settings |
| Launch at Login | Start the app automatically at login. | Keep recovery available without manual launch. | Login-item manager works. | Launch behavior persists. | Convenience only | Settings |
| Update Management | Check/install/skip app updates. | Keep the app current. | Update service available. | Update state is visible and controllable. | Convenience only | Settings |
| Language Selection | Choose System, English, or Korean. | Use preferred language. | Localization resources available. | Language preference persists. | Convenience only | Settings |

## PRD/SPEC pruning recommendations

1. Rewrite the top-line promise around **safe recovery of a saved desk layout**, not around feature breadth.
2. Move `Swap Positions`, shortcuts, updates, login item, and language out of the headline feature list.
3. Describe `Apply Layout`, `Show Numbers`, thresholds, and diagnostics as supporting tools around the core loop.
4. State non-goals directly instead of implying future expansion.
5. Prefer the shipped three-primary-section settings model in docs; avoid creating a larger IA just to give supporting surfaces more weight.
