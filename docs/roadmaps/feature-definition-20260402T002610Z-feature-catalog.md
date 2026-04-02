# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: proposed definition set for PM + Designer + Engineer signoff before implementation

## Audit summary

Reviewed sources before defining the catalog:

- `.omx/context/feature-definition-20260402T002610Z.md`
- `README.md`
- `docs/PRD.md`
- `docs/SPEC.md`
- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppModel.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`
- `Sources/LayoutRecallKit/Models/DisplayProfile.swift`
- `Sources/LayoutRecallKit/Models/AppSettings.swift`

## Normalization goals

1. Keep one canonical name per user-facing capability.
2. Separate product features from support surfaces like diagnostics and shortcuts.
3. Make menu-first recovery clear without duplicating deep management controls.
4. Preserve the current conservative trust model.

## Key drift found during audit

- Docs still describe a **five-pane** settings window, but the app currently ships a **three-pane sidebar** (`Restore`, `Profiles`, `General`) with `Shortcuts` and `Diagnostics` nested inside `General`.
- README/PRD/SPEC talk about per-profile restore behavior, but the current code normalizes `profile.settings.autoRestore = true` on load, so per-profile auto-restore is not a real user-facing feature today.
- `Fix Now`, `Apply Layout`, and `Restore Now` are used to describe closely related restore actions; the catalog below normalizes them.

## Canonical terminology map

| Current terms in repo | Canonical definition term | Notes |
| --- | --- | --- |
| Fix Now, Restore Now | **Restore matched layout now** | Menu/runtime action for the currently matched or best-known profile. |
| Apply Layout, Apply Profile | **Apply saved profile** | Profile-specific restore action from Profiles/settings or quick switch. |
| Save, Save Current Layout, Save First Profile, Save Another Baseline | **Save current layout as profile** | Same feature with context-specific CTA copy. |
| Show Numbers, Identify Displays | **Identify displays** | Use one feature name; `Show Numbers` can stay user-facing shortcut copy if needed. |
| displayplacer install, restore tool install | **Restore tool setup** | User-facing dependency setup capability. |
| Automatic restore, app auto-restore | **Automatic restore** | App-level runtime mode. |
| Ask Before Restore, review before restore | **Review before automatic restore** | App-level trust mode layered on top of automatic restore. |
| Swap Positions, Swap Left/Right | **Swap side displays** | Keep explicitly narrow wording. |

## Normalized feature catalog

| Feature | One-line definition | User goal | Primary trigger | Preconditions | Success result | Blocked states | Canonical home |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Automatic restore | Watch for display changes and restore a matched layout when confidence is safe. | Recover without manual intervention after dock/sleep/wake churn. | Display reconfiguration or wake event. | Saved profile exists; dependency ready; confidence meets threshold; app auto-restore enabled. | Matched profile restores and verification is logged. | No profiles; dependency missing; low confidence; review-required mode; auto-restore disabled. | Menu + Restore |
| Review before automatic restore | Hold a confident match until the user explicitly confirms restore. | Keep automation visible and trustable before monitors move. | Automatic restore would otherwise run while ask-before-restore is enabled. | Automatic restore enabled; saved profile exists; dependency ready; confident match. | App surfaces review-needed state and waits for manual confirmation. | No profiles; dependency missing; no confident match; global auto-restore disabled. | Restore |
| Restore matched layout now | Manually restore the currently matched/best-known layout from the runtime surface. | Recover immediately when the desk drifted or auto-restore stayed manual. | `Fix Now` menu/settings action or shortcut. | Saved profile exists; dependency ready. | Restore command runs, verification is attempted, diagnostics updated. | No profiles; dependency missing; no matched profile context. | Menu + Restore |
| Apply saved profile | Run restore for a specific saved profile. | Recover to a chosen baseline instead of the currently inferred one. | Profile card `Apply Layout`, quick switch menu. | Saved profile exists; dependency ready. | Selected profile command runs and result is logged. | Dependency missing; restore already running. | Profiles |
| Save current layout as profile | Capture the live display arrangement as a reusable baseline profile. | Preserve a known-good desk layout for later recovery. | Save action from menu or Profiles pane. | Live displays available. | New or updated profile saved with fingerprint, expected origins, and generated command. | No displays detected; restore command in progress if save is intentionally deferred. | Menu + Profiles |
| Manage profiles | Rename, inspect, delete, and compare saved profiles. | Keep baselines understandable and tidy. | Open Profiles pane. | At least one profile exists for management actions. | User can rename, review details, and delete stale profiles. | No profiles for management sub-actions. | Profiles |
| Tune confidence threshold | Adjust how strict the app is before automatic restore runs for a profile set. | Avoid unsafe restores on ambiguous desks. | Threshold slider in profile details. | Profile exists. | Threshold persists and changes future confidence gating. | No profiles. | Profiles |
| Identify displays | Overlay display numbers to map physical monitors to saved layout order. | Understand which display is which before restoring or editing. | Menu advanced action or Profiles/Restore action. | Reference or selected profile exists; display identifier available. | Number overlays appear and diagnostics note the identify action. | No reference/selected profile; no matching displays. | Menu + Profiles + Restore |
| Swap side displays | Perform the limited left/right swap fallback for simpler desk setups. | Recover faster when only side displays are flipped. | Swap action from menu/settings or shortcut. | Dependency ready; restore not running; supported display count (currently 2 or 3). | Swap command runs and verification is logged. | Dependency missing; unsupported display count; restore in progress. | Menu + Restore |
| Restore tool setup | Install or confirm the external restore dependency (`displayplacer`). | Make real layout restore available. | Install dependency CTA in degraded states. | Homebrew/bootstrap path available. | Dependency becomes ready or installation progress is shown. | Installer already running; install path failure. | Menu + Restore |
| Diagnostics review | Inspect latest decision, recent restore history, runtime snapshot, and support files. | Understand what happened and why the app acted or refused. | Open Diagnostics disclosure from Restore or General. | None. | User sees latest evidence and can copy a report. | None; only empty history state. | General |
| Keyboard shortcuts | Bind quick actions for restore/save/swap. | Trigger key recovery actions without opening the menu. | Open Shortcuts disclosure in General. | None. | Shortcut bindings persist and can be reused globally. | None. | General |
| Launch at login | Start the app automatically on login so monitoring is available. | Keep restore protection active without manual launch. | Toggle in General. | User approval and login item support available. | Login item preference persists. | System approval missing or denied. | General |
| Updates | Check for and install new releases, including skip-version behavior. | Keep the app current without manual GitHub monitoring. | General > Updates. | Update feed available. | App reports update state or installs an update. | Network/release unavailable; install busy. | General |
| Language selection | Choose System, English, or Korean copy. | Keep the UI readable in the preferred language. | General language picker. | None. | Preferred language persists. | None. | General |

## Feature-to-surface policy

### Menu-only responsibilities

- runtime status
- primary recovery CTA when immediate intervention is needed
- quick access to save, restore, identify, swap, settings, quit

### Settings-only responsibilities

- profile editing and deletion
- threshold tuning
- launch-at-login, updates, language
- diagnostics history and support-file inspection
- shortcut configuration

### Both menu and settings

- save current layout as profile
- restore matched layout now / apply saved profile entrypoints
- identify displays
- swap side displays
- restore tool setup
- automatic restore state visibility

## Features intentionally not treated as first-class in phase 1

- per-profile auto-restore toggle (data model exists but current app behavior normalizes it away)
- undo last restore
- profile rules or context-aware profile routing
- cloud sync / cross-machine profiles
- full multi-monitor rearrangement suite beyond the current limited swap fallback

## Phase 2 implementation follow-up candidates

Only after signoff on this catalog:

1. decide whether per-profile auto-restore is a real feature or dead model baggage
2. align menu/settings copy to the normalized terms above
3. update README/PRD/SPEC to match the chosen settings IA and feature names
4. tighten the distinction between “restore matched layout now” and “apply saved profile” in UI copy
