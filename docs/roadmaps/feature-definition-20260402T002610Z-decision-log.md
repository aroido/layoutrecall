# LayoutRecall Definition Decision Log

Lab: `feature-definition-20260402T002610Z`
Status: definition-phase artifact
Updated: 2026-04-02

## Decision protocol used

This log follows the run brief:

- PM coordinates and records the decision.
- Designer and Engineer must both agree before a definition is accepted.
- Critic objections are logged explicitly.
- Unresolved items remain open and are not silently decided.

## Audit summary

The audit surfaced three primary definition gaps:

1. **Terminology drift** — “Fix Now,” “Apply Layout,” “saved layout,” and “profile” are close but not cleanly separated.
2. **IA drift** — docs promise five settings panes; current implementation exposes three primary panes and hides two conceptual panes under General.
3. **Recovery ambiguity** — manual override / low-confidence states do not clearly express the user’s choice set.

## Decisions

### D1. Adopt a normalized feature vocabulary

**Decision:** Accepted

**Accepted definition**
- Use **Profile** as the canonical saved-layout object.
- Use **Restore Now** for runtime matched recovery.
- Use **Apply Profile** for restoring a specifically chosen saved profile.
- Use **Review Before Restore** for confirm-first automatic restore behavior.
- Use **Restore Tool** as the user-facing umbrella term for the `displayplacer` dependency.

**Why**
- PM: improves docs and release communication.
- Designer: reduces hidden semantic differences between similar actions.
- Engineer: maps cleanly onto current code paths without changing the underlying runtime model.

**Critic objection logged**
- “If you keep `Fix Now`, users may treat it as a generic repair button instead of a concrete restore action.”

**Disposition:** objection accepted; phase 2 should consider copy alignment.

---

### D2. Keep restore actions split into runtime restore vs specific-profile restore

**Decision:** Accepted

**Options considered**
1. Merge both flows under one generic “Restore” concept.
2. Keep two actions: runtime best-match restore and explicit profile restore.

**Chosen option:** keep two actions.

**Why**
- Designer: the user intent differs materially between “restore what LayoutRecall thinks matches” and “apply this exact profile.”
- Engineer: the current runtime already uses different code paths (`performManualRestore` vs `performRestoreProfile`).
- PM: separate terminology helps docs stay trustworthy.

**Rejected alternative**
- One generic “Restore” verb everywhere.
- Rejected because it collapses two different decisions into one label.

---

### D3. Choose explicit five-pane settings IA as the canonical model

**Decision:** Accepted

**Options considered**
1. Keep the current 3-pane sidebar with nested sections.
2. Adopt explicit 5-pane navigation: Restore, Profiles, Shortcuts, Diagnostics, General.

**Chosen option:** explicit 5-pane navigation.

**Why**
- PM: it matches the current product narrative already present in docs.
- Designer: Diagnostics and Shortcuts are real destinations, not hidden detail sections.
- Engineer: low-to-moderate follow-up cost because the pane enum already exists.

**Critic objection logged**
- “Five panes could be overkill if two of them are rarely opened.”

**Disposition:** objection noted but rejected; discoverability and terminology consistency outweigh the sidebar cost.

**Phase 2 note**
- This is a definition decision only; implementation follow-up remains separate.

---

### D4. Treat Diagnostics as a primary trust surface

**Decision:** Accepted

**Accepted definition**
- Diagnostics gets a canonical home and should not be described merely as passive history.
- Restore surfaces may link into Diagnostics, but full evidence browsing lives there.

**Why**
- PM: trust is central to the product promise.
- Designer: users should not hunt through General to confirm what happened.
- Engineer: the data model already supports latest entry, history, snapshot, and support files.

**Rejected alternative**
- Keep diagnostics as a support-only subsection.
- Rejected because it conflicts with runtime trust needs.

---

### D5. Manual override and low-confidence states need explicit decision language

**Decision:** Accepted

**Accepted definition**
Future recovery language should distinguish among:
- Restore saved layout
- Keep current layout
- Save current layout as profile
- Swap side displays

**Why**
- PM: makes guidance legible without expanding feature scope.
- Designer: current runtime states feel too similar and under-specified.
- Engineer: this can mostly be implemented in presentation/copy layers plus a small suppression choice if kept.

**Rejected alternative**
- Keep the current generic action cluster.
- Rejected because the critic lane flagged this as a trust gap.

---

## Rejected alternatives

| Alternative | Rejected because |
| --- | --- |
| Treat LayoutRecall as a full display-management suite | Violates product boundary and would expand scope beyond trustful restore. |
| Collapse Profiles into Restore | Blurs management vs runtime recovery responsibilities. |
| Keep Shortcuts and Diagnostics permanently nested under General | Preserves the exact IA drift this sprint was created to resolve. |
| Replace `displayplacer` in this definition sprint | Not part of current product boundary; would turn the sprint into architecture expansion. |

## Unresolved questions

1. **Should the user-facing label actually change from `Fix Now` to `Restore Now` in phase 2?**
   - Consensus: likely yes, but final copy change still needs localization/product validation.
2. **Does manual override need a dedicated persisted “Keep current layout” control or only clearer language?**
   - Consensus: the intent needs to exist; persistence semantics need a separate implementation decision.
3. **Should healthy-state menu keep any direct restore button at all?**
   - Consensus: maybe only when it is genuinely useful; final density decision remains open.
4. **How much restore-proof summary should appear in Restore before the user opens Diagnostics?**
   - Consensus: at least one summary row, but exact density is unresolved.

## Phase 2 boundary

No implementation is approved by this document alone. If phase 2 starts, it should be scoped separately and explicitly reference these accepted definitions.
