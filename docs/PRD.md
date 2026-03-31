# LayoutRecall Product Summary

_Last updated: 2026-04-01_

## One-line definition

LayoutRecall is a macOS menu bar utility that helps people recover a known multi-display layout after sleep, wake, dock reconnect, or identical-monitor shuffling.

## Product promise

- restore a saved layout automatically only when confidence is high
- keep recovery obvious when confidence is lower
- show enough evidence that the user can trust what the app is about to do
- stay lightweight, menu-bar-first, and practical for daily desk setups

## Current baseline

The current branch is no longer a scaffold-only MVP. The app already ships a usable restore workflow with:

- live display snapshot capture from CoreGraphics
- real display reconfiguration and wake monitoring with debounce
- profile save, rename, delete, and direct `Apply Layout`
- confidence-based automatic restore plus manual `Fix Now`
- `Show Numbers` to confirm screen-to-profile mapping
- `Swap Positions` fallback for supported desk layouts
- persisted diagnostics history with verification outcomes
- launch-at-login, keyboard shortcuts, update checks, and language selection
- automatic `displayplacer` install flow when the dependency is missing

## Target user

- developers using a laptop, dock, and two or more external displays
- creators with layout-sensitive editing or preview workflows
- analysts, operators, or traders who depend on stable left/right placement

## Key user flows

### 1. Capture a known-good workspace

1. Arrange displays the way you want.
2. Save the current layout as a profile.
3. LayoutRecall stores matching metadata, expected origins, and a generated restore command.

### 2. Recover automatically when confidence is high

1. macOS emits a real display reconfiguration or wake event.
2. LayoutRecall waits for the event burst to settle.
3. The app compares the live display set with saved profiles.
4. If confidence clears the threshold and auto-restore is enabled, the app runs the restore command and verifies the result.

### 3. Recover manually when confidence is low or the user wants control

1. The menu bar surface explains why auto-restore did not run.
2. The user chooses `Fix Now`, `Apply Layout`, `Show Numbers`, or `Swap Positions`.
3. The app records the action, outcome, and verification result in diagnostics.

## Information architecture

### Menu bar

- current status and recent decision
- confidence, display-count, and dependency badges
- primary recovery action when needed
- quick actions for save, identify, apply, and advanced controls

### Settings

- **Restore**: automatic restore state, dependency readiness, recommended recovery actions
- **Profiles**: profile management, confidence thresholds, direct apply, and identify displays
- **Shortcuts**: keyboard bindings for recovery actions
- **Diagnostics**: latest diagnostic, capped recent history, and runtime snapshot
- **General**: launch at login, updates, and preferred language

## Product boundaries

The current app intentionally does **not** promise:

- perfect prevention of every macOS display glitch
- automatic restore below the configured confidence threshold
- broad four-plus-display rearrangement heuristics
- cloud sync, cross-machine profile sync, or per-app window placement
- a native restore engine that replaces `displayplacer`

## Known limitations to communicate clearly

- `displayplacer` is still the execution engine for real layout changes.
- Automatic restore is biased toward safe false negatives over risky false positives.
- `Swap Positions` is intentionally limited to simpler supported layouts.
- Live hardware stress coverage exists, but some hardware-dependent tests are opt-in.

## Code quality review notes

The codebase is in solid shape for continued 2.0 iteration:

- app/runtime dependencies are injected cleanly enough to support focused tests
- restore, persistence, diagnostics, localization, and UI behavior already have meaningful automated coverage
- documentation was lagging behind implementation and needed a current-state refresh more than a structural rewrite

The highest-value remaining product work is therefore polish, clarity, and trust-building rather than replacing the entire architecture.

## Recommended next priorities

1. Improve restore trust signals and explainability in the menu and diagnostics.
2. Tighten profile-management ergonomics for multi-profile users.
3. Clarify supported manual recovery paths and unsupported complex layouts.
4. Continue hardening around dependency setup, verification failures, and edge-case hardware churn.
