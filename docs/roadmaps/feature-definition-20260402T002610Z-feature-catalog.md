# LayoutRecall Feature Catalog

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1B simplification pass)

## Core user problem

LayoutRecall exists to solve one narrow macOS desk problem:

> After sleep, wake, dock reconnect, or identical-monitor reshuffling, macOS brings back the **wrong physical display arrangement**, and the user wants their **previously saved known-good layout restored safely** without having to rebuild it manually every time.

This is **not** a general display-management suite. It is a trust-first recovery utility for people who already know the layout they want back.

## Smallest required user jobs

If LayoutRecall is reduced to the minimum useful product, it must still let the user do these jobs:

1. **Save one known-good layout** so the app has a baseline to recover.
2. **Notice when the current display arrangement drifted** enough that recovery may be needed.
3. **Restore the saved layout safely**:
   - automatically when confidence is high, or
   - with one clear manual recovery action when confidence is not high enough.
4. **Explain why restore did or did not happen** so the user can trust the behavior.

Anything that does not directly support one of those jobs should be demoted to a supporting surface or made an explicit non-goal.

## Simplicity filter used in this pass

1. Keep only features that directly support the core desk-recovery problem.
2. Treat duplicate recovery actions as debt unless their user intent is meaningfully different.
3. Keep runtime surfaces focused on **status, trust, and next action**.
4. Demote support, convenience, and platform-management features below core product definition.

## Keep / demote / non-goal framing

### Keep as core product features

| Feature | Why it stays core | Canonical home |
| --- | --- | --- |
| Save Current Layout | The product is useless without creating a baseline. | Both |
| Automatic Restore | This is the core “recover it for me when safe” value proposition. | Restore policy |
| Fix Now | The minimum manual fallback when auto-restore does not run. | Menu primary runtime action |
| Restore Status & Evidence | Trust depends on knowing what the app detected and why it acted or did not act. | Both |
| Install displayplacer | Real restore execution depends on it; dependency readiness is part of the core experience. | Restore / blocked-state flow |

### Keep, but demote to supporting features

| Feature | Why it is supporting, not core | Canonical home |
| --- | --- | --- |
| Ask Before Restore | Important trust control, but layered on top of the core restore loop. | Settings > General > Advanced |
| Apply Layout | Useful for explicit profile choice, but secondary to the main “recover the current desk” flow. | Settings > Profiles |
| Show Numbers | Supports trust and mapping, but not needed on every recovery. | Settings > Profiles, optional menu utility |
| Profile Management | Needed after the first save, but supporting rather than headline product value. | Settings > Profiles |
| Confidence Threshold Tuning | Important for advanced users; should not dominate the main spec. | Settings > Profiles |
| Diagnostics History | Important evidence/support surface, but should not compete with the runtime recovery flow. | Settings > General > Diagnostics |

### Candidate features to demote hard or treat as convenience only

| Feature | Recommendation | Rationale |
| --- | --- | --- |
| Swap Positions | Demote to constrained fallback utility, not a headline feature. | Helps some desks, but it is not the core promise and overlaps with restore/apply flows. |
| Keyboard Shortcuts | Keep as convenience only. | Speeds usage, but not part of the essential product definition. |
| Launch at Login | Keep as convenience/platform behavior. | Valuable for always-on use, but not central to feature definition. |
| Update Management | Keep as app-maintenance surface, not product-defining capability. | Necessary operationally, but unrelated to the core user problem. |
| Language Selection | Keep as app preference only. | Important for usability/accessibility, but not part of the desk-recovery concept. |

### Explicit non-goals

These should be described clearly as non-goals in PRD/SPEC language:

- Full display-management suite behavior
- Arbitrary layout editing / general monitor choreography
- Broad automatic heuristics for complex 4+ display setups
- Cloud sync or cross-machine profile sync
- Per-app window placement
- Rule engine for choosing different profiles by many contexts
- Replacing `displayplacer` with a native restore engine in this phase

## Canonical terminology map after pruning

| Variants seen | Chosen term | Keep / demote note |
| --- | --- | --- |
| Save, Save Current Layout, save baseline | **Save Current Layout** | Keep |
| automatic restore | **Automatic Restore** | Keep |
| Fix Now, manual restore, manual recovery | **Fix Now** | Keep |
| Apply Layout, restore profile | **Apply Layout** | Demote to profile-management action |
| Show Numbers, identify displays | **Show Numbers** | Demote to support utility |
| swap left/right, Swap Positions | **Swap Positions** | Demote hard; utility only |
| install dependency, install displayplacer | **Install displayplacer** | Keep because restore depends on it |

## Strict feature catalog

| Feature | One-line definition | User goal | Preconditions | Success result | Keep class | Canonical home |
| --- | --- | --- | --- | --- | --- | --- |
| Save Current Layout | Capture the current arrangement as a reusable baseline profile. | Save the desk the user wants back. | Display snapshot is readable. | Profile is stored and available for future recovery. | **Core** | Both |
| Automatic Restore | Recover the saved layout automatically when the live display set is a strong match. | Avoid manual repair when the app is confident. | Profiles exist, dependency available, auto-restore on, confidence high. | Restore executes and verifies. | **Core** | Restore policy |
| Fix Now | Recover immediately using the best current match when the user wants manual control. | Get the desk back now. | Dependency available and a valid recovery path exists. | Restore executes and verifies. | **Core** | Menu |
| Restore Status & Evidence | Show current state, confidence, dependency, and reason for acting or not acting. | Decide whether to trust the app and what to do next. | Runtime state evaluated. | User sees clear next-step guidance. | **Core** | Both |
| Install displayplacer | Unblock restore execution when the required dependency is missing. | Make restore actually work. | Install flow available. | Dependency becomes available or failure is explained. | **Core** | Both |
| Ask Before Restore | Require user confirmation before an otherwise-safe automatic restore. | Add a trust gate without disabling recovery. | Profiles exist and automatic restore is enabled. | Recovery is held for confirmation instead of auto-executing. | Supporting | Settings |
| Apply Layout | Run one specific saved profile manually. | Choose a specific baseline instead of the inferred best match. | Selected profile exists; dependency available. | Chosen profile restore runs. | Supporting | Settings |
| Show Numbers | Label displays so the user can confirm physical-to-profile mapping. | Verify screen identity before or after recovery. | Profile/display markers resolve. | Overlays appear. | Supporting | Settings |
| Profile Management | Rename, delete, inspect, and tune profiles. | Keep saved layouts usable over time. | Profiles exist. | Profile metadata persists. | Supporting | Settings |
| Confidence Threshold Tuning | Adjust per-profile confidence cutoff. | Control how conservative restore matching should be. | Profile exists. | New threshold persists. | Supporting | Settings |
| Diagnostics History | Review recent actions, outcomes, and support files. | Troubleshoot or understand prior behavior. | Diagnostics persistence works. | Recent history is visible/copyable. | Supporting | Settings |
| Swap Positions | Run a limited 2–3 display swap fallback. | Try a quick utility fallback for simple desk cases. | Dependency available; supported display count. | Swap executes and verifies. | Convenience only | Secondary utility |
| Keyboard Shortcuts | Bind quick triggers for common actions. | Access recovery actions faster. | Shortcut registration works. | Shortcuts persist and invoke correctly. | Convenience only | Settings |
| Launch at Login | Start the app automatically at login. | Keep recovery available without manual launch. | Login-item manager works. | Launch behavior persists. | Convenience only | Settings |
| Update Management | Check/install/skip app updates. | Keep the app current. | Update service available. | Update state is visible and controllable. | Convenience only | Settings |
| Language Selection | Choose System, English, or Korean. | Use preferred language. | Localization resources available. | Language preference persists. | Convenience only | Settings |

## PRD/SPEC pruning recommendations

1. Rewrite the top-line promise around **safe recovery of a saved desk layout**, not around feature breadth.
2. Move `Swap Positions`, shortcuts, updates, login item, and language out of the headline feature list.
3. Describe `Apply Layout`, `Show Numbers`, thresholds, and diagnostics as supporting tools around the core loop.
4. State non-goals directly instead of implying future expansion.
5. Prefer the shipped three-primary-section settings model in docs; avoid creating a larger IA just to give supporting surfaces more weight.
