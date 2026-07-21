---
name: test-gaps
description: Use when the user asks to find or implement $test-gaps/test gaps in a package or folder, set a confidence closure target such as 95% or 99%, find flaky tests, wrong-layer tests, weak harnesses, or test-support-code gaps, uses Start, Approved, or Done with ledger entry IDs and optional agents or a goal, or asks what the fix is for a test-gap ledger entry. Find concrete missing, weak, misleading, flaky, wrong-layer, or brittle coverage; record scoped ledger entries; later propose and implement agreed entries sequentially, including contract-driven same-prefix approved batches.
---

# Test Gaps

Use Find mode by default when no mode is stated. Enter Implement mode only
after the human explicitly agrees to a specific proposed solution, typically
with `Approved <ID>-N`, or a same-prefix batch
`Approved <ID>-N[/N...]`, using the prefix from `ledger.yaml`. The shared
workflow processes an approved batch sequentially. Do not combine modes in one pass:

- **Find mode**: `Find $test-gaps in PACKAGE_OR_FOLDER` or `Find test gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $test-gaps in PACKAGE_OR_FOLDER` or `Implement test gaps in PACKAGE_OR_FOLDER`.

Before either mode, read `ledger.yaml`, `references/plan.md`, and
`../references/gap-workflow.md` and the mode-specific reference below own
runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates. Before Find mode, also read
`../references/gap-workflow/find-audit.md`; before Implement mode, also read
`../references/gap-workflow/implementation.md`.

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
non-prose evidence, then route code bugs to `$code-issues` and stale prose to
`$doc-gaps`.

Treat test harnesses, test fixtures, feature helpers, test-support scripts,
cross-language acceptance layers, and test-only Ruby, shell, Go, or other code
as test surfaces when the proposed improvement primarily makes tests more
correct, representative, deterministic, maintainable, configurable, or
appropriately layered. Do not mistake test-support code for product code merely
because it has executable logic. Route pure build, CI, Makefile, release,
validation-preflight, command-discovery, setup, or repository workflow
improvements to `$project-gaps`.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those test-gap rules remain mandatory in Find
mode.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml` and
`references/ledger-format.md`. Each entry is a self-contained mini-RFC using
`What -> Why -> How`. The required core must keep `| Field | Value |`,
`| Status |`, and `**Summary.**`; `### What` with `**Current.**` and
`**Expected.**`; `### Why` with `**Impact.**` and `#### Evidence` containing
`**Claim:**`, `**Observed:**`, `**Reproduction:** Smallest supported command`,
and `**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`,
`### Goals / Non-goals`, `### Open Questions`, and `### Decision` only when the
entry warrants them.

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow/implementation.md`.

These test-gap implementation rules remain mandatory:

- Before proposing a fix for each finding, re-check the current code and nearby tests. Treat the ledger as something that can go stale: dismiss or revise findings that are already covered, would duplicate the local test shape, test only underlying libraries/frameworks, or require validation modes the repository does not run.
- When re-checking a finding whose evidence depends on documentation or comments contradicting implementation, prove the expected behavior with non-prose evidence before proposing tests. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a test gap and propose reclassifying or fixing documentation instead.
- Ask questions when behavior, compatibility, test layer, fixture strategy, validation, or user intent is ambiguous. Treat silence or a broad "implement test gaps" request as permission to start the proposal workflow, not as permission to code.
- After the human agrees and before editing, state the selected local test pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed finding with the smallest clear test change, preferring the existing local test shape over new standalone structure.
- Use `$testing-standards` for test design and pair with the relevant language standard for local idioms. If implementing the test gap requires production behavior to change, prefer the test-first or scenario-first loop from `$testing-standards`.
- For test gaps that require behavior-changing production code, state the test execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. For a single approval, ask the human to verify and say `Done <ID>-N` using the prefix from `ledger.yaml`; an approved batch follows the shared sequential re-check and stop rules.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `references/find-rules.md` during Find mode before reviewing or
  recording candidates.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for Find-mode rules and
  `../references/gap-workflow/implementation.md` for Implement-mode rules.
- Use `../references/decision-card.md` to present the agreement-gate proposal as a self-contained decision card.
- Use `../references/gap-lead-generation.md` during Find mode to classify repo
  archetypes, generate test-coverage leads, and account for rejected or routed
  candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$testing-standards` for cross-language test quality, coverage, fixtures, determinism, and test-layer decisions.
- Use relevant language standards for local test idioms.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-gaps` instead when the concern is build, CI, Makefile, release,
  setup, validation preflight, command discovery, or repository workflow rather
  than test correctness or harness quality.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented test fixes.
