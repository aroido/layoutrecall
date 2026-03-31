# LayoutRecall Product Specification

Status: Working baseline for the 2.0 overnight program  
Last updated: 2026-04-01

## 1. Purpose

LayoutRecall is a macOS menu bar utility that detects disruptive display changes and restores a previously saved layout when the connected monitor set matches a known workspace with high confidence.

This specification reflects the **current implemented baseline**, not an earlier scaffold plan. Its job is to document what exists today, where the product intentionally draws safety boundaries, and which areas are the best candidates for the next improvement waves.

## 2. Product goals

### Primary goals

- Detect meaningful display reconfiguration events with low noise.
- Match the current monitor set against saved profiles safely.
- Restore automatically only when confidence is high enough to trust the action.
- Keep manual recovery fast and understandable when automation is unsafe.
- Make the menu bar surface trustworthy enough for daily use.

### Secondary goals

- Preserve diagnostics that explain recent decisions and failures.
- Keep setup friction manageable even when `displayplacer` is missing.
- Support daily-driver quality for common dual- and triple-monitor desks.

## 3. Current implemented baseline

The repository already includes the following real behavior:

### Runtime and recovery pipeline

- live display snapshot capture using CoreGraphics
- real display reconfiguration callback registration
- wake notification monitoring
- debounce before reevaluating a hardware change burst
- confidence-based profile matching
- automatic restore when the best match clears the active threshold
- manual restore entrypoints for `Fix Now` and direct `Apply Layout`
- post-restore verification against expected origins

### Profile and diagnostics surface

- save current layout as a profile
- rename and delete profiles
- per-profile confidence threshold editing
- per-profile auto-restore toggle
- `Show Numbers` to map profile order to physical displays
- persisted diagnostics with action, score, execution, and verification fields
- runtime snapshot details in settings

### General app capabilities

- launch at login via `SMAppService`
- global shortcuts
- English / Korean / System language choice
- update checks, skip-version handling, and install flow plumbing
- automatic dependency installation path for `displayplacer`

## 4. Architecture snapshot

### Main modules

- `LayoutRecallApp`
  - SwiftUI menu bar and settings surfaces
  - `AppModel` orchestration and user-triggered actions
  - presentation-state mapping for trust, confidence, and recovery affordances
- `LayoutRecallKit`
  - display models and persistence
  - profile matching and restore decisions
  - display event monitoring, snapshot reading, restore execution, verification, and diagnostics

### Key services

- `DisplaySnapshotReader` — reads live display state from CoreGraphics
- `CGDisplayEventMonitor` — listens for reconfiguration and wake events
- `ProfileMatcher` — scores a live display set against saved profiles
- `RestoreCoordinator` — decides whether to auto-restore, stay manual, or prompt profile creation
- `DisplayplacerCommandBuilder` — generates restore commands from saved layouts
- `DisplayplacerRestoreExecutor` — runs restore commands and captures command results
- `RestoreVerifier` — re-reads displays after restore and compares expected origins
- `DiagnosticsLogger` — persists a capped recent history

## 5. User-facing behavior

## 5.1 Menu bar surface

The menu bar is the primary runtime surface and should answer four questions quickly:

1. Is LayoutRecall healthy right now?
2. Did it find a trustworthy profile match?
3. If it did not auto-restore, why not?
4. What is the next best action for the user?

Current surface elements:

- status title and subtitle
- evidence pills for dependency, display count, and confidence
- primary action when intervention is needed
- quick actions for save, identify, manage profiles, and recovery

## 5.2 Settings information architecture

The settings window currently has five panes:

- **Restore** — automatic restore state, dependency readiness, recommended actions
- **Profiles** — save/manage profiles, thresholds, apply layout, identify displays
- **Shortcuts** — keyboard shortcuts for restore actions
- **Diagnostics** — latest decision plus recent capped history
- **General** — launch at login, updates, preferred language

This is already a reasonable foundation for 2.0 work; improvements should focus on clarity and trust rather than adding settings volume without evidence.

## 6. Safety and trust model

The product is intentionally conservative.

### Current safety rules

- no automatic restore when there are no displays or no profiles
- no automatic restore when the best profile is below threshold
- no automatic restore when app-level automatic restore is disabled
- no automatic restore when `displayplacer` is unavailable
- diagnostics should capture both successful actions and blocked decisions

### Product principle

Prefer safe false negatives over unsafe false positives.

If the app is not confident enough to move monitors automatically, it should explain the reason and surface the most relevant manual action instead.

## 7. Known limitations

These are current boundaries, not necessarily bugs:

- `displayplacer` remains the execution engine for real layout changes.
- Automatic dependency installation depends on Homebrew/bootstrap success.
- `Swap Positions` is intentionally limited to simpler supported layouts.
- Four-plus-display rearrangement remains a manual/review-heavy area.
- Some live hardware and UI harness tests are opt-in because they require a real environment.

## 8. Code quality review

The current codebase is in good shape for incremental product work.

### Strengths observed

- `AppModel` uses dependency injection consistently enough to keep app behavior testable.
- Restore logic is separated into matcher, coordinator, executor, and verifier layers.
- Diagnostics and persistence paths are isolated behind protocols.
- Localization, update, restore, and settings behavior already have broad automated coverage.

### Main quality concerns

- Product documentation was materially behind implementation, which makes planning noisier than it should be.
- Some user trust behaviors are spread across presentation logic and localization strings, so future edits should preserve terminology consistency.
- Dependency bootstrap relies on shelling out to Homebrew install flows, which is practical but deserves careful user-facing explanation.

## 9. Verification and coverage baseline

The repository already contains useful automated coverage in these areas:

- app-model orchestration and UI presentation behavior
- profile persistence and settings persistence
- diagnostics truncation/persistence
- profile matching and restore decisions
- restore verification logic
- localization
- command generation
- view snapshot smoke coverage
- optional live hardware and UI harness smoke paths

Local completion should continue to use:

```bash
./scripts/run-ai-verify --mode full
```

## 10. 2.0 improvement priorities

The next waves should build on the current baseline instead of rewriting it.

### Priority 1: restore trust and explainability

- make confidence and dependency state easier to understand at a glance
- explain blocked auto-restore decisions more crisply
- improve diagnostic summaries so users know what happened without reading raw details

### Priority 2: profile management ergonomics

- reduce friction when multiple profiles exist
- make direct apply, identify, and threshold tuning feel more obvious
- tighten profile naming and reference-layout cues

### Priority 3: manual recovery clarity

- document exactly when `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions` should be used
- better communicate unsupported complex-layout cases

### Priority 4: setup and resilience polish

- make dependency setup messaging calmer and more explicit
- continue hardening around restore verification failures and transient event bursts
- improve user confidence in launch-at-login and update-management flows

## 11. Suggested acceptance criteria for the next program waves

Any 2.0 wave should satisfy all of the following:

- keep the branch shippable after the wave
- preserve the conservative auto-restore safety model
- update user-facing docs when behavior changes materially
- keep automated verification green
- improve user trust, clarity, or recoverability in a visible way

## 12. Recommended documentation posture

Going forward, the docs should describe:

- the **current implemented baseline**
- the **current known limits**
- the **next highest-value polish work**

They should not drift back into describing the app as an unimplemented scaffold when the code already delivers real behavior.
