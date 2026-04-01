# LayoutRecall

LayoutRecall is a macOS menu bar utility that saves known display layouts and restores them when macOS scrambles identical or frequently reconnected monitors.

It is aimed at the common desktop problem where external displays come back in the wrong order, wrong origin, or wrong main-display state after sleep, wake, dock reconnect, or cable churn.

## Features

- Saves and manages one or more display layout profiles from the current live monitor arrangement
- Watches for real display reconfiguration events and attempts automatic restore when confidence is high
- Falls back to manual recovery with `Fix Now`, direct `Apply Layout`, `Show Numbers`, and `Swap Positions`
- Shows profile, confidence, dependency, and diagnostic context directly from the menu bar
- Persists diagnostics history and exposes restore controls from a five-pane settings window
- Supports launch at login, keyboard shortcuts, in-app update checks, and explicit `System` / `English` / `Korean` language choice
- Can install `displayplacer` through the app flow when the dependency is missing

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

The current implementation is deliberately biased toward stable, practical recovery for common desk setups:

- automatic restore focuses on exact or high-confidence matches against saved profiles
- `Swap Positions` supports either two displays, or a main display plus two secondary displays
- four-plus-display layouts stay manual on purpose until the app can expose a predictable repositioning model

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

Issues and pull requests are welcome. If you are changing restore behavior, matching logic, localization, or release packaging, run:

```bash
./scripts/run-ai-verify --mode full
```

## License

MIT. See [LICENSE](/Users/macmini/code/layoutrecall/LICENSE).
