# LayoutRecall OSS Launch Plan

_Date: 2026-04-01_

## Launch goal

Increase qualified OSS interest from multi-monitor macOS users by pairing a clearer README with assets and posts that emphasize pain specificity, safety, and fast evaluation.

## Launch thesis

LayoutRecall is most compelling when introduced as:

- a practical macOS recovery tool
- for repeat display-layout breakage
- with safe automation and visible manual fallback
- ready to try from a signed DMG or Homebrew

## Target audience order

1. Developers with MacBook + dock + external monitors
2. Power users already using `displayplacer`, BetterDisplay, or shell scripts
3. Creators and operators whose desk layout must stay stable
4. Broader Mac productivity / menu bar utility audiences

## Channel sequencing

### Phase 1 — Repository conversion

Ship first:

- updated positioning doc
- updated asset direction doc
- updated launch copy
- README hero / top-of-page improvements from other implementation lanes

Reason:

Do not send traffic before the repo explains itself clearly.

### Phase 2 — Owned launch surfaces

Primary channels:

1. GitHub release notes / repository announcement
2. README + social card refresh
3. short GIF/MP4 demo on repo and social surfaces

### Phase 3 — Community launch surfaces

Priority order:

1. Reddit communities for Mac productivity / setup / developer workflows
2. Hacker News “Show HN” style launch if the framing stays technical and honest
3. X / Mastodon / Bluesky follow-up posts using the social card and short demo

## Launch blockers to clear before broad posting

- README must clearly explain `displayplacer` instead of burying it.
- Trust language must explain conservative auto-restore behavior.
- Install path must look easy enough to try in minutes.
- Screenshot/GIF captions must explain the product without requiring a full README read.

## Message pillars

### Pillar 1 — Pain specificity

This is for people whose monitor layout keeps breaking—not for general window management.

### Pillar 2 — Safe recovery

LayoutRecall does not pretend to be magic. It restores automatically when confidence is high and stays manual when it is not.

### Pillar 3 — Low-friction trial

Install it, save one layout, and wait for the next display scramble.

## Recommended proof points to repeat

- macOS menu bar utility for multi-display recovery
- saves known-good layouts
- reacts to sleep, wake, and dock reconnect scenarios
- `Fix Now`, `Apply Layout`, `Show Numbers`, diagnostics
- signed DMG and Homebrew install paths
- open source, explicit about using `displayplacer`

## Launch copy pack

### GitHub / release announcement

**Title**

LayoutRecall: open-source macOS display-layout recovery from the menu bar

**Body**

If your Mac keeps bringing external displays back in the wrong order after sleep, wake, or dock reconnect, I built LayoutRecall to make recovery much less annoying.

LayoutRecall is a macOS menu bar app that lets you save a known-good monitor layout and restore it later—automatically when the match is confident, or manually with clear recovery tools when you want control.

What it already does:

- save and manage display layout profiles
- attempt high-confidence automatic restore
- surface `Fix Now`, `Apply Layout`, and `Show Numbers`
- keep diagnostics so you can see what happened
- install `displayplacer` through the app flow when needed

If you have a desk setup that macOS scrambles often, I would love feedback on your workflow, hardware mix, and where recovery still feels unclear.

### Reddit post

**Title**

I made an open-source macOS menu bar app to restore broken monitor layouts after dock reconnects

**Body**

macOS occasionally brings my external displays back in the wrong order after sleep/wake or reconnecting a dock, so I built LayoutRecall.

It is a small menu bar utility that saves a known-good display layout and restores it later. The part I cared about most was not making it feel reckless: it only auto-restores when the match is confident, and otherwise it keeps recovery manual with `Fix Now`, `Apply Layout`, `Show Numbers`, and diagnostics.

It is open source, supports a signed DMG and Homebrew install path, and uses `displayplacer` for the actual layout commands.

If you have a multi-monitor Mac desk and this problem drives you crazy too, I would really appreciate feedback.

### Hacker News / Show HN post

**Title**

Show HN: LayoutRecall, a macOS menu bar utility for restoring broken multi-monitor layouts

**Body**

I built LayoutRecall after getting tired of macOS bringing identical or frequently reconnected monitors back in the wrong arrangement.

It is a menu bar app that saves known display layouts and restores them when the connected monitor set matches a saved profile. It is intentionally conservative: automatic restore only happens when confidence is high, and otherwise the app stays manual and shows recovery actions plus diagnostics.

The project is open source, installs via DMG or Homebrew, and uses `displayplacer` for actual restore execution.

I would especially love feedback from people with laptop + dock + multi-monitor desk setups.

### Short social post

Your Mac should not make you rebuild your monitor layout after every dock reconnect.

LayoutRecall is an open-source menu bar app for macOS that saves known-good display layouts and restores them later—with safe automation when confidence is high and clear manual recovery when it is not.

## Community-response plan

When comments arrive, prioritize answering:

1. What hardware setup was LayoutRecall built for?
2. Why use `displayplacer` instead of hiding it?
3. Can the app be trusted not to move displays blindly?
4. What happens when the match is uncertain?
5. Does it work without `displayplacer` installed?

## Success criteria for the first launch wave

- README conversion improves: clearer who/why/trust/try-now messaging
- launch posts generate feedback from real multi-monitor users, not generic “looks neat” reactions
- the most common replies are about workflow fit or hardware edge cases, not confusion about what the app does
- follow-up issues or discussions produce actionable trust/setup feedback
