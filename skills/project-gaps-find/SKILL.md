---
name: project-gaps-find
description: Find scoped build, CI, Makefile, release, setup, validation, command-discovery, and workflow gaps without edits; use $project-gaps-implement for confirmed entries.
---

# Project Gaps Find

Trigger phrases: `Find $project-gaps-find in PACKAGE_OR_FOLDER` or
`Find project gaps in PACKAGE_OR_FOLDER`. This skill only discovers and
records candidates; it never edits files. Use `$project-gaps-implement` to
re-check and implement a specific ledger entry, using the contract in
`../project-gaps-implement/ledger.yaml`.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, coverage, and
confidence gates. Read `references/find-rules.md` when beginning review and
`references/acceptance-gate.md` before recording a candidate. Read
`../references/gap-workflow/find-audit.md` when beginning review mechanics.
Read `../project-gaps-implement/ledger.yaml` only when resolving the scoped
ledger path or an entry ID, and its ledger format only before interpreting,
creating, or updating an entry.

## Operating Stance

Operate as a repository workflow triager: propose only improvements to the
project's build, CI, release, setup, validation, command discovery, Makefile,
script, reusable tooling, or local developer workflow surfaces. A project gap
is not a product feature, code bug, security issue, reliability gap, test gap,
doc gap, naming issue, or style preference.

Use `$feature-gaps-find` for main product behavior and first-class user or
consumer capabilities. Use `$test-gaps-find` when the concern is test
coverage, wrong-layer tests, flaky tests, or test-harness/support-code
quality. Use `$doc-gaps-audit` or `$doc-gaps-fix` when the concern is missing,
stale, or misleading documentation or command help for existing behavior.

Treat local repository evidence as the primary source of fit. Comparable CI,
build, release, or developer workflow patterns can reveal useful project
opportunities, but do not record a project gap merely because another project
has a target, script, workflow, or convention. First prove the opportunity maps
to this repository's workflow ownership, audience, and maintenance posture.

## Acceptance Gate

Before recording any scoped-ledger candidate, read
`references/acceptance-gate.md`. A proposal must satisfy that gate at the
active confidence threshold or higher. Use an explicit confidence target from
the current request when provided; otherwise use the 90% default (or the 95%
high-risk default when applicable). A lower explicit target changes the
actionability threshold but does not waive the gate's evidence requirements.
Otherwise gather more evidence or reject the proposal.

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Those project-gap rules remain mandatory.

If a candidate's implementation home is outside the requested scope, route it
according to `references/find-rules.md` instead of recording it as a normal
local project gap.

## Ledger Format

Before recording a candidate, read `../project-gaps-implement/ledger.yaml` and
`../project-gaps-implement/references/ledger-format.md` —
`$project-gaps-implement` owns the ledger contract and entry-format
definition so there is one canonical copy. Each entry is a self-contained
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
- Read `references/find-rules.md` before reviewing or recording candidates.
- Read `references/acceptance-gate.md` before recording any scoped-ledger
  candidate.
- Read `../project-gaps-implement/ledger.yaml` and
  `../project-gaps-implement/references/ledger-format.md` before creating or
  updating the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate project-workflow leads, and account for rejected or routed
  candidates.
- Use `$project-workflow` for repository command discovery, documented
  entrypoints, CI expectations, examples, and `./bin` wiring before review
  planning.
- Use `$change-safety` when a proposed project change affects public targets,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$testing-standards` when deciding whether a project workflow change has
  an established executable test layer, and use `$test-gaps-find` instead when
  the concern is test harness quality or missing/weak tests.
- Use `$doc-standards` when project workflow behavior needs README, docs,
  examples, command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a project change creates or changes target
  names, commands, flags, files, test fixtures, public terminology, or
  documentation terms.
- Use `$code-issues-find`, `$security-audit`, `$reliability-gaps-find`,
  `$test-gaps-find`, `$doc-gaps-audit`/`$doc-gaps-fix`, or `$feature-gaps-find`
  when the confirmed concern belongs to those ledgers instead of project
  workflow opportunities.
