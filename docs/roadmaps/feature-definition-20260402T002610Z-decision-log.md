# LayoutRecall Simplicity Decision Log

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1B simplification pass)

## Phase 1B framing

This pass optimizes for product simplicity and usability, not feature completeness.
A feature is kept only if it directly serves the core user problem:

> Restore one known display layout safely and quickly after macOS scrambles the desk.

## Exact user problem statement

The user already knows the layout they want. They do not need a toolbox for many display experiments. They need a trustworthy way to get one saved layout back.

## Keep / merge / remove-or-demote decisions

| ID | Topic | Decision | Rationale |
| --- | --- | --- | --- |
| K1 | `profile` terminology | Keep | Clearest single object name for the saved layout |
| K2 | Auto Restore | Keep | Core value when trust is high |
| K3 | Restore Now | Keep as the single primary manual recovery CTA | Simpler than competing recovery verbs |
| K4 | Apply Layout | Keep, but only as the profile-specific restore action in Profiles | Useful, but not a separate product pillar |
| K5 | Show Numbers | Keep as a support utility | Helps confirm mapping without expanding product scope |
| K6 | 3-pane settings IA | Keep as canonical product IA | Simpler, matches shipped implementation, avoids inflating support/admin surfaces |
| M1 | Recovery story | Merge around one core flow: save profile -> auto restore when safe -> Restore Now when not safe | Reduces duplicate recovery concepts |
| M2 | Support surfaces | Merge diagnostics, shortcuts, updates, language, login into General | Keeps low-frequency functions out of the primary product story |
| D1 | Swap Positions | Demote to advanced/manual fallback utility | Useful edge aid, not part of the core promise |
| D2 | Per-profile autoRestore | Remove from baseline truth | Hidden/inconsistent behavior should not shape the product definition |
| D3 | 5-pane IA as active target | Remove from current product truth | Adds complexity and keeps docs drift alive |

## Explicit non-goals

- broad display-management feature expansion
- advanced layout experimentation workflows
- first-class support/admin surfaces competing with recovery surfaces
- broad complex-layout automation promises
- preserving existing behavior only because it already exists in code

## Contradictions resolved in this pass

| Issue | Resolution |
| --- | --- |
| 5-pane docs vs 3-pane implementation | 3-pane is the canonical product IA |
| `Fix Now` vs `Restore Now` drift | Product-level canonical action is `Restore Now`; legacy code/test naming can be cleaned later |
| per-profile autoRestore field vs actual behavior | Do not document per-profile autoRestore as supported baseline behavior |
| core feature vs utility sprawl | Utilities are retained only when they support the saved-layout recovery job |
| `Swap Positions` prominence | Demoted from core feature to advanced/manual utility |

## Remaining justified unresolved item

| ID | Topic | Why still open |
| --- | --- | --- |
| U1 | Cleanup scope for legacy `Fix Now` references in code/tests | Naming cleanup is implementation follow-up, not a blocking product-definition issue |

## Final editorial rule for follow-up work

If a future change does not make the app better at safely restoring one known layout, it should be removed, merged, hidden, or explicitly treated as a non-goal.
