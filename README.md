# LayoutRecall

LayoutRecall is a macOS menu bar utility that saves known display layouts and restores them when macOS scrambles identical or frequently reconnected monitors.

It is aimed at the common desktop problem where the same two external displays come back in the wrong order, wrong origin, or wrong main-display state after sleep, wake, dock reconnect, or cable churn.

## Features

- Saves one or more display layout profiles from the current live monitor arrangement
- Watches for display reconfiguration events and attempts automatic restore when confidence is high
- Falls back to one-click manual recovery with `Fix Now` and `Swap Left / Right`
- Shows profile, confidence, and diagnostic context directly from the menu bar
- Supports launch at login, keyboard shortcuts, and in-app update checks
- Lets you choose app language explicitly with `System`, `English`, or `Korean`

## Install

### Download the signed app

- Download the latest `DMG` from [GitHub Releases](https://github.com/aroido/layoutrecall/releases)
- Drag `LayoutRecall.app` into `/Applications`
- Launch the app and save a baseline layout from the menu bar

### Install with Homebrew

```bash
brew install --cask aroido/layoutrecall/layoutrecall
```

## Requirements

- macOS 13 or later
- Apple Silicon is currently the primary tested target
- `displayplacer` is required for actual restore commands

LayoutRecall can build and run tests without `displayplacer`, but restoring a saved layout depends on it being available on `PATH`.

## How it works

1. Arrange your displays the way you want.
2. Save the current layout as a profile.
3. LayoutRecall watches for display change events.
4. If the current display snapshot strongly matches a saved profile, the app restores it automatically.
5. If confidence is lower, the menu bar app keeps recovery manual and shows the relevant action and diagnostics.

The current implementation is deliberately biased toward stable, practical recovery for dual external monitor setups, especially identical left/right displays.

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
- `docs/SPEC.md`: detailed product behavior and roadmap

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

Issues and pull requests are welcome. If you are changing restore behavior, matching logic, localization, or release packaging, run:

```bash
./scripts/run-ai-verify --mode full
```

## License

MIT. See [LICENSE](/Users/macmini/code/layoutrecall/LICENSE).
