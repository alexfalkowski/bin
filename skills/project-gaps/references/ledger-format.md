# `PROJECTS.md` Format

Use this structure:

````markdown
# Projects

## PROJECT-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Project Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Audience | Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Implementation home | current repo \| shared bin \| external repo \| mixed |
| Project surface | Make target \| CI job \| script \| setup flow \| validation flow \| release flow \| command discovery \| shared ./bin wiring. |

### Workflow Map

```text
current limitation: The project workflow friction or missing project capability.
ownership: Why this scope owns the fix, or why the issue is routed to a
third-party, external repo, shared tooling, or upstream project-owned library.
repository fit: Why this belongs in the current repository and matches existing project patterns.
compatibility and maintenance: Public target behavior, dependency, migration,
support, CI runtime, or maintenance tradeoffs.
```

### Evidence

```text
Evidence: Concrete file and line references, command behavior, CI config, docs,
examples, comparable workflow evidence, or maintainer workflow evidence.
Reproduction: Smallest supported maintainer, developer, CI, Make, setup,
validation, release, or command-discovery workflow trace that demonstrates the
current friction or missing project capability.
```

### Decision Trace

```text
maintainer or workflow actor
  -> current command or project surface
  -> observed friction or missing capability
  -> owning implementation home
  -> smallest useful project change
  -> validation that proves the workflow
```

### Proposed Change

```yaml
proposed_change: Smallest useful project workflow improvement.
validation:
  - Suggested checks for the project workflow change.
```
````

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
