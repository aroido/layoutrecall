# LayoutRecall Consensus Decision Log

_Date:_ 2026-04-02

## How to read this log

A definition is treated as approved only when **PM, Designer, and Engineer** all agree.  
Critic objections are recorded explicitly.  
Verifier notes whether the result is concrete enough for phase-2 implementation.

Legend:
- **A** = agree
- **R** = reject
- **?** = unresolved / needs follow-up

## Accepted decisions

| ID | Topic | Options considered | Decision | PM | Designer | Engineer | Critic | Verifier | Rationale |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| A1 | Canonical saved-layout term | baseline / profile / saved layout | **Use “profile” as the object name** | A | A | A | Notes users may still understand “saved layout” better in helper copy | A | Matches code and settings structure most closely |
| A2 | Manual recovery CTA label | Fix Now / Restore Now | **Use “Restore Now”** | A | A | A | Objects that docs and shortcuts still say Fix Now | A | Localization already exposes Restore Now, so this is the lowest-risk normalization |
| A3 | Settings IA | 5-pane nav / 3-pane nav + nested sections | **Use 3 top-level panes: Restore, Profiles, General** | A | A | A | Warns Diagnostics might become too hidden if support load grows | A | Matches shipped sidebar and menu-bar utility expectations |
| A4 | Canonical home for Auto Restore | Restore / General | **Restore** | A | A | A | None | A | It is a runtime recovery behavior, not a general app preference |
| A5 | Canonical home for Apply Layout | Menu primary / Profiles | **Profiles** | A | A | A | None | A | Profile-specific action should live beside the profile itself |
| A6 | Canonical home for Show Numbers | Restore only / Profiles only / shared | **Shared, with Profiles as primary reference surface** | A | A | A | Notes that menu access is still useful for fast diagnosis | A | Supports both fast recovery and per-profile inspection |
| A7 | State model simplification | docs-only “auto/manual” / explicit runtime states | **Use explicit runtime state model** | A | A | A | None | A | Current code already exposes richer state; docs should catch up instead of flattening it |
| A8 | Swap Positions framing | profile edit / manual override tool | **Manual override tool; does not edit saved profiles** | A | A | A | Wants warning copy to remain explicit | A | Matches current command flow and confirmation copy |
| A9 | Diagnostics placement | separate top-level pane / General section | **General > Diagnostics** | A | A | A | Warns discoverability could drop in failure-heavy flows | A | Current design already shortcuts to diagnostics when attention is needed |

## Rejected alternatives

| ID | Topic | Rejected option | Why rejected |
| --- | --- | --- | --- |
| R1 | Settings IA | Five equal-weight top-level panes | Too heavy for the product shape and inconsistent with the current implementation |
| R2 | Action label | Keep `Fix Now` as primary copy | Drift with current localization and weakly describes the actual action |
| R3 | Save-object name | Keep “baseline” as the main object name | Sounds temporary/internal and conflicts with current profile model |
| R4 | Diagnostics IA | Make Diagnostics a first-class top-level pane again by default | Overweights troubleshooting compared with daily recovery tasks |
| R5 | Auto-restore model | Pretend per-profile and app-level automation are both fully supported | Not true in the current UI/runtime contract |

## Unresolved items

| ID | Topic | Current evidence | Open question | PM | Designer | Engineer | Critic | Verifier |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| U1 | Per-profile auto restore | `DisplayProfile.settings.autoRestore` exists, but RestoreCoordinator/UI operate on app-level auto restore | Should per-profile auto restore become a real user-facing feature or be removed from the model? | ? | ? | ? | Objects to hidden behavior | ? |
| U2 | “No match” manual behavior | Menu primary action becomes Save Profile, while direct profile apply can still exist elsewhere | Should the product explicitly surface Apply Layout in no-match states when dependency is ready? | ? | ? | ? | Wants clearer recovery path for expert users | ? |
| U3 | Diagnostics discoverability | Diagnostics is nested under General but shortcut-linked from recovery surfaces | Is the current shortcuting enough, or should severe failures pin Diagnostics more aggressively? | ? | ? | ? | Concern about buried support signals | ? |
| U4 | Manual Recovery naming | Catch-all state is useful internally but not yet polished as a user-facing term | Should this state get a clearer end-user title in future UI copy? | ? | ? | ? | Says “manual recovery” can sound vague | ? |
| U5 | Save Profile prominence | Save Profile is available in many states | Is this correctly empowering, or does it risk encouraging users to overwrite a broken layout too quickly? | ? | ? | ? | Worries about accidental bad captures | ? |

## Explicit critic objections logged

1. **Diagnostics discoverability:** moving Diagnostics under General is acceptable only if blocked states continue to offer a direct shortcut.
2. **Save Profile overuse:** exposing Save Profile in degraded states can help expert users, but the product must avoid suggesting that every broken state should be captured as a new truth.
3. **Restore Now wording:** although preferred over Fix Now, the app should make clear whether it restores the best match or a specific profile.
4. **Hidden per-profile automation:** keeping hidden model fields without product intent creates trust risk.

## Implementation-readiness check

| Requirement | Result |
| --- | --- |
| Normalized feature catalog completed | Yes |
| State/action matrix completed | Yes |
| One chosen settings IA documented | Yes |
| Accepted / rejected / unresolved items recorded | Yes |
| PM + Designer + Engineer agreement explicitly required and represented | Yes |
| Phase 2 separated from phase 1 definitions | Yes |

## Phase 2 follow-up (definition complete, implementation not started)

These are implementation follow-ups only. They are **not** part of phase 1 execution:

1. Update docs and localization copy to use **profile** and **Restore Now** consistently.
2. Remove or fully productize per-profile auto-restore.
3. Align README / PRD / SPEC wording with the chosen three-pane settings IA.
4. Audit tests and snapshot names that still encode legacy “Fix Now” or “five-pane” assumptions.
