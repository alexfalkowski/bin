# `FEATURES.md` Format

Use this structure:

````markdown
# Features

## FEATURE-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Feature Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Audience | User \| Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Product surface | Public command \| API \| library behavior \| service/operator behavior \| package-consumer workflow \| integration \| template \| extension point. |

### Workflow Map

```text
current limitation: The workflow limitation, missing capability, or friction.
existing coverage: Current product surfaces that already address part or all of
the need, and why they are insufficient for the named audience.
residual gap: Even with the existing coverage, the audience still cannot
complete this specific supported workflow or outcome.
benefit: Why this matters to the named audience and how their workflow becomes better.
common operation: Evidence that this is a normal or recurring workflow for the
named audience, not only comparable-tool parity.
```

### Evidence

```text
Evidence: Concrete file and line references, command behavior, docs, examples,
comparable-tool evidence, or user/developer workflow evidence.
Reproduction: Smallest supported user, developer, service-author, operator, or
package-consumer workflow trace that demonstrates the current limitation or
missing capability.
```

### Decision Trace

```text
named audience
  -> supported workflow
  -> existing coverage
  -> residual gap
  -> smallest useful feature
  -> validation that proves the feature
```

### Proposed Change

```yaml
repository_fit: Why this belongs in the current repository and matches existing patterns.
proposed_feature: Smallest useful capability to add.
compatibility_and_maintenance: Public behavior, dependency, migration, support, or maintenance tradeoffs.
validation:
  - Suggested checks for the feature change.
```
````

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
