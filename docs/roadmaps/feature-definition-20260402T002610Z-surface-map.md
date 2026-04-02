# LayoutRecall Surface Map

Lab: `feature-definition-20260402T002610Z`
Status: definition-phase artifact
Updated: 2026-04-02

## Audit findings that drove the IA decision

- Docs (`README.md`, `docs/PRD.md`, `docs/SPEC.md`) describe a **five-pane** settings model.
- Current code exposes **three primary sidebar panes** (`Restore`, `Profiles`, `General`) and nests `Shortcuts` and `Diagnostics` inside `General` disclosure groups.
- Runtime diagnostics shortcuts already behave like a first-class destination from degraded restore states.
- Shortcuts and Diagnostics are advanced but still distinct jobs; burying them under General weakens findability and increases wording drift.

## IA candidates considered

### Candidate A — keep the current 3-pane primary sidebar

**Structure**
- Restore
- Profiles
- General
  - Shortcuts (embedded)
  - Diagnostics (embedded)
  - Language / updates / login-item / advanced

**Pros**
- Matches current implementation with minimal code change.
- Keeps the sidebar short.
- Preserves the idea that shortcuts/diagnostics are secondary.

**Cons**
- Conflicts with current docs and release messaging.
- Makes Diagnostics look like an advanced setting rather than a trust surface.
- Creates a weak mental model: some destinations are panes, some are hidden sections.

### Candidate B — explicit 5-pane settings navigation

**Structure**
- Restore
- Profiles
- Shortcuts
- Diagnostics
- General

**Pros**
- Matches current docs and product story.
- Gives Diagnostics a clear canonical home.
- Keeps each pane focused on one user job.
- Future implementation cost is modest because the enum model already contains the five pane types.

**Cons**
- Requires a sidebar/navigation implementation follow-up.
- Adds two more sidebar destinations that need disciplined scope.

## Chosen IA

**Chosen structure: Candidate B — explicit five-pane settings navigation.**

### Consensus rationale

- **PM:** the docs, release plan, and product promise are already written as five conceptual areas; definitions should stop the drift instead of encoding it.
- **Designer:** Diagnostics and Shortcuts are discoverable tasks, not hidden “advanced” extras.
- **Engineer:** implementation is incremental because `SettingsPane` already models all five panes; phase 2 is mostly navigation exposure and content grouping.

PM, Designer, and Engineer all agreed to choose Candidate B.

## Canonical surface model

### Menu bar

The menu is the runtime trust and intervention surface.

**Menu content model**
1. **Status summary**
   - state badge
   - title + subtitle
   - matched/reference profile when relevant
2. **Primary runtime action**
   - Restore Now
   - Install Restore Tool
   - Save Profile
   - Enable Automatic Restore
3. **Quick recovery controls**
   - auto-restore toggle
   - Swap Side Displays (only when supported)
   - open advanced actions / settings
4. **Utility destinations**
   - open Profiles
   - open Diagnostics
   - open full Settings

**Menu principles**
- Healthy state should collapse to a low-attention summary.
- Degraded states may expand to show trust context and next best action.
- Menu is not the primary management surface for profile editing, updates, language, or history browsing.

### Settings

The settings window is the full management and explanation surface.

#### 1. Restore
Owns:
- automatic restore toggle
- review-before-restore / restore policy copy
- restore tool readiness and install flow
- current vs saved layout comparison
- recommended recovery actions
- supported swap action
- trust explainer and latest proof summary

#### 2. Profiles
Owns:
- save profile
- rename/delete profile
- profile details preview
- apply profile
- show numbers
- confidence threshold editing

#### 3. Shortcuts
Owns:
- all global keyboard shortcut configuration
- shortcut conflict messaging
- shortcut summary

#### 4. Diagnostics
Owns:
- latest restore outcome
- recent history
- runtime snapshot
- support files
- copy/export report action

#### 5. General
Owns:
- launch at login
- updates
- version info
- language selection
- only truly general app preferences

## Canonical home map

| Feature / action | Runtime visibility | Canonical home | Why |
| --- | --- | --- | --- |
| Status | Menu + Restore | Menu | Primary runtime question lives here. |
| Save Profile | Menu shortcut + Profiles full flow | Profiles | Profile capture belongs with profile lifecycle. |
| Restore Now | Menu + Restore pane | Menu | This is the main runtime intervention. |
| Apply Profile | Profiles only with optional runtime shortcut to open pane | Profiles | Specific profile selection is management, not glanceable runtime control. |
| Show Numbers | Profiles | Profiles | It explains a saved profile mapping. |
| Swap Side Displays | Menu + Restore | Restore | It is a recovery action, not profile management. |
| Install Restore Tool | Menu + Restore | Restore | Dependency readiness is part of restore trust. |
| Automatic Restore toggle | Menu quick toggle + Restore | Restore | Policy belongs with restore rules. |
| Review Before Restore | Restore | Restore | This is a restore policy, not a general preference. |
| Diagnostics | Menu shortcut + Diagnostics | Diagnostics | Trust evidence deserves a dedicated destination. |
| Shortcuts | Settings only | Shortcuts | Dedicated configuration task. |
| Launch at Login | Settings only | General | App lifecycle preference. |
| Updates | Settings only | General | App maintenance preference. |
| Language | Settings only | General | App-wide preference. |

## Explicit drift callouts to resolve in phase 2

1. **Docs vs implementation drift:** docs say five panes, code currently surfaces three primary panes.
2. **Diagnostics discoverability drift:** diagnostics behaves like a primary trust destination but is nested under General.
3. **General-pane overload drift:** language, updates, launch-at-login, review-before-restore, shortcuts, and diagnostics are all partially blended today.

## Phase 2 implementation boundary

The chosen surface map is a definition artifact only. It implies later implementation work such as:

1. expose `Shortcuts` and `Diagnostics` as first-class sidebar panes
2. move review-before-restore out of “advanced/general” framing into Restore framing
3. tighten healthy-state menu density
4. align docs and runtime copy with the chosen canonical homes
