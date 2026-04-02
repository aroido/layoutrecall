# LayoutRecall Surface Map

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Current-state information architecture and review outcome

**Current shipped IA:** 3 top-level panes

- `README.md`
- `docs/PRD.md`
- `docs/SPEC.md`
- `Sources/LayoutRecallApp/MenuContentView.swift`
- `Sources/LayoutRecallApp/SettingsView.swift`
- `Sources/LayoutRecallApp/AppPresentation.swift`

**Review outcome:** long-term canonical IA remains **unresolved** after peer review. Two reviewers support keeping 3-pane as canonical; two reviewers argue the final target should remain a 5-area model so trust/support surfaces stay first-class.

### Why the current implementation favors 3 panes

- It matches the implemented sidebar (`SettingsPane.primaryNavigationPanes`).
- It fits a menu-bar-first utility better than a wider five-pane navigation model.
- It keeps recovery tasks close together while moving lower-frequency maintenance/admin work under General.
- It reduces navigation noise without hiding important actions, because Shortcuts and Diagnostics remain directly linkable.

### Competing IA candidate still under debate

**Candidate:** five equal-weight conceptual panes (`Restore / Profiles / Shortcuts / Diagnostics / General`)

**Why it remains open:** critics argue that Diagnostics is a trust surface, not only a maintenance detail, and that current 3-pane code should not automatically settle the product model.

## Audit: current surface structure

### Menu bar content model (implemented)

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
   - Fix Now
   - Enable Automatic Restore
4. **Quick control section** (when profiles exist)
   - Automatic Restore toggle
   - optional inline Fix Now button
   - optional Swap Positions button
   - More Actions menu with:
     - Save Current Layout
     - profile quick switch / Apply Layout
     - Manage Profiles
     - Show Numbers
     - Open Diagnostics
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

### Drift between docs and code

| Surface area | Docs say | Code does |
| --- | --- | --- |
| Settings IA | Five panes: Restore / Profiles / Shortcuts / Diagnostics / General | Three sidebar sections with Shortcuts + Diagnostics collapsed into General |
| Diagnostics access | Dedicated settings pane | Nested disclosure under General plus contextual shortcut from Restore |
| Shortcuts access | Dedicated settings pane | Nested disclosure under General |
| Menu quick actions | README lists `Fix Now`, `Apply Layout`, `Show Numbers`, `Swap Positions` | Same capabilities exist, but some are top-level buttons while others are buried in the More Actions menu or per-profile settings cards |

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

| Feature | Menu | Restore | Profiles | General | Canonical home |
| --- | --- | --- | --- | --- | --- |
| Runtime Status & Match Review | Primary | Primary | - | - | Restore |
| Save Profile | Quick action | Secondary mention only | Primary | - | Profiles |
| Auto Restore | Quick toggle | Primary control | - | Ask-before-restore support only | Restore |
| Restore Now | Primary CTA | Primary CTA | - | - | Restore |
| Apply Layout | Quick-switch submenu only | - | Primary per-profile action | - | Profiles |
| Show Numbers / Identify Displays | Advanced action | Reference-profile action | Per-profile action | - | Profiles |
| Swap Positions | Secondary quick action | Secondary action | - | - | Restore |
| Profile Management | quick-switch entry only | - | Primary | - | Profiles |
| Diagnostics | shortcut when needed | shortcut when needed | - | Primary section today | **Unresolved:** General section vs first-class trust surface |
| Dependency Setup | Primary CTA when blocked | Primary CTA when blocked | - | - | Restore |
| Shortcuts | - | - | - | Primary section today | **Unresolved:** General section vs dedicated pane in a future 5-area IA |
| Updates / launch / language | - | - | - | Primary | General |

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

**Chosen candidate: Candidate B — explicit 5-section settings IA.**

### Why this is the chosen definition

- The product promise is trust-heavy; **Diagnostics** is too important to bury as a disclosure.
- **Shortcuts** is a full user-facing capability with three independent action bindings, not just an advanced footnote.
- The existing docs already teach a 5-section mental model, so choosing it minimizes long-term narrative drift.
- PM, Designer, and Engineer alignment is easier when every major feature area has one obvious home.

## Chosen canonical surface map

### Menu bar: what belongs here

The menu remains the **runtime trust and recovery surface**.

#### Menu should own

## 5-pane vs 3-pane review split

| Option | Pros | Cons | Verdict |
| --- | --- | --- | --- |
| 5-pane top-level navigation | Trust/support surfaces stay first-class; aligns with older docs and the full SettingsPane enum model | Heavier navigation for a menu-bar utility; does not match shipped sidebar today | **Contested** |
| 3-pane navigation with nested sections | Matches current implementation; simpler mental model; keeps recovery/admin distinction clear | Diagnostics and Shortcuts are one click deeper and may feel buried | **Contested** |

- Profile renaming/deletion
- Confidence threshold sliders
- Shortcut editing
- Update policy configuration
- Language settings
- Support-file browsing as a primary workflow

### Settings: chosen 5-section IA

#### 1. Restore

Purpose: explain current restore policy, trust state, and recommended next actions.

Owns:
- Automatic Restore toggle
- Ask Before Restore toggle
- dependency/install state
- recommended restore actions (`Fix Now`, `Install displayplacer`, `Enable Automatic Restore`)
- current-vs-saved layout comparison
- contextual diagnostics shortcut
- Swap Positions action and availability messaging

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

#### 3. Shortcuts

Purpose: configure hotkeys for high-frequency recovery actions.

Owns:
- Fix Now shortcut
- Save Current Layout shortcut
- Swap Positions shortcut

#### 4. Diagnostics

Purpose: expose evidence, history, and support artifacts.

Owns:
- latest restore outcome
- runtime snapshot
- recent history
- copy diagnostics report
- support-folder and support-file links

#### 5. General

Purpose: app-level non-recovery preferences and app lifecycle controls.

Owns:
- language selection
- automatic update checks
- update actions (check now / install / skip)
- launch at login
- app version/build info

## Feature-to-surface canonical home map

| Feature | Menu | Restore | Profiles | Shortcuts | Diagnostics | General | Canonical home |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Save Current Layout | Yes | No | Yes | Shortcut entry only | No | No | **Profiles** |
| Automatic Restore | Toggle | Yes | No | No | No | No | **Restore** |
| Ask Before Restore | No | Yes | No | No | No | No | **Restore** |
| Fix Now | Yes | Yes | No | Shortcut entry only | Context only | No | **Restore** |
| Apply Layout | Quick-switch only | No | Yes | No | No | No | **Profiles** |
| Show Numbers | Utility action | No | Yes | No | No | No | **Profiles** |
| Swap Positions | Yes | Yes | No | Shortcut entry only | No | No | **Restore** |
| Profile rename/delete | No | No | Yes | No | No | No | **Profiles** |
| Confidence threshold | No | No | Yes | No | No | No | **Profiles** |
| Diagnostics history/report | Shortcut only | Shortcut only | No | No | Yes | No | **Diagnostics** |
| Shortcut editing | No | No | No | Yes | No | No | **Shortcuts** |
| Updates | No | No | No | No | No | Yes | **General** |
| Launch at login | No | No | No | No | No | Yes | **General** |
| Language | No | No | No | No | No | Yes | **General** |
| Install displayplacer | Yes when blocked | Yes | No | No | Context only | No | **Restore** |

## Rationale: 5-pane vs 3-pane

### Accepted rationale for 5-pane

- Trust-heavy apps need **Diagnostics** to be first-class, not buried.
- The app already has enough surface area that “General” should not become a junk drawer.
- A dedicated **Shortcuts** pane is justified because shortcut editing is structured, repetitive, and task-specific.
- The five-pane model better matches the product story in README/PRD/SPEC and reduces future documentation drift.

### Why 3-pane was not chosen

- It optimizes for a shorter sidebar at the cost of clarity.
- It hides two user-visible capabilities inside an “Advanced” stack that weakens findability.
- It makes the “canonical home” of diagnostics ambiguous, especially when restore trust is the core product value.

## Phase 2 follow-up candidates (not part of definition approval)

- Move Shortcuts and Diagnostics back into first-class sidebar panes in code.
- Update README/PRD/SPEC copy to match the chosen IA exactly.
- Rebalance the menu so more-actions density stays manageable after terminology cleanup.
