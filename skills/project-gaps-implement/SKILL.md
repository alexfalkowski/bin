---
name: project-gaps-implement
description: Implement a confirmed project-gap ledger entry when explicitly requested; explain a fix proposal read-only otherwise. Use $project-gaps-find to find workflow gaps.
---

# Project Gaps Implement

Use this skill to work on an existing project-gap entry. An informational
question about a fix receives a read-only explanation and does not authorize
edits. Re-check an entry and implement it only when the human explicitly asks
for implementation. Name an ordered same-prefix batch as
`PREFIX-N[/N...]`, using the prefix from `ledger.yaml`. Use
`$project-gaps-find` first if no scoped ledger entry exists yet for this scope.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, and
implementation gates. Read `ledger.yaml` when resolving the scoped ledger path
or entry ID, `references/ledger-format.md` only before interpreting, creating,
or updating an entry, and `../references/gap-workflow/implementation.md` when
beginning an actual implementation path.

## Operating Stance

Operate as a repository workflow triager: implement only project workflow
improvements to build, CI, release, setup, validation, command discovery,
Makefile, script, or reusable tooling surfaces.

Before proposing an implementation for each project gap, re-check current
Makefiles, CI config, scripts, docs, tests, examples, command behavior, and
comparable workflow evidence. Treat the ledger as something that can go
stale: dismiss or revise proposals that are already supported, duplicate
another project workflow, no longer fit the repository, belong in another
workflow, or have an implementation home outside the requested scope. If the
proposal's implementation home is outside the requested scope, stop and
propose moving or reclassifying it instead of implementing it locally.

Follow `references/plan.md`. For an actual implementation path, also follow
the implementation rules in `../references/gap-workflow/implementation.md`;
an informational explanation remains read-only.

These project-gap implementation rules remain mandatory:

- Ask questions when audience, workflow ownership, compatibility, dependency
  policy, validation, or user intent is ambiguous. Treat silence or a broad
  "implement project gaps" request as permission to start the proposal
  workflow, not as permission to edit.
- Before editing, state the selected local project workflow pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing project workflow changes, state the project execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Implement only the confirmed project gap with the smallest clear change that
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
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. After validation, update the selected ledger entry; a named batch follows the shared sequential re-check and stop rules.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml`
and `references/ledger-format.md`. This skill is the canonical owner of the
ledger contract; `$project-gaps-find` cross-references these same files by
relative path rather than duplicating them. Each entry is a self-contained
mini-RFC using `What -> Why -> How`. The required core must keep
`| Field | Value |`, `| Status |`, and `**Summary.**`; `### What` with
`**Current.**` and `**Expected.**`; `### Why` with `**Impact.**` and
`#### Evidence` containing `**Claim:**`, `**Observed:**`,
`**Reproduction:** Smallest supported maintainer`, and `**Source:**`; and
`### How` with `#### Proposal`, `**Keep.**`, `#### Alternatives Considered`,
and `#### Definition of Success` containing `**Validation:**`. Keep
`| Implementation home | current repo \| shared bin \| external repo \| mixed |`,
and add `#### Situation Map`, `### Goals / Non-goals`, `### Open Questions`,
and `### Decision` only when the entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/implementation.md` for
  implementation sequencing and fresh review.
- Use `$project-workflow` for repository command discovery, documented
  entrypoints, CI expectations, examples, and `./bin` wiring before validation.
- Use `$change-safety` when a proposed project change affects public targets,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$testing-standards` when deciding whether a project workflow change has
  an established executable test layer, and use `$test-gaps-implement`
  instead when the concern is test harness quality or missing/weak tests.
- Use `$doc-standards` when project workflow behavior needs README, docs,
  examples, command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a project change creates or changes target
  names, commands, flags, files, test fixtures, public terminology, or
  documentation terms.
- Use `$change-validation` when selecting validation commands for implemented
  project changes.
- Use `$project-gaps-find` when no scoped ledger entry exists yet for this
  scope.
