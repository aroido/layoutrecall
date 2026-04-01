# LayoutRecall

> **Stop rebuilding your monitor layout every time macOS forgets it.**

LayoutRecall is an open-source macOS menu bar app for **MacBook + dock + multi-display desks**. Save a known-good layout once, then bring it back after sleep, wake, or reconnect — with **automatic restore when confidence is high** and **manual recovery when it is not**.

![LayoutRecall hero showing menu bar recovery and settings proof](docs/marketing/generated/final/readme-hero.png)

## Install now

- **Download the signed app:** grab the latest `DMG` from [GitHub Releases](https://github.com/aroido/layoutrecall/releases), drag `LayoutRecall.app` into `/Applications`, then save your baseline layout from the menu bar.
- **Install with Homebrew:**

  ```bash
  brew install --cask aroido/layoutrecall/layoutrecall
  ```

- **Dependency note:** LayoutRecall can guide you through installing `displayplacer` from inside the app when restore support is missing.

## Who it is for

LayoutRecall is built first for people whose desk setup keeps drifting:

- MacBook + dock users with 2+ external displays that return in the wrong order
- developers, creators, analysts, and operators with strong left/right monitor muscle memory
- Mac mini / Mac Studio users dealing with repeated KVM, dock, or cable reconnect churn

## Why cautious desk users trust it

- **It does not guess blindly.** Automatic restore only happens when the connected display set is a strong match for a saved profile.
- **It stays transparent.** Profile match status, confidence, dependency state, and diagnostics are visible from the menu bar and settings.
- **It stays usable when confidence is lower.** `Fix Now`, `Apply Layout`, `Show Numbers`, and `Swap Positions` keep recovery practical instead of magical.
- **It is easy to evaluate.** Signed releases, Homebrew install, OSS code, and a documented verify path are available today.

![LayoutRecall demo showing the recovery flow from scramble to restore](docs/marketing/generated/final/layoutrecall-demo.gif)

## What problem it solves

macOS can bring external displays back with the wrong order, wrong origin, or wrong main-display state after:

- sleep / wake
- dock reconnect
- cable churn
- identical-monitor swaps

LayoutRecall is intentionally narrow: it restores **known** layouts safely instead of trying to become a full display-management suite.

## How recovery works

1. Arrange your displays the way you want.
2. Save the current arrangement as a profile.
3. LayoutRecall watches for real display reconfiguration events.
4. If the new display snapshot strongly matches a saved profile, it can restore automatically.
5. If confidence is lower, it stays manual on purpose and shows the relevant recovery action and diagnostics.

The current implementation is deliberately biased toward stable, practical recovery for common desk setups:

- automatic restore focuses on exact or high-confidence matches against saved profiles
- `Swap Positions` supports either two displays, or a main display plus two secondary displays
- four-plus-display layouts stay manual on purpose until the app can expose a predictable repositioning model

## Why use this instead of a one-off script?

| When macOS scrambles the desk | What LayoutRecall adds |
| --- | --- |
| You have to remember and re-run the right command at the right moment | Saved profiles and menu bar recovery actions are already in place |
| Automation can feel risky if it fires at the wrong time | High-confidence matching keeps low-confidence cases manual |
| It is hard to know why a restore did or did not happen | Diagnostics, dependency state, and recovery hints stay visible |
| Setup can feel fragile | Signed app download, Homebrew install, and in-app dependency guidance lower the first-run cost |

## See the safety + control surfaces

![LayoutRecall trust and diagnostics still](docs/marketing/generated/final/readme-feature-trust.png)

*Confidence, dependency, and recent restore evidence stay visible so LayoutRecall can explain what it did — or why it refused to act.*

![LayoutRecall profiles and controls still](docs/marketing/generated/final/readme-feature-profiles.png)

*Save multiple desk profiles, tune recovery behavior, and fall back to direct controls when you want to stay hands-on.*

## Features

- Saves and manages one or more display layout profiles from the current live monitor arrangement
- Watches for real display reconfiguration events and attempts automatic restore when confidence is high
- Falls back to manual recovery with `Fix Now`, direct `Apply Layout`, `Show Numbers`, and `Swap Positions`
- Shows profile, confidence, dependency, and diagnostic context directly from the menu bar
- Persists diagnostics history and exposes restore controls from a five-pane settings window
- Supports launch at login, keyboard shortcuts, in-app update checks, and explicit `System` / `English` / `Korean` language choice
- Can install `displayplacer` through the app flow when the dependency is missing

## Requirements

- macOS 13 or later
- Apple Silicon is currently the primary tested target
- `displayplacer` is required for actual restore commands

LayoutRecall can build and run tests without `displayplacer`, but restoring a saved layout depends on it being available on `PATH`.

## FAQ

### Does it work without `displayplacer`?

The app runs without it, but actual layout restore requires `displayplacer` to be available. LayoutRecall surfaces missing dependency state and can guide the install flow.

### Will it move my monitors automatically every time?

No. It only auto-restores when the saved profile match is strong enough. Lower-confidence cases stay manual on purpose.

### Is it meant for very complex 4+ monitor setups?

Not as a fully automatic promise yet. More complex layouts remain manual/review-heavy until the app can expose a predictable repositioning model.

## FAQ

### Does LayoutRecall work without `displayplacer`?

The app launches, saves profiles, and exposes diagnostics without it. Real layout restore still requires `displayplacer` on `PATH`.

### Will it move my monitors automatically every time?

No. LayoutRecall only auto-restores when the current display snapshot is an exact or high-confidence match for a saved profile.

### Is this meant for very complex 4+ monitor setups?

Not yet for full automatic recovery. More complex arrangements intentionally stay manual until the app can expose a predictable repositioning model.

## Development

```bash
git clone https://github.com/aroido/layoutrecall.git
cd layoutrecall
make build
make test
```

Useful commands:

```bash
make run
./scripts/run-ai-verify --mode full
```

The repository uses a scratch build path in `~/Library/Caches` to avoid Swift index-store rename failures on slower or externally mounted volumes.

Open `Package.swift` in Xcode if you want an IDE workflow.

## Repository layout

- `Sources/LayoutRecallApp`: SwiftUI menu bar application shell
- `Sources/LayoutRecallKit`: matching, persistence, restore execution, localization, and diagnostics logic
- `Tests/LayoutRecallAppTests`: app-level state, UI harness, and end-to-end coverage
- `Tests/LayoutRecallKitTests`: matcher, localization, restore, and persistence coverage
- `docs/PRD.md`: product summary
- `docs/SPEC.md`: detailed current behavior, architecture, and 2.0 priorities

## Release workflow

Tagged releases are published through GitHub Actions.

Relevant pieces:

- `./scripts/release-preflight.sh <tag>` validates version and required secrets
- `./scripts/build-release-archive` builds signed and notarized `ZIP` and `DMG` artifacts
- `.github/workflows/release.yml` publishes release assets and syncs the Homebrew tap

Example local release build:

```bash
VERSION=<version> BUILD_NUMBER=$(date +%Y%m%d%H%M%S) ./scripts/build-release-archive
```

The app checks GitHub Releases for `aroido/layoutrecall`. Automatic update checks can be controlled from `General > Updates`.

## Contributing

Issues and pull requests are welcome. If you are changing restore behavior, matching logic, localization, release packaging, or repo-visible marketing surfaces, run:

```bash
./scripts/run-ai-verify --mode full
```

## License

MIT. See [LICENSE](LICENSE).
