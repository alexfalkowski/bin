# `PROJECTS.md` Format

Each entry is a short, debatable mini-RFC: skimmable at the top, with just
enough reasoning and alternatives for a reviewer to agree or push back. Keep the
**required core** on every entry. Add the **expandable sections** only when the
entry warrants them; do not pad a trivial gap.

## Required Core

Use this structure for every entry:

````markdown
# Projects

## PROJECT-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Project Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Audience | Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Implementation home | current repo \| shared bin \| external repo \| mixed |
| Project surface | Make target \| CI job \| script \| setup flow \| validation flow \| release flow \| command discovery \| shared ./bin wiring. |

**Summary.** One or two sentences a reviewer can read on their own: the project
workflow friction or missing capability and who it slows down.

### Context
The current workflow friction or missing capability, why this scope owns the
fix (or why it is routed to third-party, external repo, shared tooling, or an
upstream project-owned library), and why it fits this repository's existing
project patterns.

### Evidence
Evidence: Concrete file and line references, command behavior, CI config, docs,
examples, comparable workflow evidence, or maintainer workflow evidence.
Reproduction: Smallest supported maintainer, developer, CI, Make, setup,
validation, release, or command-discovery workflow trace that demonstrates the
current friction or missing project capability.

### Proposal
The smallest useful project workflow improvement, its implementation home, and
any public-target, dependency, migration, CI-runtime, or maintenance cost.

### Alternatives Considered
- Chosen: the proposal above — why this home and surface fit.
- Other option: a different implementation home (shared bin / repo-local /
  external) or project surface — why not.
- Do nothing: the friction of leaving the workflow as is.

### Definition of Success
- The observable proof the workflow improves (the target runs, CI passes, or the
  command is discoverable) plus the validation that proves it.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
### Goals / Non-goals
- Goal: the workflow outcome the change must deliver.
- Non-goal: workflows or surfaces this deliberately does not change.

### Open Questions
- A workflow-ownership, compatibility, or CI-runtime decision that needs the human.

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
## Routed Project Follow-Ups

- Owning home: shared bin|external repo|mixed
  Evidence: Local evidence that exposed the gap.
  Ownership reason: Why the fix belongs outside the current scope.
  Follow-up scope: The repository, package, or shared tooling scope where the
  project-gaps run or implementation belongs.

## Optional Project Follow-Ups

- Optional or non-blocking idea.
```

## Priority And Confidence

Use confidence as a hard actionability gate: record only proposals at 90%
confidence or higher. Below 90%, gather more evidence or discard the candidate.
Confidence means the inspected evidence makes it very likely that the project
workflow is repository-owned, not already supported, valuable to the named
audience, and implementable without violating local patterns.

Do not assign 90% or higher confidence to a reusable-library or shared-tooling
proposal whose support is limited to package-local possibility, synthetic
fakes, manual construction, or unsupported downstream usage. Inspect supported
usage evidence first.

Assign priority by workflow value and fit, not implementation ease:

- `High`: Improves a primary build, CI, release, validation, setup, or shared
  repository workflow, or removes recurring maintainer/developer friction.
- `Medium`: Improves a real secondary project workflow with clear fit and
  manageable maintenance cost.
- `Low`: Useful but narrow project workflow improvement with limited audience,
  limited urgency, or meaningful tradeoffs that still fit the repository.

Do not use `Low` for vague ideas. Low-priority proposals still need concrete
evidence, audience, fit, and a plausible implementation path.
