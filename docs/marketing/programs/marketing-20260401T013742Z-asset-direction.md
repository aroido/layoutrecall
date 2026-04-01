# LayoutRecall Asset Direction

_Date: 2026-04-01_

## Creative brief

Use the real app UI to make LayoutRecall feel like a calm, reliable recovery tool for serious desk setups.

The aesthetic target is:

- practical, not flashy
- premium enough to trust
- system-native enough to feel safe
- focused on “recovery from monitor chaos,” not generic productivity branding

## Core visual narrative

Every top-level asset should support one funnel:

1. **Problem:** macOS scrambled the desk again.
2. **Decision:** LayoutRecall recognized a known layout and shows why it can help.
3. **Recovery:** the user restores confidently without dragging displays around manually.

## What to preserve from current assets

Existing assets already have strong inputs:

- real menu bar UI from `docs/marketing/generated/raw-ui/menu.png`
- real settings panes for profiles, diagnostics, shortcuts, and general controls
- branded stills and short demo media under `docs/marketing/generated/final/`

Keep those as the base; refine narrative, captions, crop hierarchy, and trust framing before inventing new visuals.

## Art-direction principles

### 1. Show a real Mac utility, not a concept mockup

Prefer authentic menu/settings UI crops over fake devices or abstract dashboards.

### 2. Show evidence-rich moments

Prioritize UI states that communicate:

- saved profile exists
- confidence is visible
- recovery actions are obvious
- diagnostics prove the app is not guessing blindly

### 3. Use calm contrast

The product promise is “desk chaos becomes controlled.”

Recommended contrast pattern:

- neutral dark or graphite shell
- bright blue accent for primary recovery state
- restrained green only for verified success / trust moments
- avoid alarm-red as the dominant theme unless highlighting the “before” problem

### 4. Caption what the user is seeing

A screenshot should not rely on the reader understanding the menu bar app by inspection alone. Each still needs a short label that explains the value in plain English.

## Screenshot direction

### Screenshot 1: README hero

**Goal:** establish desk-recovery value in one glance.

Use:

- `docs/marketing/generated/final/readme-hero.png` as the base direction
- a crop that keeps the menu bar panel readable and the settings/profile context visible

Caption territory:

- Save a known-good layout, then restore it after sleep, wake, or dock reconnect.

Required emphasis:

- menu bar utility
- profile awareness
- recovery action readiness

### Screenshot 2: Trust / diagnostics still

**Goal:** prove the app is conservative and explainable.

Use:

- `docs/marketing/generated/final/readme-feature-trust.png`
- diagnostics or confidence-related UI states with readable labels

Caption territory:

- LayoutRecall restores automatically only when the match is confident—and shows you the evidence when it is not.

Required emphasis:

- confidence
- diagnostics history or verification context
- no-blind-automation story

### Screenshot 3: Profiles / control still

**Goal:** prove the app is useful even when the user wants manual control.

Use:

- `docs/marketing/generated/final/readme-feature-profiles.png`
- profile-management pane with direct controls visible

Caption territory:

- Keep one or more desk layouts ready, apply them directly, and identify displays without digging through System Settings.

Required emphasis:

- saved profiles
- `Apply Layout`
- `Show Numbers` / practical control

## Concrete screenshot improvements to make in the next asset pass

1. Increase the readability of any small menu text in hero crops.
2. Add a tighter caption system so each still is tied to one promise only.
3. Prefer one primary promise per asset instead of mixing setup, trust, and diagnostics together.
4. If a badge/pill treatment is used, make “confidence” and “manual fallback” the hero proof points.
5. Keep shadows and background treatments subtle; the UI itself should do most of the selling.

## GIF / video direction

### Current baseline

The repo already has:

- `docs/marketing/generated/final/layoutrecall-demo.mp4`
- `docs/marketing/generated/final/layoutrecall-demo.gif`

These are useful because they are built from branded slides rather than noisy screen recordings.

### Recommended demo concept

**Concept:** “Three beats to get your desk back.”

#### Beat 1 — Save the layout

Text:

- Save your known-good monitor arrangement once.

Visual:

- profile/settings UI with a calm, clean crop

#### Beat 2 — macOS scrambles the desk

Text:

- After sleep, wake, or dock reconnect, LayoutRecall checks what changed.

Visual:

- menu/status state with confidence and profile context

#### Beat 3 — Recover safely

Text:

- Restore automatically when confidence is high—or use `Fix Now` when you want control.

Visual:

- recovery-ready menu bar view plus diagnostics/trust still

## Demo pacing guidance

- 6 to 8 seconds total is enough for README/GitHub/social usage.
- Keep transitions simple fade or push transitions; avoid “product ad” theatrics.
- Every frame should be readable without sound.
- Assume the GIF will autoplay muted and loop.

## Social-card direction

Use `docs/marketing/generated/final/social-card.png` as the starting point, but ensure the final copy emphasizes:

- problem specificity: Mac display layouts breaking
- recovery promise: save + restore
- trust lens: safe automation / manual control

Recommended copy territory:

- Stop rebuilding your monitor layout after every dock reconnect.
- Save a known-good setup. Restore it from the menu bar.

## README top-of-page structure this asset system should support

1. Headline + subheadline
2. Primary hero image
3. Three proof bullets
4. Install CTA
5. Trust / profiles screenshots with short captions
6. Demo GIF/video

## Asset handoff checklist

Before accepting a marketing asset pass, confirm:

- the visual is clearly from the real app
- the caption states one benefit, not three
- trust is visible, not implied
- `displayplacer` is not hidden or misrepresented
- the asset helps a first-time visitor decide whether to try the app now
