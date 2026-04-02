# LayoutRecall Consensus State / Action Matrix

_Date:_ 2026-04-02

## Purpose

This matrix converts the current runtime behavior into one user-observable state model that design, product, and implementation can share.

Primary runtime state source audited: `AppPresentation.menuPrimaryState` plus supporting restore/dependency flags in `AppModel` and `RestoreCoordinator`.

## Canonical runtime states

| Canonical state | Current code anchor | User-facing meaning |
| --- | --- | --- |
| No Profiles | `menuPrimaryState = .noProfiles` | The app cannot restore because nothing has been saved yet |
| Installing Dependency | `.installingDependency` | The app is setting up `displayplacer`; restores are temporarily unavailable |
| Dependency Missing | `.dependencyMissing` | A profile may exist, but real restore commands cannot run yet |
| No Match | `.noMatch` | Profiles exist, but none match the current live display set confidently enough to even review |
| Needs Review | `.lowConfidence` or `.reviewBeforeRestore` | A candidate profile exists, but the user should manually decide before restore |
| Auto Restore Off | `.autoRestoreDisabled` | The app is otherwise ready but automation is intentionally disabled |
| Manual Layout Override | `.manualLayoutOverride` | The current layout differs because the user performed a manual repositioning action |
| Manual Recovery Available | `.manualRecovery` | The app is not in a healthy auto-ready state, but manual restore controls remain usable |
| Ready | `.healthy` | A trusted profile is ready or the app is otherwise healthy with current conditions |
| No Displays (substate) | `RestoreDecisionContext.noDisplays` | No displays are detected; most layout actions are meaningless until hardware returns |
| Restore In Progress (overlay) | `restoreCommandInProgress == true` | A restore/reposition command is already running; duplicate actions should be blocked |

## Allowed and blocked actions by state

| State | Allowed actions | Blocked actions | Notes |
| --- | --- | --- | --- |
| No Profiles | Save Profile, open Settings | Restore Now, Apply Layout, Show Numbers, Auto Restore enable, Swap Positions | First-run capture state |
| Installing Dependency | Wait, open Settings, optional Save Profile | Restore Now, Apply Layout, Swap Positions, dependency reinstall | Save remains harmless because it does not require `displayplacer` |
| Dependency Missing | Install Dependency, Save Profile, open Diagnostics | Restore Now, Apply Layout, Swap Positions, full auto restore | Dependency CTA is primary |
| No Match | Save Profile, inspect Diagnostics, open Profiles | Restore Now should not be shown as primary, Apply Layout from a specific profile stays user-directed only if dependency exists | Current docs under-explain this distinction |
| Needs Review | Restore Now, Save Profile, Show Numbers, open Diagnostics | Automatic restore, silent background apply | Combines low-confidence and ask-before-restore review paths into one user model |
| Auto Restore Off | Enable Auto Restore, Restore Now, Save Profile, Show Numbers | Automatic restore | App is healthy enough for manual recovery |
| Manual Layout Override | Restore Now, Apply Layout, Show Numbers, inspect Diagnostics | Automatic restore until next qualifying event | Manual override should be explained, not treated as failure |
| Manual Recovery Available | Restore Now, Save Profile, Apply Layout, Show Numbers, Diagnostics | Automatic restore if readiness conditions are not met | Catch-all recovery state |
| Ready | Save Profile, Apply Layout, Show Numbers, optional Swap Positions, open Settings | None, except actions blocked by dependency/runtime overlays | “Ready” is healthy, not idle-only |
| No Displays (substate) | Open Settings, inspect Diagnostics | Save Profile, Restore Now, Apply Layout, Show Numbers, Swap Positions | This should be called out explicitly in later UX copy |
| Restore In Progress (overlay) | Observe progress, open Diagnostics | Trigger another restore, Apply Layout, Swap Positions | Overlay blocks duplicate execution across base states |

## Action inventory

| Action | Canonical name | Current anchor(s) | Primary owner surface |
| --- | --- | --- | --- |
| Save current layout | Save Profile | `saveCurrentLayout()` / `.saveNewProfile` | Menu + Profiles |
| Restore best match now | Restore Now | `fixNow()` / `.fixNow` | Menu + Restore |
| Restore a specific profile | Apply Layout | `restoreProfile(_:)` | Profiles |
| Show overlay mapping | Show Numbers | `identifyDisplays(for:)` | Menu + Restore + Profiles |
| Reposition simple layouts | Swap Positions | `swapLeftRight()` | Menu + Restore |
| Turn on automation | Enable Auto Restore | `setAutoRestore(true)` | Menu + Restore |
| Install dependency | Install Dependency | `installDisplayplacer()` | Menu + Restore |
| Open diagnostics context | Open Diagnostics | settings-navigation only | Menu shortcut + General > Diagnostics |

## Duplicate or contradictory actions to call out

### 1. `Restore Now` vs `Apply Layout`
- **Why it exists:** `Restore Now` chooses the best manual recovery path from current context, while `Apply Layout` is profile-specific.
- **Consensus:** Keep both. They solve different user intents.
- **Implementation rule:** Never label both with the same verb in the same surface.

### 2. `Fix Now` vs `Restore Now`
- **Why it exists:** legacy/internal naming drift.
- **Consensus:** Keep **Restore Now** as the user-facing label and phase out `Fix Now` in docs/copy.

### 3. Save Profile shown in many non-empty states
- **Why it exists:** current app allows capturing a fresh known-good state almost anywhere.
- **Consensus:** Keep. It is a valid escape hatch from mismatch/manual-override situations.

### 4. Swap Positions visible when unavailable
- **Why it exists:** `showsSwapDisplaysControl` returns true in many states to explain availability via help text.
- **Consensus:** Keep the control visible only when it teaches something useful; if later simplified, prefer a visible disabled control in Restore, not a surprise hidden action.

### 5. App-level auto restore vs per-profile auto restore
- **Why it exists:** model shape suggests both, UI/runtime currently expose only app-level automation.
- **Consensus:** Treat **app-level Auto Restore** as canonical phase-1 behavior. Per-profile automation remains unresolved.

## Consensus state transitions

| From | Trigger | To | Guard |
| --- | --- | --- | --- |
| No Profiles | Save Profile succeeds | Ready or Manual Recovery Available | Depends on dependency/runtime readiness |
| Dependency Missing | Install Dependency succeeds | Ready / Needs Review / Auto Restore Off | Re-evaluate current displays after setup |
| Ready | Display event causes weak match | Needs Review | Score below auto threshold or ask-before-restore enabled |
| Ready | User toggles Auto Restore off | Auto Restore Off | Profiles still exist |
| Needs Review | User chooses Restore Now | Ready or Manual Layout Override | Depends on restore success and verification |
| Any restore-capable state | User chooses Swap Positions | Manual Layout Override | Supported display count + dependency ready |
| Any | Displays disappear | No Displays | Hardware removed/unreadable |
| Any executing state | Command completes/fails | Ready / Manual Recovery Available | Based on verification outcome |

## Product rules that must remain explicit

1. **No automatic restore below threshold.**
2. **No restore action without dependency readiness.**
3. **Manual actions remain available even when automation is blocked, if dependency is ready.**
4. **Diagnostics must explain blocked decisions and manual overrides.**
5. **The same user intent should not appear under multiple conflicting labels.**

## Phase 2 follow-up (not started here)

1. Add explicit UX copy for the `No Displays` substate.
2. Decide whether `Manual Recovery Available` needs a clearer user-facing name.
3. Remove or expose per-profile auto-restore so the state model stops implying both scopes.
