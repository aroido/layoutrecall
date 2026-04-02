# LayoutRecall Simplified State / Action Matrix

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Core rule

The state model exists to answer one question:

> Can LayoutRecall safely restore the saved profile now?

## Primary user-facing states

| State | Meaning | Primary next action |
| --- | --- | --- |
| No Profile | No saved layout exists yet | Save Profile |
| Ready to Auto Restore | A trusted saved profile matches and automation can run | Auto Restore runs automatically |
| Needs Manual Restore | A profile exists, but the app should not restore automatically | Restore Now |
| Dependency Blocked | `displayplacer` is missing or setup is incomplete | Install Dependency |
| Restore Running | A restore or reposition command is running | Wait / observe |
| Restore Verified | Restore succeeded and layout matches expected result | None |

## Core actions

| Action | Purpose | Home |
| --- | --- | --- |
| Save Profile | Capture the known-good layout | Profiles |
| Restore Now | Manually restore the best current match | Menu + Restore |
| Apply Layout | Restore a specific saved profile | Profiles |
| Auto Restore toggle | Allow or disallow automatic recovery | Menu + Restore |
| Show Numbers | Verify display mapping | Profiles + utility access |
| Install Dependency | Resolve restore blocker | Restore |

## Demoted actions

| Action | Status | Reason |
| --- | --- | --- |
| Swap Positions | Advanced/manual fallback | Not part of the core recovery path |
| Shortcuts | Convenience | Not required for the recovery model |

## Simplification decisions

1. Treat `Restore Now` as the one primary manual recovery action.
2. Treat `Apply Layout` as profile-scoped restore only.
3. Treat `Show Numbers` as a trust utility, not a main action.
4. Do not make low-frequency utilities shape the whole state model.
