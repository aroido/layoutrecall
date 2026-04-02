# LayoutRecall marketing positioning

_Last updated: 2026-04-01_

## Product frame

LayoutRecall is the open-source macOS menu bar app for people whose monitor layout gets scrambled after sleep, wake, dock reconnect, or identical-display churn.

It should be presented as a **practical desk-recovery utility**, not as a speculative window manager, experimental display hacker toy, or future roadmap promise.

## Who should use LayoutRecall first

### Primary audience

**MacBook + dock + 2+ external display users who repeatedly lose a known-good desk layout.**

Typical first adopters:

- developers working between a laptop and identical external monitors
- creators with layout-sensitive preview or editing workspaces
- operators, analysts, or traders who depend on stable left/right screen placement
- remote workers who reconnect to the same desk multiple times per day

### Secondary audience

- Mac mini or Mac Studio users with recurring cable / KVM / dock churn
- power users already using `displayplacer` who want a safer menu bar workflow on top

### Users to de-prioritize in the hero

- single-display laptop users
- users looking for window tiling or app-placement automation
- users expecting magical recovery for every four-plus-display edge case

## Why they should trust LayoutRecall

LayoutRecall earns trust when the marketing consistently shows that the app is:

1. **Built around a real pain** — monitor order and main-display state breaking after reconnects.
2. **Conservative by design** — automatic restore happens only when confidence is high.
3. **Transparent when it does not act** — the app explains blocked auto-restore decisions and surfaces manual recovery actions.
4. **Grounded in real workflows** — saved profiles, `Restore Now`, `Apply Layout`, `Show Numbers`, and diagnostics already exist today.
5. **Low-friction to try** — signed app download, Homebrew cask, and OSS code visibility reduce adoption fear.

## Why they should download it now

- The current branch already ships a usable baseline instead of a concept demo.
- The app solves a specific, recurring desk problem that users feel immediately after install.
- It already includes trust signals that competing quick hacks usually skip: confidence gating, diagnostics, and manual fallbacks.
- OSS users can evaluate the code, install path, and current product boundaries before committing.

## Core message hierarchy

### One-line positioning

**Stop re-fixing your monitor layout every time macOS forgets it.**

### Supporting message

LayoutRecall saves a known-good display setup, watches for real reconfiguration events, and restores only when the connected monitor set is a confident match.

### Trust message

When automatic restore is unsafe, LayoutRecall stays manual on purpose and shows the next best recovery action instead of guessing.

## Proof points to surface repeatedly

- menu bar utility with saved layout profiles
- confidence-based automatic restore
- manual recovery tools: `Restore Now`, `Apply Layout`, `Show Numbers`, `Swap Positions`
- diagnostics history for recent restore decisions
- signed app + Homebrew install path
- open-source codebase with current docs and verification workflow

## Conversion blockers audit

- README still needs to open with a pain-to-outcome promise instead of a neutral description.
- Trust framing needs to appear earlier so cautious users understand the safety model before install details.
- Install and dependency caveats need to follow proof, not interrupt the first-scroll story.
- README visuals need to lead with the strongest hero/demo assets instead of feeling secondary.
- The page needs a faster “macOS scramble vs LayoutRecall recovery” comparison for skeptical scanners.
- Launch copy needs a reusable pack so GitHub, Reddit, and HN do not drift from the core message.
- Product limits should read like intentional safety boundaries, not accidental weakness.

| Rank | Blocker | Severity | Why people bounce |
| --- | --- | --- | --- |
| 1 | README opens with a factual description, not a sharp pain-to-outcome promise | Would bounce | Users do not immediately see why this is worth trying now |
| 2 | Trust model is buried instead of being framed as a product advantage | Would bounce | Automatic monitor movement feels risky without an explicit safety story |
| 3 | Install + dependency caveats appear before confidence-building proof | Would bounce | OSS visitors can misread the app as fragile or high-maintenance |
| 4 | README does not currently lead with the strongest generated visuals | Major | The repo undersells polish even though branded assets already exist |
| 5 | There is no obvious quick comparison between “what macOS does” and “what LayoutRecall fixes” | Major | Users may assume the problem is too niche or not solved clearly |
| 6 | Launch copy is not packaged for channel-specific reuse | Medium | Momentum slows because the team has to rewrite the story for every post |
| 7 | Limits are documented, but not framed as intentional safety boundaries | Medium | Honest constraints can sound like weakness instead of discipline |

## Skeptical user ranking

### “Would bounce” list from a doubtful downloader

1. **I still do not know if this is for my exact setup.**
2. **I do not trust an app that moves monitors unless it proves it is conservative.**
3. **If `displayplacer` is required, tell me why this is still worth installing.**
4. **The screenshots need to make the app feel real and current within five seconds.**
5. **I need one fast example of the failure mode it fixes.**

## Product marketing prioritization

### Must

- Lead README and launch copy with the broken-layout pain and the “restore only when confident” promise.
- Make safety / trust a headline-level concept, not a buried implementation detail.
- Keep install instructions short near the top and move deeper caveats below proof and visuals.
- Reuse polished generated assets in the README funnel immediately.

### Should

- Add a crisp “Why trust it” section with diagnostics, manual controls, and OSS transparency.
- Add a short “Is this for me?” audience fit section for multi-display desk users.
- Add a comparison snippet between macOS scramble behavior and LayoutRecall recovery behavior.

### Could

- Add user-problem scenarios by role (developer, creator, analyst).
- Add short testimonials later once real usage quotes exist.
- Add a follow-up comparison page versus bare `displayplacer` workflows.

## Messaging guardrails

- Do not promise perfect prevention of every display glitch.
- Do not imply LayoutRecall replaces `displayplacer` internally.
- Do not market unsupported four-plus-display behavior as automatic.
- Do not invent growth claims or user counts.
- Do market the app as safe, practical, and already useful today.
