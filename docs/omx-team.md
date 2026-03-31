# OMX Team Workflow

This repository can use `oh-my-codex` team mode without replacing the project
root `AGENTS.md`.

## One-time setup

Install OMX and wire it into the existing Codex home:

```bash
npm install -g oh-my-codex
omx setup --scope user
omx doctor
omx doctor --team
```

OMX runtime state lives under `.omx/`, which is ignored by git.

## Why user scope

Use `user` scope for this repository.

That keeps OMX prompts, skills, and native agent configs in `~/.codex` while
leaving the repository's own [`AGENTS.md`](../AGENTS.md)
as the project contract.

## Recommended commands

Run from the repository root:

```bash
omx doctor
omx doctor --team
```

Start a normal Codex session with OMX enabled:

```bash
omx --madmax --high
```

Inside that session, hand large tasks to a team:

```text
$team 3:executor "diagnose the layout restore regression and verify with ./scripts/run-ai-verify --mode full"
```

You can also start the tmux-backed team runtime directly:

```bash
omx team 3:executor "implement the requested feature and finish with ./scripts/run-ai-verify --mode full"
```

Useful team runtime commands:

```bash
omx team status <team-name>
omx team resume <team-name>
omx team shutdown <team-name>
```

## Cross-functional lab

What you asked for is possible, but there is one OMX limitation to keep in
mind:

- `omx team` currently launches one shared `agent-type` for all workers.
- That means a literal mixed team of `pm + designer + developer + qa + user`
  is not a native launch shape yet.
- The closest working model is a cross-functional squad brief where OMX
  assigns lanes internally.

Recommended role mapping for this repository:

- PM / product lead: `planner` + `analyst`
- Designer: `designer`
- Developer: `executor`
- QA: `test-engineer` + `verifier`
- Virtual user: `critic`

Recommended experiment flow:

```bash
./scripts/omx-lab-start current-version-pass
cd ../layoutrecall-current-version-pass-<timestamp>
omx doctor --team
```

Then choose one of these:

1. `omx ralph --prd "Run the cross-functional LayoutRecall squad experiment described in .omx/context/<lab-id>.md"`
2. `omx team 5:team-executor "Run the LayoutRecall squad experiment described in .omx/context/<lab-id>.md"`

Use `ralph` when you want one persistent leader loop that keeps delegating
specialist work until verification is green.

Use `team` when you want durable tmux panes and a more visible multi-worker
runtime.

`./scripts/omx-lab-start` creates all of this safely:

- a local git baseline tag for the current `HEAD`
- a dedicated experiment branch and worktree
- patch files if the source worktree is dirty
- a starter `.omx/context/*.md` brief for the squad run

## Repo-specific rules

- Work from the repository root so OMX picks up the project `AGENTS.md`.
- Use GitHub PR workflow, not direct pushes to protected branches.
- Do not declare work complete before `./scripts/run-ai-verify --mode full`.
- Treat `.omx/` as local runtime state, not project source.

## Notes

- Team mode requires `tmux`.
- `omx doctor` may report an `Explore Harness` warning when no Rust toolchain
  or packaged explore binary is available. That does not block `omx team`.
