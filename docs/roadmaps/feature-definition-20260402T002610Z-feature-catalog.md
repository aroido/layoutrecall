# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`
Status: definition-phase artifact
Updated: 2026-04-02

## Audit basis

Reviewed before defining the catalog:

- `README.md`
- `docs/PRD.md`
- `docs/SPEC.md`
- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppModel.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`
- `docs/roadmaps/v2-release-20260331T233306Z-designer-audit.md`
- `docs/roadmaps/v2-release-20260331T233306Z-decision-log.md`

## Consensus summary

- **PM**: keep the product menu-bar-first and conservative; do not expand scope into a display-management suite.
- **Designer**: make recovery intent explicit and stop hiding important destinations behind ambiguous labels or nested disclosure groups.
- **Engineer**: keep definitions aligned with current restore, profile, diagnostics, and dependency flows so phase 2 can be incremental.
- **Critic**: log every trust gap, especially around unclear recovery labels and settings navigation drift.

PM, Designer, and Engineer all agree on the normalized feature set below.

## Terminology normalization

| Canonical term | Current variants found | Definition |
| --- | --- | --- |
| **Profile** | saved profile, saved layout, baseline, workspace | A saved known-good monitor arrangement plus restore command and threshold settings. |
| **Restore now** | Fix Now, manual restore | Restore the best current profile match immediately from the menu/runtime context. |
| **Apply profile** | Apply Layout, direct apply | Restore a specific saved profile from profile management. |
| **Review before restore** | Ask Before Restore, awaiting confirmation | Hold an otherwise safe automatic restore until the user confirms it. |
| **Restore tool** | displayplacer, dependency, restore dependency | The external command-line dependency required for real layout changes. |
| **Diagnostics** | history, recent restore evidence, runtime snapshot | The visible proof trail for restore decisions, executions, and blocked states. |

## Normalized feature catalog

| Feature | Canonical user-facing name | One-line definition | User goal | Trigger | Preconditions | Success result | Blocked states | Intended visibility | Canonical home |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Runtime status | Status | Show whether LayoutRecall is healthy, blocked, reviewing, or needs action. | Know if the app can be trusted right now. | Menu open, settings open, runtime event refresh. | App running. | User sees current state, profile context, and next best action. | Snapshot read failure. | Both | Menu |
| Profile capture | Save Profile | Save the current display arrangement as a reusable profile. | Preserve a known-good desk layout. | User chooses save. | Current displays can be read and converted into a restore plan. | New or duplicate-safe profile recorded. | Snapshot failure; command generation failure. | Both | Profiles |
| Automatic restore | Automatic Restore | Restore a matched profile automatically only when confidence and safety rules allow it. | Recover after reconnect without manual work. | Display change or wake event. | Profile exists, score clears threshold, auto restore enabled, restore tool available, not suppressed. | Restore executes and verifies automatically. | No profiles, no confident match, below threshold, auto restore off, tool missing, review-before-restore enabled. | Both | Restore |
| Review gate | Review Before Restore | Convert an otherwise automatic restore into a confirm-first state. | Stay in control when the match is good but confirmation is preferred. | Confident match while review gate is enabled. | Same as automatic restore, plus review gate enabled. | User sees pending restore and can confirm intentionally. | No confident match, tool missing, auto restore off. | Settings-first with runtime state visible | Restore |
| Matched manual restore | Restore Now | Restore the best current profile match immediately from the runtime surface. | Recover the desk when LayoutRecall stopped short. | User chooses runtime recovery action. | Tool available, at least one compatible profile match. | Best match restores and verifies. | Tool missing; no compatible saved profile. | Both | Menu |
| Direct profile restore | Apply Profile | Restore a specific saved profile on demand. | Force a known profile even outside the current best-match path. | User chooses a profile action. | Tool available, saved profile exists. | Chosen profile restores and verifies. | Tool missing. | Both | Profiles |
| Display identification | Show Numbers | Overlay profile-to-display number markers to map saved order to physical screens. | Understand which saved display maps to which real monitor. | User chooses identify on a profile. | Saved profile exists; current displays readable. | Overlay markers appear for the current setup. | No readable current displays or no matching markers. | Both | Profiles |
| Side-display swap | Swap Side Displays | Flip left/right side-display positions for simple supported desks. | Recover from simple mirror-order mistakes without re-saving. | User chooses swap action. | Tool available; supported 2- or 3-display setup. | Supported swap command runs. | Tool missing; unsupported display count. | Both | Restore |
| Profile management | Manage Profiles | Rename, inspect, delete, and compare saved profiles. | Keep saved layouts organized and understandable. | User opens profile management. | At least zero profiles; current display data optional. | User can manage lifecycle of profiles. | None for viewing; per-action blockers still apply. | Settings | Profiles |
| Confidence tuning | Profile Confidence Threshold | Set the minimum confidence required before a profile can auto-restore. | Control false positives vs false negatives per profile. | User edits a profile threshold. | Profile exists. | Profile threshold persists and affects matching. | No profile selected. | Settings | Profiles |
| Restore tool setup | Install Restore Tool | Detect, explain, and install the external restore dependency. | Enable real restore actions safely. | Tool missing, user requests install, or automatic dependency flow runs. | Installer available. | Tool becomes available and restore actions unblock. | Install failure, Homebrew/bootstrap failure, permissions/environment problems. | Both | Restore |
| Diagnostics proof | Diagnostics | Show latest restore outcome, recent history, runtime snapshot, and support files. | Inspect what happened and why. | User opens diagnostics or restore state requests proof. | App has runtime state; history may be empty. | User sees evidence without guesswork. | No history yet still allowed; only evidence volume limited. | Both | Diagnostics |
| Keyboard shortcuts | Shortcuts | Configure global bindings for recovery actions. | Trigger recovery faster without opening settings deeply. | User edits shortcuts. | Shortcut manager available. | Bindings persist and avoid collisions. | Shortcut conflict or unavailable binding. | Settings | Shortcuts |
| Launch at login | Launch at Login | Start LayoutRecall automatically at login. | Ensure restore protection is present without manual launching. | User toggles startup behavior. | Login item service available. | App login-item state persists. | OS approval requirements or login-item failure. | Settings | General |
| Updates | Updates | Check for, install, or skip published updates. | Keep the app current without leaving the app. | Automatic or user-initiated update check. | Network/release feed available. | User sees status and can update or skip. | No release available; network or install failure. | Settings | General |
| Language preference | Language | Choose System, Korean, or English. | Read the app in the preferred language. | User changes language. | Localization bundle available. | Preferred language persists. | Unsupported language choice. | Settings | General |

## Catalog-level observations

1. **The runtime product is really four groups, not one flat list:** trust/status, restore controls, profile tools, and support/admin controls.
2. **“Fix Now” is the largest naming debt.** The action is conceptually “restore the current best match now,” not “fix anything and everything.”
3. **Profiles and restore are separate features.** Saving, tuning, and applying a specific profile should not be treated as the same feature as runtime matched recovery.
4. **Diagnostics is a primary trust feature, not a support afterthought.** It needs a canonical home and should not be described only as history.

## Explicit exclusions for phase 1

These are not part of the chosen feature model for the definition sprint:

- cloud sync or cross-machine profiles
- per-app window placement
- advanced four-plus-display heuristic automation
- replacing `displayplacer` with a native restore engine
- rule-based automatic profile selection beyond current confidence matching

## Phase 2 follow-up candidates

Definition-only callouts that may drive later implementation work:

1. Rename runtime copy from **Fix Now** to **Restore Now** if UX copy review confirms the change.
2. Promote Diagnostics and Shortcuts into explicit settings panes if the chosen five-pane IA is implemented.
3. Add a guided restore-readiness checklist that reflects the feature group boundaries above.
