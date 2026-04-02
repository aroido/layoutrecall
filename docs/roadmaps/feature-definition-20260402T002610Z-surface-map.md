# LayoutRecall Surface Map

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Simplified implementation-aligned artifact

## Audit basis

Reviewed implementation and docs for surface structure using:

- `README.md`
- `docs/PRD.md`
- `docs/SPEC.md`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppPresentation.swift`

## Current implementation snapshot

### Menu bar content model (current)

1. **Header**
   - App name
   - state-sensitive app symbol
2. **Status block**
   - state badge
   - status title
   - status subtitle
   - optional compact reference-profile summary
3. **Primary action** (conditional)
   - Save Current Layout
   - Install displayplacer
   - Restore Now
   - Enable Automatic Restore
4. **Quick control section** (when profiles exist)
   - Automatic Restore toggle
   - optional inline Restore Now button
   - More Actions menu with:
     - Save Current Layout
     - profile quick switch / Apply Layout
     - Manage Profiles
     - Show Numbers
     - Open Diagnostics
     - Advanced fallback utility: Swap Positions
5. **Footer**
   - Settings
   - Quit

### Settings content model (current)

#### Primary sidebar sections

- Restore
- Profiles
- General

#### Embedded advanced sub-sections inside General

- Shortcuts
- Diagnostics

### Drift resolved by the accepted implementation direction

| Surface area | Docs say | Code does |
| --- | --- | --- |
| Settings IA | Three primary sections: Restore / Profiles / General | Three sidebar sections with Shortcuts + Diagnostics collapsed into General |
| Diagnostics access | Supporting section under General plus contextual shortcut from Restore | Nested disclosure under General plus contextual shortcut from Restore |
| Shortcuts access | Supporting section under General | Nested disclosure under General |
| Menu quick actions | README/PRD/SPEC treat `Restore Now` as the primary manual recovery CTA and demote other utilities | Core recovery action is primary; supporting actions sit behind `More Actions` or in settings/profile flows |

## IA candidates considered

### Candidate A — Keep current 3-section sidebar with embedded advanced sub-sections

**Sidebar**
- Restore
- Profiles
- General

**Inside General**
- Language
- Updates
- Launch at Login
- Advanced
  - Ask Before Restore
  - Shortcuts (disclosure)
  - Diagnostics (disclosure)

**Pros**
- Minimal implementation disruption.
- Keeps the top-level sidebar short and simple.
- Works well if Shortcuts and Diagnostics are considered secondary/advanced.

**Cons**
- Diagnostics is too important for trust and support to feel “tucked away.”
- Shortcuts and Diagnostics are user-visible enough to deserve clearer findability.
- Conflicts with the current docs and marketing narrative about the product surface.

### Candidate B — Use one explicit 5-section settings IA

**Sidebar**
- Restore
- Profiles
- Shortcuts
- Diagnostics
- General

**Pros**
- Matches the docs users and contributors already read.
- Gives trust/support surfaces first-class visibility.
- Makes “where does this live?” decisions simpler and less nested.

**Cons**
- Slightly heavier sidebar.
- Requires implementation work to unnest the current General pane.
- Needs careful copy cleanup to avoid duplicating restore controls across panes.

## Chosen IA

**Chosen candidate: Candidate A — shipped 3-section sidebar with supporting sections under General.**

### Why this is the chosen definition

- It matches the shipped app and the accepted simplified PRD/SPEC.
- It keeps the product centered on the recovery loop instead of turning support/admin areas into equal-weight navigation peers.
- Diagnostics and Shortcuts remain available, but as supporting surfaces rather than product-defining panes.
- It reduces navigation weight and keeps the settings window aligned with the narrower product scope.

## Chosen canonical surface map

### Menu bar: what belongs here

The menu remains the **runtime trust and recovery surface**.

#### Menu should own

- Current status badge/title/subtitle
- Reference profile summary when relevant
- Primary next action for the current state
- Automatic Restore toggle
- Fast runtime actions:
  - Restore Now
  - Save Current Layout
  - Apply Layout (via quick switch)
  - Show Numbers
- Fast link to Settings / Diagnostics when attention is needed
- Advanced fallback utilities only behind `More Actions`

#### Menu should not own

- Profile renaming/deletion
- Confidence threshold sliders
- Shortcut editing
- Update policy configuration
- Language settings
- Support-file browsing as a primary workflow

### Settings: chosen 3-section IA

#### 1. Restore

Purpose: explain current restore policy, trust state, and recommended next actions.

Owns:
- Automatic Restore toggle
- Ask Before Restore toggle
- dependency/install state
- recommended restore actions (`Restore Now`, `Install displayplacer`, `Enable Automatic Restore`)
- current-vs-saved layout comparison
- contextual diagnostics shortcut

#### 2. Profiles

Purpose: create, inspect, and manage saved layouts.

Owns:
- Save Current Layout
- profile list
- Apply Layout per profile
- Show Numbers per profile
- rename/delete profile
- confidence threshold tuning
- saved-layout preview/details

#### 3. General

Purpose: app-level non-recovery preferences and app lifecycle controls.

Owns:
- language selection
- automatic update checks
- update actions (check now / install / skip)
- launch at login
- app version/build info
- diagnostics disclosure
- shortcuts disclosure
- advanced/manual fallback utilities such as Swap Positions

## Feature-to-surface canonical home map

| Feature | Menu | Restore | Profiles | General | Canonical home |
| --- | --- | --- | --- | --- | --- |
| Save Current Layout | Yes | No | Yes | No | **Profiles** |
| Automatic Restore | Toggle | Yes | No | No | **Restore** |
| Ask Before Restore | No | Yes | No | Yes | **Restore** |
| Restore Now | Yes | Yes | No | No | **Restore** |
| Apply Layout | Quick-switch only | No | Yes | No | **Profiles** |
| Show Numbers | Utility action | No | Yes | No | **Profiles** |
| Swap Positions | Advanced utility only | No | No | Yes | **General** |
| Profile rename/delete | No | No | Yes | No | **Profiles** |
| Confidence threshold | No | No | Yes | No | **Profiles** |
| Diagnostics history/report | Shortcut only | Shortcut only | No | Yes | **General** |
| Shortcut editing | No | No | No | Yes | **General** |
| Updates | No | No | No | Yes | **General** |
| Launch at login | No | No | No | Yes | **General** |
| Language | No | No | No | Yes | **General** |
| Install displayplacer | Yes when blocked | Yes | No | No | **Restore** |

## Rationale: 3-pane vs 5-pane

### Accepted rationale for 3-pane

- The accepted product frame is a small recovery utility, not a broad management console.
- Restore and Profiles are the only primary user workflows.
- Diagnostics, Shortcuts, and other preferences remain important but supporting.
- The simpler sidebar keeps attention on the core recovery loop.

### Why 5-pane was not chosen

- It overstates the product breadth.
- It makes supporting/admin surfaces look equal to the recovery flow.
- It reintroduces the same documentation drift the simplified implementation already closed.

## Phase 2 follow-up candidates (not part of definition approval)

- Keep roadmap docs aligned with the shipped 3-pane IA.
- Continue reducing menu density when a utility starts competing with the main recovery CTA.
