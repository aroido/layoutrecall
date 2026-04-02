# LayoutRecall Simplified Feature Catalog

_Date:_ 2026-04-02

## Core user problem

The user wants one saved desk layout back after macOS scrambles monitors on wake, reconnect, or identical-display reorder.

## Feature test

A feature stays in the product definition only if it directly helps the user:
1. save the right layout,
2. restore it safely,
3. recover it manually when needed,
4. understand what happened.

## Kept features

| Feature | Definition | Canonical home | Reason kept |
| --- | --- | --- | --- |
| Profile | The single saved layout object | Profiles | Core recovery model |
| Save Profile | Capture the current layout as the known-good profile | Profiles | Required starting point |
| Auto Restore | Restore automatically when the match is safe | Restore | Core automation value |
| Restore Now | Primary manual recovery action | Restore + Menu | Core fallback path |
| Apply Layout | Restore a specific saved profile from Profiles | Profiles | Secondary variant of manual restore |
| Show Numbers | Confirm saved-to-live display mapping | Profiles + utility access from Menu/Restore | Trust/support utility |
| Diagnostics | Explain what happened and why | General | Trust/support evidence |
| Dependency Setup | Make restore possible by enabling `displayplacer` | Restore | Direct blocker removal |

## Demoted features

| Feature | New status | Reason |
| --- | --- | --- |
| Swap Positions | Advanced/manual fallback utility | Not part of the core restore promise |
| Shortcuts | Convenience only | Helpful but non-essential |
| Launch at login | Preference only | Administrative setting |
| Updates | Preference/maintenance only | Not part of core recovery workflow |
| Language selection | Preference only | Not part of core recovery workflow |

## Removed from baseline definition

| Item | Decision | Reason |
| --- | --- | --- |
| Per-profile autoRestore | Remove from baseline truth | Not consistent with the current product behavior |
| 5-pane settings target | Remove from current product truth | Simplicity-first product chooses 3 panes |
| Full display-management story | Remove | Too broad for the core job |

## Canonical names

| Intent | Canonical name |
| --- | --- |
| saved layout object | Profile |
| primary manual recovery | Restore Now |
| profile-specific restore | Apply Layout |
| display-mapping utility | Show Numbers |
| automatic recovery mode | Auto Restore |
| advanced repositioning fallback | Swap Positions |

## Warning for degraded states

`Save Profile` may remain available in some degraded states, but it should be treated as an expert escape hatch. The product should not encourage users to capture a broken temporary layout as the new truth.
