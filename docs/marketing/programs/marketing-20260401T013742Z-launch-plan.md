# LayoutRecall launch plan

_Last updated: 2026-04-01_

## Launch goal

Turn the repo from “interesting utility” into “I should try this on my desk today.”

## Launch strategy

### Core angle

**LayoutRecall is the safer open-source way to recover a known monitor layout after macOS scrambles it.**

### Message stack

1. pain: macOS reorders identical or frequently reconnected displays
2. outcome: save a known-good layout and restore it quickly
3. trust: auto-restore only happens when confidence is high
4. safety net: manual recovery and diagnostics stay visible when confidence is lower

## Release readiness checklist

- [ ] README hero updated to lead with pain → outcome → trust
- [ ] Generated hero, trust, and profile stills embedded into README
- [ ] Demo GIF or MP4 linked near the top of the README
- [ ] Install path reduced to “download DMG” and “brew install” quick options
- [ ] Trust section explains confidence gating, diagnostics, and manual controls
- [ ] FAQ covers `displayplacer`, supported layouts, and why manual fallback exists
- [ ] Channel copy prepared for GitHub, Reddit, and Hacker News

## Channel plan

### 1. GitHub release / pinned repo update

**Goal:** convert existing repo visitors who already have technical intent.

Use:

- refreshed README hero and stills
- short release note pointing to the specific pain solved
- bullets focused on saved profiles, confidence-aware auto-restore, manual recovery, diagnostics, and install paths

### 2. Reddit

**Best fit communities:** macOS productivity, desk-setup, dev workflow, multi-monitor, and open-source tool communities where self-promo rules allow it.

**Angle:** “I built the Mac utility I wanted after macOS kept scrambling my identical monitors.”

Reddit post should sound firsthand, not brand-polished. Emphasize:

- repeated real-world pain
- why the tool is conservative instead of overly automatic
- OSS availability and install path

### 3. Hacker News

**Angle:** “Show HN: LayoutRecall — restore a known monitor layout on macOS after reconnect chaos”

HN copy should be short, technical, and concrete. Stress:

- actual problem scope
- menu bar UI + CoreGraphics monitoring
- `displayplacer` dependency as a deliberate integration choice
- conservative trust model

## Copy pack

### GitHub release summary

> LayoutRecall is a macOS menu bar utility for people whose external monitors come back in the wrong order after sleep, wake, or dock reconnects. Save a known-good layout, let the app watch for real display changes, and restore automatically only when the connected monitor set is a confident match. When confidence is lower, LayoutRecall stays manual on purpose and exposes `Fix Now`, `Apply Layout`, `Show Numbers`, and diagnostics instead of guessing.

### Short GitHub repo blurb

> Save and restore known-good macOS monitor layouts with confidence-aware automation, manual recovery tools, and diagnostics for multi-display desks.

### Reddit draft

**Title:** I built an open-source macOS menu bar app to fix monitor layouts after sleep/wake and dock reconnects

**Body:**

> I kept hitting the same problem on my desk: after sleep, wake, or reconnecting through a dock, macOS would bring my displays back in the wrong order or move the main display unexpectedly.
>
> I built LayoutRecall to solve that one job without pretending it can magically fix every display edge case. You save a known-good layout, the app watches for real display reconfiguration events, and it only auto-restores when the connected display set is a strong match. If confidence is lower, it stays manual and gives you direct recovery actions plus diagnostics.
>
> It is open source, there is a signed app release path, and there is also a Homebrew cask install path. If you use a MacBook or dock with two or more monitors, I would love feedback on whether the current trust model and recovery flow feel right.

### Hacker News draft

**Title:** Show HN: LayoutRecall — recover a known monitor layout on macOS

**Body:**

> LayoutRecall is a small macOS menu bar app for a very specific problem: external displays coming back in the wrong order after sleep, wake, or dock reconnects.
>
> The app lets you save a known-good layout profile, watches CoreGraphics display-change events, and restores automatically only when the current monitor set is a confident match. If it is not confident enough, it stays manual and shows recovery tools plus diagnostics instead.
>
> Real restore commands still go through `displayplacer`; the goal is not to replace that tool, but to wrap it in a safer everyday workflow.

### Social post draft

> macOS forgot your monitor layout again.
>
> LayoutRecall is the open-source menu bar app that saves a known-good setup and restores it after sleep, wake, or dock reconnects — with confidence-aware automation, manual recovery tools, and diagnostics when it should not guess.

## FAQ talking points for launch replies

### Why not just use `displayplacer` directly?

Because LayoutRecall handles profile capture, matching, confidence gating, manual recovery actions, and diagnostics in a menu bar workflow that is easier to trust day to day.

### Does it automatically fix every layout?

No. It deliberately prefers safe false negatives over risky false positives, so unsupported or low-confidence cases stay manual.

### Does it require `displayplacer`?

Yes for real restore commands. That should be framed as an honest dependency, not hidden.

### Is it only for identical monitors?

No, but identical or frequently reconnected monitors are one of the clearest pain cases because macOS often scrambles those desks in frustrating ways.

## Post-launch follow-up

- collect the first 10 pieces of feedback by failure mode: install friction, trust concerns, unsupported layouts, unclear copy, missing comparison
- update README FAQ based on repeated objections
- convert strong user phrases into future hero or social copy once real quotes exist
