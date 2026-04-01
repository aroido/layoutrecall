# LayoutRecall v2 Release Plan

Lab: `v2-release-20260331T233306Z`
Owner: PM lane synthesized by worker-1
Updated: 2026-04-01

## Virtual-user pain inventory

Observed from daily desk-setup use:

1. Users do not always trust an automatic display move without seeing which profile matched first.
2. The app needs a way to say “not this setup right now” without turning off protection globally.
3. First-run and no-profile states need clearer language about the first safe action.
4. Recovery controls should explain when LayoutRecall is waiting, paused, or safe.
5. Multi-profile users need faster context on what the app thinks is matched before they act.
6. Diagnostics help, but the top-level UI should communicate restore intent more directly.

## PM prioritization

### Must ship
- **v2.0.1 trust + clarity**
  - clearer restore-state messaging for review / paused states
  - stronger recovery guidance in menu and settings
  - tracked release plan + decision log artifacts
- **v2.0.2 new functionality**
  - Ask Before Restore
  - Pause / Ignore Current Setup

### Should ship
- Keep existing save/restore/swap flows working without extra confirmation friction
- Persist new restore-trust preferences in app settings

### Could ship later
- Undo Last Restore
- Profile Rules
- richer onboarding walkthrough
- more explicit restore history timeline in diagnostics

## Designer recommendations and PM disposition

| Designer recommendation | Input source | PM decision | Ship target |
| --- | --- | --- | --- |
| Add a **review-first restore state** that names the matched profile before anything moves | trust + clarity pain #1, #4 | **Accepted** | v2.0.1 messaging and v2.0.2 Ask Before Restore behavior |
| Add a **pause / ignore this exact setup** control near recovery actions | temporary setup pain #2, #5 | **Accepted** | v2.0.2 |
| Expand first-run / no-profile guidance so the first safe action is obvious | onboarding pain #3 | **Accepted** | v2.0.1 |
| Add a richer restore-history timeline with stronger diagnostics storytelling | clarity pain #6 | **Deferred** | later, after release cut |
| Add Undo Last Restore as a primary recovery affordance | trust / reversibility | **Rejected for this run** because it expands command-history scope too much | not in v2.0.1 or v2.0.2 |
| Add Profile Rules UI now | multi-profile power-user need | **Rejected for this run** because precedence / UX needs stronger evidence | not in v2.0.1 or v2.0.2 |

## Version cuts

## v2.0.1 — trust, onboarding, clarity

Scope:
- clarify restore mode messaging in menu/settings
- add review-first and paused-here status language
- make recovery guidance visible next to restore controls
- document product decisions in tracked roadmap artifacts

Acceptance criteria:
- UI can distinguish normal automatic mode, review-before-restore mode, and paused-current-setup mode
- no-profile and recovery surfaces still point users toward Save Profile / Restore Now cleanly
- roadmap artifacts are committed under `docs/roadmaps/`

## v2.0.2 — net-new user-facing functionality

Scope:
- **Ask Before Restore**: hold a confident automatic restore until the user confirms with Restore Now
- **Pause / Ignore Current Setup**: suppress automatic restore for the exact current arrangement until it changes or the user resumes protection

Acceptance criteria:
- a matched reconfiguration with confirmation enabled records a review-needed state and does not execute until confirmation
- pausing the current setup suppresses automatic restore for the exact arrangement
- when the arrangement changes away from the paused setup, automatic restore resumes normally
- settings persist both features across reloads

## Verification plan

- `swift test`
- targeted diagnostics/build via repo verify entrypoint
- `./scripts/run-ai-verify --mode full`

## Explicit deferrals

- Undo Last Restore: valuable but broader command-history plumbing than this cut allows
- Profile Rules: useful, but needs stronger PM definition around rule precedence and matching semantics
