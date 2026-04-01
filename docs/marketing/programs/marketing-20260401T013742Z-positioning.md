# LayoutRecall OSS Positioning

## Audit snapshot

### Current strengths
- The app already looks like a real product: menu bar workflow, five-pane settings window, diagnostics, shortcuts, update checks, and localization are implemented.
- README already explains the problem clearly for people with unstable multi-monitor desks.
- Install routes exist for both signed downloads and Homebrew.
- Marketing assets are grounded in real app visuals via `./scripts/generate-marketing-assets`.

### Current weaknesses
- The README opens with a correct explanation, but the first screen is still text-heavy and not immediately proof-rich.
- Trust signals are scattered instead of stacked into one fast answer.
- The app feels niche in a good way, but the first audience is not named sharply enough.
- “Why now?” is implied, not stated.
- Manual recovery and safety boundaries are explained later than they should be.

## Who should use LayoutRecall first

### Primary initial audience
Developers, power users, analysts, creators, and operators on macOS who use a laptop/dock plus two or more external monitors and routinely lose their preferred layout after sleep, wake, or reconnects.

### Best first-fit profile
Someone who says: “macOS keeps putting my monitors back in the wrong place, and I want a lightweight fix that is safer than a random script.”

### Secondary audience
- Desk setups with identical monitors that macOS frequently confuses
- Users who want a menu-bar utility instead of a heavy window-management suite
- People willing to install one focused OSS utility if the setup looks trustworthy

## Why they should trust LayoutRecall

1. It solves a narrow, real pain instead of making inflated “manage your whole desktop” claims.
2. The product is conservative: it only auto-restores when confidence is high.
3. It exposes manual recovery paths (`Fix Now`, `Apply Layout`, `Show Numbers`, `Swap Positions`) instead of hiding risky automation.
4. Diagnostics, thresholds, and dependency status are visible in the UI.
5. The README can truthfully say the app is already usable today, not a placeholder roadmap.

## Why they should download it now

- It already covers the painful baseline: save a known-good layout, detect real display churn, and restore when a trusted profile matches.
- It supports both signed-download and Homebrew installation paths.
- It is menu-bar-first, focused, and easier to trial than broader display-management tools.
- The product boundaries are honest, which lowers the fear of “what will this do to my desk?”

## Conversion blockers

| Blocker | Type | Why a skeptical user would bounce | Skeptical-user severity | Priority |
| --- | --- | --- | --- | --- |
| README hero lacks instant visual proof above the fold | aesthetics / trust | “Looks serious, but I still cannot see the app solving my problem in 5 seconds.” | 5/5 | Must |
| Trust proof is spread across Features / Requirements / How it works | clarity / trust | “I do not yet know if this is safe, implemented, or just a wrapper around scripts.” | 5/5 | Must |
| First audience is implied instead of named | clarity | “Is this for my exact laptop + dock + two-monitor mess, or not?” | 4/5 | Must |
| Dependency story (`displayplacer`) appears as a requirement before being framed as managed setup | installation friction | “I probably need to do terminal work before this app even starts helping.” | 4/5 | Must |
| Safety model and manual fallback are buried | trust | “If the app guesses wrong, will it make my monitor setup worse?” | 4/5 | Must |
| No crisp “why now” CTA near the top | conversion | “Maybe later; this feels nice-to-have, not urgent.” | 3/5 | Should |
| README top section is copy-dense before it becomes scannable | aesthetics / clarity | “I need shorter proof blocks and clearer hierarchy.” | 3/5 | Should |
| Launch copy is not yet packaged for sharing | growth | “I have to translate the product into post language myself.” | 3/5 | Should |
| Screenshot sequence does not yet tell a before → detect → recover story | asset coherence | “I see UI, but not the full payoff loop.” | 3/5 | Should |
| OSS trust hooks (tested baseline, boundaries, explicit limitations) are present but not merchandised | trust | “I cannot quickly judge maturity.” | 2/5 | Could |

## Product marketing priority translation

### Must
- Rebuild the README hero around one sentence, one proof visual, one trust strip, and one install CTA.
- Name the first audience explicitly: macOS users with laptop/dock/external-monitor churn.
- Reframe `displayplacer` as “required for restore, but installable through the app flow.”
- Surface the conservative safety model and manual recovery controls earlier.

### Should
- Add a short “why now” section tied to daily desk frustration.
- Turn the top of the README into a more scannable funnel.
- Package launch copy so GitHub / Reddit / HN posts can ship immediately.
- Make screenshots tell a clearer narrative.

### Could
- Add stronger OSS trust merchandising: tested areas, signed DMG, Homebrew, localization, diagnostics.
- Add a lightweight comparison block versus ad-hoc scripts and broader window tools.

## Messaging hierarchy

### Headline territory
Restore your Mac display layout after sleep, dock reconnects, and identical-monitor shuffling.

### Subheadline territory
LayoutRecall is a menu bar utility for macOS that saves a known-good monitor layout and restores it when macOS brings your screens back wrong.

### Supporting proof points
- Conservative auto-restore: runs only when confidence is high
- Manual recovery always available
- Diagnostics and thresholds visible in-app
- Signed download and Homebrew install paths
- Built for real two- and three-monitor desk setups

## Trust language to preserve
- “Prefer safe false negatives over unsafe false positives.”
- “Restores a saved layout when the connected monitor set matches a known workspace with high confidence.”
- “Uses `displayplacer` for real layout changes, with in-app setup help when missing.”

## Funnel recommendation
1. Hero: problem + proof visual + install CTA
2. Why trust it: conservative restore + manual controls + diagnostics
3. How it works: 3–5 steps
4. Feature proof: profiles, recovery, diagnostics, shortcuts
5. Install / requirements / troubleshooting
6. FAQ and limitations
