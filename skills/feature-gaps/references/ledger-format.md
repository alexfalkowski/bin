# `FEATURES.md` Format

Each entry is a self-contained, debatable mini-PRD: the product form of the
shared mini-RFC. A reviewer must be able to understand the opportunity, the
evidence, and the proposed direction without opening another file. Organize the
entry as `What -> Why -> How`. Keep the **required core** on every
entry, and add the **expandable sections** only when they help a real decision;
feature proposals often warrant `### Goals / Non-goals`.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable command, API, workflow, example, public symbol, or documented
surface over a bare line number. Add a line number only when it makes the source
faster to find. Include the relevant short excerpt or observed output when the
reviewer would otherwise need to reconstruct the claim from source.

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
| Confidence | 93% — one-line reason; minimum 90%, or 95% for high-risk acceptance. |
| Scope | path/to/file-or-folder |
| Audience | User \| Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Product surface | Public command \| API \| library behavior \| service/operator behavior \| package-consumer workflow \| integration \| template \| extension point. |

**Summary.** In one or two plain sentences, state the workflow the audience
cannot complete, why that matters, and the proposed capability direction.

### What

**Current.** State the audience workflow, the existing product surfaces that
address part of it, and the residual limitation. Make the residual gap explicit:
even with the existing surface, the named audience still cannot complete the
specific outcome.

**Expected.** State the new audience outcome and the product surface through
which it should be available.

### Why

**Impact.** Explain the concrete audience benefit and why this is a normal or
recurring workflow rather than parity for its own sake.

#### Evidence

- **Claim:** The plain-language product fact this evidence establishes.
- **Observed:** The current limitation or missing capability, with enough detail
  to understand it here.
- **Reproduction:** Smallest supported user, developer, service-author,
  operator, or package-consumer workflow trace that demonstrates the current
  limitation or missing capability.
- **Source:** `path/to/file` — stable command, API, workflow, example, public
  symbol, or heading; line number optional.

### How

#### Proposal

Describe the smallest useful capability, why it fits this repository and its
existing patterns, and any public-behavior, dependency, migration, or
maintenance cost.

**Keep.** Name the existing APIs, defaults, workflows, or compatibility
boundaries that must remain unchanged.

#### Alternatives Considered

- Chosen: the proposal above — why this shape wins for the audience.
- Other option: a wider build, a different surface, or reusing an existing
  surface — why not.
- Do nothing: the cost to the audience of leaving the gap.

#### Definition of Success

- The observable outcome the audience gains (the previously blocked workflow now
  completes).
- **Validation:** The repository command(s), scenario(s), or supported workflow
  that prove the result.
````

## Add When Warranted

Add these sections only when the entry needs them; feature proposals usually
warrant Goals / Non-goals.

````markdown
#### Situation Map

Place this directly after `**Expected.**` under `### What`.

Use only when a small visual explains a multi-step workflow, boundary, ownership
relationship, or current-versus-expected outcome better than the prose. Do not
turn the entry into an architecture document.

```text
[Audience]
    |
    v
[Product surface]
    |-- today --> [Current outcome]
    +-- target -> [Expected outcome]
```

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
