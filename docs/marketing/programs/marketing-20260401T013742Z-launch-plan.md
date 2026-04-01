# LayoutRecall Launch Plan

## Launch objective
Ship a small OSS launch that makes LayoutRecall easier to trust, easier to install, and easier to share without overclaiming beyond the current baseline.

## Launch promise
A focused macOS menu bar utility that helps people recover a known display layout after sleep, wake, dock reconnects, and identical-monitor shuffling.

## Release funnel
1. README refresh lands first
2. Regenerated hero / stills / GIF land second
3. GitHub release post uses the new headline, trust framing, and install CTAs
4. Social/community posts follow with channel-specific copy
5. Early replies gather objections around trust, setup, and supported layouts

## Pre-launch checklist
- README hero clearly names the problem and first audience
- Install paths show signed DMG and Homebrew near the top
- Safety model appears before deep implementation details
- At least one proof GIF/video and one proof screenshot are up to date
- FAQ/limitations explain `displayplacer`, confidence thresholds, and manual controls honestly
- `./scripts/run-ai-verify --mode full` passes before shipping

## Channel priorities

### Must-launch channels
1. **GitHub README + Releases** — canonical conversion surface
2. **GitHub release notes / project post** — best place for install/update framing
3. **Hacker News / Show HN style post** — good for “I built a focused tool for a specific recurring pain”

### Should-launch channels
1. **Relevant Reddit communities** (macOS, setup/productivity, developer-workstation audiences)
2. **Personal/social post thread** with problem, solution, and install CTA

### Could-launch channels
1. Short demo clip reposts
2. Direct outreach to multi-monitor power users already complaining about identical-display churn

## Core objections and response strategy

| Objection | Response |
| --- | --- |
| “Why not just use a script?” | LayoutRecall wraps the recovery flow in a menu bar utility with saved profiles, confidence gating, diagnostics, and manual fallback. |
| “Will it rearrange my desk incorrectly?” | The product is intentionally conservative and favors not acting over acting unsafely when confidence is low. |
| “Do I need terminal setup?” | Real restore uses `displayplacer`, but the app can guide setup and the README explains the dependency clearly. |
| “Is this a full window manager?” | No. It is a focused tool for restoring known display layouts after monitor churn. |
| “Does it work for every complex desk?” | Honest answer: the safest common dual-/triple-monitor paths are the focus today; some complex layouts remain manual by design. |

## GitHub release copy

### Release title
LayoutRecall: restore your Mac display layout after sleep, wake, and dock reconnects

### Release body
If macOS keeps bringing your monitors back in the wrong order, wrong position, or wrong main-display state, LayoutRecall is built for that exact problem.

LayoutRecall is a macOS menu bar utility that lets you save a known-good display layout, watch for real display changes, and restore the matching layout when confidence is high.

Why try it now:
- save one or more known-good monitor layouts
- restore automatically only when the match is trustworthy
- use manual recovery tools like `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions`
- inspect diagnostics, confidence, and dependency status directly in the app
- install via signed DMG or Homebrew

Install:
- Download the latest signed DMG from GitHub Releases
- Or run `brew install --cask aroido/layoutrecall/layoutrecall`

Honest boundary:
LayoutRecall uses `displayplacer` for real layout changes and stays conservative when confidence is low.

## Hacker News / Show HN draft

**Title:** Show HN: LayoutRecall — a macOS menu bar app for fixing scrambled external monitor layouts

**Body:**
I built LayoutRecall for a specific desk problem: macOS sometimes brings identical or frequently reconnected monitors back in the wrong order or position after sleep, wake, or dock reconnects.

The app lets you save a known-good layout, watches for real display changes, and restores automatically only when the profile match is confident enough. When it is not confident, it stays manual and surfaces tools like `Fix Now`, `Apply Layout`, `Show Numbers`, and diagnostics instead of guessing.

It is intentionally narrow: not a general window manager, just a focused menu bar utility for restoring known monitor layouts more safely.

You can install it from a signed DMG or with Homebrew:
`brew install --cask aroido/layoutrecall/layoutrecall`

I would especially love feedback from people with laptop + dock + 2–3 monitor setups, or from anyone who has been relying on ad-hoc `displayplacer` scripts.

## Reddit draft

**Title:** I made a macOS menu bar app for when external monitors come back in the wrong layout

**Body:**
If your Mac keeps scrambling monitor positions after sleep, wake, or reconnecting a dock, I made a focused tool for that.

LayoutRecall lets you save a known-good display layout and restore it later when the connected monitor set matches with high confidence. It also keeps manual recovery visible, so it does not silently guess when the match looks risky.

Current highlights:
- save/manage multiple monitor layout profiles
- auto-restore only on trusted matches
- manual `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions`
- diagnostics and dependency status in-app
- signed DMG + Homebrew install

It is open source and built specifically for the “my desk was right yesterday, why is it broken again?” problem.

## GitHub social / personal post draft

MacBook + dock + external monitors, and macOS keeps putting them back wrong?

I built LayoutRecall: a focused macOS menu bar utility that saves your known-good display layout and restores it when your monitor setup comes back scrambled after sleep, wake, or reconnects.

Why it feels safer than a one-off script:
- conservative auto-restore
- manual recovery tools when confidence is low
- visible diagnostics and dependency state
- signed DMG and Homebrew install paths

Repo + downloads: GitHub Releases / README

## Post-launch watchpoints
- Questions about `displayplacer` setup
- Fear around wrong automatic restores
- Requests for more complex 4+ display heuristics
- Confusion about whether the tool manages windows vs. display layout only
- Feedback on whether the top README visual proves the outcome fast enough
