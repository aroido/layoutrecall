# LayoutRecall launch copy pack

Use this file as the ready-to-post companion to the final README and asset set.

## Core framing

- **Primary audience:** MacBook + dock + 2-3 external display users whose monitor order keeps breaking after sleep, wake, or reconnect.
- **Primary promise:** Restore a known display layout after macOS scrambles it.
- **Trust promise:** LayoutRecall only auto-restores when confidence is high, and stays manual when it is not.
- **Install CTA:** Download the signed DMG from GitHub Releases or install via Homebrew.

## README-above-the-fold copy

### Headline

**Stop re-fixing your monitor layout every time macOS forgets it.**

### Subheadline

LayoutRecall is the open-source macOS menu bar app for laptop + dock desk setups that come back scrambled after sleep, wake, or reconnect.

### Proof bullets

- Save a known-good layout profile from the desk you already use.
- Restore it automatically when the connected monitor set is a confident match.
- Fall back to `Fix Now`, `Apply Layout`, `Show Numbers`, and diagnostics when automation is unsafe.

### Install CTA block

- **Download:** GitHub Releases DMG
- **CLI install:** `brew install --cask aroido/layoutrecall/layoutrecall`
- **Dependency note:** `displayplacer` is required for real restore commands, but the app explains dependency state and does not guess when setup is incomplete.

## Asset + caption map

### `readme-hero.png`

**Caption:** Save a known-good monitor layout, then restore it after sleep, wake, or dock reconnect — without blindly guessing.

### `layoutrecall-demo.gif`

**Caption:** Watch a scrambled desk return to a saved profile, with confidence-aware recovery and visible fallback controls.

### `readme-feature-trust.png`

**Caption:** Confidence, dependency, and recent restore evidence stay visible so the app can explain what it did — or why it refused to act.

### `readme-feature-profiles.png`

**Caption:** Save multiple desk profiles, tune restore confidence, and keep one-click recovery controls close when you want to intervene.

### `social-card.png`

**Caption:** macOS forgot your monitor layout. LayoutRecall brings it back.

## GitHub release / repo announcement

### Title

**LayoutRecall — restore scrambled macOS monitor layouts from the menu bar**

### Body

LayoutRecall is an open-source macOS menu bar app for people whose external monitor layout comes back wrong after sleep, wake, or dock reconnect.

It lets you save a known-good display layout, then restore it automatically when confidence is high — or recover manually with clear controls when it is not.

What you get today:

- saved display layout profiles
- high-confidence automatic restore
- direct `Fix Now`, `Apply Layout`, and `Show Numbers` recovery controls
- diagnostics and dependency visibility
- signed GitHub Releases and Homebrew install paths

If your desk setup keeps drifting and you want a focused fix instead of another display-management experiment, LayoutRecall is ready to try.

## Reddit post

### Title

I built a macOS menu bar app to restore monitor layouts after sleep/wake/dock reconnect scrambles them

### Body

I kept hitting the same problem on my MacBook desk setup: after sleep, wake, or reconnecting a dock, identical monitors would come back in the wrong order or wrong position.

So I built **LayoutRecall**, a small macOS menu bar utility that saves a known layout and restores it later.

A few details that matter:

- it only auto-restores when the match is confident,
- if confidence is low, it stays manual instead of guessing,
- there are direct recovery actions like `Fix Now`, `Apply Layout`, and `Show Numbers`,
- it surfaces diagnostics and dependency state instead of hiding them.

It is open source, available through GitHub Releases and Homebrew, and aimed at people with real multi-monitor desk setups — especially laptop + dock users.

If you try tools like this, I would especially love feedback on install clarity and whether the restore behavior feels trustworthy.

## Hacker News / Show HN

### Title options

- Show HN: LayoutRecall — restore scrambled macOS monitor layouts
- Show HN: LayoutRecall, a menu bar app for broken external display layouts on macOS

### Body

I built LayoutRecall because macOS kept returning my external monitors in the wrong order after sleep, wake, and dock reconnects.

The app is intentionally narrow: save a known-good display layout, detect when the connected monitor set matches it again, and restore that layout from a menu bar app.

A few design decisions were important:

- automatic restore is conservative and only runs on high-confidence matches,
- lower-confidence cases stay manual instead of guessing,
- users can inspect diagnostics and run direct recovery actions,
- the project stays honest about limits like the `displayplacer` dependency and more complex 4+ display scenarios.

The repo includes a signed release path, Homebrew install, real UI screenshots, and a short demo asset.
