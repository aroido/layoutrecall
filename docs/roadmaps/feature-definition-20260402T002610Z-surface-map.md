# LayoutRecall Menu + Settings Surface Map

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: proposed definition set for PM + Designer + Engineer signoff before implementation

## Audit finding that forces an IA decision

The code and docs currently disagree:

- `README.md`, `docs/PRD.md`, and `docs/SPEC.md` still describe a **five-pane** settings window.
- `SettingsPane.primaryNavigationPanes` in `Sources/LayoutRecallApp/AppPresentation.swift` currently exposes only **three sidebar destinations**: `Restore`, `Profiles`, and `General`.
- `Shortcuts` and `Diagnostics` are currently secondary disclosures inside `General`.

## Chosen settings structure

**Choose one canonical settings IA:**

### Top-level navigation: 3 panes only

1. **Restore**
2. **Profiles**
3. **General**

### Secondary sections within General

- Shortcuts
- Diagnostics

## Why 3-pane navigation wins over 5-pane navigation

### Accepted rationale

- The current code already implements 3-pane primary navigation, so the chosen IA aligns with the shipped product instead of documenting an aspirational split.
- `Shortcuts` and `Diagnostics` are support utilities, not primary workflow destinations for day-to-day use.
- The product is menu-bar-first; top-level settings panes should map to the three stable jobs users do there: understand restore status, manage baselines, and configure app behavior.
- A 5-pane top-level split would add navigation weight without adding new conceptual clarity for this product size.

### Rejected rationale for 5-pane top-level

- It creates artificial parity between operational panes (`Restore`, `Profiles`) and support panes (`Shortcuts`, `Diagnostics`).
- It increases sidebar noise in a compact utility app.
- It preserves documentation drift instead of resolving it.

## Canonical surface model

## 1. Menu bar surface

### Purpose

The menu answers immediate runtime questions and exposes recovery actions without becoming the long-term management surface.

### Canonical menu content model

1. **Header**
   - app name
   - app symbol / overall health accent

2. **Runtime status card**
   - primary state badge
   - status title
   - status subtitle
   - matched/reference profile summary when relevant

3. **Primary runtime CTA** (shown only when needed)
   - save current layout as profile
   - install restore tool
   - restore matched layout now
   - enable automatic restore

4. **Quick controls card**
   - automatic restore toggle
   - secondary recovery actions row
     - restore matched layout now (if not already primary)
     - swap side displays
     - overflow menu

5. **Overflow / more actions menu**
   - save current layout as profile
   - quick switch to another saved profile
   - manage profiles
   - identify displays
   - open diagnostics

6. **Footer utility row**
   - settings
   - quit

### Menu action rules

- Menu owns runtime intervention, not profile administration.
- Menu can launch deep actions, but profile editing/deletion belongs in Settings.
- Healthy state should minimize interruption and emphasize glanceability.

## 2. Restore pane

### Purpose

Canonical home for trust, readiness, and the “what should happen next?” question.

### Current/accepted content blocks

1. **Current state overview**
   - status title/subtitle
   - auto-restore badge
   - dependency badge
   - display-count badge
   - confidence badge (when relevant)
   - matched baseline summary / identify displays shortcut

2. **Layout comparison**
   - current layout preview
   - saved layout preview

3. **Automatic restore control**
   - app-level toggle
   - dependency summary line

4. **Recommended actions**
   - context-specific primary action
   - secondary save action in degraded states
   - swap side displays
   - diagnostics shortcut

### Restore pane owns

- automatic restore mode
- review-before-restore mode visibility
- dependency readiness
- matched baseline context
- recommended next action

### Restore pane must not own

- profile rename/delete
- threshold tuning
- shortcut authoring
- update and language settings

## 3. Profiles pane

### Purpose

Canonical home for baseline creation and profile-specific management.

### Current/accepted content blocks

1. **Save current layout card**
2. **Saved profile cards** with:
   - name / rename
   - saved date
   - reference badge
   - display-count badge
   - confidence threshold badge
   - apply saved profile
   - identify displays
   - disclosure for preview and details
   - threshold slider
   - delete action

### Profiles pane owns

- save current layout as profile
- rename profile
- delete profile
- inspect profile layout details
- tune confidence threshold
- apply saved profile
- identify displays for a chosen profile

## 4. General pane

### Purpose

Canonical home for app-level preferences and support utilities.

### Current/accepted content blocks

1. **Updates**
2. **Language**
3. **Launch at login**
4. **Advanced**
   - ask before automatic restore
   - Shortcuts disclosure
   - Diagnostics disclosure

### General pane owns

- launch at login
- updates
- preferred language
- ask-before-restore toggle
- shortcuts configuration
- diagnostics review and report copy

## Feature-to-home mapping

| Feature / content | Menu | Restore | Profiles | General | Canonical home |
| --- | --- | --- | --- | --- | --- |
| Runtime status | Yes | Yes | No | No | Restore |
| Automatic restore toggle | Yes | Yes | No | No | Restore |
| Ask before automatic restore | No | visibility only | No | Yes | General |
| Save current layout as profile | Yes | via recommendation only if needed | Yes | No | Profiles |
| Apply specific saved profile | Quick switch only | No | Yes | No | Profiles |
| Restore matched layout now | Yes | Yes | No | No | Restore |
| Identify displays | Yes | Yes | Yes | No | Profiles |
| Swap side displays | Yes | Yes | No | Optional shortcut only | Restore |
| Restore tool setup | Yes | Yes | No | No | Restore |
| Confidence threshold | No | No | Yes | No | Profiles |
| Profile rename/delete | No | No | Yes | No | Profiles |
| Launch at login | No | No | No | Yes | General |
| Updates | No | No | No | Yes | General |
| Language | No | No | No | Yes | General |
| Shortcuts | No | No | No | Yes | General |
| Diagnostics history/report | Shortcut only | Shortcut only | No | Yes | General |

## Decision summary

- **Accepted:** 3-pane top-level settings IA (`Restore`, `Profiles`, `General`).
- **Accepted:** `Shortcuts` and `Diagnostics` remain secondary sections inside `General`.
- **Accepted:** Menu stays runtime-first, not profile-admin-first.
- **Rejected:** returning to a 5-pane top-level sidebar as the canonical model.

## Phase 2 follow-up after signoff

1. update README/PRD/SPEC to stop describing the settings window as five-pane
2. tighten menu healthy-state density so the surface feels calmer
3. decide whether `Ask Before Restore` should move into Restore or remain an advanced General preference
