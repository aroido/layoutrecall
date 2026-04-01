# LayoutRecall OSS launch plan

_Date:_ 2026-04-01  
_Scope:_ launch sequencing, channel copy, and trust-first conversion plan for the current LayoutRecall baseline

## 1. Launch goal

Turn LayoutRecall from "useful but easy to skip" into a GitHub-first OSS download that:

1. looks real and polished enough to click,
2. explains the recovery problem in one glance,
3. gives cautious macOS users enough proof to install it now.

Primary conversion event for this launch: **download or install intent** via GitHub Releases / Homebrew.

## 2. First user to target

### Who should use LayoutRecall first

**MacBook + dock + 2-3 external monitor users whose display order keeps breaking after sleep, wake, or reconnect.**

Best first audience segments:

- developers with a desk setup that resets after undocking/redocking,
- designers, video editors, and creators with left/right monitor muscle memory,
- analysts / operators who need stable monitor placement every day.

### Why they should trust it

Trust proof already present in the repo and product:

- real macOS menu bar app, not a concept mockup,
- actual screenshots and demo assets generated from app UI,
- conservative restore model: auto-restore only on high-confidence matches,
- manual recovery options when automation is not safe,
- diagnostics, verification, and visible dependency status,
- MIT license, GitHub Releases, Homebrew cask, and documented build/test flow.

### Why they should download it now

- the problem is recurring and painful, not aspirational,
- LayoutRecall already ships the baseline workflow users need today,
- install paths are clear enough for both download-first and Homebrew-first users,
- the product promise is narrow and honest: restore known layouts safely, not "magically fix everything."

## 3. Funnel audit and conversion blockers

## Current funnel shape

1. User sees a post or GitHub page.
2. README explains the problem and features.
3. User decides whether the app feels trustworthy enough to install.
4. User picks DMG or Homebrew.
5. User opens the app and saves a first layout.

## Skeptical-user blocker ranking

| Rank | Blocker | Bounce severity | Why it makes users leave |
| --- | --- | --- | --- |
| 1 | README opens with utility language instead of an instantly recognizable "my monitors got scrambled again" pain statement | Would bounce immediately | Users must self-translate the product before caring |
| 2 | Trust proof is present but scattered across README sections instead of concentrated near the hero | Would bounce fast | macOS utility downloads need immediate safety signals |
| 3 | Install flow does not foreground the simplest first-run path and dependency expectations together | Would bounce during evaluation | Users fear hidden setup work or terminal surprise |
| 4 | Asset story exists, but channel copy does not yet turn screenshots/demo into a cohesive launch narrative | Would bounce after first skim | The project can look polished but still feel "unfinished" |
| 5 | README describes capabilities well, but does not sharply separate safe automatic restore from manual fallback in launch language | Medium-high | Users may worry it is too risky or too limited |
| 6 | OSS launch copy is missing, so every channel would require ad hoc rewriting | Medium | Inconsistent positioning reduces conversion quality |

## Product marketing prioritization

### Must

- lead with the scrambled-monitor pain in every public surface,
- place trust proof near the hero,
- make install + dependency expectations obvious,
- reuse real-app visuals with captions that explain safety and control,
- ship ready-to-post launch copy for GitHub, Reddit, and HN.

### Should

- highlight the exact "safe auto / clear manual" split,
- show one screenshot focused on diagnostics/trust,
- include one concise FAQ block for dependency and supported layouts.

### Could

- create short follow-up clips for specific desk setups,
- add user quote snippets once early feedback exists,
- prepare a separate productivity-focused social thread.

## 4. Launch positioning to keep consistent

### Core message

**Stop rebuilding your monitor layout every time macOS forgets it — LayoutRecall restores a known setup when confidence is high and stays manual when it is not.**

### Message pillars

1. **Recognizable pain:** identical monitors return in the wrong order after sleep, wake, or docking.
2. **Safe recovery:** the app is conservative and will not auto-fire when confidence is weak.
3. **Practical control:** users can fix the layout now, apply a profile, show numbers, or inspect diagnostics.
4. **Low-friction tryout:** menu bar utility, Homebrew option, release downloads, documented setup.

### Claims to avoid

Do **not** imply:

- perfect prevention of every macOS display issue,
- magical no-setup recovery without `displayplacer`,
- strong support for complex 4+ display rearrangement beyond documented boundaries.

## 5. Asset usage plan

Use the current generated assets as a funnel, not as isolated files.

| Funnel stage | Asset | Job |
| --- | --- | --- |
| GitHub hero / top-of-page | `docs/marketing/generated/final/readme-hero.png` | Show the app is real, branded, and menu-bar-first |
| Trust explainer | `docs/marketing/generated/final/readme-feature-trust.png` | Reinforce safety, diagnostics, and confidence language |
| Capability explainer | `docs/marketing/generated/final/readme-feature-profiles.png` | Explain profile save/apply workflow quickly |
| Social / link preview | `docs/marketing/generated/final/social-card.png` | Carry the same pain → safety → action framing into shares |
| Demo proof | `docs/marketing/generated/final/layoutrecall-demo.gif` and `.mp4` | Show before/after recovery concept without a noisy screen recording |

### Recommended caption style

- Caption visuals with concrete outcomes, not feature labels.
- Prefer phrases like **"Restore a known layout safely"** over **"Confidence-based profile matching."**
- Pair every automation claim with a safety qualifier when relevant.

## 6. Channel plan and timing

## T-2 to T-1 days: prep

- finalize README hero + trust section,
- ensure release page points to DMG and Homebrew paths clearly,
- confirm GIF/MP4 render cleanly on GitHub and social previews,
- verify launch copy matches actual shipped behavior,
- run full repo verification before posting.

## Launch day sequence

### Step 1 — GitHub first

- publish or refresh the GitHub Release,
- ensure README top section reflects launch-ready positioning,
- pin the demo visual near the top.

### Step 2 — Hacker News / Show HN

- post after GitHub is fully ready,
- aim the text at developers with recurring monitor-layout pain,
- lean on honest boundaries and conservative automation as trust builders.

### Step 3 — Reddit

Suggested communities to evaluate manually for fit/rules:

- r/macapps
- r/mac
- r/apple
- a relevant developer/productivity setup subreddit if self-promo rules allow

Use a more problem-first, less "launch announcement" tone than HN.

### Step 4 — follow-up GitHub / social snippets

- clip one visual into follow-up posts,
- answer install questions quickly,
- convert repeated questions into README / FAQ improvements.

## 7. Launch-ready copy pack

## GitHub release / repo announcement

### Title

**LayoutRecall — stop re-fixing scrambled macOS monitor layouts**

### Body

LayoutRecall is the open-source macOS menu bar app for MacBook + dock + multi-display desks that come back scrambled after sleep, wake, or reconnect.

Save a known-good display layout once, then restore it automatically when confidence is high — or recover manually with clear controls when it is not.

What ships in the current baseline:

- saved display layout profiles,
- high-confidence automatic restore,
- manual `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions`,
- diagnostics and dependency visibility,
- signed GitHub Releases and Homebrew install paths.

If your MacBook + dock setup keeps drifting and you want a focused fix instead of a giant display-management suite, LayoutRecall is ready to try.

## Reddit post

### Title

I built a macOS menu bar app because I got tired of re-fixing my monitor layout after every dock reconnect

### Body

I kept hitting the same problem on my MacBook desk setup: after sleep, wake, or reconnecting a dock, identical monitors would come back in the wrong order or wrong position.

So I built **LayoutRecall**, an open-source macOS menu bar app that saves a known layout and brings it back later.

A few details that matter:

- it only auto-restores when the match is confident,
- if confidence is low, it stays manual instead of guessing,
- there are direct recovery actions like `Fix Now`, `Apply Layout`, and `Show Numbers`,
- it surfaces diagnostics and dependency state instead of hiding them.

It is open source, available through signed GitHub Releases and Homebrew, and aimed at people with real multi-monitor desk setups — especially laptop + dock users.

If you try tools like this, I would especially love feedback on install clarity and whether the restore behavior feels trustworthy.

## Hacker News / Show HN

### Title options

- Show HN: LayoutRecall — stop re-fixing scrambled macOS monitor layouts
- Show HN: LayoutRecall, a menu bar app for broken macOS external display layouts

### Body

I built LayoutRecall because macOS kept returning my external monitors in the wrong order after sleep, wake, and dock reconnects.

The app is intentionally narrow: save a known-good display layout, detect when the connected monitor set matches it again, and restore that layout from a menu bar app instead of making users manually rebuild the same desk every time.

A few design decisions were important:

- automatic restore is conservative and only runs on high-confidence matches,
- lower-confidence cases stay manual instead of guessing,
- users can inspect diagnostics and run direct recovery actions,
- the project stays honest about limits like the `displayplacer` dependency and more complex 4+ display scenarios.

Repo includes signed releases, Homebrew install, screenshots generated from the real UI, and a short demo asset.

Happy to answer questions about the matching/safety model, the macOS menu bar architecture, or why I kept the product narrow instead of turning it into a full display-management suite.

## 8. FAQ topics to expect on launch

Prepare short answers for:

1. **Does it work without `displayplacer`?**  
   The app runs, but real layout restore requires `displayplacer` to be available.

2. **Will it move my monitors automatically every time?**  
   No. It only auto-restores when the saved profile match is strong enough.

3. **Does it support very complex 4+ monitor setups?**  
   Some advanced arrangements remain manual/review-heavy on purpose.

4. **Can I use it without Homebrew?**  
   Yes. The primary download path is the release DMG.

5. **What kind of user is this best for?**  
   People with repeatable desk setups who want the same layout back quickly after reconnect churn.

## 9. Success metrics for the first launch wave

Track qualitatively first, then quantitatively:

- GitHub stars / watchers after launch,
- release downloads and Homebrew install interest,
- comments mentioning immediate problem recognition,
- questions about trust/safety/install friction,
- repeated objections that suggest README or onboarding changes.

A good first-wave signal is not just traffic — it is users saying **"this is exactly my problem"** and feeling safe enough to install.

## 10. Execution checklist

- [ ] README hero and top section match this message stack
- [ ] trust screenshot and demo are placed near install intent
- [ ] release notes use the GitHub copy above as a base
- [ ] Homebrew and DMG paths are both visible on launch day
- [ ] FAQ answers are easy to find
- [ ] `./scripts/run-ai-verify --mode full` passes before final launch claim
