---
name: project-gaps
description: Use when the user asks to find or implement $project-gaps/project gaps in a package or folder, set a confidence closure target such as 95% or 99%, find build, CI, Makefile, release, setup, validation, command discovery, or repository workflow gaps, uses Start PROJECT-1 or Approved PROJECT-1 with agents and a goal, asks about project gap IDs such as PROJECT-1, asks what the fix is for PROJECT-1, asks to fix or verify PROJECT-1, or uses Done PROJECT-1. Find concrete repository workflow and project plumbing improvements; record scoped PROJECTS.md entries; later propose and implement agreed fixes one at a time.
---

# Project Gaps

Use Find mode by default when no mode is stated. Enter Implement mode only
after the human explicitly agrees to a specific proposed solution, typically
with `Approved PROJECT-N`. Do not combine modes in one pass:

- **Find mode**: `Find $project-gaps in PACKAGE_OR_FOLDER` or `Find project gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $project-gaps in PACKAGE_OR_FOLDER` or `Implement project gaps in PACKAGE_OR_FOLDER`.

Before either mode, read `references/plan.md` and
`../references/gap-workflow.md` and the mode-specific reference below own
runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates. Before Find mode, also read
`../references/gap-workflow/find-audit.md`; before Implement mode, also read
`../references/gap-workflow/implementation.md`.

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

Before recording any `PROJECTS.md` candidate, read
`references/acceptance-gate.md`. A proposal must satisfy that gate at the
active confidence threshold or higher. Use an explicit confidence target from
the current request when provided; otherwise use the 90% default (or the 95%
high-risk default when applicable). A lower explicit target changes the
actionability threshold but does not waive the gate's evidence requirements.
Otherwise gather more evidence or reject the proposal.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those project-gap rules remain mandatory in
Find mode.

If a candidate's implementation home is outside the requested scope, route it
according to `references/find-rules.md` instead of recording it as a normal
local project gap.

## `PROJECTS.md` Format

Before creating, updating, or interpreting `PROJECTS.md`, read
`references/ledger-format.md`. Each entry is a self-contained mini-RFC using
`What -> Why -> How`. The required core must keep `| Field | Value |`,
`| Status |`, and `**Summary.**`; `### What` with `**Current.**` and
`**Expected.**`; `### Why` with `**Impact.**` and `#### Evidence` containing
`**Claim:**`, `**Observed:**`, `**Reproduction:** Smallest supported maintainer`,
and `**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Keep
`| Implementation home | current repo \| shared bin \| external repo \| mixed |`,
and add `#### Situation Map`, `### Goals / Non-goals`, `### Open Questions`, and
`### Decision` only when the entry warrants them.

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow/implementation.md`.

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
- For behavior-changing project workflow changes, state the project execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
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
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. Ask the human to verify and say `Done PROJECT-N`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `references/find-rules.md` during Find mode before reviewing or
  recording candidates.
- Read `references/acceptance-gate.md` before recording any `PROJECTS.md`
  candidate.
- Read `references/ledger-format.md` before creating, updating, or interpreting
  `PROJECTS.md`.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for Find-mode rules and
  `../references/gap-workflow/implementation.md` for Implement-mode rules.
- Use `../references/decision-card.md` to present the agreement-gate proposal as a self-contained decision card.
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
