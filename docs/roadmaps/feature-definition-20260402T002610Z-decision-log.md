# LayoutRecall Feature Definition Decision Log

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: proposed decision set; implementation remains blocked until PM + Designer + Engineer approve

## Audit-backed findings

Reviewed code and docs show three important drifts:

1. docs still describe a five-pane settings model, while the app ships a three-pane primary navigation model
2. feature naming around restore actions is inconsistent (`Fix Now`, `Apply Layout`, `Restore Now`)
3. `ProfileSettings.autoRestore` exists in the model but is not a meaningful product capability today

## Options considered

### Option A — keep documenting the product as five-pane settings

- **Pros:** matches older docs; no wording churn in README/PRD/SPEC today
- **Cons:** does not match shipped navigation; keeps implementation and product definition out of sync
- **Decision:** **Rejected**

### Option B — normalize to three top-level settings panes with nested support sections

- **Pros:** matches current code; simplifies navigation story; keeps utility surfaces secondary
- **Cons:** requires doc updates elsewhere; some team members may still think in five-pane terms
- **Decision:** **Accepted**

### Option C — treat `Fix Now` and `Apply Layout` as the same feature everywhere

- **Pros:** fewer terms to manage
- **Cons:** hides an important distinction between restoring the currently matched layout and restoring a specific chosen profile
- **Decision:** **Rejected**

### Option D — define two restore actions: runtime restore vs profile-specific apply

- **Pros:** cleaner mental model; maps well to menu vs profile-management contexts
- **Cons:** requires copy discipline in future implementation
- **Decision:** **Accepted**

### Option E — expose per-profile auto-restore as a first-class feature because the model exists

- **Pros:** sounds powerful; aligns with latent data field
- **Cons:** current code normalizes it away and restore decisions only respect app-level automatic restore
- **Decision:** **Rejected for phase 1**

### Option F — keep `Shortcuts` and `Diagnostics` as top-level panes

- **Pros:** easier direct navigation for heavy users
- **Cons:** over-weights support tools in a compact utility app; does not match current sidebar design
- **Decision:** **Rejected**

## Accepted decisions

1. **Canonical settings IA is 3-pane, not 5-pane**
   - Top-level: `Restore`, `Profiles`, `General`
   - Nested support sections: `Shortcuts`, `Diagnostics`

2. **Canonical feature terms are normalized**
   - `Restore matched layout now` for runtime/manual confirmation restore
   - `Apply saved profile` for profile-specific restore
   - `Save current layout as profile` for all save/baseline actions
   - `Identify displays` for overlay/numbering behavior
   - `Swap side displays` for the narrow fallback action

3. **The product remains menu-bar-first and trust-first**
   - Menu owns status and fast recovery
   - Settings owns explanation, profile administration, and configuration

4. **Per-profile auto-restore is not part of the agreed definition set yet**
   - Treat it as unresolved model debt or future scope, not a promised feature

5. **Phase 1 remains definition-only**
   - No implementation should start until PM, Designer, and Engineer approve the chosen model

## Rejected alternatives

- returning to a five-pane settings sidebar as the canonical definition
- collapsing all restore actions into one undifferentiated verb
- treating model-only fields as shipped features
- broadening LayoutRecall into a full display-management suite during this definition sprint

## Unresolved questions

1. **Manual layout override CTA design**
   - Current code gives `.manualLayoutOverride` no primary action.
   - Decision needed: should the chosen CTA set be `Restore saved layout`, `Keep current layout`, and `Save as new profile`?

2. **Ask Before Restore placement**
   - Current code places the toggle in `General > Advanced`.
   - Decision needed: should the agreed IA move it into `Restore` because it directly affects restore trust?

3. **Swap-side-displays scope wording**
   - Logic allows 2 or 3 displays, but copy still implies “requires two.”
   - Decision needed: narrow behavior to two displays, or broaden copy and tests to match the current code?

4. **Healthy-state menu density**
   - Current menu still behaves like a compact dashboard.
   - Decision needed: should the healthy state collapse further in phase 2?

5. **Reference profile semantics**
   - The app exposes a “reference profile” based on latest decision/match context.
   - Decision needed: should product language keep “reference profile,” or rename it to “matched baseline” everywhere?

## Consensus checkpoints

| Role | Required position before implementation | Current documentation status |
| --- | --- | --- |
| PM | Accept scope boundaries and terminology | pending explicit signoff |
| Designer | Accept chosen IA and surface ownership | pending explicit signoff |
| Engineer | Accept state model and feasibility boundaries | pending explicit signoff |
| Critic / virtual user | objections logged, not silently dropped | logged via unresolved questions and rejected alternatives |

## Implementation gate

Implementation is **not approved** by this document alone.

Phase 2 may begin only after:

1. PM accepts the chosen catalog and scope boundaries
2. Designer accepts the 3-pane settings IA and menu/settings ownership split
3. Engineer accepts the state/action model, especially degraded-state distinctions and removal of per-profile auto-restore from the promised feature set

## Recommended phase 2 follow-up once approved

1. align README/PRD/SPEC terminology and settings IA wording
2. resolve manual-layout-override action design
3. either remove `ProfileSettings.autoRestore` or implement it as a real feature
4. tighten healthy-state menu density and degraded-state CTA language
