# LayoutRecall Marketing Wave 2 Brief

## Goal

Turn the first-wave strategy into concrete, repo-visible marketing improvements.

This wave must ship actual outputs, not just planning:

- rewrite the top of `README.md`
- improve the hero/feature/social image direction in `docs/marketing/generated/`
- improve the GIF/video story or regenerate the demo assets
- keep launch copy aligned with the new README structure

## Inputs from wave 1

Use these artifacts as the source of truth:

- `docs/marketing/programs/marketing-20260401T013742Z-positioning.md`
- `docs/marketing/programs/marketing-20260401T013742Z-asset-direction.md`
- `docs/marketing/programs/marketing-20260401T013742Z-launch-plan.md`

## Required deliverables

1. `README.md`
   - stronger headline and subheadline
   - explicit first audience
   - top-of-page visual proof and install CTA
   - trust framing earlier in the funnel
2. Marketing assets under `docs/marketing/generated/`
   - at least one materially improved hero or feature still
   - demo GIF/MP4 direction that tells a clearer problem -> recovery story
3. Launch copy alignment
   - keep GitHub / Reddit / HN copy consistent with the new README framing
4. Verification
   - repository must pass `./scripts/run-ai-verify --mode full`

## Role split

- Product marketing lead: choose the final hierarchy and tradeoffs
- Brand/visual designer: improve asset direction and one concrete asset set
- Copywriter: rewrite README top section and tighten captions
- Docs/conversion editor: improve install clarity, FAQ, and comparison/trust flow
- OSS launch strategist: align launch copy with the new README and assets
- Skeptical user: critique whether the new output is attractive enough to click and credible enough to install

## Guardrails

- prefer real app visuals over fake mockups
- do not overclaim features the app does not actually have
- do not stop at strategy docs; this wave must change visible product-marketing surfaces
- avoid broad product changes unless needed to keep marketing claims honest

## Success bar

Someone landing on the repo should be able to answer within seconds:

- what problem this solves
- whether it looks polished enough to try
- why it is safer than a random script
- how to install it now
