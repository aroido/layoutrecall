# LayoutRecall Feature Definition Decision Log

Lab: `feature-definition-20260402T002610Z`  
Updated: 2026-04-02

## Council lanes used for this definition sprint

- PM facilitator
- Analyst / feature-definition owner
- macOS UX / IA designer
- engineer / state-model reviewer
- critic / skeptical virtual user
- verifier / implementation-readiness reviewer

## Audit findings that forced this run

1. Product docs had drifted from the current shipped UI and behavior.
2. Settings IA was described as five panes in docs, but shipped as three top-level panes with nested advanced/support sections.
3. Per-profile auto-restore language remained in docs even though the code now normalizes behavior to a global app-level mode.
4. Runtime actions (`Fix Now`, `Apply Layout`, `Swap Positions`, `Identify Displays`) existed, but their canonical ownership was not written down in one place.

## Consensus gate

A definition is approved only when PM, Designer, and Engineer all agree.

| Decision | PM | Designer | Engineer | Result |
| --- | --- | --- | --- | --- |
| Use global automatic restore as the canonical baseline | Agree | Agree | Agree | **Approved** |
| Use 3 top-level settings panes with nested Shortcuts/Diagnostics | Agree | Agree | Agree | **Approved** |
| Keep `Fix Now` and `Apply Layout` as distinct actions with different intent | Agree | Agree | Agree | **Approved** |
| Keep `Swap Positions` as a constrained manual fallback, not a general restore engine | Agree | Agree | Agree | **Approved** |
| Separate implementation follow-up from definition approval | Agree | Agree | Agree | **Approved** |

## Accepted decisions

### 1. Automatic restore is app-level, not profile-level

**Accepted.**

Rationale:
- The current code already normalizes legacy profile flags to global behavior.
- A single runtime mode is easier to explain and safer to test.
- Reintroducing profile-scoped restore rules would be a net-new product feature.

### 2. Chosen settings IA: 3 top-level panes

**Accepted.**

Chosen structure:
- Restore
- Profiles
- General
  - Shortcuts
  - Diagnostics

Rationale:
- Matches the shipped sidebar behavior.
- Better suits a menu-bar utility with a small number of high-frequency tasks.
- Avoids a definition sprint turning into an unnecessary UI refactor.

### 3. `Fix Now` and `Apply Layout` remain separate concepts

**Accepted.**

Canonical wording:
- **Fix Now** = recover the current desk now using the best available runtime match.
- **Apply Layout** = run a specific saved profile from profile management.

Rationale:
- The intents are distinct even if both eventually execute restore commands.
- Keeping the names distinct reduces ambiguity between runtime recovery and profile administration.

### 4. Diagnostics has one canonical home

**Accepted.**

Canonical home:
- `General > Diagnostics`

Deep-links allowed from:
- Restore pane
- Menu utility actions

Rationale:
- Keeps runtime surfaces lightweight.
- Preserves a single support/history destination.

### 5. `Swap Positions` stays limited

**Accepted.**

Rationale:
- Current implementation is intentionally limited to supported 2- and 3-display desks.
- Expanding it into a general layout editor would change the product promise.

## Rejected alternatives

### Rejected: restore the old 5-pane settings model as the canonical definition

Why rejected:
- Conflicts with current shipped navigation.
- Adds UI churn without solving the main trust/clarity problem.

### Rejected: revive per-profile auto-restore toggles in this definition set

Why rejected:
- Current implementation intentionally does not behave this way.
- Would require fresh rule-precedence UX, persistence semantics, and tests.

### Rejected: rename everything to one generic “Restore Now” action immediately

Why rejected for this run:
- The shipped split between `Fix Now` and `Apply Layout` is purposeful.
- A naming rewrite would need user-copy validation and migration review.

### Rejected: start implementation during the definition sprint

Why rejected:
- The brief requires definition artifacts first.
- There was enough drift that implementation before alignment would be risky.

## Critic objections logged explicitly

- “If diagnostics, restore controls, and profile controls all compete in the same place, the menu becomes a junk drawer.”
- “A per-profile auto-restore promise in docs is misleading if the shipped app only supports a global mode.”
- “Five-pane documentation will create trust debt if the UI keeps showing only three.”
- “`Fix Now` must not appear when the system has no profile or no dependency, or the app looks confused.”

## Unresolved questions

### 1. Should `Fix Now` stay named `Fix Now` long-term?

Current call: keep it for this baseline.

Open question:
- Future user research may show that `Restore Now` or `Recover Now` is clearer, but that is not required to approve the feature model.

### 2. Should Diagnostics ever return to a top-level sidebar pane?

Current call: no.

Open question:
- If diagnostics volume grows substantially, revisit with evidence instead of silently drifting back to the older docs.

### 3. How should manual-layout-override be described to end users?

Current call: keep the behavior, but the public-facing label may need a friendlier phrase in a future copy pass.

## Implementation-readiness verdict

**Verifier verdict: ready for phase 2 planning, not for silent implementation shortcuts.**

What is now concrete enough to build from:
- canonical feature catalog
- canonical state/action matrix
- canonical menu/settings surface map
- explicit accepted/rejected/unresolved log

## Phase 2 follow-up (separate from this approval)

1. Update PRD/SPEC/README to reflect the chosen 3-pane settings IA and global auto-restore mode.
2. Review naming/copy consistency for `Fix Now`, `Apply Layout`, `Identify Displays`, and diagnostics hints.
3. Add or update tests/docs that assert the chosen information architecture and feature ownership rules.
