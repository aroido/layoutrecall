# LayoutRecall asset direction

_Last updated: 2026-04-01_

## Objective

Make LayoutRecall feel polished enough to click, trustworthy enough to install, and concrete enough to understand in under 15 seconds.

## Creative direction

### Visual thesis

Show **real app UI with cleaner framing**, not fake futuristic mockups.

The visual system should communicate:

- desk recovery, not generic productivity
- menu bar simplicity, not dashboard complexity
- safety and proof, not “AI magic” or opaque automation

### Tone

- calm
- technical but not cold
- practical
- Mac-native
- trustworthy

## Funnel-wide asset story

### 1. Hero still

Primary asset: `docs/marketing/generated/final/readme-hero.png`

The hero should answer three questions at a glance:

1. What broke? — the desk layout got scrambled
2. What does LayoutRecall do? — it restores a saved layout
3. Why trust it? — it only auto-restores when confidence is high

Hero caption direction:

> Save a known-good monitor layout, then restore it after sleep, wake, or dock reconnect — without blindly guessing.

### 2. Trust / diagnostics still

Primary asset: `docs/marketing/generated/final/readme-feature-trust.png`

Purpose:

- show that LayoutRecall exposes confidence, dependency state, and diagnostics
- make safety visible instead of abstract

Caption direction:

> Confidence, dependency, and recent restore evidence stay visible so the app can explain what it did — or why it refused to act.

### 3. Profiles / controls still

Primary asset: `docs/marketing/generated/final/readme-feature-profiles.png`

Purpose:

- show the app is not only automatic; users retain direct control
- reinforce saved layouts, thresholds, and manual actions

Caption direction:

> Save multiple desk profiles, tune restore confidence, and fall back to `Fix Now`, `Apply Layout`, or `Show Numbers` when you want control.

## Screenshot treatment rules

- Prefer cropped real UI over full-window noise.
- Keep one focal story per image.
- Put benefit-led captions next to each still.
- Preserve macOS visual authenticity; avoid neon overlays or fake device bezels.
- Use annotations sparingly and only to clarify confidence, profile, or action state.

## README asset sequence

Recommended top-of-page visual order:

1. hero still (`readme-hero.png`)
2. short benefit bullets
3. demo GIF/video
4. trust still (`readme-feature-trust.png`)
5. profiles still (`readme-feature-profiles.png`)

This order makes the repo read like a funnel:

- hook with the problem + outcome
- prove the app is real
- prove the app is safe
- prove the app is controllable

## GIF / video direction

Primary assets:

- `docs/marketing/generated/final/layoutrecall-demo.mp4`
- `docs/marketing/generated/final/layoutrecall-demo.gif`

### Demo concept

Keep the motion asset short and structured around a single story arc:

1. scrambled desk state / reconnect problem
2. saved profile recognized
3. confidence-aware restore
4. diagnostics + fallback controls visible

### Demo rules

- keep under 20 seconds
- prioritize readability over flair
- use branded slides only when they clarify the flow faster than live capture
- if later live captures are added, keep this composited version for README/social reuse

## Social card direction

Primary asset: `docs/marketing/generated/final/social-card.png`

Use the social card to sell a single promise:

> macOS forgot your monitor layout. LayoutRecall brings it back.

The social card should avoid tiny UI details and instead emphasize:

- app name
- monitor-layout pain
- menu bar / macOS context
- restore-with-confidence positioning

## Concrete asset improvements to keep pursuing

- tighten hero subtitle copy so it speaks to desk users, not only technical readers
- ensure the trust still visually highlights blocked auto-restore and diagnostics evidence
- if annotations are added, make confidence and fallback actions the only labeled callouts
- add one future still that contrasts “scrambled layout” versus “restored layout” with the same monitors

## Asset guardrails

- no fake app states that the shipped app does not support
- no fake testimonials or usage numbers
- no Windows-style hardware mockups for a Mac utility
- no dense text baked into images that should live in Markdown copy
