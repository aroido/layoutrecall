# LayoutRecall OSS Positioning Program

_Date: 2026-04-01_

## Program goal

Make LayoutRecall feel immediately relevant, trustworthy, and worth trying for macOS users whose external-monitor layouts keep breaking after sleep, wake, dock reconnect, or cable churn.

## Current audit snapshot

### What already works in LayoutRecall's favor

- The product problem is painfully real for developers, creators, and operators with multi-display desks.
- The app already has concrete proof points: saved profiles, auto-restore, `Fix Now`, `Show Numbers`, diagnostics, shortcuts, language selection, and a `displayplacer` install flow.
- The repo already includes real generated UI stills plus a demo GIF/MP4 under `docs/marketing/generated/final/`.
- README install paths are short and credible: signed DMG plus Homebrew.

### What is underperforming right now

- The README opens with a correct but flat description; it does not immediately sell the severity of the pain or the speed of the recovery.
- Trust signals exist, but they are buried below the fold instead of being framed as “safe automation with visible proof.”
- Screenshot and demo assets exist, but the product story is not tightly connected to them.
- The README assumes the reader already understands `displayplacer`, confidence thresholds, and why the app is safer than a script.
- There is no launch-ready messaging hierarchy that ties README, visuals, and channel posts into one funnel.

## Who should use LayoutRecall first

### Primary initial user

**MacBook + dock + 2-3 external-display users whose desk setup breaks often enough to create daily friction.**

Most likely early adopters:

- developers working from a docked laptop setup
- designers, video editors, and creators with one stable “known good” desk layout
- analysts / operators / traders who care about exact left-right monitor order
- technical Mac users already aware of `displayplacer`, BetterDisplay, or DIY recovery scripts

### Why this user first

They already feel the pain, understand what “monitor layout drift” means, and care about predictable recovery more than flashy window-management promises.

## Why they should trust LayoutRecall

LayoutRecall is credible when framed around **conservative automation, visible evidence, and real recovery controls**.

Trust anchors to emphasize:

1. **It only auto-restores when confidence is high.**
2. **It stays manual when uncertain instead of gambling with your desk.**
3. **It exposes proof and recovery tools in the menu bar and diagnostics.**
4. **It is open source and explicit about using `displayplacer` for actual layout changes.**
5. **It already ships practical controls beyond automation:** `Fix Now`, `Apply Layout`, `Show Numbers`, `Swap Positions`, diagnostics history, and dependency guidance.

## Why they should download it now

### Immediate payoff

- It solves a painful, repeated workflow interruption today.
- It offers faster recovery than re-arranging monitors manually after every glitch.
- It is safer than a blind auto-run script because it exposes confidence, diagnostics, and manual fallback actions.
- It has low evaluation cost: install, save one known-good profile, and wait for the next macOS monitor scramble.

### Honest urgency line

**If macOS rearranges your displays even a few times a week, LayoutRecall can pay for itself on day one.**

## Messaging hierarchy

### Headline territory

**Restore your Mac's display layout before broken monitor order breaks your flow.**

### Subheadline territory

LayoutRecall is a macOS menu bar app that saves known-good monitor layouts and restores them after sleep, wake, dock reconnect, and identical-monitor shuffle—automatically when confidence is high, manually when you want control.

### Three supporting proof bullets

- Save a known-good layout once, then recover it in a click—or automatically when the match is clear.
- See confidence, dependency, and diagnostic context before you trust the app to move your screens.
- Recover with `Fix Now`, `Apply Layout`, and `Show Numbers` instead of dragging displays around System Settings again.

## Conversion blockers audit

### Skeptical-user ranking: “would bounce” severity

| Rank | Blocker | Why a skeptical OSS user would bounce |
| --- | --- | --- |
| 1 | README hero is descriptive but not urgent | It does not instantly answer “is this for my exact desk pain?” |
| 2 | Trust model is not prominent enough | Users may fear a utility that can move displays automatically |
| 3 | `displayplacer` dependency is mentioned, not framed | Readers may interpret it as brittle setup debt instead of transparent execution design |
| 4 | Visual funnel is under-narrated | Existing screenshots/GIF are real, but the story they prove is not explicit |
| 5 | “Why now” is weak | The current README explains behavior better than value |
| 6 | Install/evaluate path lacks an explicit fast-start promise | Users do not get a strong “3 minutes to first saved profile” expectation |
| 7 | Competitive framing is absent | Readers cannot quickly distinguish LayoutRecall from generic window/display tools or shell scripts |

## Product marketing lead prioritization

### Must

1. Rewrite hero around pain + promise + safety.
2. Surface trust model above the fold: high-confidence auto-restore, manual fallback, diagnostics.
3. Reframe installation around quick evaluation and honest `displayplacer` dependency language.
4. Tie screenshots and demo assets to a simple three-step story: save, detect, recover.
5. Publish launch copy that targets multi-monitor macOS users instead of generic productivity audiences.

### Should

1. Add comparison language vs manual rearranging, scripts, and generic display utilities.
2. Add a short FAQ for “Will this move my displays blindly?”, “Why `displayplacer`?”, and “Will it work without it?”
3. State tested target more clearly: macOS 13+, Apple Silicon primary target.

### Could

1. Add user-scenario callouts for dev / creator / trading desks.
2. Add a “what it does not do” section earlier in the funnel.
3. Add a lightweight “before / after sleep-wake chaos” visual caption set.

## Positioning statement

**For macOS users with repeat display-layout breakage, LayoutRecall is the open-source menu bar recovery tool that restores a known-good monitor setup safely and visibly—so you spend less time dragging displays back into place and more time getting back to work.**

## Proof language to reuse

- Safe automation, not blind automation.
- Built for repeat monitor-layout breakage, not generic desktop tweaking.
- Save once, recover fast.
- Clear when confident. Manual when not.
- Open-source recovery for real multi-monitor desks.

## Acceptance criteria for downstream README / asset work

The top-of-funnel materials should make a new visitor understand all three within seconds:

1. **Who this is for:** multi-monitor Mac users with repeat layout breakage.
2. **Why it is trustworthy:** conservative automation plus visible proof and manual controls.
3. **Why act now:** it can remove repeated daily friction immediately.
