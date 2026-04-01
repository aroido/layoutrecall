# LayoutRecall launch copy pack

Use this file to keep GitHub, Reddit, HN, and README copy aligned with the current asset set.

## Core positioning

**Stop re-fixing your monitor layout every time macOS forgets it.**

LayoutRecall is the open-source macOS menu bar app for MacBook + dock + multi-display desks. Save a known-good layout once, then restore it after sleep, wake, or reconnect — automatically when the match is confident, manually when it is not.

## Asset captions

- `readme-hero.png`: Save one known-good desk, then bring it back without blind guesses.
- `layoutrecall-demo.gif` / `.mp4`: Watch the desk drift, the saved profile get recognized, and recovery stay confidence-aware.
- `readme-feature-trust.png`: LayoutRecall shows confidence, dependency state, and diagnostics before it moves your monitors.
- `readme-feature-profiles.png`: Save multiple desk profiles and keep manual fallback controls close by.
- `social-card.png`: macOS forgot your monitor layout. LayoutRecall brings back the desk you trust.

## GitHub release / repo announcement

### Title

LayoutRecall — restore scrambled macOS monitor layouts from the menu bar

### Body

LayoutRecall is a macOS menu bar utility for people whose external monitor layout comes back wrong after sleep, wake, or reconnect.

It lets you save a known-good display layout, then restore it automatically when confidence is high — or recover manually with clear controls when it is not.

What ships in the current baseline:

- saved display layout profiles
- high-confidence automatic restore
- manual `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions`
- diagnostics and dependency visibility
- GitHub Releases and Homebrew install paths

If your desk setup keeps drifting and you want a focused fix instead of a giant display-management suite, LayoutRecall is ready to try.

## Reddit post

### Title

I built a macOS menu bar app to restore monitor layouts after sleep/wake/dock reconnect breaks them

### Body

I kept hitting the same problem on my MacBook desk setup: after sleep, wake, or reconnecting a dock, identical monitors would come back in the wrong order or wrong position.

So I built **LayoutRecall**, a small macOS menu bar utility that saves a known layout and restores it later.

What matters most:

- it only auto-restores when the match is confident
- if confidence is low, it stays manual instead of guessing
- there are direct recovery actions like `Fix Now`, `Apply Layout`, and `Show Numbers`
- it surfaces diagnostics and dependency state instead of hiding them

It is open source, available through GitHub Releases and Homebrew, and aimed at people with repeat multi-monitor desk setups.

## Show HN

### Title options

- Show HN: LayoutRecall — restore scrambled macOS monitor layouts
- Show HN: LayoutRecall, a menu bar app for broken macOS external display layouts

### Body

I built LayoutRecall because macOS kept returning my external monitors in the wrong order after sleep, wake, and dock reconnects.

The app is intentionally narrow: save a known-good display layout, detect when the connected monitor set matches it again, and restore that layout from a menu bar app.

A few design decisions mattered:

- automatic restore is conservative and only runs on high-confidence matches
- lower-confidence cases stay manual instead of guessing
- users can inspect diagnostics and run direct recovery actions
- the project stays honest about limits like the `displayplacer` dependency and more complex 4+ display scenarios
