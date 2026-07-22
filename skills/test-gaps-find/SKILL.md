---
name: test-gaps-find
description: Use when the user asks to find $test-gaps-find/test gaps in a package or folder, set a confidence closure target such as 95% or 99% for a test-gap audit, find flaky tests, wrong-layer tests, weak harnesses, or test-support-code gaps, or asks what evidence backs a test-gap ledger entry. Find concrete missing, weak, misleading, flaky, wrong-layer, or brittle coverage and record scoped ledger entries; never edits tests. Use $test-gaps-implement to act on a confirmed entry.
---

# Test Gaps Find

Trigger phrases: `Find $test-gaps-find in PACKAGE_OR_FOLDER` or
`Find test gaps in PACKAGE_OR_FOLDER`. This skill only discovers and records
candidates; it never edits tests. Use `$test-gaps-implement` to re-check and
implement a specific ledger entry, using the contract in
`../test-gaps-implement/ledger.yaml`.

Before starting, read `../test-gaps-implement/ledger.yaml`, `references/plan.md`,
`../references/gap-workflow.md`, and `../references/gap-workflow/find-audit.md`;
they own runtime state, ledger, delegation, scope, coverage, and confidence
gates.

## Operating Stance

Operate as a coverage triager: protect repository-owned behavior through the
narrowest credible established test layer, and reject gaps that only test
dependency semantics, private implementation detail, implementation-only
optimizations, or coverage vanity. A missing test is a gap only when the
untested behavior belongs to a real caller-facing contract; a public helper,
exported function, or internal collaborator is not automatically a test boundary.

Use code, executable behavior, existing tests, schemas, generated contracts,
runtime evidence, external standards, and history to establish expected
behavior. Comments, GoDoc, README prose, examples, and other documentation can
be stale. Do not record a test gap merely to make tests enforce stale prose; if
prose and implementation disagree, first prove which behavior is wrong with
non-prose evidence, then route code bugs to `$code-issues-find` and stale
prose to `$doc-gaps-audit` or `$doc-gaps-fix`.

Treat test harnesses, test fixtures, feature helpers, test-support scripts,
cross-language acceptance layers, and test-only Ruby, shell, Go, or other code
as test surfaces when the proposed improvement primarily makes tests more
correct, representative, deterministic, maintainable, configurable, or
appropriately layered. Do not mistake test-support code for product code merely
because it has executable logic. Route pure build, CI, Makefile, release,
validation-preflight, command-discovery, setup, or repository workflow
improvements to `$project-gaps-find`.

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those test-gap rules remain mandatory.

## Ledger Format

Before recording a candidate, read `../test-gaps-implement/ledger.yaml` and
`../test-gaps-implement/references/ledger-format.md` — `$test-gaps-implement`
owns the ledger contract and entry-format definition so there is one canonical
copy. Each entry is a self-contained mini-RFC using `What -> Why -> How`. The
required core must keep `| Field | Value |`, `| Status |`, and
`**Summary.**`; `### What` with `**Current.**` and `**Expected.**`; `### Why`
with `**Impact.**` and `#### Evidence` containing `**Claim:**`,
`**Observed:**`, `**Reproduction:** Smallest supported command`, and
`**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`, `### Goals / Non-goals`,
`### Open Questions`, and `### Decision` only when the entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `references/find-rules.md` before reviewing or recording candidates.
- Read `../test-gaps-implement/ledger.yaml` and
  `../test-gaps-implement/references/ledger-format.md` before creating or
  updating the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate test-coverage leads, and account for rejected or routed candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence
  labels, and severity.
- Use `$testing-standards` for cross-language test quality, coverage,
  fixtures, determinism, and test-layer decisions.
- Use relevant language standards for local test idioms.
- Use `$doc-gaps-audit` or `$doc-gaps-fix` instead when the user asks for a
  standalone missing, stale, misleading, or weak documentation, README,
  example, comment, or docstring pass.
- Use `$project-gaps-find` instead when the concern is build, CI, Makefile,
  release, setup, validation preflight, command discovery, or repository
  workflow rather than test correctness or harness quality.
- Use `$project-workflow` for repository command discovery, CI expectations,
  and `./bin` wiring before review planning.
- Use `$change-validation` when selecting validation commands.
