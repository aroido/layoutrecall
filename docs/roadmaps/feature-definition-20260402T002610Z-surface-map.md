# LayoutRecall Menu and Settings Surface Map

_Date:_ 2026-04-02

## Chosen information architecture

**Chosen canonical settings IA: 3 top-level panes**

1. **Restore**
2. **Profiles**
3. **General**
   - Shortcuts (section)
   - Diagnostics (section)

### Why this is the chosen IA

- It matches the implemented sidebar (`SettingsPane.primaryNavigationPanes`).
- It fits a menu-bar-first utility better than a wider five-pane navigation model.
- It keeps recovery tasks close together while moving lower-frequency maintenance/admin work under General.
- It reduces navigation noise without hiding important actions, because Shortcuts and Diagnostics remain directly linkable.

### Rejected alternative

**Rejected:** five equal-weight top-level panes (`Restore / Profiles / Shortcuts / Diagnostics / General`)

**Reason rejected:** this overstates the importance of maintenance surfaces for a lightweight utility and does not match the current implementation reality.

## Audit: current surface structure

### Menu bar content model (implemented)

1. **Header**
   - App name
   - status symbol
2. **Status block**
   - state badge
   - title
   - subtitle
   - reference profile summary when not healthy
3. **Primary action** (conditional)
   - Install Dependency / Restore Now / Enable Auto Restore / Save Profile
4. **Quick controls** (when profiles exist)
   - Auto Restore toggle
   - Restore Now secondary button when needed
   - Swap Positions
   - More Actions menu
5. **Advanced actions menu**
   - Save Profile
   - quick switch to specific profile
   - Show Numbers
   - Open Diagnostics
6. **Footer**
   - Settings
   - Quit

### Settings surface model (implemented)

#### Restore
- Current state summary
- status badges: auto restore, dependency, display count, confidence
- reference profile summary and Show Numbers
- live vs saved layout preview comparison
- Auto Restore card
- recommended actions card
- Swap Positions when relevant
- Open Diagnostics shortcut when needed

#### Profiles
- Save Profile primary action
- empty state or profile list
- each profile card contains:
  - name / rename
  - reference badge when matched
  - saved date
  - display count
  - confidence threshold
  - Apply Layout
  - Show Numbers
  - disclosure with preview/details
  - confidence slider
  - delete action

#### General
- summary/status card
- language selector
- update controls
- launch at login
- advanced section:
  - Ask Before Restore
  - Shortcuts disclosure
  - Diagnostics disclosure

## Canonical feature-to-surface ownership

| Feature | Menu | Restore | Profiles | General | Canonical home |
| --- | --- | --- | --- | --- | --- |
| Runtime Status & Match Review | Primary | Primary | - | - | Restore |
| Save Profile | Quick action | Secondary mention only | Primary | - | Profiles |
| Auto Restore | Quick toggle | Primary control | - | Ask-before-restore support only | Restore |
| Restore Now | Primary CTA | Primary CTA | - | - | Restore |
| Apply Layout | Quick-switch submenu only | - | Primary per-profile action | - | Profiles |
| Show Numbers | Advanced action | Reference-profile action | Per-profile action | - | Profiles |
| Swap Positions | Secondary quick action | Secondary action | - | - | Restore |
| Profile Management | quick-switch entry only | - | Primary | - | Profiles |
| Diagnostics | shortcut when needed | shortcut when needed | - | Primary section | General > Diagnostics |
| Dependency Setup | Primary CTA when blocked | Primary CTA when blocked | - | - | Restore |
| Shortcuts | - | - | - | Primary section | General > Shortcuts |
| Updates / launch / language | - | - | - | Primary | General |

## Canonical menu content order

When the menu is in any non-healthy state, content should appear in this order:

1. Status summary
2. Single best next action
3. Auto Restore control (if profiles exist)
4. Secondary recovery actions
5. More Actions / profile switching / diagnostics
6. Settings / Quit

### Rule

The menu must answer four questions in under one glance:
1. What state is the app in?
2. Which profile, if any, is relevant?
3. Why did it not auto-restore?
4. What should I do next?

## Canonical settings structure

### Restore pane
**Purpose:** runtime trust + immediate recovery.

Sections:
1. Current state overview
2. Live vs saved layout comparison
3. Auto Restore controls
4. Recommended actions
5. Swap Positions (availability-aware)
6. Diagnostics shortcut when state is not healthy

### Profiles pane
**Purpose:** create and manage saved layouts.

Sections:
1. Save Profile
2. Profile list / empty state
3. For each profile:
   - metadata
   - Apply Layout
   - Show Numbers
   - details preview
   - confidence threshold
   - delete

### General pane
**Purpose:** app-wide preferences and maintenance.

Sections:
1. App summary
2. Language
3. Updates
4. Launch at login
5. Advanced
   - Ask Before Restore
   - Shortcuts disclosure
   - Diagnostics disclosure

## 5-pane vs 3-pane rationale

| Option | Pros | Cons | Verdict |
| --- | --- | --- | --- |
| 5-pane top-level navigation | Easier direct linking to every maintenance area; familiar from larger desktop apps | Too heavy for a menu-bar utility; splits related preferences; disagrees with shipped sidebar | Rejected |
| 3-pane navigation with nested sections | Matches current implementation; simpler mental model; keeps recovery/admin distinction clear | Diagnostics and Shortcuts are one click deeper | Accepted |

## Naming and surface rules

1. **Restore Now** is the primary recovery verb.
2. **Apply Layout** is profile-specific and belongs to Profiles.
3. **Show Numbers** is the user-facing mapping verb.
4. **Swap Positions** is a supported manual override, not a profile edit.
5. **Auto Restore** belongs to Restore, not General.
6. **Diagnostics** and **Shortcuts** are maintenance surfaces and should stay inside General unless future evidence proves otherwise.

## Phase 2 follow-up (not started here)

1. Update docs/marketing that still describe a five-pane settings window.
2. Consider whether Show Numbers should move fully under Profiles if multi-profile usage becomes dominant.
3. Revisit direct diagnostics visibility only if support data shows users miss it in General.
