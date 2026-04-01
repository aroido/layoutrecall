# LayoutRecall OSS Marketing Program — Asset Direction

_Last updated: 2026-04-01_

## Audit summary

Current funnel inputs reviewed:

- README top-of-page copy in `README.md:1-51`
- asset pipeline notes in `docs/marketing/README.md:1-36`
- final stills / motion assets in `docs/marketing/generated/final/`
- raw UI captures in `docs/marketing/generated/raw-ui/`
- release / trust documentation in `README.md:17-98`, `docs/PRD.md`, and `docs/SPEC.md`
- prior UX review in `docs/roadmaps/v2-release-20260331T233306Z-designer-audit.md:23-154`

## Funnel verdict

The project already looks more real than a typical early OSS utility because the screenshots come from the app itself and the hero art direction is coherent. The weak point is not visual polish alone; it is **conversion hierarchy**.

The funnel currently makes the reader work too hard to understand:

1. whether they are the target user
2. whether the app is safe to trust
3. what the first-run path actually is
4. why this is better than just living with the problem or using `displayplacer` manually

## Explicit answers required by the program

### Who should use LayoutRecall first

Mac users with a laptop/dock/external-monitor setup whose layout repeatedly breaks after reconnect, wake, or identical-monitor shuffling.

### Why they should trust it

Because the app shows confidence, dependency readiness, matched profile context, and diagnostics history instead of silently moving displays.

### Why they should download it now

Because the repo already ships a practical, real utility with releases, Homebrew distribution, diagnostics, and real screenshots—not just a concept README.

## Conversion blockers

### Skeptical user ranking (“would bounce” severity)

| Rank | Blocker | Severity | Why a skeptical user bounces |
| --- | --- | --- | --- |
| 1 | README opens with a generic definition instead of a painful scenario (`README.md:1-5`) | Would bounce immediately | The reader may not realize the app is for *their exact desk problem*. |
| 2 | First-run/install trust chain is scattered across README and settings concepts (`README.md:17-37`, prior audit lines 23-50) | Would bounce hard | Users worry about background behavior and dependency setup before trying a menu bar utility. |
| 3 | Trust proof is buried below features instead of surfaced near the hero (`README.md:7-15`, `39-51`) | Would bounce | “Will this do something risky to my monitors?” is unanswered too late. |
| 4 | The hero stills are strong, but the README top section does not explain the screenshots quickly enough | Medium-high | Attractive visuals are not doing enough conversion work because the surrounding copy is too generic. |
| 5 | The project lacks a crisp comparison angle versus manual `displayplacer` workflows | Medium | Power users do not immediately see why they should install a GUI utility. |
| 6 | The GIF/video concept is polished but still slide-based, so it does not fully demonstrate “save → scramble → recover” | Medium | Motion exists, but the payoff loop is not yet obvious. |
| 7 | Installation/troubleshooting reassurance is present but not framed as “safe to try, easy to back out” | Medium | OSS users still expect more setup friction than the project actually requires. |

## Product marketing lead priorities

### Must

1. Rewrite the README hero so the pain and audience are obvious within the first screen.
2. Surface trust proof directly under the hero: confidence-based restore, diagnostics, signed/Homebrew distribution.
3. Show a clear first-run path: install, save baseline, let LayoutRecall watch, inspect proof.
4. Make the screenshots and GIF/video tell one narrative instead of acting like isolated assets.

### Should

1. Add a comparison / “why not just use `displayplacer`?” section.
2. Add a short FAQ/trust section that answers safety and dependency questions.
3. Make the demo concept show the before/after loop more explicitly.

### Could

1. Add desk-context photography or lifestyle framing later.
2. Add optional live-capture demos for launch day social use.
3. Add longer-form install walkthrough content after the README funnel is fixed.

## Cohesive creative direction

### Visual direction

Use a **calm, desktop-night, confidence-dashboard aesthetic**:

- dark navy / graphite backgrounds
- real app UI as the hero subject
- soft accent glows and thin line texture only as support
- badges / chips that read like proof, not decoration
- restrained motion and no fake “exploding monitor” gimmicks

The visuals should communicate: **quiet utility, controlled recovery, real macOS-native product**.

### Copy direction

Use copy that is:

- concrete
- pain-first
- proof-backed
- conservative in claims

Good tone:

- “When macOS scrambles your monitors…”
- “Restore a saved layout when the match is trustworthy.”
- “See confidence, profile context, and diagnostics before you trust automation.”

Avoid tone that feels:

- flashy
- hacker-jokey
- overpromising
- too abstract about “productivity”

## Recommended README top-of-page structure

1. Hero headline with the desk problem in plain language
2. One-sentence subheadline naming the audience and trigger events
3. Hero image
4. Three proof chips
5. “Why people install it” bullets
6. “How it works” 3-step strip
7. Trust / install FAQ
8. Feature screenshots
9. Motion demo
10. Install options and development details after conversion content

## Screenshot direction

### Screenshot 1 — Hero / promise

Use the existing `readme-hero.png` as the base direction, but keep the copy tightly pain-first:

- headline about macOS scrambling monitor layouts
- subheadline naming sleep, wake, and dock reconnect
- chips limited to proof, not feature laundry list

### Screenshot 2 — Trust / proof

Lead with the diagnostics + matched-profile story:

- show matched profile name
- show high-confidence or blocked state
- show a short “why” caption
- caption theme: “See why LayoutRecall did—or did not—restore.”

The existing `readme-feature-trust.png` is the right base visual direction.

### Screenshot 3 — Profiles / setup

Show the profile model as “save once, reuse later” rather than “manage records.”

Caption theme:

- save a baseline once
- tune thresholds only if you want
- keep multiple desk profiles ready

### Screenshot treatment rules

- Prefer one headline + one caption + 3–4 proof bullets max.
- Crop for readability first; do not show more UI just because it exists.
- Keep screenshots grounded in the real app and real copy.
- Use consistent chip vocabulary across README and social assets.

## GIF / video direction

### Recommended concept

Replace the abstract “slide deck only” impression with a loop that tells this exact story:

1. A stable desk layout is saved.
2. A reconnect/swap event breaks the arrangement.
3. LayoutRecall identifies the matched profile.
4. The restore state and proof are shown.
5. The layout returns to normal.

### Minimum viable structure

- Scene 1: “Mac wakes up to the wrong layout.”
- Scene 2: “LayoutRecall matches the right desk profile.”
- Scene 3: “Restore with visible confidence and diagnostics.”

### Motion rules

- Keep total loop under 8 seconds.
- Favor legibility over complex transitions.
- Use the real UI captures as anchors, then add only lightweight branded framing.

## Comparison angle to include in assets / README

A short reusable comparison line:

> LayoutRecall gives `displayplacer` users a saved-profile workflow, a safer restore gate, and visible diagnostics instead of a manual command habit.

## Asset acceptance checklist

An asset is good enough for launch if it:

- clearly names the target pain
- shows the real app UI
- includes at least one trust proof
- avoids inflated claims
- helps the next funnel step rather than repeating the previous one
