# Ledger Format

Each entry is a self-contained, debatable mini-RFC. A reviewer must be able to
understand the workflow gap, the evidence, and the proposed direction without
opening another file. Organize the entry as `What -> Why -> How`. Keep the
**required core** on every entry, and add the **expandable sections** only when
they help a real decision.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable Make target, CI job, script, command, workflow, or heading over a
bare line number. Add a line number only when it makes the source faster to
find. Include the relevant short excerpt or observed output when the reviewer
would otherwise need to reconstruct the claim from source.

## Required Core

Use this structure for every entry:

````markdown
# Projects

## <ID>-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Project Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Scope | path/to/file-or-folder |
| Audience | Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Implementation home | current repo \| shared bin \| external repo \| mixed |
| Project surface | Make target \| CI job \| script \| setup flow \| validation flow \| release flow \| command discovery \| shared ./bin wiring. |

**Summary.** In one or two plain sentences, state the project workflow friction,
why it matters, and the proposed improvement direction.

### What

**Current.** State the supported project workflow, its current friction or
missing capability, and who encounters it.

**Expected.** State the workflow outcome that should become possible and the
project surface that should provide it.

### Why

**Impact.** Explain the concrete developer, maintainer, operator, consumer, CI,
release, or delivery cost and why the named implementation home owns the change.

#### Evidence

- **Claim:** The plain-language workflow fact this evidence establishes.
- **Observed:** The actual command behavior, CI result, setup friction, missing
  surface, or workflow trace, with enough detail to understand it here.
- **Reproduction:** Smallest supported maintainer, developer, CI, Make, setup,
  validation, release, or command-discovery workflow trace that demonstrates
  the current friction or missing project capability.
- **Source:** `path/to/file` — stable Make target, CI job, script, command,
  workflow, or heading; line number optional.

### How

#### Proposal

Describe the smallest useful project workflow improvement, its implementation
home, and any public-target, dependency, migration, CI-runtime, or maintenance
cost.

**Keep.** Name the existing targets, CI behavior, setup paths, release behavior,
or ownership boundaries that must remain unchanged.

#### Alternatives Considered

- Chosen: the proposal above — why this home and surface fit.
- Other option: a different implementation home (shared bin / repo-local /
  external) or project surface — why not.
- Do nothing: the friction of leaving the workflow as is.

#### Definition of Success

- The observable proof the workflow improves (the target runs, CI passes, or the
  command is discoverable).
- **Validation:** The repository command(s), CI path(s), or workflow check(s)
  that prove the result.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

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
[Project surface]
    |-- today --> [Current outcome]
    +-- target -> [Expected outcome]
```

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

Use confidence as the active actionability gate: record only proposals at or
above the active threshold. The active threshold is the explicit confidence
target in the current request when provided; otherwise use 90% (or 95% for
high-risk acceptance). Below the active threshold, gather more evidence or
discard the candidate. Confidence means the inspected evidence supports that
the project workflow is repository-owned, not already supported, valuable to
the named audience, and implementable without violating local patterns. If an
explicit target lowers the default, state the reduced assurance and residual
risks.

Do not assign confidence at or above the active threshold to a reusable-library
or shared-tooling proposal whose support is limited to package-local
possibility, synthetic fakes, manual construction, or unsupported downstream
usage. Inspect supported usage evidence first.

Assign priority by workflow value and fit, not implementation ease:

- `High`: Improves a primary build, CI, release, validation, setup, or shared
  repository workflow, or removes recurring maintainer/developer friction.
- `Medium`: Improves a real secondary project workflow with clear fit and
  manageable maintenance cost.
- `Low`: Useful but narrow project workflow improvement with limited audience,
  limited urgency, or meaningful tradeoffs that still fit the repository.

Do not use `Low` for vague ideas. Low-priority proposals still need concrete
evidence, audience, fit, and a plausible implementation path.
