# LayoutRecall Feature Definition Decision Log

Lab: `feature-definition-20260402T002610Z`
Updated: 2026-04-02
Status: Definition-phase consensus artifact (phase 1B simplification pass)

## Phase 1B objective

Sharpen the product definition around simplicity and direct usability.

Rule used in this pass:

> If a feature does not directly help the user save a known-good layout, restore it safely, or understand why restore did or did not happen, it should be demoted or treated as a non-goal.

## Accepted decisions

### 1. Narrow the core product problem explicitly

**Accepted.**

Canonical problem statement:
- LayoutRecall helps a user recover a previously saved multi-display desk layout after macOS sleep, wake, dock reconnect, or identical-monitor shuffling.

Why accepted:
- It is concrete.
- It matches the implemented product better than a broad “display management” framing.
- It reduces pressure to keep unrelated convenience features in the headline spec.

### 2. Define the smallest required jobs only

**Accepted.**

Required jobs:
1. Save a known-good layout.
2. Detect when the current arrangement drifted.
3. Restore safely automatically or with one clear manual action.
4. Explain why restore did or did not happen.

Why accepted:
- This is the minimum loop that still delivers the product’s value.
- It gives a hard test for whether a feature belongs in the core spec.

### 3. Keep only five features in the core product definition

**Accepted core set**
- Save Current Layout
- Automatic Restore
- Fix Now
- Restore Status & Evidence
- Install displayplacer

Why accepted:
- These are the smallest capabilities that still make the product real and trustworthy.
- Everything else is either supporting, convenience, or out of scope.

### 4. Demote overlapping or secondary recovery features

**Accepted demotions**
- `Apply Layout` = supporting profile-management action, not a headline feature
- `Show Numbers` = supporting trust utility, not a headline feature
- `Swap Positions` = constrained convenience fallback, not a headline feature
- thresholds / diagnostics / profile management = supporting surfaces, not the product core

Why accepted:
- The product is sharper when it promises one main recovery loop instead of many near-overlapping “fix” actions.
- This keeps the PRD/SPEC from reading like a feature buffet.

### 5. Keep the shipped 3-primary-section settings model in the definition

**Accepted IA**
- Restore
- Profiles
- General

Supporting subsections remain nested under General.

Why accepted:
- It matches the actual current app.
- It is simpler than promoting every supporting surface to top-level navigation.
- It avoids inventing a larger IA just to honor legacy docs.

### 6. Make explicit non-goals part of the spec

**Accepted non-goals**
- full display-management suite
- broad 4+ display automatic rearrangement promise
- cloud sync / cross-machine sync
- per-app window placement
- complex profile-rule engine
- native restore engine replacement for `displayplacer` in this phase

Why accepted:
- Product clarity improves when expansion ideas are stated as non-goals rather than left ambiguous.

## Rejected alternatives

### Rejected: define the product by completeness instead of focus

Why rejected:
- It blurs the core user problem.
- It turns secondary capabilities into false obligations.

### Rejected: promote Diagnostics and Shortcuts to first-class top-level settings sections

Why rejected:
- They matter, but they support the core loop rather than define it.
- The simpler shipped 3-section model is easier to explain and use.

### Rejected: keep `Swap Positions` as a core product feature

Why rejected:
- It solves a narrower subset of desks.
- It overlaps with the main recovery story and should not compete with it in headline docs.

### Rejected: treat update management, login item, language, and shortcuts as product-defining features

Why rejected:
- These are app qualities and conveniences, not the product’s central promise.

### Rejected: leave non-goals implicit

Why rejected:
- Implicit non-goals invite scope creep and ambiguous PRD/SPEC language.

## Critic / verifier objections captured

- “If everything stays first-class, the product never explains what actually matters most.”
- “`Swap Positions` is useful, but it should not compete with the main recovery loop in the product story.”
- “A trust-centric utility should not force users to parse a bloated settings IA to understand the core behavior.”
- “Docs should not imply a broader display-management ambition than the code and safety model actually support.”

## Unresolved items worth keeping

These remain acceptable unresolved items because they are naming/copy issues, not core product-definition gaps:

1. Whether `Fix Now` should eventually be renamed to `Restore Now` or `Recover Now`
2. Whether `manual layout override` needs friendlier public wording

## Resolved by this pass

1. **Core problem:** now explicit
2. **Minimum required jobs:** now explicit
3. **Core vs supporting vs convenience features:** now explicit
4. **Non-goals:** now explicit
5. **Settings IA direction:** resolved in favor of shipped simplicity, not expanded navigation

## Recommendations to carry into the final packet

1. Rewrite PRD/SPEC intros around the narrow recovery problem first.
2. Split features into **core**, **supporting**, and **convenience** instead of listing everything together.
3. Remove any PRD/SPEC language that makes `Swap Positions`, updates, shortcuts, or language selection sound core to the product identity.
4. Keep the final unresolved list short; do not manufacture extra open questions once the keep/non-goal framing is clear.
