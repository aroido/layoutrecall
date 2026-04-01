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

### Designer recommendations reviewed explicitly

1. **Review-first restore state**  
   - Recommendation: surface the matched profile and a clear “Restore Now” gate before displays move.  
   - PM decision: **Accepted** because it directly addresses trust/mistrust from the virtual-user lane.

2. **Pause / Ignore Current Setup**  
   - Recommendation: let users suppress automatic restore for the exact arrangement currently connected.  
   - PM decision: **Accepted** because temporary setups are a real desk-use case and global disable is too coarse.

3. **Stronger first-run and no-profile guidance**  
   - Recommendation: make the first safe action explicit in empty states and recovery cards.  
   - PM decision: **Accepted** for v2.0.1 polish.

4. **Richer diagnostics / restore-history storytelling**  
   - Recommendation: turn diagnostics into a more narrative restore timeline.  
   - PM decision: **Deferred** because it is helpful but not release-critical for the current cut.

5. **Undo Last Restore**  
   - Recommendation: give users an explicit reversal path after an automatic restore.  
   - PM decision: **Rejected for this run** because it requires command-history and reverse-plan scope not justified for this cut.

6. **Profile Rules**  
   - Recommendation: let different contexts choose different restore rules or profiles automatically.  
   - PM decision: **Rejected for this run** because rule precedence and UX semantics need more evidence before shipping.

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
