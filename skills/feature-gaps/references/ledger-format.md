# `FEATURES.md` Format

Each entry is a short, debatable mini-PRD: skimmable at the top, with just
enough reasoning and alternatives for a reviewer to agree or push back. Keep the
**required core** on every entry. Add the **expandable sections** only when the
entry warrants them; feature proposals often warrant `### Goals / Non-goals`.

## Required Core

Use this structure for every entry:

````markdown
# Features

## FEATURE-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Feature Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Audience | User \| Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Product surface | Public command \| API \| library behavior \| service/operator behavior \| package-consumer workflow \| integration \| template \| extension point. |

**Summary.** One or two sentences a reviewer can read on their own: the workflow
the audience cannot complete today and why it matters.

### Context
The current limitation, the existing product surfaces that already address part
of the need and why they fall short, and the residual gap — even with that
coverage, the named audience still cannot complete this specific supported
workflow. Note why now: evidence it is a normal or recurring workflow, not only
comparable-tool parity.

### Evidence
Evidence: Concrete file and line references, command behavior, docs, examples,
comparable-tool evidence, or user/developer workflow evidence.
Reproduction: Smallest supported user, developer, service-author, operator, or
package-consumer workflow trace that demonstrates the current limitation or
missing capability.

### Proposal
The smallest useful capability to add, why it fits this repository and its
existing patterns, and any public-behavior, dependency, migration, or
maintenance cost.

### Alternatives Considered
- Chosen: the proposal above — why this shape wins for the audience.
- Other option: a wider build, a different surface, or reusing an existing
  surface — why not.
- Do nothing: the cost to the audience of leaving the gap.

### Definition of Success
- The observable outcome the audience gains (the previously blocked workflow now
  completes) plus the validation that proves the feature.
````

## Add When Warranted

Add these sections only when the entry needs them; feature proposals usually
warrant Goals / Non-goals.

````markdown
### Goals / Non-goals
- Goal: the audience outcome the feature must deliver.
- Non-goal: adjacent capabilities this deliberately does not build.

### Open Questions
- A product-direction, scope, or compatibility decision that needs the human.

### Decision
> Accepted 2026-07-07 — chose <option> because <reason>.
````

## Status And Lifecycle

`Status` is a lightweight hint for where the entry stands in the current
conversation, not a durable record: `Proposed` when first recorded, `Accepted`
after the human agrees, `In progress` while implementing, and `Rejected` for an
entry ruled out but kept for context. The `### Decision` line is an optional
one-line record of the agreement-gate outcome. Per the shared gap workflow,
remove the entry once the change is confirmed done and delete the ledger once
every entry is resolved.

Keep optional follow-up notes separate from proposals:

```markdown
## Optional Feature Follow-Ups

- Optional or non-blocking idea.
```

## Priority And Confidence

Use confidence as a hard actionability gate: record only proposals at 90%
confidence or higher. Below 90%, gather more evidence or discard the candidate.
Confidence means the inspected evidence makes it very likely that the feature
is repository-owned, not already supported, valuable to the named audience, and
implementable without violating local patterns.

Do not assign 90% or higher confidence to a missing-feature proposal when the
current behavior may be provided by an included framework, shared helper,
generated surface, vendored dependency, or default configuration that has not
been inspected. Keep the candidate below threshold, gather that evidence, or
discard it.

Do not assign 90% or higher confidence to a reusable-library or shared-tooling
proposal whose support is limited to package-local possibility, synthetic
fakes, manual construction, or unsupported downstream usage. Inspect supported
usage evidence first.

Do not add a separate percentage for idea quality, strength, value, impact, or
priority. Use `Priority` to express the strength of the audience benefit and
use `Confidence` only for evidence-backed actionability.

Assign priority by user value and fit, not implementation ease:

- `High`: Improves a primary workflow, unlocks a documented use case, removes
  recurring maintainer/developer friction, or aligns strongly with comparable
  mature tools while fitting the repository's existing direction.
- `Medium`: Improves a real secondary workflow or extension point with clear
  fit and manageable maintenance cost.
- `Low`: Useful but narrow improvement with limited audience, limited urgency,
  or meaningful tradeoffs that still fit the repository.

Do not use `Low` for vague ideas. Reject vague-benefit candidates instead.
Low-priority proposals still need concrete benefit, evidence, audience, fit,
and a plausible implementation path.
