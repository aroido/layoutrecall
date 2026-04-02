# LayoutRecall Surface Map

Lab: `feature-definition-20260402T002610Z`
Status: phase-1B minimal-product refinement
Updated: 2026-04-02

## Minimal-product framing

LayoutRecall's core job is narrow:

> **When macOS scrambles a previously known desk layout, help the user get back to the saved arrangement safely.**

Everything in the surface map should be judged against that job.

### Keep prominent only if it directly supports the core job

Prominent surfaces should be limited to:
1. understanding current restore readiness
2. saving a known-good layout
3. restoring the saved layout safely
4. resolving the most common confidence/dependency blockers

Anything else should be demoted, hidden behind one extra step, or treated as a non-goal for the core product story.

## Decision: choose 3-pane IA as the canonical minimal product model

### Chosen top-level settings panes

1. **Restore**
2. **Profiles**
3. **General**
   - Shortcuts
   - Diagnostics

### Why 3 panes wins under a minimal-product lens

- **Restore** and **Profiles** are the only two settings destinations directly tied to the app's core recovery job.
- **General** cleanly absorbs maintenance and app-level preferences without asking users to treat every support/admin area as a first-class workflow.
- A menu bar utility benefits more from fewer primary destinations than from strict conceptual purity.
- The current implementation already supports this structure, so the docs can become sharper without creating a second, more expansive target IA.

### Why 5 panes loses under a minimal-product lens

A five-pane model over-promotes secondary surfaces:
- **Diagnostics** is important, but it is evidence/support, not the main workflow.
- **Shortcuts** is useful, but optional.
- Making both top-level panes implies a broader product than the app actually needs to be.

**Decision:** treat the old 5-area documentation model as product-definition drift, not as a future target to preserve.

## Prominence rules

### Primary surfaces

#### Menu bar
The menu should primarily answer:
1. What state is the app in?
2. Can it safely restore right now?
3. What is the single best next action?

#### Restore pane
The Restore pane is the canonical surface for runtime trust and recovery.

#### Profiles pane
The Profiles pane is the canonical surface for creating and managing saved layouts.

### Secondary / demoted surfaces

#### Diagnostics
- Keep accessible from blocked/error states.
- Keep as a section under General.
- Do **not** make it a top-level pane in the minimal product.
- Treat it as a support/trust artifact, not a daily workflow.

#### Shortcuts
- Keep under General.
- Do **not** elevate to a top-level pane.
- It is optional acceleration, not core recovery behavior.

#### Updates / language / launch at login
- Keep under General.
- These are operational preferences, not recovery workflow.

## Canonical menu model

### Healthy state
Healthy state should be quiet.

Keep visible:
- status summary
- optional profile context
- settings access

Demote or remove from immediate prominence:
- multiple secondary controls at once
- heavy dashboard-like cards
- maintenance/admin affordances

### Degraded state
Degraded states may expand, but only enough to support recovery.

Keep prominent:
- blocker explanation
- one primary next action
- one or two relevant secondary actions at most

Demote:
- broad utility menus
- profile-management detail
- support/admin content unless directly relevant

## Feature-to-surface ownership under minimal scope

| Feature / action | Prominence | Canonical home | Minimal-product ruling |
| --- | --- | --- | --- |
| Status / readiness | Primary | Menu + Restore | Keep primary |
| Save Profile | Primary in Profiles, secondary in Menu | Profiles | Keep |
| Auto Restore | Primary policy control | Restore | Keep |
| Restore Now / Fix Now | Primary runtime recovery | Menu + Restore | Keep, but one canonical label should win later |
| Apply specific profile | Secondary | Profiles | Keep, but do not over-promote in runtime surfaces |
| Show Numbers | Secondary utility | Profiles | Keep, but demote from top-level runtime prominence |
| Swap display positions | Advanced/manual fallback | Restore | Keep as demoted fallback, not a co-equal primary action |
| Diagnostics | Support / trust evidence | General > Diagnostics | Keep demoted but shortcut from blocked states |
| Shortcuts | Optional acceleration | General > Shortcuts | Keep demoted |
| Updates / language / launch at login | Operational preferences | General | Keep demoted |

## Accept / reject decisions

### Accepted

1. **Accept 3-pane settings navigation as canonical.**
   - Rationale: it is the smallest structure that fully supports the product's real job.

2. **Accept Restore as the primary runtime/trust pane.**
   - Rationale: runtime safety, dependency readiness, and immediate recovery belong together.

3. **Accept Profiles as the primary saved-layout management pane.**
   - Rationale: saving, inspecting, and applying a specific profile is a distinct but still core job.

4. **Accept Diagnostics as demoted but directly reachable from blocked states.**
   - Rationale: evidence matters most when something is blocked or unclear.

5. **Accept Shortcuts as demoted under General.**
   - Rationale: useful, but not required to understand or complete the main workflow.

### Rejected

1. **Reject 5-pane IA as canonical.**
   - Rationale: it optimizes for feature completeness and conceptual symmetry rather than product sharpness.

2. **Reject first-class prominence for Diagnostics.**
   - Rationale: diagnostics is important evidence, but not a daily primary workflow.

3. **Reject first-class prominence for Shortcuts.**
   - Rationale: shortcuts should not compete with restore/profile surfaces for primary navigation attention.

4. **Reject equal prominence for Swap Positions and other expansion-oriented controls.**
   - Rationale: they are fallback tools, not the main product promise.

## Simplification guidance for final docs

The final PRD/SPEC language should emphasize:
- save a known-good layout
- restore it safely when the desk drifts
- stay manual when confidence is weak
- expose evidence only as much as needed to maintain trust

The final PRD/SPEC language should de-emphasize:
- feature completeness
- support/admin surfaces as primary destinations
- every advanced/manual fallback as if it were part of the main promise

## Remaining low-priority unresolved item

Only one unresolved item should remain if needed:

- **Final runtime CTA copy:** whether the user-facing label settles on `Fix Now` or `Restore Now`.

This is copy debt, not IA debt.
