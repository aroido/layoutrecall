# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Audit basis

Audited sources before normalizing the catalog:

- `README.md`
- `docs/PRD.md`
- `docs/SPEC.md`
- `Sources/LayoutRecallApp/AppPresentation.swift`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppModel.swift`
- `Sources/LayoutRecallKit/Models/AppSettings.swift`
- `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift`

## Audit findings

### Naming drift observed

- **Restore action naming** drifts between `Fix Now`, `Apply Layout`, `restore`, and `manual recovery`.
- **Profile creation naming** drifts between `Save Current Layout`, `Save`, `save a baseline`, and `save profile`.
- **Display identification naming** drifts between `Show Numbers`, `identify displays`, and `display identification`.
- **Surface structure naming** drifts because the docs still describe a five-pane settings window, while the current implementation exposes **three primary panes** (`Restore`, `Profiles`, `General`) and nests `Shortcuts` + `Diagnostics` inside `General`.
- **Auto-restore controls** are split across app-wide toggle, ask-before-restore toggle, and per-profile confidence settings, but not presented as one unified “restore policy” model in docs.

### Normalization principles used

1. Keep existing user-recognizable verbs where possible.
2. Distinguish **app-wide policy** from **per-profile controls**.
3. Give each feature one canonical home: **Menu**, **Settings**, **Both**, or **Hidden**.
4. Treat diagnostics, dependency install, updates, login item, language, and shortcuts as first-class user-visible features because they materially affect trust and usability.

## Chosen terminology map

| Current variants | Chosen canonical term | Notes |
| --- | --- | --- |
| Fix Now, manual restore, manual recovery | **Fix Now** | Keep the short imperative label for the primary manual recovery action. |
| Apply Layout, restore profile | **Apply Layout** | Use for manually applying a specific saved profile. |
| Save, Save Current Layout, save baseline | **Save Current Layout** | Clearer than plain “Save” in menu/settings copy. |
| Show Numbers, identify displays, display identification | **Show Numbers** | Keep the user-facing label; “identify displays” can remain internal/descriptive text. |
| automatic restore | **Automatic Restore** | App-wide policy name. |
| ask before automatic restore, review before restore | **Ask Before Restore** | Explicit trust control layered on top of automatic restore. |
| dependency install, install displayplacer | **Install displayplacer** | Explicitly name the dependency. |
| swap left/right, swap positions | **Swap Positions** | More general than left/right and matches current copy. |
| five-pane settings window | **Three primary settings sections with two advanced sub-sections** | Matches actual current IA. |

## Normalized feature catalog

| Feature | One-line definition | User goal | Primary trigger | Preconditions | Success result | Blocked states | Canonical home |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Save Current Layout | Capture the current live display arrangement as a reusable profile. | Save a known-good desk setup. | User clicks save from menu or settings. | At least one display is detected; layout can be read and converted to a restore plan. | A new profile is stored or an identical existing profile is recognized. | Snapshot read failure; unsupported layout-plan generation. | **Both** |
| Automatic Restore | Restore the best-matching saved layout automatically when confidence is high. | Recover without manual intervention when the match is safe. | Display reconfiguration/wake events after debounce. | Displays detected, profiles exist, dependency available, app-wide auto-restore enabled, score meets threshold. | Restore command runs and verification succeeds. | No displays, no profiles, no match, low confidence, dependency missing, auto-restore disabled, ask-before-restore enabled. | **Settings** |
| Ask Before Restore | Convert an otherwise-safe automatic restore into a review gate that requires user action. | Keep automation available while preventing surprise moves. | User enables the toggle; a high-confidence match occurs later. | Profiles exist and automatic restore is enabled. | Auto-restore is suppressed, and the UI presents a manual restore path with explicit context. | No profiles; app-wide automatic restore disabled. | **Settings** |
| Fix Now | Manually restore the best current profile match right away. | Recover immediately when the desk is wrong or automation was blocked. | User clicks the primary recovery button or shortcut. | Dependency available (or installable), displays readable, at least one compatible profile match. | Best-match profile restore executes and verification completes. | Dependency missing and install fails; no compatible profile; snapshot read failure. | **Both** |
| Apply Layout | Manually apply one specific saved profile. | Recover to a chosen profile instead of the best inferred match. | User clicks Apply Layout on a profile card or quick-switch item. | Selected profile exists; dependency available. | Chosen profile command runs and verification completes. | Dependency missing; selected profile missing. | **Both** |
| Show Numbers | Overlay numbered markers so the user can map saved profile order to physical displays. | Verify which physical screen corresponds to which profile entry. | User clicks Show Numbers / identify displays. | Selected or reference profile exists; matching markers can be resolved. | Number overlays appear on detected displays. | No matching displays; snapshot read failure. | **Both** |
| Swap Positions | Apply a simple swap plan for supported two- or three-display layouts. | Fix common left/right ordering issues quickly. | User clicks Swap Positions or shortcut. | Dependency available, no restore already running, 2 or 3 displays detected. | Swap command runs and verification completes. | Dependency missing; unsupported display count; command already running. | **Both** |
| Profile Management | Rename, delete, inspect, and tune saved layout profiles. | Keep saved layouts usable and understandable over time. | User opens Profiles settings. | Profiles exist for rename/delete/tuning actions. | Profile metadata updates persist and remain selectable. | Missing profile; persistence failure. | **Settings** |
| Confidence Threshold Tuning | Adjust how strong a profile match must be before it counts as safe. | Control restore conservatism for each profile. | User edits profile threshold slider. | Target profile exists. | New threshold persists and affects future restore decisions. | Missing profile; settings persistence failure. | **Settings** |
| Restore Status & Evidence | Show current state, reason, dependency status, display count, and confidence context. | Decide whether to trust the app and what to do next. | Menu opens or settings restore overview opens. | Runtime state has been evaluated. | User can see the current state and recommended action. | Snapshot-read failures reduce available evidence. | **Both** |
| Diagnostics History | Record and expose recent restore decisions, outcomes, and support files. | Understand what happened and share evidence for troubleshooting. | Automatic/manual actions and event evaluations. | Diagnostics persistence available. | Latest decision and recent history remain visible and copyable. | Persistence failure. | **Settings** |
| Keyboard Shortcuts | Bind shortcuts for Fix Now, Save Current Layout, and Swap Positions. | Trigger common recovery actions quickly. | User edits shortcuts in settings. | App can register hotkeys; chosen binding is not duplicated. | New shortcuts persist and invoke the intended action. | Shortcut registration failure. | **Settings** |
| Launch at Login | Start LayoutRecall automatically at login. | Keep protection active without manual launch. | User toggles launch at login. | Login-item manager available. | Login item state changes and persists. | Login item update failure. | **Settings** |
| Update Management | Check for updates, install an available update, and skip a version. | Stay current without leaving the app. | Background/user-initiated update checks and update buttons. | Update checker/installer available. | Update state is shown clearly; install or skip action persists. | Check/install failure. | **Settings** |
| Language Selection | Choose System, English, or Korean. | Read the app in the preferred language. | User changes language segmented control. | Localization resources available. | Preferred language persists and UI strings follow the selection. | Settings persistence failure. | **Settings** |
| Install displayplacer | Guide or perform dependency setup for actual restore execution. | Enable real restore commands when the dependency is missing. | Bootstrap/manual install path, or user presses install action. | Installer flow is available. | Dependency becomes available and restore actions are unblocked. | Install/bootstrap failure. | **Both** |

## Feature grouping model

### Core runtime features

- Save Current Layout
- Automatic Restore
- Ask Before Restore
- Fix Now
- Apply Layout
- Show Numbers
- Swap Positions
- Restore Status & Evidence

### Supporting control-plane features

- Profile Management
- Confidence Threshold Tuning
- Diagnostics History
- Keyboard Shortcuts
- Launch at Login
- Update Management
- Language Selection
- Install displayplacer

## Canonical feature-home rules

| Home | Meaning |
| --- | --- |
| Menu | Fast runtime actions/status only; avoid deep configuration. |
| Settings | Detailed management, persistence, policy, and support surfaces. |
| Both | A fast entrypoint in the menu plus the canonical management view in settings. |
| Hidden | Internal capability only; not used for any catalog item above. |

## Phase 2 follow-up candidates (not part of this definition approval)

- Rewrite user-facing copy so “Save”, “Fix Now”, “Apply Layout”, and “Show Numbers” use the normalized terms consistently.
- Restructure settings to match the chosen IA from the surface map.
- Tighten menu/status strings so blocked automatic-restore cases expose the same state vocabulary as settings and diagnostics.
