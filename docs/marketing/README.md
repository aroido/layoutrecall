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
- `docs/marketing/generated/final/launch-copy.md`

The pipeline also stores the raw UI snapshots used as source material under:

- `docs/marketing/generated/raw-ui/`

## README / launch narrative

Wave 2 treats the generated assets as one conversion story instead of isolated files:

1. `readme-hero.png` — identify the broken multi-display desk problem and the safe-recovery promise
2. `layoutrecall-demo.gif` / `.mp4` — show the problem → recognition → restore flow quickly
3. `readme-feature-trust.png` — make confidence, blocked auto-restore, and diagnostics visible
4. `readme-feature-profiles.png` — prove users keep direct control through profiles and manual recovery
5. `social-card.png` — reuse the same pain → trust → action message in previews and shares
6. `launch-copy.md` — keep GitHub / Reddit / HN copy aligned with the README framing

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
- GIF and MP4 outputs are built from branded slide images so the README can tell a short problem → trust → recovery story without an opaque screen recording.
- If you want live-action demos later, keep this pipeline for README/social and add a separate live-capture script on top.
