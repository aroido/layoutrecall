# OMX Marketing Program

Use this mode when the goal is to improve how LayoutRecall is presented,
understood, and adopted as an open-source product.

## Why

The default execution and release-program modes are good at product delivery,
but they are not enough for OSS conversion work.

For LayoutRecall, the better pattern is:

- make the project look polished enough to click
- make the README and docs clear enough to trust
- make installation and troubleshooting easy enough to try
- make launch copy sharp enough to share

## Team contract

- Product marketing lead: owns positioning, ICP, messaging hierarchy, and acceptance
- Brand / visual designer: owns art direction, screenshot treatment, and asset coherence
- Copywriter: owns headline, subheadline, README copy, and launch voice
- Docs / conversion editor: owns install clarity, FAQ, comparison, and trust scaffolding
- OSS launch strategist: owns channels, sequencing, and distribution copy
- Skeptical user / conversion critic: flags what still feels confusing, ugly, risky, or skippable

## Required outputs

For each run, create tracked strategy artifacts under [`docs/marketing/programs`](./marketing/programs/README.md):

- positioning
- asset direction
- launch plan

The run should also improve one or more of:

- README hero and top-of-page structure
- screenshot direction
- GIF / short-video demo direction
- launch copy for GitHub, Reddit, Hacker News, or similar channels
- install / FAQ / comparison docs

## Launch

```bash
./scripts/omx-lab-start --marketing-program marketing "LayoutRecall OSS marketing, README, and launch asset program"
cd ../layoutrecall-marketing-<timestamp>
omx doctor --team
omx team 6:executor "Run the LayoutRecall OSS marketing program described in .omx/context/<lab-id>.md"
```
