# Release Planning Artifacts

Use this directory for tracked PM artifacts produced by OMX release-program runs.

Recommended files per run:

- `<lab-id>-release-plan.md`
- `<lab-id>-decision-log.md`

Why this directory exists:

- worker worktrees can write tracked repo files more reliably than shared `.omx/plans/`
- PM decisions stay reviewable in git history
- virtual-user pain points and PM scope calls remain visible after the tmux run ends
