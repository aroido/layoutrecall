# LayoutRecall Feature Definition Decision Log

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1B simplification pass)

## Phase 1B objective

Sharpen the product definition around simplicity and direct usability.

Rule used in this pass:

> If a feature does not directly help the user save a known-good layout, restore it safely, or understand why restore did or did not happen, it should be demoted or treated as a non-goal.

## Accepted decisions after peer review

| ID | Topic | Reviewed outcome | Rationale |
| --- | --- | --- | --- |
| A1 | Saved-layout object name | **Accepted: use `profile` as the canonical object name** | All reviewers accepted this normalization over `baseline` |
| A2 | Auto Restore ownership | **Accepted: Auto Restore belongs to Restore** | Clear majority and code evidence align on runtime recovery ownership |
| A3 | Runtime/menu vs settings ownership | **Accepted: menu owns runtime status and immediate recovery; settings owns persistent management/config** | Strong cross-review agreement |
| A4 | Profiles ownership | **Accepted: Profiles is the canonical management home for save/manage/apply/tune profile actions** | Even reviewers who differ on wording/IA agreed on Profiles as the management surface |
| A5 | Per-profile autoRestore baseline status | **Accepted: do not treat per-profile autoRestore as a supported baseline behavior** | Hidden model field exists, but reviewers agreed it is unresolved at best and not current product truth |
| A6 | Swap action semantics | **Accepted: swap is a manual override and does not edit saved profiles** | Cross-review agreement, matches current behavior |

## Rejected alternatives

| ID | Topic | Rejected option | Why rejected |
| --- | --- | --- | --- |
| R1 | Saved-layout object name | Keep `baseline` as the main object name | No reviewer defended it over `profile` |
| R2 | Auto-restore model | Pretend per-profile and app-level automation are both fully supported baseline behavior | Reviewers rejected that as inaccurate current-state documentation |

Why rejected:
- It blurs the core user problem.
- It turns secondary capabilities into false obligations.

| ID | Topic | Review split / evidence | Open question |
| --- | --- | --- | --- |
| U1 | Manual recovery CTA label | Split 2–2 between `Fix Now` and `Restore Now` | Keep current shipped label for now, or define `Restore Now` as phase-2 rename target? |
| U2 | Settings IA target | Split 2–2 between canonizing shipped 3-pane IA and restoring a 5-area target model | Is current 3-pane navigation the long-term product IA, or just an implementation waypoint? |
| U3 | Diagnostics / Shortcuts status | Some reviewers accept General nesting; others want first-class trust/utility surfaces | Should these remain nested under General or become top-level in a future IA? |
| U4 | Show Numbers / Identify naming | Broad agreement on visible `Show Numbers`, but disagreement on what should be canonical/internal | What final naming pair should phase 2 standardize on? |
| U5 | Apply Layout / Apply Profile wording | Current code says `Apply Layout`; some reviewers want the intent model made more explicit | Should phase 2 rename profile-specific restore to `Apply Profile`? |
| U6 | Swap naming | `Swap Positions`, `Swap side displays`, and older left/right language all remain in circulation | What final user-facing label is stable enough for canon? |
| U7 | Degraded-state Save Profile guidance | Multiple reviewers want an explicit warning | How prominently should the product warn against capturing a broken temporary layout as the new truth? |
| U8 | NoDisplays / RestoreFailed surfacing | Some reviewers want them promoted from generic manual-recovery buckets | Do these deserve first-class surfaced states in future UI/docs? |
| U9 | ManualLayoutOverride public wording | Reviewers agree the concept exists but not the final public label/CTA model | Does this state need a clearer user-facing title and/or explicit “keep current layout” action? |

Why rejected:
- They matter, but they support the core loop rather than define it.
- The simpler shipped 3-section model is easier to explain and use.

### Rejected: keep `Swap Positions` as a core product feature

Why rejected:
- It solves a narrower subset of desks.
- It overlaps with the main recovery story and should not compete with it in headline docs.

This packet is implementation-ready for **agreed** items only. Contested items remain intentionally unresolved and should not be silently implemented as if decided.


| Requirement | Result |
| --- | --- |
| Normalized feature catalog completed | Yes |
| State/action matrix completed | Yes |
| One chosen settings IA documented | Yes |
| Accepted / rejected / unresolved items recorded | Yes |
| PM + Designer + Engineer agreement explicitly required and represented | Yes |
| Phase 2 separated from phase 1 definitions | Yes |

Why rejected:
- These are app qualities and conveniences, not the product’s central promise.

### Rejected: leave non-goals implicit

Why rejected:
- Implicit non-goals invite scope creep and ambiguous PRD/SPEC language.

## Critic / verifier objections captured

- “If everything stays first-class, the product never explains what actually matters most.”
- “`Swap Positions` is useful, but it should not compete with the main recovery loop in the product story.”
- “A trust-centric utility should not force users to parse a bloated settings IA to understand the core behavior.”
- “Docs should not imply a broader display-management ambition than the code and safety model actually support.”

## Unresolved items worth keeping

These remain acceptable unresolved items because they are naming/copy issues, not core product-definition gaps:

1. Whether `Fix Now` should eventually be renamed to `Restore Now` or `Recover Now`
2. Whether `manual layout override` needs friendlier public wording

## Resolved by this pass

1. **Core problem:** now explicit
2. **Minimum required jobs:** now explicit
3. **Core vs supporting vs convenience features:** now explicit
4. **Non-goals:** now explicit
5. **Settings IA direction:** resolved in favor of shipped simplicity, not expanded navigation

## Recommendations to carry into the final packet

1. Rewrite PRD/SPEC intros around the narrow recovery problem first.
2. Split features into **core**, **supporting**, and **convenience** instead of listing everything together.
3. Remove any PRD/SPEC language that makes `Swap Positions`, updates, shortcuts, or language selection sound core to the product identity.
4. Keep the final unresolved list short; do not manufacture extra open questions once the keep/non-goal framing is clear.
