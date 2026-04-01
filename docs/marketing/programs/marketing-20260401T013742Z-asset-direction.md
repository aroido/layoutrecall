# LayoutRecall Asset Direction

## Goal
Turn the project from “credible text README” into “credible product page” using real app visuals, tighter art direction, and a clearer before/after story.

## What the current assets already do well
- They use real UI snapshots instead of fake mockups.
- The existing compositor already outputs a README hero, feature stills, a social card, and a short demo GIF/MP4.
- The menu bar and settings views are visually clean enough to support polished marketing treatment.

## What the current assets still miss
- The story is not obvious enough at thumbnail size.
- The strongest visual payoff is the desk problem being corrected, not just the app chrome.
- Hero treatment needs clearer headline-safe space and stronger contrast between pain and recovery.
- The GIF concept is still “slide deck demo,” not yet “instant recovery narrative.”

## Visual direction

### Art direction keywords
- calm utility
- trustworthy recovery
- macOS-native polish
- technical, but not hacker-noisy
- real desk problem, visibly resolved

### Visual principles
1. Prefer real app UI over synthetic device mockups.
2. Show the problem state and the recovery state as a sequence, not isolated screenshots.
3. Keep captions short and outcome-focused.
4. Use display-layout diagrams, highlight callouts, and subtle zoom/crop to make the utility obvious.
5. Treat diagnostics and confidence badges as trust proof, not clutter.

## Improved README screenshot direction

### Screenshot 1: Hero / “macOS scrambled my monitors again”
**Purpose:** make the problem legible in one glance.

**Composition:**
- Left: abstracted “wrong layout” mini-diagram or highlighted mismatched screen ordering
- Right: real LayoutRecall menu with confidence/status visible
- Caption: `Save a known-good layout, then restore it when macOS brings your displays back wrong.`

**Why it converts:** it links the abstract desk pain to a concrete UI that already exists.

### Screenshot 2: Profiles / “save the desk you actually want”
**Purpose:** prove the app is not a one-shot script.

**Composition:**
- Real Profiles pane
- Highlight saved profile name, threshold, and direct apply controls
- Caption: `Keep one or more known-good layouts and tune how confidently each should auto-restore.`

### Screenshot 3: Trust / “show me why it did or did not act”
**Purpose:** reduce fear of black-box automation.

**Composition:**
- Real Restore or Diagnostics pane
- Highlight dependency readiness, decision state, and recent diagnostic history
- Caption: `See dependency status, recovery options, and recent restore decisions before you trust it with your desk.`

## Improved GIF / short-video concept

### Recommended concept: Problem → detection → recovery → proof

**Length:** 8–12 seconds

**Storyboard:**
1. Title frame: “macOS put your monitors back wrong?”
2. Wrong-layout diagram appears beside a live LayoutRecall menu snapshot
3. Quick cut to saved profile in Profiles pane
4. Menu state shows trusted match / recovery action
5. Final frame shows corrected layout diagram + CTA: `Download the signed app or install with Homebrew`

**Why this is better than a generic slideshow:**
It shows outcome logic, not just polished UI.

## Social-card direction
- Use the product name, one-line promise, and a simple multi-display diagram.
- Favor one strong claim: `Restore your Mac display layout after sleep, wake, and dock reconnects.`
- Do not overload with feature bullets.

## README top-of-page structure recommendation
1. Hero image with problem/recovery framing
2. Headline + subheadline
3. Trust strip: Signed DMG · Homebrew · Conservative auto-restore · Manual recovery
4. Install CTA block
5. “How it works” mini-sequence

## Concrete asset update recommendations
- Regenerate the hero with a more explicit wrong-layout → recovered-layout visual contrast.
- Update one feature still to foreground profile thresholds and direct apply.
- Update one trust still to foreground diagnostics and dependency readiness.
- Keep final exports under `docs/marketing/generated/`.

## Copy rules for captions and overlays
- Lead with the outcome, not the feature name.
- Avoid vague UI labels as headline text.
- Keep overlay copy to one sentence or one clause.
- Make the UI do the proof; let the caption do the interpretation.
