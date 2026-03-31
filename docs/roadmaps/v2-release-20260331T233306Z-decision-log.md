# LayoutRecall v2 Decision Log

Lab: `v2-release-20260331T233306Z`
Updated: 2026-04-01

## Virtual-user findings

- “I need to know *why* LayoutRecall wants to move my displays before it does it.”
- “Sometimes the current arrangement is intentional for a meeting or a temporary dock setup. Don’t keep fighting me.”
- “The app should explain the safe next action more clearly when nothing is broken yet.”
- “Low-confidence and manual-recovery states feel too similar unless the top card explains the difference.”
- “If the app pauses protection for my current setup, I need a quick way to resume it from the same surface.”

## PM calls

### Accepted for v2.0.1
- Add clearer trust-oriented status messaging for review-needed and paused-current-setup states
- Keep recovery hints close to restore controls in both menu and settings
- Record release artifacts in tracked roadmap files

### Accepted for v2.0.2
- Ship **Ask Before Restore**
- Ship **Pause / Ignore Current Setup**

### Rejected for this run
- **Undo Last Restore**: rejected for this cut because it needs command-history / reverse-plan state that would broaden the change set
- **Profile Rules**: rejected for this cut because the PM brief lacks enough evidence to lock rule UX and precedence safely

## Developer constraints adopted

- Prefer minimal diffs in the existing menu/settings flows
- Reuse existing `Restore Now` action for confirmation instead of inventing a second restore command path
- Persist new behavior through `AppSettings` so restarts do not silently reset trust controls

## QA focus

- verify no regression in normal automatic restore
- verify confirmation mode blocks auto-execution until user action
- verify paused-current-setup suppression clears when the display arrangement changes
