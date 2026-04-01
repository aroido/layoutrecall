# LayoutRecall OSS Marketing Program — Positioning

_Last updated: 2026-04-01_

## Review scope

This document records the positioning output for the 2026-04-01 OSS marketing program.
The review used:

- `README.md:1-110`
- `docs/PRD.md:1-107`
- `docs/SPEC.md:1-220`
- `docs/marketing/README.md:1-36`
- generated assets under `docs/marketing/generated/final/`
- raw UI captures under `docs/marketing/generated/raw-ui/`
- prior UX audit in `docs/roadmaps/v2-release-20260331T233306Z-designer-audit.md:17-178`
- release proof in `.github/workflows/release.yml:74-167` and `scripts/build-release-archive:137-255`

## Executive positioning

LayoutRecall should be marketed first as:

> **The calm menu bar utility for Mac users whose external monitor layout keeps coming back wrong.**

The product is strongest when presented as a practical recovery tool for people who already understand the pain of dock/sleep/reconnect display churn and want a safer, lower-effort way to get back to a known-good desk layout.

## Who should use LayoutRecall first

### Primary launch ICP

1. **MacBook + dock + 2–3 external display users**
   - developers
   - designers
   - analysts / operators
   - creators with layout-sensitive desks
2. People who repeatedly hit the same pain:
   - left/right monitor order changes after wake or reconnect
   - main display flips unexpectedly
   - identical displays become hard to distinguish
   - manual recovery is annoying enough to want a background helper

### Secondary audiences

- multi-monitor Homebrew power users who already know `displayplacer`
- Mac utility enthusiasts who prefer menu bar tools over larger dashboard apps
- people comparing “remember my desk layout” utilities and want a more conservative / explainable option

### Audiences to de-prioritize in the first wave

- users expecting per-app window placement or full workspace automation
- users with complex 4+ display choreography as the main use case
- cross-platform users looking for Windows support

## Why they should trust it

The trust case is stronger than the current README communicates.

### Product proof already present in the repo

- The app is conservative by design: it restores automatically only on high-confidence matches and stays manual otherwise (`README.md:39-51`, `docs/SPEC.md:89-129`).
- The app exposes diagnostics, confidence, dependency state, and verification context instead of hiding decisions (`README.md:9-15`, `docs/PRD.md:49-71`).
- Marketing assets are generated from real app snapshots, not fake mockups (`docs/marketing/README.md:3-36`, `scripts/generate-marketing-assets:1-38`).
- Release docs already support a signed / notarized distribution story plus Homebrew distribution (`README.md:17-37`, `README.md:82-98`, `.github/workflows/release.yml:74-167`, `scripts/build-release-archive:137-255`).
- Code organization and tests are already framed as mature baseline work rather than a thin prototype (`docs/PRD.md:89-107`, `docs/SPEC.md:141-211`).

### Trust claims we can honestly make

- It is a **menu bar app, not a giant display manager**.
- It is **safer than blind auto-restore** because it explains confidence and blocked states.
- It gives the user **proof after the action**, not just a promise before it.
- It supports a practical install path even when `displayplacer` is initially missing.

## Why they should download it now

Users need a reason stronger than “it exists.”

### Download-now angle

- It already solves the annoying everyday desk-reset problem without requiring users to keep manual shell commands around.
- The current build already includes automatic restore, manual recovery paths, diagnostics history, settings, localization, launch at login, and update plumbing (`README.md:7-15`, `docs/PRD.md:14-28`, `docs/SPEC.md:28-62`).
- The generated marketing assets already show a product that looks real, current, and actively maintained.
- OSS users can inspect the implementation, install via releases or Homebrew, and verify how the restore safety model works.

### Recommended urgency framing

Use:

> “If your monitor layout breaks often enough to annoy you every week, LayoutRecall is ready to save you repeated recovery time now.”

Avoid:

- “perfect display automation”
- “works for every monitor setup”
- “native replacement for displayplacer”

## Positioning statement

### Internal positioning statement

For Mac users with recurring external-display layout churn, LayoutRecall is the menu bar recovery utility that restores a known-good desk layout with visible confidence and diagnostics, unlike opaque display tools or manual command workflows that leave users guessing what just happened.

### Category language

Prefer:

- menu bar utility
- display layout recovery tool
- multi-display restore helper
- monitor layout recall for macOS

Avoid leading with:

- display manager
- window manager
- workstation automation platform

## Messaging hierarchy

### Core promise

**Put your display layout back where it belongs.**

### Supporting points

1. Save a known-good desk layout once.
2. Restore automatically when the match is trustworthy.
3. Review confidence, dependency status, and diagnostics when it is not.

### Proof bullets to reuse

- Confidence-based automatic restore
- Manual recovery tools when the match is uncertain
- Diagnostics history and restore verification
- Signed release builds and Homebrew install path
- Real screenshots generated from the app itself

## Recommended README / hero narrative

### Hero headline direction

- **Put your display layout back where it belongs.**
- Alternative: **When macOS scrambles your monitors, get your desk back fast.**

### Subheadline direction

LayoutRecall is a macOS menu bar utility for people whose external displays come back in the wrong order after sleep, wake, dock reconnect, or identical-monitor churn.

### Three hero proof chips

- Save a baseline once
- Confidence-based restore
- Diagnostics you can inspect

## Message guardrails

### Lean into

- calmness
- trust
- recoverability
- real Mac desk pain
- “safe enough to leave running”

### Do not lean into

- speculative future features
- enterprise/admin language
- aggressive claims about preventing every macOS display bug
- abstract “AI” or “smart automation” framing

## PM recommendation

For the first public-facing funnel, LayoutRecall should be presented as a trustworthy utility for a painfully specific Mac problem, not as a broad display-management platform. Specificity is the conversion advantage.
