# LayoutRecall OSS Marketing Program — Launch Plan

_Last updated: 2026-04-01_

## Launch objective

Ship a tighter OSS launch funnel that makes LayoutRecall look trustworthy, specific, and immediately useful to Mac users with recurring display-layout breakage.

## Launch thesis

This project should not launch as “yet another Mac utility.” It should launch as:

> **the OSS menu bar fix for Mac users tired of re-arranging the same monitors again and again.**

## Audience and channel fit

### Best first channels

1. **GitHub Releases / repo front page**
   - intent is high
   - users already expect install instructions and proof
2. **Reddit** (`r/macapps`, `r/mac`, targeted setup/productivity communities where allowed)
   - strong pain recognition potential
   - best for plain-language scenario framing
3. **Hacker News**
   - strongest when framed as a focused open-source utility with real implementation details
4. **Homebrew / release notes / changelog amplification**
   - useful for distribution reinforcement, not primary storytelling

## Sequencing

### Phase 0 — landing-page readiness

Before pushing launch posts, make sure the repo front page answers:

- what exact problem this solves
- who it is for
- why it is trustworthy
- how to install it in under a minute

### Phase 1 — owned surfaces

1. Update README hero and top funnel
2. Publish / polish release notes
3. Confirm GitHub Releases and Homebrew instructions match the README

### Phase 2 — community launch

1. Post concise GitHub release announcement
2. Adapt the same core story for Reddit
3. Publish a more builder-focused HN version

### Phase 3 — follow-through

1. Watch issues and comments for install friction
2. Capture repeated objections into FAQ / README updates
3. If a question appears more than twice, document it

## Message pillars for launch copy

### Pillar 1 — pain

macOS sometimes brings external monitors back in the wrong order, wrong origin, or wrong main-display state.

### Pillar 2 — solution

LayoutRecall saves a known-good layout profile and restores it when the current display set matches with high confidence.

### Pillar 3 — trust

It stays conservative, exposes diagnostics, and does not pretend every setup should restore automatically.

### Pillar 4 — OSS credibility

The repo includes real screenshots, signed release workflow, Homebrew distribution, tests, and docs.

## Launch checklist

### Product / repo checklist

- [ ] README hero rewritten around pain + proof
- [ ] install section validated for Releases and Homebrew
- [ ] diagnostics / trust story visible near the top
- [ ] screenshots and GIF/video align to the same narrative
- [ ] required program docs committed under `docs/marketing/programs/`

### Verification checklist

- [ ] `./scripts/run-ai-verify --mode full`
- [ ] release / install links checked manually
- [ ] generated asset paths valid

## GitHub launch copy

### Release headline

**LayoutRecall: put your Mac display layout back where it belongs**

### Release body draft

LayoutRecall is an open-source macOS menu bar utility for people whose external monitor layout keeps coming back wrong after sleep, wake, dock reconnect, or identical-monitor churn.

It lets you save a known-good desk layout, then restore it automatically only when the current display set matches with high confidence. When it is not safe to restore automatically, LayoutRecall keeps recovery manual and shows profile, confidence, dependency, and diagnostics context so you can decide what to do next.

Current highlights:

- saved layout profiles
- confidence-based automatic restore
- manual recovery actions like `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions`
- diagnostics history and verification context
- signed GitHub release builds and Homebrew install path

If multi-monitor Mac desk churn wastes your time every week, try it and tell us where the recovery flow still feels unclear.

## Reddit launch copy

### Recommended post title

**I built an open-source Mac menu bar app that restores my monitor layout after macOS scrambles it**

### Post body draft

I kept hitting the same problem on my MacBook + dock setup: after sleep, wake, or reconnecting displays, my monitors would come back in the wrong order or with the wrong main display.

So I built **LayoutRecall**, an open-source macOS menu bar utility that lets you save a known-good display layout and restore it later.

What I cared about most was making it feel safe enough to trust:

- it only restores automatically when the current display set matches a saved profile with high confidence
- it keeps recovery manual when confidence is low
- it shows diagnostics / profile context instead of hiding what happened
- it has GitHub release downloads and a Homebrew install path

Repo + downloads:

- GitHub: https://github.com/aroido/layoutrecall
- Releases: https://github.com/aroido/layoutrecall/releases

If you use a multi-monitor Mac setup, I’d love feedback on whether the install flow and trust story feel clear enough.

## Hacker News launch copy

### Recommended title

**Show HN: LayoutRecall – OSS macOS menu bar utility for restoring scrambled monitor layouts**

### Post body draft

LayoutRecall is an open-source macOS menu bar utility for a very specific desk problem: external displays returning in the wrong arrangement after sleep, wake, dock reconnect, or identical-monitor swaps.

The approach is intentionally conservative. You save a known-good layout profile, the app watches for real display changes, and it restores automatically only when the current display set matches a saved profile with high confidence. Otherwise it stays manual and surfaces diagnostics / recovery context instead of guessing.

I wanted something that felt more trustworthy than a purely manual `displayplacer` habit, but also less opaque than a background tool that moves monitors without explanation.

The repo includes release automation, Homebrew distribution, diagnostics, and generated screenshots from the real app UI.

Feedback I’m especially looking for:

- does the trust model make sense?
- is the install/setup path clear enough?
- what would make you comfortable leaving a tool like this running in the menu bar?

## Comment-response guidance

### If users ask “why not just use displayplacer?”

Because LayoutRecall adds saved profiles, confidence-gated restore behavior, and visible diagnostics on top of that workflow.

### If users ask “is it safe?”

Answer with the conservative restore model first, then point to diagnostics and manual fallback paths.

### If users ask “what are the limits?”

Be explicit:

- it still relies on `displayplacer` for real restore execution
- it is most comfortable today on common 2–3 display desk setups
- it prefers false negatives over risky false positives

## Post-launch learning loop

Track and fold back into docs:

1. install failures
2. dependency confusion (`displayplacer`, Homebrew, permissions)
3. trust objections (“what will it do automatically?”)
4. unsupported-layout questions
5. screenshot / demo confusion

Anything repeated across GitHub + Reddit + HN should become README FAQ copy.
