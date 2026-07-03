---
name: project-gaps
description: Use when the user asks to find $project-gaps in a package or folder, find project gaps in a package or folder, find project gaps with a specific confidence closure target such as 95% or 99%, find build, CI, Makefile, release, setup, validation, command discovery, or repository workflow gaps, implement $project-gaps in a package or folder, implement project gaps in a package or folder, uses a remembered command such as Work PROJECT-1 or Agent goal work PROJECT-1, asks about project gap IDs such as PROJECT-1, asks what the fix is for PROJECT-1, asks to fix or verify PROJECT-1, or says PROJECT-1 is done. Find concrete repository workflow and project plumbing improvements, record confirmed gaps in scoped PROJECTS.md, and later propose and implement agreed fixes one gap at a time.
---

# Project Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $project-gaps in PACKAGE_OR_FOLDER` or `Find project gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $project-gaps in PACKAGE_OR_FOLDER` or `Implement project gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

## Operating Stance

Operate as a repository workflow triager: propose only improvements to the
project's build, CI, release, setup, validation, command discovery, Makefile,
script, reusable tooling, or local developer workflow surfaces. A project gap
is not a product feature, code bug, security issue, reliability gap, test gap,
doc gap, naming issue, or style preference.

Use `$feature-gaps` for main product behavior and first-class user or consumer
capabilities. Use `$test-gaps` when the concern is test coverage, wrong-layer
tests, flaky tests, or test-harness/support-code quality. Use `$doc-gaps` when
the concern is missing, stale, or misleading documentation or command help for
existing behavior.

Treat local repository evidence as the primary source of fit. Comparable CI,
build, release, or developer workflow patterns can reveal useful project
opportunities, but do not record a project gap merely because another project
has a target, script, workflow, or convention. First prove the opportunity maps
to this repository's workflow ownership, audience, and maintenance posture.

## Acceptance Gate

Apply this gate before recording any candidate in `PROJECTS.md`. A project
proposal must satisfy every item below at 90% confidence or higher. If any item
cannot be answered from concrete evidence, gather more evidence or reject the
candidate instead of recording it as low priority.

- **Audience**: Name the developer, maintainer, operator, service author, or
  package consumer who benefits from the project workflow improvement.
- **Current limitation**: State the existing build, CI, release, setup,
  validation, command discovery, Makefile, script, reusable tooling, or
  repository workflow friction.
- **Project surface**: Identify the repository-owned project workflow surface:
  Make target or fragment, CI job, setup path, release/versioning flow,
  validation/preflight entrypoint, script, generated-artifact check, local
  developer command, or shared `./bin` wiring.
- **Implementation home**: Identify where the smallest useful fix should live:
  current repo, shared `bin`, external repo, or mixed. Confirm the requested
  scope owns that home before recording a normal project gap.
- **Evidence**: Cite concrete local evidence such as Makefiles, CI config,
  scripts, docs, command behavior, recurring maintainer workflow, or comparable
  mature project workflow behavior. Comparable evidence is supporting evidence,
  not a sufficient reason by itself.
- **Repository fit**: Explain why the improvement matches the repository
  purpose, current command style, dependency posture, validation model, and
  downstream `./bin` reuse model when relevant.
- **Smallest useful version**: Define the smallest project workflow change that
  creates real value without broad build-system churn or speculative platform
  work.
- **Compatibility and maintenance**: Identify public target behavior, migration,
  dependency, security, CI runtime, support, and long-term maintenance
  tradeoffs. Reject proposals whose cost or compatibility risk outweighs the
  demonstrated value.
- **Validation path**: Name the repository-defined command, lint, CI check,
  dry-run, or manual verification path that can credibly validate the change.
- **Correct workflow**: Confirm the candidate is not primarily a product
  feature, code bug, security issue, reliability gap, test gap, doc gap, naming
  issue, style preference, or unsupported roadmap decision.
- **Upstream ownership**: When the evidence points to a third-party library,
  framework, tool, image, or another project-owned library, confirm whether the
  requested scope owns a dependency/workflow response or should route the
  candidate to the owning project.

Reject ideas whose support is only novelty, taste, competitor parity, a trend,
an imagined future workflow, private implementation preference, or generic
"nice to have" polish.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These project-gap rules remain mandatory:

- Use `PROJECTS.md` in the requested package or folder as the proposal ledger,
  for example `PACKAGE_OR_FOLDER/PROJECTS.md`.
- Classify every candidate's implementation home before recording it. Use:
  `current repo` when the requested scope owns the fix; `shared bin` when
  reusable `bin` tooling owns the fix; `external repo` when another repository,
  image, third-party dependency, tool, or project-owned upstream library owns
  the invoked command, script, CI job, release behavior, or underlying defect;
  and `mixed` only when a small local adapter plus an owning upstream change are
  both necessary.
- Treat third-party library, framework, tool, and image defects as project
  workflow candidates only for the repository-owned response. The upstream
  defect itself is not a normal `PROJECT-N` for the current scope.
- Before assigning review agents or starting local review, build a recursive
  scope inventory for the requested package or folder: relevant file count,
  first-level subfolders, nested packages, dominant languages, Makefiles, CI
  config, scripts, validation entrypoints, release/deploy/versioning surfaces,
  setup flows, command discovery surfaces, generated/vendor/build/cache
  exclusions, tests, docs, examples, and likely project workflow extension
  points.
- Prefer slices based on repository-owned project workflow value: Make targets
  and fragments, CI jobs, setup and dependency installation, validation and
  local preflight, release/versioning/publishing paths, reusable scripts,
  command discovery/help entrypoints, downstream `./bin` wiring, and changed or
  recently touched project tooling.
- For delegated review, each assigned agent owns recursive review only within
  its bounded slice. Each agent must perform project-gap discovery for that
  slice, pairing with
  `$project-workflow`, `$change-safety`, `$change-validation`, relevant
  language standards, and `$testing-standards` only when needed to route
  test-surface concerns correctly.
- Confirm each candidate project gap against the acceptance gate, repository
  commands, CI config, Makefiles, scripts, docs, tests, examples, and current
  architecture before recording it. Try to disprove the candidate by asking
  whether the workflow is already supported, whether the repository owns the
  surface, whether the likely audience exists, and whether the project change
  can be added incrementally using local patterns.
- Do not record confirmed bugs, security issues, compatibility breaks,
  reliability gaps, missing tests, stale docs, unclear naming, or main product
  feature ideas as project gaps. Route them to `$code-issues`,
  `$security-audit`, `$reliability-gaps`, `$test-gaps`, `$doc-gaps`,
  `$naming-standards`, or `$feature-gaps` as appropriate.
- If a candidate mostly improves test correctness, test coverage, test-harness
  maintainability, fixture design, test determinism, or wrong-layer tests, route
  it to `$test-gaps` even when the changed file is Ruby, shell, or another
  language used only by the test harness.
- If a candidate mostly adds or improves product-owned capabilities for users,
  package consumers, service authors, or operators, route it to
  `$feature-gaps`.
- If a candidate mostly documents existing behavior, route it to `$doc-gaps`.
- If a candidate's implementation home is outside the requested scope, do not
  record it as a normal `PROJECT-N` for that scope. Record it under
  `Routed Project Follow-Ups` with the owning home and local evidence, or route
  it to a separate project-gaps run in the owning repository or shared tooling
  scope.

## `PROJECTS.md` Format

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

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These project-gap implementation rules remain mandatory:

- Before proposing an implementation for each project gap, re-check current
  Makefiles, CI config, scripts, docs, tests, examples, command behavior, and
  comparable workflow evidence. Treat the ledger as something that can go
  stale: dismiss or revise proposals that are already supported, duplicate
  another project workflow, no longer fit the repository, belong in another
  workflow, or have an implementation home outside the requested scope.
- If the proposal's implementation home is outside the requested scope, stop
  and propose moving or reclassifying it instead of implementing it locally.
- Ask questions when audience, workflow ownership, compatibility, dependency
  policy, validation, or user intent is ambiguous. Treat silence or a broad
  "implement project gaps" request as permission to start the proposal
  workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local project workflow pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing project workflow changes, state the project execution checklist before editing:
   - `TDD decision`: yes/no, with the concrete reason if no.
   - `First test/scenario`: the narrowest test, fixture, example, dry-run, or
     scenario to add or update first.
   - `Expected red`: the command and failure expected before implementation
     edits, or why red is not practical for project tooling.
   - `Intended green change`: the smallest implementation expected to pass.
   - `Refactor checkpoint`: the cleanup pass planned after green, or `none`.
   - `Validation`: the focused and expanded commands intended after refactor.
- Implement only the agreed project gap with the smallest clear change that
  preserves existing public behavior unless the human explicitly approved a
  compatibility break.
- Use `$change-safety` for public targets, compatibility, migrations, generated
  files, config, dependencies, deployment, release behavior, or
  security-sensitive workflow changes.
- Use `$testing-standards` only when adding or changing executable tests for
  project workflow behavior; do not invent a language-native test layer for
  Makefile, CI, shell, Docker, policy, metadata, or formatting-only changes.
- Use `$doc-standards` when the project change affects public commands, Make
  targets, setup, validation, release, configuration, or documented workflows.
- Use `$change-validation` when selecting validation commands.
- Report the result for that project gap with `Red`, `Green`, `Refactor`, and
  `Validation` entries. Use `Refactor: none (<reason>)` when no cleanup was
  needed after green. Then ask the human to verify and explicitly say
  `PROJECT-N is done`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
- Use `../references/gap-lead-generation.md` during Find mode to classify repo
  archetypes, generate project-workflow leads, and account for rejected or
  routed candidates.
- Use `$project-workflow` for repository command discovery, documented
  entrypoints, CI expectations, examples, and `./bin` wiring before review
  planning or validation.
- Use `$change-safety` when a proposed project change affects public targets,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$testing-standards` when deciding whether a project workflow change has
  an established executable test layer, and use `$test-gaps` instead when the
  concern is test harness quality or missing/weak tests.
- Use `$doc-standards` when project workflow behavior needs README, docs,
  examples, command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a project change creates or changes target names,
  commands, flags, files, test fixtures, public terminology, or documentation
  terms.
- Use `$change-validation` when selecting validation commands for implemented
  project changes.
- Use `$code-issues`, `$security-audit`, `$reliability-gaps`, `$test-gaps`,
  `$doc-gaps`, or `$feature-gaps` when the confirmed concern belongs to those
  ledgers instead of project workflow opportunities.
