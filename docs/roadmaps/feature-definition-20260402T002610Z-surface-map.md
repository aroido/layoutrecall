# LayoutRecall Simplified Surface Map

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Exact core problem

The app must help the user get one saved display profile back with as little friction and ambiguity as possible.

## Canonical IA

### Menu
Use for runtime recovery only.

Owns:
- current state
- Restore Now
- Auto Restore toggle
- lightweight utility access

### Restore
Use for the current recovery situation.

Owns:
- state summary
- dependency readiness
- current vs saved layout comparison
- recommended action

### Profiles
Use for saved-layout management.

Owns:
- Save Profile
- Apply Layout
- profile rename/delete
- confidence threshold
- Show Numbers

### General
Use for low-frequency preferences and support.

Owns:
- Diagnostics
- shortcuts
- launch at login
- updates
- language
- advanced preferences

## Surface ownership decisions

| Item | Canonical home |
| --- | --- |
| Restore state | Restore |
| Auto Restore | Restore |
| Restore Now | Menu + Restore |
| Save Profile | Profiles |
| Apply Layout | Profiles |
| Show Numbers | Profiles (with utility access elsewhere) |
| Diagnostics | General |
| Shortcuts | General |
| Swap Positions | Restore as advanced/manual utility |

## Simplicity rules

1. Do not create a top-level pane for a low-frequency support utility.
2. Do not let utility actions compete with restore actions.
3. Menu should lead with state and recovery, not administration.
4. Profiles should own the saved-layout object completely.
