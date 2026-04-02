# LayoutRecall Product Specification

Status: Phase 1B simplified baseline  
Last updated: 2026-04-02

## 1. Exact user problem

A user with a repeatable multi-display desk already knows the layout they want back. After sleep, wake, or reconnect, macOS can return monitors in the wrong order or position. The product's job is to restore that one known layout safely and quickly.

## 2. Product definition

LayoutRecall is a menu bar recovery utility for saved monitor layouts.

It is intentionally narrower than a display-management suite. The app should help the user:
- save the desired layout once
- restore it automatically when the match is trustworthy
- restore it manually when trust is lower
- understand why the app did or did not act

## 3. Core user problem statement

> "My desk came back wrong. I want my saved layout back now, and I only want the app to do it automatically when it is clearly safe."

Everything in the product should support that job directly or be demoted.

## 4. Core product capabilities to keep

### 4.1 Saved profile
- Save the current layout as the known-good recovery profile
- Rename and delete profiles
- Tune confidence threshold per profile

### 4.2 Automatic restore
- Watch display events
- Match current displays against saved profiles
- Restore automatically only when threshold and dependency conditions are satisfied

### 4.3 Manual restore
- Provide one primary manual recovery action: **Restore Now**
- Provide profile-specific restore inside Profiles via **Apply Layout**

### 4.4 Trust and support
- Show current restore state
- Show dependency readiness
- Show confidence/match context
- Record diagnostics
- Provide `Show Numbers` as a support utility

## 5. Demoted or non-core capabilities

These may remain in the product, but they are not part of the main value proposition:

- `Swap Positions` — advanced/manual fallback utility
- keyboard shortcuts — convenience only
- launch at login — preference only
- updates — maintenance only
- language selection — preference only

These should not shape the primary IA or PRD story.

## 6. Removed from baseline truth

The following should not be described as baseline supported behavior:

- per-profile auto-restore as an active supported product model
- five equal-weight settings panes as the current implemented IA
- broad complex-layout automation beyond the saved-layout recovery job

## 7. Information architecture

## 7.1 Menu bar

Primary runtime surface.

Responsibilities:
- state summary
- primary manual recovery CTA
- Auto Restore control
- minimal utilities

The menu should prioritize:
1. current state
2. next best action
3. reference profile context
4. supporting evidence only when needed

## 7.2 Settings

Canonical settings structure:
- **Restore**
- **Profiles**
- **General**

### Restore
- status summary
- Auto Restore
- dependency state
- recommended action
- restore comparison preview

### Profiles
- save profile
- manage profiles
- apply layout
- show numbers
- threshold tuning

### General
- diagnostics
- launch at login
- updates
- language
- shortcuts
- advanced preferences

## 8. Canonical actions

### Core actions
- **Save Profile**
- **Restore Now**
- **Apply Layout**
- **Auto Restore**

### Support utilities
- **Show Numbers**
- **Open Diagnostics**
- **Install displayplacer**

### Advanced/manual fallback
- **Swap Positions**

## 9. Safety model

The product is intentionally conservative.

### Rules
- no automatic restore with no displays
- no automatic restore with no saved profiles
- no automatic restore below threshold
- no automatic restore when dependency is missing
- no automatic restore when Auto Restore is off

### Principle

Prefer safe false negatives over unsafe false positives.

If confidence is weak, the product should stop, explain why, and offer **Restore Now** instead of guessing.

## 10. Non-goals

LayoutRecall should not optimize for:
- every possible display arrangement edge case
- broad layout manipulation features
- being a monitor management control panel
- replacing `displayplacer`
- expanding settings/navigation for low-frequency utilities

## 11. Current contradictions resolved for docs

1. **3-pane vs 5-pane**: current and canonical product IA is 3-pane for simplicity.
2. **Per-profile auto-restore**: not baseline behavior.
3. **Core vs utility actions**: `Restore Now` is core; `Swap Positions` is utility.
4. **Primary product story**: saved-layout recovery, not display management.

## 12. Naming status

- User-facing product naming is standardized on **Restore Now**.
- Internal compatibility identifiers may continue to use `fixNow` where needed for persistence or test continuity.

## 13. Verification baseline

Local completion uses:

```bash
./scripts/run-ai-verify --mode full
```

## 14. Acceptance criteria for follow-up work

Any follow-up implementation should:
- preserve the saved-layout recovery core
- reduce overlap rather than add new product pillars
- keep docs aligned with shipped behavior
- keep `./scripts/run-ai-verify --mode full` passing
- make the product simpler or clearer, not merely larger
