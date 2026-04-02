# LayoutRecall Product Summary

_Last updated: 2026-04-02_

## Exact user problem

When a MacBook + dock + multi-display desk wakes, reconnects, or reorders identical monitors, macOS can bring the displays back in the wrong arrangement. The user already knows the one layout they want. They need a lightweight tool that can bring that known layout back quickly, automatically when it is clearly safe, and manually when it is not.

## One-line definition

LayoutRecall is a macOS menu bar app that restores one known display profile after sleep, wake, or reconnect, automatically when the match is trustworthy and manually when it is not.

## Product promise

- save one known-good desk layout as a profile
- restore it automatically only when the current desk clearly matches
- keep manual recovery one click away when automation is unsafe
- explain why the app acted or refused to act
- stay small, predictable, and menu-bar-first

## Core product shape

LayoutRecall is not a general display-management suite.
It is a **known-layout recovery utility**.

That means the product should optimize for:
1. one clear restore model
2. one clear saved-profile model
3. one clear fallback path
4. clear safety signals

## Keep / merge / remove-or-demote decisions

### Keep

- **Profile** as the single saved-layout object
- **Auto Restore** when confidence is high enough
- **Restore Now** as the single manual recovery CTA
- **Apply Layout** as the profile-specific action inside Profiles
- **Show Numbers** as a support utility for mapping displays
- **Dependency setup** for `displayplacer`
- **Diagnostics** as a support surface

### Merge / simplify

- Merge the product story around **one primary manual recovery action**: `Restore Now`
- Treat `Apply Layout` as the profile-specific variant of restore, not a separate product pillar
- Treat `Show Numbers` as a utility within recovery/profile management, not a standalone feature area
- Treat settings as a simple three-pane model: **Restore / Profiles / General**

### Remove or demote

- **Swap Positions** is demoted from a core feature to an advanced/manual fallback utility
- **Shortcuts** are demoted to advanced convenience, not a core workflow
- **Update controls, launch at login, language choice** remain product features but are general preferences, not part of the core recovery story
- **Per-profile auto-restore** is not part of the product baseline and should not be documented as a supported feature

## Canonical user flows

### 1. Save the desk once

1. Arrange displays the way you want.
2. Save the current layout as a profile.
3. LayoutRecall stores the restore command and matching metadata.

### 2. Restore automatically when safe

1. Sleep, wake, or reconnect triggers a display event.
2. LayoutRecall checks whether the current display set strongly matches the saved profile.
3. If the match is strong enough and dependency/setup is ready, the app restores automatically.
4. The app verifies the result and records diagnostics.

### 3. Restore manually when not safe

1. The menu explains why auto restore did not run.
2. The user clicks **Restore Now**.
3. If needed, the user can inspect **Show Numbers** or open **Diagnostics**.

## Information architecture

### Menu bar

The menu exists to answer four questions quickly:
1. Is the app ready?
2. Did it find the right profile?
3. Why did it not restore automatically?
4. What should I do next?

Primary menu responsibilities:
- current restore state
- main recovery CTA
- Auto Restore toggle
- utility shortcuts (`Show Numbers`, diagnostics, save profile)

### Settings

Use a simple three-pane model:

- **Restore** — current state, Auto Restore, recommended action, dependency readiness
- **Profiles** — save/manage profiles, confidence threshold, apply layout, show numbers
- **General** — diagnostics, launch at login, updates, language, shortcuts, advanced preferences

## Non-goals

LayoutRecall does **not** aim to be:
- a full display-management suite
- a tool for arbitrary layout experimentation
- a broad four-plus-display rearrangement engine
- a per-app window placement manager
- a cloud sync tool
- a replacement for `displayplacer`

## Known limitations to communicate clearly

- `displayplacer` is still required for real layout changes.
- Auto Restore is intentionally conservative.
- `Swap Positions` is a limited fallback utility, not a primary workflow.
- Some hardware-heavy tests remain opt-in.

## Product priorities after this definition pass

1. Make restore trust signals easier to read.
2. Reduce duplicate or overlapping recovery actions.
3. Keep profile management simple and obvious.
4. Make degraded states clearer without expanding the feature set.
