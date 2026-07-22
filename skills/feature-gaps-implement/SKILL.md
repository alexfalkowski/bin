---
name: feature-gaps-implement
description: Use when the human asks to work on or asks what the proposal is for a feature-gap ledger entry. Re-check that the confirmed entry still stands, then implement it; named same-prefix batches run sequentially.
---

# Feature Gaps Implement

Use this skill to work on an existing feature-gap entry. Re-check that it still
stands before editing, then implement it. Name an ordered same-prefix batch as
`PREFIX-N[/N...]`, using the prefix from `ledger.yaml`. Use
`$feature-gaps-find` first if no scoped ledger entry exists yet for this scope.

Before starting, read `ledger.yaml`, `references/plan.md`,
`../references/gap-workflow.md`, and `../references/gap-workflow/implementation.md`;
they own runtime state, ledger, delegation, scope, and implementation gates.

## Operating Stance

Operate as a scoped product implementer: implement only the confirmed feature
with the smallest clear change that preserves existing public behavior unless
the human explicitly approved a compatibility break.

These feature implementation rules remain mandatory:

- Before implementation, re-check the current
  code, generated surfaces, framework wrappers, shared helpers, vendored
  dependency behavior when delegated, docs, tests, examples, command behavior,
  and comparable-tool evidence. Treat the ledger as something that can go
  stale: dismiss or revise proposals that are already supported, duplicate
  another feature, no longer fit the repository, or belong in another workflow.
- Ask questions when audience, product direction, compatibility, dependency
  policy, UX/DX behavior, test layer, validation, or user intent is ambiguous.
  Treat a broad "implement feature gaps" request as permission to re-check and
  implement a selected ledger entry, not as permission to invent one.
- Before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- In that pre-edit statement, also state the simplest implementation shape that
  satisfies the feature using existing local code, config, docs, harness,
  lifecycle, and validation patterns.
- Treat new orchestration, lifecycle, or harness machinery as a complexity
  trigger. Before adding extra processes, ports, config files, startup paths,
  lifecycle hooks, env/config indirection, harness classes, generated fixtures,
  or helper layers, stop and explain why the existing repository pattern cannot
  support the confirmed feature. If the reason is only flexibility,
  convenience, experimentation, or personal clarity, do not add the machinery.
- For behavior-changing features, state the feature execution checklist before
  editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended
  green change`, `Refactor checkpoint`, and `Validation`. When the harness is
  runnable, observe and paste the red (command + failing output) before
  implementation edits; if it is not runnable, stop and request agreement to
  proceed test-after with the reason rather than skipping red silently.
- Implement only the confirmed feature with the smallest clear change that
  preserves existing public behavior unless the human explicitly approved a
  compatibility break.
- Use `$change-safety` for public interfaces, compatibility, migration,
  generated files, config, security-sensitive behavior, or dependencies.
- Use `$testing-standards` for test design and pair with relevant language
  standards for local idioms.
- Use `$doc-standards` when the feature changes public commands, APIs, examples,
  configuration, or documented workflows.
- Use `$change-validation` when selecting validation commands.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. After validation, update the selected ledger entry; a named batch follows the shared sequential re-check and stop rules.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml`
and `references/ledger-format.md`. This skill is the canonical owner of the
ledger contract; `$feature-gaps-find` cross-references these same files by
relative path rather than duplicating them. Each entry is a self-contained
mini-PRD organized like the shared mini-RFC: `What -> Why -> How`. The
required core must keep `| Field | Value |`, `| Status |`, and
`**Summary.**`; `### What` with `**Current.**` and `**Expected.**`; `### Why`
with `**Impact.**` and `#### Evidence` containing `**Claim:**`,
`**Observed:**`, `**Reproduction:** Smallest supported user`, and
`**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`, `### Goals / Non-goals` (usually
warranted for features), `### Open Questions`, and `### Decision` when the
entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/implementation.md` for
  implementation sequencing and fresh review.
- Use `$change-safety` when a proposed feature affects public contracts,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$testing-standards` when deciding or reviewing tests for a feature.
- Use `$doc-standards` when feature behavior needs README, docs, examples,
  command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a feature creates or changes identifiers,
  commands, flags, files, test fixtures, public terminology, or documentation
  terms.
- Use `$change-validation` when selecting validation commands for implemented
  feature changes.
- Use `$feature-gaps-find` when no scoped ledger entry exists yet for this
  scope.
