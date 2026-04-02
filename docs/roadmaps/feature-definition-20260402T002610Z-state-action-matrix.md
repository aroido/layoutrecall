# LayoutRecall State / Action Matrix

Lab: `feature-definition-20260402T002610Z`  
Updated: 2026-04-02

## Audit basis

Primary runtime state comes from `AppModel.menuPrimaryState` in `Sources/LayoutRecallApp/AppPresentation.swift`, backed by `RestoreDecisionContext` in `Sources/LayoutRecallKit/Services/RestoreCoordinator.swift` and verified by `Tests/LayoutRecallAppTests/AppModelTests.swift`.

## Canonical states

| User-visible state | Backing context / condition | Allowed primary action | Allowed secondary actions | Explicitly blocked or unavailable actions | Notes |
| --- | --- | --- | --- | --- | --- |
| No Profiles | `profiles.isEmpty` or `.noSavedProfile` | `Save Current Layout` | None | `Fix Now`, `Apply Layout`, `Enable Automatic Restore` (non-actionable), profile-specific actions | First-run / empty-library state. |
| Installing Dependency | `installationInProgress` | `Install displayplacer` (busy/in-progress) | `Save Current Layout`; diagnostics shortcut; swap may remain visible but disabled as needed | Real restore execution while install is running | Busy transitional state. |
| Dependency Missing | `!dependencyAvailable` or `.dependencyBlocked` | `Install displayplacer` | `Save Current Layout`; diagnostics shortcut; identify may still work if profile exists | `Fix Now`, `Apply Layout`, auto execution, swap execution | Setup state, not a profile-matching state. |
| No Match | `.noConfidentMatch` | `Save Current Layout` | Diagnostics shortcut; swap if supported | `Fix Now` for current state; auto execution | Means profiles exist but none match confidently enough even to review. |
| Low Confidence | `.belowThreshold` | `Fix Now` | `Save Current Layout`; `Swap Positions`; diagnostics; identify displays | Automatic restore | The app found a plausible profile but it did not meet threshold. |
| Review Before Restore | `.awaitingUserConfirmation` | `Fix Now` | `Save Current Layout`; `Swap Positions`; diagnostics; identify displays | Automatic restore without confirmation | Produced when Ask Before Restore is enabled. |
| Automatic Restore Disabled | `.automaticRestoreDisabled` while profiles exist | `Enable Automatic Restore` | `Save Current Layout`; `Swap Positions`; diagnostics; identify displays | Automatic restore while the global mode is off | This is a global app-mode state, not a profile-specific state. |
| Manual Layout Override | `.manualLayoutOverride` | None | `Save Current Layout`; `Swap Positions`; diagnostics; identify displays; optional manual `Fix Now` inline if restore is otherwise possible | Automatic restore for current arrangement until override clears | Temporary suppression/trust-preservation state. |
| Manual Recovery | `.manualRestoreRequested`, `.profileRestoreRequested`, `.restoreFailed`, or no stronger context after a failed/explicit manual path | `Fix Now` | `Save Current Layout`; `Swap Positions`; diagnostics; identify displays | Automatic restore if confidence/dependency/mode rules are not met | Recovery-in-progress or recover-manually state. |
| Healthy | `.ready`, `.savedProfileReady`, or latest action `.autoRestore` | None | Inline `Fix Now` if user wants a manual rerun; `Save Current Layout`; `Swap Positions`; quick-switch; diagnostics if attention is needed | None beyond normal dependency/count constraints | Trustworthy steady state with a matched baseline. |

## Action definitions

| Action | Meaning | Canonical placement |
| --- | --- | --- |
| Save Current Layout | Capture the live desk as a new profile. | Menu + Settings |
| Fix Now | Execute restore for the current best/matched layout immediately. | Menu runtime action |
| Apply Layout | Execute restore for a specific chosen profile. | Settings / profile management |
| Enable Automatic Restore | Turn the app-level auto-restore mode back on. | Menu + Settings toggle context |
| Install displayplacer | Make the restore dependency available. | Menu + Restore settings |
| Identify Displays | Show numbered overlays for the selected/reference profile. | Menu + Settings |
| Swap Positions | Apply limited manual left/right swap fallback. | Menu + Restore settings |
| Open Diagnostics | Deep-link to restore evidence/history. | Menu shortcut + Settings home |

## Duplicate / contradictory behavior found during audit

### 1. Five-pane docs vs three-pane navigation

- `SettingsPane` still defines `restore`, `profiles`, `shortcuts`, `diagnostics`, and `general`.
- `primaryNavigationPanes` only exposes `restore`, `profiles`, and `general`.
- `Shortcuts` and `Diagnostics` are therefore **content sections**, not true top-level panes in the shipped UI.

### 2. Per-profile auto restore vs global auto restore

- `DisplayProfile.settings.autoRestore` still exists in the model.
- `AppModel.normalizeProfiles` forces legacy values back to `true`.
- Runtime decisioning and settings UI expose only **global automatic restore**.
- Canonical definition: **global only** for this baseline.

### 3. `Fix Now` vs `Apply Layout`

- Both trigger restore execution, but they solve different user intents.
- Canonical rule:
  - `Fix Now` = runtime “recover the current desk now.”
  - `Apply Layout` = profile-management “run this exact saved profile.”

### 4. Diagnostics entrypoint duplication

- Diagnostics is offered from Restore affordances and under General.
- This is acceptable if Diagnostics has **one canonical home** in Settings and Restore only deep-links to it.

## Normalized matrix rules

1. Only one primary action should be presented per runtime state.
2. `Fix Now` should never be offered as the primary action in `No Profiles`, `Dependency Missing`, or `No Match`.
3. `Apply Layout` belongs to profile cards and quick-switch/profile management flows, not to the generic runtime card.
4. `Enable Automatic Restore` is only meaningful when profiles exist and the global mode is off.
5. `Swap Positions` remains a constrained manual fallback, not a substitute for profile restore.

## Test evidence referenced during the audit

- `AppModelTests.bootstrapNormalizesLegacyProfileAutoRestoreToGlobalMode`
- `AppModelTests.presentationActionsReflectGlobalAutoRestoreDisabledWithoutMutatingProfileState`
- `AppModelTests` expectations for `.healthy`, `.noProfiles`, `.dependencyMissing`, `.noMatch`, `.lowConfidence`, `.reviewBeforeRestore`, and `.autoRestoreDisabled`

## Phase 2 follow-up (implementation only, not approved here)

- Add doc/tests that explicitly encode the chosen three-pane settings model.
- Remove stale references to per-profile auto-restore from user-facing docs.
- Review whether manual-layout-override language needs a clearer public-facing name.
