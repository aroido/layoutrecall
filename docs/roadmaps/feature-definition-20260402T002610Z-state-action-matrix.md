# LayoutRecall State / Action Matrix

Lab: `feature-definition-20260402T002610Z`
Status: definition-phase artifact
Updated: 2026-04-02

## Scope

This matrix describes the user-observable runtime states derived from `AppPresentation.swift`, `RestoreCoordinator.swift`, and `AppModel.swift`.

## Canonical runtime states

| Runtime state | What the user sees | Allowed actions | Blocked actions | Notes |
| --- | --- | --- | --- | --- |
| No profiles | No baseline exists yet. | Save Profile, open settings. | Restore Now, Apply Profile, automatic restore. | First safe action is profile capture. |
| Installing restore tool | Dependency install is in progress. | Wait, view status, optionally save profile. | Real restore actions, swap, apply profile. | Runtime should act as temporarily read-only. |
| Restore tool missing | Real restore cannot run. | Install Restore Tool, save profile, inspect settings. | Restore Now, Apply Profile, automatic restore, swap. | Tool absence blocks execution, not profile management. |
| No confident match | Profiles exist, but none match current displays. | Save Profile, inspect Profiles/Diagnostics. | Automatic restore, Restore Now for current state. | Current code offers manual-fix semantics only when a match exists. |
| Low confidence | Best match exists but score is below threshold. | Restore Now, Save Profile, open diagnostics, possibly swap. | Automatic restore. | Review-style manual recovery state. |
| Review before restore | Best match is good enough, but confirm-first mode is on. | Restore Now, Save Profile, open diagnostics. | Automatic restore until user confirms. | Derived from `awaitingUserConfirmation`. |
| Auto restore off | Match is good, but global automatic restore is disabled. | Enable Automatic Restore, Restore Now, Save Profile. | Automatic restore. | Global switch blocks otherwise-safe automation. |
| Manual layout override | Current arrangement appears intentional or recently user-forced. | Save Profile, open diagnostics, possibly Apply Profile from profiles. | No single clear runtime primary action in current UI. | This is the most ambiguous current state. |
| Manual recovery | The app will not act automatically, but user-controlled recovery is available. | Restore Now, Save Profile, open diagnostics, possibly swap. | Automatic restore. | Catch-all degraded runtime state. |
| Healthy | A good profile/context exists and nothing needs intervention. | Open settings, optionally save profile, optionally apply/swap from advanced controls. | None structurally, but no urgent action needed. | Should collapse to a low-attention summary state. |

## Action matrix by state

| Action | No profiles | Installing tool | Tool missing | No match | Low confidence | Review before restore | Auto restore off | Manual override | Manual recovery | Healthy |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Save Profile | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed |
| Install Restore Tool | N/A unless tool missing | In progress only | Allowed | N/A | N/A | N/A | N/A | N/A | N/A | N/A |
| Enable Automatic Restore | N/A | Blocked | Blocked by missing tool if user expects full restore | N/A | Optional but not sufficient alone | Optional but review gate still wins | Allowed primary action | Optional | Optional | Allowed toggle |
| Restore Now (best current match) | Blocked | Blocked | Blocked | Blocked without compatible match | Allowed | Allowed | Allowed | Ambiguous today; should be explicit if kept | Allowed | Optional utility action only |
| Apply Profile (specific profile) | Blocked | Blocked | Blocked | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists | Allowed from Profiles if tool exists |
| Show Numbers | Blocked | Allowed only if current displays can still be read; no restore dependency required | Allowed if markers can resolve | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed |
| Swap Side Displays | Blocked | Blocked | Blocked | Allowed only for supported display counts and available tool | Allowed under same constraints | Allowed under same constraints | Allowed under same constraints | Allowed under same constraints | Allowed under same constraints | Allowed under same constraints |
| Open Diagnostics | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed |
| Edit Profile Threshold | Blocked | Allowed if profiles exist | Allowed if profiles exist | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed |
| Delete / Rename Profile | Blocked | Allowed if profiles exist | Allowed if profiles exist | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed | Allowed |

## Contradictions and drift

### 1. “Fix Now” hides two different intents

- In low-confidence, review, and manual-recovery states, the runtime action is really **restore the best current match now**.
- In profile cards, the analogous action is **apply a specific profile**.
- The current naming makes these feel more interchangeable than they are.

**Decision:** keep them as two distinct actions: **Restore Now** vs **Apply Profile**.

### 2. Manual override has no explicit keep/restore choice

- `manualLayoutOverride` currently has **no** primary action in `menuPrimaryAction`.
- Users in this state need a clear choice between preserving the current layout, restoring the saved one, or saving a new profile.

**Decision:** phase 2 should expose an explicit recovery choice set instead of leaving the state actionless.

### 3. “No match” and “no profiles” both point to saving, but for different reasons

- No profiles = create the first baseline.
- No match = capture a new arrangement or investigate why current hardware differs.

**Decision:** keep both states distinct in copy even if the first CTA remains Save Profile.

### 4. Diagnostics is simultaneously “support” and “runtime trust”

- The app offers diagnostics shortcuts from degraded restore states.
- Settings still nests Diagnostics under General.

**Decision:** treat diagnostics as a first-class trust surface with its own canonical home.

## State model rules accepted by PM, Designer, and Engineer

1. **Never auto-restore in a state that still needs user interpretation.** Low-confidence, review-before-restore, tool-missing, and no-match states remain manual.
2. **Manual recovery must name what will happen.** The chosen model distinguishes restoring the best match from applying a specific saved profile.
3. **Healthy is a quiet state, not a control panel.** The user can still access utilities, but the state should read as stable by default.
4. **Every blocked state must explain the blocker and the next safe action.** Hidden blockers are not acceptable.

## Phase 2 follow-up candidates

1. Replace ambiguous runtime copy with the canonical action pair: **Restore Now** and **Apply Profile**.
2. Add a distinct **Keep Current Layout** outcome for manual override / intentional temporary setups.
3. Rework healthy-state menu density so it behaves like a quiet status surface instead of a mini dashboard.
