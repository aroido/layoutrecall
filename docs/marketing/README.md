# Marketing Assets

Generate README, social, GIF, and short demo video assets from the app's own UI snapshots.

## Output set

Running the generator creates:

- `docs/marketing/generated/final/readme-hero.png`
- `docs/marketing/generated/final/readme-feature-trust.png`
- `docs/marketing/generated/final/readme-feature-profiles.png`
- `docs/marketing/generated/final/social-card.png`
- `docs/marketing/generated/final/layoutrecall-demo.mp4`
- `docs/marketing/generated/final/layoutrecall-demo.gif`

The pipeline also stores the raw UI snapshots used as source material under:

- `docs/marketing/generated/raw-ui/`

## Regenerate

```bash
./scripts/generate-marketing-assets
```

To write to a different directory:

```bash
./scripts/generate-marketing-assets /absolute/output/path
```

## Notes

- The stills come from `renderMenuAndSettingsSnapshots()` so they track the actual app UI.
- GIF and MP4 outputs are built from branded slide images rather than an opaque screen recording.
- If you want live-action demos later, keep this pipeline for README/social and add a separate live-capture script on top.
