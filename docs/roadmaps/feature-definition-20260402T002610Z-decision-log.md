# LayoutRecall Feature Definition Decision Log

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1 only)

## Council composition used for this definition sprint

- **PM facilitator:** scope framing, artifact structure, convergence gate
- **Analyst:** feature normalization and terminology cleanup
- **Designer:** menu/settings IA and user-flow clarity
- **Engineer:** implementation-feasibility and state-model integrity
- **Critic / skeptical user:** ambiguity, trust, and discoverability objections
- **Verifier:** completeness and implementation-readiness check

## Audit summary

The product is already materially implemented, but the **definition layer has drifted**:

- docs still teach a five-pane settings model while code currently exposes three primary sections
- user-facing action names are not yet normalized across menu, settings, docs, and internal state language
- the state model knows more than the UI surfaces explicitly communicate (for example `restoreFailed` and `noDisplays` are collapsed into generic manual recovery)

## Decision ledger

### Accepted decisions

#### 1. Normalize the recovery action vocabulary

**Accepted canonical terms**
- Save Current Layout
- Automatic Restore
- Ask Before Restore
- Fix Now
- Apply Layout
- Show Numbers
- Swap Positions
- Install displayplacer

**Rationale**
- Keeps user-facing verbs short and concrete.
- Preserves familiarity with the current menu labels where they are already good.
- Separates “best inferred recovery” (`Fix Now`) from “chosen specific profile restore” (`Apply Layout`).

**Consensus**
- PM: Accept
- Designer: Accept
- Engineer: Accept
- Critic: Accept, with request to explain the `Fix Now` vs `Apply Layout` distinction explicitly in docs and UI copy

#### 2. Adopt an explicit 5-section settings IA as the canonical model

**Accepted IA**
- Restore
- Profiles
- Shortcuts
- Diagnostics
- General

**Rationale**
- Diagnostics and Shortcuts are too important to bury under General.
- This aligns docs and future implementation around one clear map.
- It reduces the “General as junk drawer” risk.

**Consensus**
- PM: Accept
- Designer: Accept
- Engineer: Accept
- Critic: Accept, provided diagnostics remains reachable contextually from Restore too

#### 3. Keep the menu as the runtime trust + recovery surface

**Accepted scope for menu**
- status/evidence
- one primary next action
- fast runtime actions
- fast links to deeper settings/diagnostics

**Rationale**
- The menu is strongest when it answers “what happened?” and “what should I do next?” quickly.
- Deep management and support workflows belong in settings.

**Consensus**
- PM: Accept
- Designer: Accept
- Engineer: Accept
- Critic: Accept, with warning not to hide Show Numbers or Apply Layout too deeply

#### 4. Preserve the conservative safety model

**Accepted rule**
- Prefer safe false negatives over unsafe false positives.

**Rationale**
- This rule is already embedded in the implemented restore logic and should remain the governing principle.
- It keeps the product differentiated as trustworthy rather than merely aggressive.

**Consensus**
- PM: Accept
- Designer: Accept
- Engineer: Accept
- Critic: Accept

#### 5. Treat the current work as phase 1 definition only

**Accepted rule**
- No UI/code restructuring is part of this approval artifact set.
- Implementation proposals must be separated clearly as phase 2 follow-up.

**Rationale**
- The brief explicitly called for definition before implementation.
- This keeps the council from silently sliding into ad hoc redesign work.

**Consensus**
- PM: Accept
- Designer: Accept
- Engineer: Accept
- Critic: Accept

### Rejected alternatives

#### Rejected: let PM freeze the feature model unilaterally

**Why rejected**
- The brief explicitly forbids PM-only finalization.
- The current drift exists partly because definitions were not kept cross-functionally aligned.

#### Rejected: keep the current 3-section settings IA as the official long-term model

**Why rejected**
- It hides Diagnostics and Shortcuts too deeply for a trust-centric utility.
- It perpetuates drift between docs and implementation.

#### Rejected: collapse `Fix Now` and `Apply Layout` into a single restore label everywhere

**Why rejected**
- They represent two different user intents.
- Removing the distinction would make manual recovery less understandable, not more.

#### Rejected: treat Diagnostics as a purely support-only internal surface

**Why rejected**
- Diagnostics is part of the trust story, not just support tooling.
- The product promise explicitly depends on visible evidence.

## Unresolved questions

### 1. Should `Restore Failed` become a first-class top-level menu state in phase 2?

- **Current situation:** internal decision context exists, but UI collapses it into generic manual recovery.
- **Open trade-off:** more explicit trust messaging vs. added state complexity.

### 2. Should `No Displays` get a distinct user-facing empty-hardware state?

- **Current situation:** internal context exists, but UI falls back to generic manual recovery semantics.
- **Open trade-off:** better root-cause clarity vs. more state variants in menu copy.

### 3. How visible should Show Numbers be in the menu once terminology is normalized?

- **Current situation:** it may appear inside More Actions or in profile management.
- **Open trade-off:** easier discoverability vs. menu crowding.

### 4. Should Ask Before Restore remain in Restore only, or also appear as a trust summary in the menu?

- **Current situation:** policy lives in settings with runtime state reflected indirectly.
- **Open trade-off:** clearer trust posture vs. more menu density.

## Critic objections logged explicitly

- “Manual recovery is too much of a catch-all. If the app knows a restore failed, say that.”
- “If Diagnostics is core to trust, don’t make me go hunting under General.”
- “`Fix Now` and `Apply Layout` are both restores; if you keep both, their difference must be explained.”
- “The docs should not teach a different settings map from the one the product team intends to ship.”

## Verifier checklist

### Required artifacts completed

- Feature catalog: **completed**
- State/action matrix: **completed**
- Surface map: **completed**
- Decision log: **completed**

### Implementation readiness assessment

Ready for phase 2 planning once the team treats the following as approved inputs:

1. canonical feature names
2. chosen 5-section settings IA
3. canonical feature-home mapping
4. normalized runtime-state vocabulary

## Phase 2 follow-up outline (separate from this definition approval)

1. Update menu/settings/docs copy to use the accepted terminology consistently.
2. Refactor settings navigation from current 3-section structure to the chosen 5-section IA.
3. Promote `Restore Failed` and possibly `No Displays` into clearer surfaced states if design review confirms the added complexity is worthwhile.
4. Re-run full verification after implementation work begins.


## Phase 1B spec-hardening resolutions (worker-5)

Simplicity-first review outcome for phase 1B:

### Resolved outcomes pushed from this lane

1. **Manual recovery CTA**
   - Resolve to **`Fix Now` for the current spec baseline**.
   - Reason: it is the shipped/menu/tested label today, it is shorter in the menu, and introducing `Restore Now` while `Apply Layout` already exists adds rename debt without solving a user problem in phase 1.

2. **Settings IA target**
   - Resolve to **3 primary panes in the baseline spec: Restore / Profiles / General**.
   - Reason: phase 1B explicitly optimizes for product simplicity, not feature completeness. A 5-pane target bakes in more surface area than the current app needs and turns support/admin areas into peers of the core recovery flow.

3. **Diagnostics and Shortcuts status**
   - Resolve to **supporting sections under General, not first-class primary destinations**.
   - Reason: they matter, but they do not define the core product promise. The core promise is “recover a known monitor layout safely.” Trust support can remain one click away and context-linked from degraded states.

4. **Per-profile auto-restore field**
   - Resolve to **non-goal / dead compatibility field for the current spec**.
   - Reason: the shipped behavior is app-level Auto Restore. Anything else creates inaccurate product language and future implementation ambiguity.

5. **Show Numbers naming**
   - Resolve to **`Show Numbers` as the user-facing command**.
   - Reason: it is concrete, fast to understand, and better suited to the menu than the more implementation-flavored “Identify Displays.”

6. **Swap naming and scope**
   - Resolve to **`Swap Positions` as a secondary/manual utility action**, not a core feature pillar.
   - Reason: it supports the core problem only for simpler desk setups and should stay clearly subordinate to saved-profile recovery.

7. **Degraded-state Save behavior**
   - Resolve to **keep Save available, but document it as an expert escape hatch rather than the recommended default in degraded states**.
   - Reason: it is useful when the current layout is intentionally correct, but the spec should warn against capturing a broken temporary layout as the new truth.

8. **NoDisplays / RestoreFailed surfacing**
   - Resolve to **keep them as explanatory sub-states for now, not first-class IA drivers**.
   - Reason: the spec should describe them, but promoting every edge condition to a top-level state would reduce clarity and overcomplicate phase 1.

### Net hardening recommendation sent to editor

The final packet should minimize unresolved items by:
- choosing the shipped/simple label set unless there is a strong usability failure,
- choosing the shipped/simple IA unless complexity clearly pays for itself,
- treating duplicate or overlapping actions as debt to demote or explain,
- and explicitly marking speculative expansion features as non-goals rather than open invitations.
