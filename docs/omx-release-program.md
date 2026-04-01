# OMX Release Program

Use this mode when the goal is not a single feature spike, but a PM-led release plan.

## Why

The default `omx team` decomposition tends to drift toward generic implementation, test,
and review lanes. That is good for bounded execution, but weak for product direction.

For LayoutRecall, the higher-value pattern is:

- PM decides what ships
- virtual user surfaces pains and missing capabilities
- designer translates accepted pains into concrete UX changes
- developers implement only the approved scope
- QA verifies each release cut

## Version split

### v2.0.1

Focus on trust and clarity:

- onboarding / first-run empty states
- clearer restore explanations
- stronger placement of `Apply Layout` / `Show Numbers`
- diagnostics clarity and recovery guidance

### v2.0.2

Focus on net-new user-facing functionality.

Preferred shortlist:

- `Ask Before Restore`
- `Undo Last Restore`
- `Pause / Ignore Current Setup`
- `Profile Rules`

Require PM to ship at least two net-new features in this cut unless evidence says the scope is unsafe.

## Role contract

- PM: owns backlog ranking, version cuts, acceptance criteria, and release call
- Virtual user: proposes real pain points, confusion, mistrust, and missing features
- Designer: recommends UX/UI changes in response to pains PM accepts
- Developers: implement approved work only
- QA: verifies each cut with `./scripts/run-ai-verify --mode full`

## Output contract

For each release-program run, create tracked artifacts under [`docs/roadmaps`](./roadmaps/README.md):

- release plan
- decision log

At minimum the decision log should record:

- what the virtual user reported
- which items PM accepted or rejected
- what moved into `v2.0.1`
- what moved into `v2.0.2`
- what was explicitly deferred

## Launch

```bash
./scripts/omx-lab-start --release-program v2-release "LayoutRecall PM-led v2.0.1 and v2.0.2 program"
cd ../layoutrecall-v2-release-<timestamp>
omx doctor --team
omx team 6:executor "Run the LayoutRecall PM-led release program described in .omx/context/<lab-id>.md"
```
