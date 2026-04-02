# LayoutRecall Surface Map

Lab: `feature-definition-20260402T002610Z`  
Updated: 2026-04-02

## Chosen IA

**Chosen canonical settings structure: 3 top-level panes with 5 named sections.**

Top-level navigation:

1. **Restore**
2. **Profiles**
3. **General**

Nested sections inside `General`:

- Language
- Updates
- Launch at Login
- Advanced
- Shortcuts
- Diagnostics

This matches the current shipped navigation behavior better than the stale five-pane documentation and keeps runtime, profile-management, and app-preference responsibilities separate.

## IA candidates reviewed

### Candidate A — 5 equal top-level panes

- Restore
- Profiles
- Shortcuts
- Diagnostics
- General

**Pros**
- Mirrors the old docs.
- Gives Diagnostics its own navigation destination.

**Cons**
- Does not match the current shipped sidebar.
- Over-separates advanced/support surfaces from general app preferences.
- Increases nav weight for infrequent tasks.

### Candidate B — 3 top-level panes with nested advanced/support sections (**chosen**)

- Restore
- Profiles
- General
  - Shortcuts
  - Diagnostics

**Pros**
- Matches current SwiftUI sidebar behavior.
- Keeps runtime recovery, profile management, and app settings legible.
- Reduces navigation clutter for a menu-bar-first utility.

**Cons**
- Diagnostics is one click deeper.
- Requires docs to explicitly explain that `Shortcuts` and `Diagnostics` are sections, not peer panes.

## Why Candidate B won

- **PM:** lower doc/UI drift, simpler to explain.
- **Designer:** better fits a menu-bar utility with only a few high-frequency tasks.
- **Engineer:** already matches `primaryNavigationPanes`, so it avoids unnecessary implementation churn during a definition sprint.

## Menu bar content model

### 1. Header
- App name
- Brand/status symbol

### 2. Runtime status card
- Current state badge
- State title
- State subtitle
- Reference profile summary when not healthy

### 3. Primary runtime action slot
- Exactly one of: `Save`, `Install displayplacer`, `Fix Now`, `Enable Automatic Restore`, or none

### 4. Quick control card
- Global automatic-restore toggle
- Inline `Fix Now` when a manual rerun is useful
- `Swap Positions` when available/visible
- Advanced actions menu containing:
  - `Save`
  - quick-switch/apply profile list when multiple profiles exist
  - `Identify Displays`
  - `Open Diagnostics`

### 5. Footer
- `Settings`
- `Quit`

## Settings surface model

### Restore
Purpose: explain current trust state and expose recovery controls.

Contains:
- current state summary
- badges for auto-restore, dependency, display count, confidence
- current vs saved layout previews
- primary restore action
- `Swap Positions`
- deep-link to diagnostics when attention is needed

### Profiles
Purpose: create and manage saved baselines.

Contains:
- `Save Current Layout`
- profile cards
- rename profile
- apply specific profile
- identify displays for a specific profile
- confidence threshold tuning
- delete profile
- saved-layout preview/details

### General
Purpose: app-wide preferences and support surfaces.

Contains:
- language picker
- update settings and actions
- launch-at-login toggle
- advanced restore preference (`Ask Before Restore`)
- shortcuts disclosure section
- diagnostics disclosure section
- app/build/support-file references

## Canonical home map

| Feature | Canonical home | Secondary entrypoint allowed? | Rule |
| --- | --- | --- | --- |
| Runtime status & trust summary | Menu status card | Restore pane summary | Menu owns the live, glanceable status. |
| Automatic restore toggle | Menu quick control | Restore pane card | Menu owns fast mode switching; Restore mirrors it. |
| Ask Before Restore | General > Advanced | No | Advanced preference, not runtime control. |
| Save Current Layout | Profiles | Yes — menu quick action | Profiles owns creation/management; menu offers fast capture. |
| Fix Now | Menu primary/runtime action | Restore pane action card | Runtime recovery action. |
| Apply specific profile | Profiles | Yes — menu quick-switch for multi-profile users | Profile management owns exact-profile execution. |
| Identify Displays | Profiles | Yes — menu utility action for reference profile | Profile context owns label meaning. |
| Swap Positions | Restore | Yes — menu secondary action | Restore owns manual recovery tools. |
| Install displayplacer | Restore | Yes — menu blocked-state action | Restore owns dependency readiness story. |
| Confidence threshold | Profiles | No | Profile tuning belongs with profile details. |
| Rename/Delete profile | Profiles | No | Pure management actions. |
| Diagnostics history/report | General > Diagnostics | Yes — deep-link from Restore/menu | One canonical home; runtime surfaces only link to it. |
| Shortcuts | General > Shortcuts | No | App preference, not runtime recovery. |
| Updates | General | No | App preference. |
| Launch at Login | General | No | App preference. |
| Language | General | No | App preference. |

## Navigation rules

1. The menu bar should stay focused on **what happened, can I trust it, what should I do now**.
2. The Restore pane should answer **why auto-restore did or did not happen**.
3. The Profiles pane should own **saved baseline lifecycle and profile-specific actions**.
4. The General pane should own **app-wide preferences, shortcuts, updates, language, and diagnostics**.
5. Diagnostics should never become a second competing runtime center; it is a support surface with deep-links.

## Phase 2 implementation follow-up

- Update stale docs that still describe five equal top-level settings panes.
- If a future release wants Diagnostics as a top-level pane, treat that as a deliberate IA change with new evidence, not a silent reversion.
