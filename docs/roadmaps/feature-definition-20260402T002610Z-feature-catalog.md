# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`  
Updated: 2026-04-02

## Audit summary

Audited sources before defining the catalog:

- `docs/PRD.md`
- `docs/SPEC.md`
- `README.md`
- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppModel.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`
- `Sources/LayoutRecallKit/Models/DisplayProfile.swift`
- `Tests/LayoutRecallAppTests/AppModelTests.swift`

## Normalization rules

1. Treat **automatic restore** as a single app-level mode, not a per-profile mode. The current code normalizes legacy per-profile `autoRestore` values back to `true` and only exposes a global toggle.
2. Treat **Fix Now** as the canonical runtime recovery action for the currently matched/best profile.
3. Treat **Apply Layout** as the canonical profile-specific action inside profile management.
4. Treat **Settings** as a three-pane navigation model (`Restore`, `Profiles`, `General`) with nested `Shortcuts` and `Diagnostics` sections inside `General`.
5. Keep runtime diagnosis and next action visible in the menu bar; keep configuration and history management in Settings.

## Drift found during audit

- Docs still describe **five settings panes**, while the shipped sidebar exposes only **three top-level panes** and nests `Shortcuts`/`Diagnostics` under `General`.
- Docs still mention a **per-profile auto-restore toggle**, but the app now behaves as **global auto-restore only**.
- Menu/runtime wording and settings wording are mostly aligned, but the feature model was not written down in one canonical artifact.

## Normalized feature catalog

| Canonical feature | One-line definition | User goal | Trigger | Preconditions | Success result | Blocked states | Canonical home |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Runtime status & trust summary | Show current restore health, matched profile context, and next best action. | Understand whether LayoutRecall is safe to trust right now. | Menu open, settings open, or post-event refresh. | App is running. | User can see current state, dependency status, display count, and confidence context. | None; degraded data falls back to no-profile/manual/dependency states. | Both |
| Automatic restore mode | Enable or disable app-level automatic restore behavior. | Decide whether restore may run automatically. | User flips the app-level toggle in menu or settings. | At least one profile exists for the toggle to matter. | Future event-driven restores follow the global mode. | No profiles make the toggle non-actionable; dependency issues still block restore even when enabled. | Both |
| Ask Before Restore | Require review before automatic execution even when confidence is high. | Keep automation available while forcing a human confirmation step. | User enables the advanced toggle. | Global automatic restore enabled; at least one profile exists. | High-confidence matches land in review-first mode instead of auto-executing. | Toggle is disabled when automatic restore is off or no profiles exist. | Settings |
| Save Current Layout | Capture the live display arrangement as a reusable profile. | Establish or refresh a known-good baseline. | User clicks `Save` from menu/settings. | A live display snapshot exists. | New profile is persisted with generated restore command and expected origins. | No displays detected; snapshot/build failure. | Both |
| Fix Now | Restore the currently matched/best-known layout immediately. | Recover the desk now when auto-restore did not run. | User clicks `Fix Now`. | Dependency available, not installing, at least one profile, and an applicable restore path. | Restore command runs and verification is recorded. | Dependency missing, no profiles, no actionable match, restore already in progress. | Menu |
| Apply Layout | Restore a specific saved profile directly from profile management. | Recover to an explicitly chosen baseline. | User clicks `Apply Layout` on a profile card or quick-switch item. | Dependency available, not installing, profile exists. | Selected profile restore command runs and verification is recorded. | Dependency missing, no profiles, restore already in progress. | Settings |
| Identify Displays / Show Numbers | Overlay display labels that map the saved profile to the current physical displays. | Verify which monitor is which before restoring or editing a setup. | User clicks `Identify Displays` / `Show Numbers`. | Reference or selected profile has display data. | Visual labels appear and a diagnostic event is recorded. | No matching/current display data, overlay unavailable. | Both |
| Swap Positions | Swap non-main display positions for supported 2- and 3-display desks. | Apply a narrow manual fallback when the exact saved layout is not the right command. | User clicks `Swap Positions`. | Dependency available, not installing, 2 or 3 displays detected. | Swap command runs and verification is recorded. | Dependency missing, unsupported display count, restore already in progress. | Both |
| Dependency setup (`displayplacer`) | Install or surface readiness of the command-line restore dependency. | Make real restore execution possible. | App startup, restore-state audit, or user clicks install. | Homebrew/install path available for success. | Dependency becomes available and later restores can execute. | Install failure, unresolved PATH, installer already running. | Both |
| Profile library management | Rename, inspect, and delete saved layouts. | Keep saved baselines understandable and current. | User expands a profile card and edits/deletes. | At least one profile exists. | Profile metadata is updated or removed and persisted. | Missing profile, persistence failure. | Settings |
| Confidence threshold tuning | Set the minimum confidence required before a profile is treated as trustworthy. | Bias the app toward safer or more aggressive matching. | User moves the profile threshold slider. | Profile exists. | Threshold persists and future decisioning reflects the new value. | Missing profile, persistence failure. | Settings |
| Diagnostics history & support files | Show latest restore evidence, runtime snapshot, recent history, and support-file locations. | Understand what happened and gather evidence for support/debugging. | User opens diagnostics section or copy report action. | App is running; history may be empty. | User can review recent outcomes or copy a report. | No hard block; can be empty. | Settings |
| Keyboard shortcuts | Bind global shortcuts to recovery actions. | Trigger recovery actions without opening the UI. | User records/clears shortcuts. | Shortcut manager available. | Shortcut bindings persist and register cleanly. | Registration conflict or persistence failure. | Settings |
| Update management | Check for updates, install available releases, and skip/clear skipped versions. | Keep the app current on the user’s terms. | User opens update section or app checks automatically. | Update service available. | Update state becomes visible and install/skip actions persist. | Busy update flow, no release available, installer failure. | Settings |
| Launch at Login | Control whether the app launches automatically with macOS login. | Keep LayoutRecall always available on desk reconnects. | User flips launch-at-login toggle. | Login item service available. | Login-item state persists and status line updates. | OS/login-item failure. | Settings |
| Language selection | Choose System, English, or Korean app language. | Read the app in the preferred language. | User changes segmented control. | Localization resources available. | Language override persists and UI reloads in chosen language. | Missing localization resource (falls back to default). | Settings |

## Feature-boundary calls

### Intentionally not part of the canonical feature set

- Cloud sync or cross-machine profile sync
- Per-app window placement
- A native restore engine that replaces `displayplacer`
- Fully automatic support for broad 4+ display rearrangement heuristics
- A per-profile auto-restore toggle in the shipped 2.0 baseline

## Phase 2 implementation follow-up (not part of this definition approval)

1. Update product docs to remove stale five-pane/per-profile-auto-restore language.
2. Align any remaining UI copy around `Fix Now`, `Apply Layout`, and `Identify Displays`.
3. If the team later wants profile-scoped restore rules, treat that as a new feature proposal rather than a quiet doc correction.
