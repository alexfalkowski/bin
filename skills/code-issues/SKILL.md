---
name: code-issues
description: Use when the user asks to find or implement $code-issues/code issues in a package or folder, set a confidence closure target such as 95% or 99%, uses Start ISSUE-1 or Approved ISSUE-1 with agents and a goal, asks about issue IDs such as ISSUE-1, asks what the fix is for ISSUE-1, asks to fix or verify ISSUE-1, or uses Done ISSUE-1. Find concrete bugs, security issues, compatibility breaks, and public contract violations; record scoped ISSUES.md entries; later propose and implement agreed fixes one at a time.
---

# Code Issues

Use this skill in two distinct modes; do not combine them in one pass:

- **Find mode**: `Find $code-issues in PACKAGE_OR_FOLDER` or `Find code issues in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $code-issues in PACKAGE_OR_FOLDER` or `Implement code issues in PACKAGE_OR_FOLDER`.

Before either mode, read `references/plan.md` and
`../references/gap-workflow.md` and the mode-specific reference below own
runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates. Before Find mode, also read
`../references/gap-workflow/find-audit.md`; before Implement mode, also read
`../references/gap-workflow/implementation.md`.

## Operating Stance

Operate as a strict issue triager and ledger owner: separate confirmed code
defects from test gaps, doc gaps, polish, and speculation; keep the scoped
`ISSUES.md` actionable, deduplicated, and tied to user-visible or contract risk.

Code is the default source of behavioral truth. Comments, GoDoc, README prose,
examples, and other documentation can be stale. Do not record or implement a
code issue merely because prose and implementation disagree. First prove the
implementation is wrong using non-prose evidence such as executable behavior,
tests, schemas, wire/API contracts, external standards, runtime failures, or
history showing an unintended code regression. If implementation and tests agree
while prose disagrees, treat it as a documentation gap and update the docs.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those code-issue rules remain mandatory in
Find mode.

## `ISSUES.md` Format

Before creating, updating, or interpreting `ISSUES.md`, read
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

These code-issue implementation rules remain mandatory:

- Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
- When re-checking an issue whose evidence depends on documentation or comments contradicting implementation, prove the code is wrong before proposing a code change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a code issue and propose reclassifying or fixing the documentation instead.
- After the human agrees and before editing, state the selected local code pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Use `$testing-standards` when deciding whether to add or update regression tests for the fix, and prefer its test-first or scenario-first loop when a behavior-changing fix has a credible test or BDD layer.
- For behavior-changing fixes, state the issue execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. Ask the human to verify and say `Done ISSUE-N`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `references/find-rules.md` during Find mode before reviewing or
  recording candidates.
- Read `references/ledger-format.md` before creating, updating, or interpreting
  `ISSUES.md`.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for Find-mode rules and
  `../references/gap-workflow/implementation.md` for Implement-mode rules.
- Use `../references/decision-card.md` to present the agreement-gate proposal as a self-contained decision card.
- Use `../references/gap-lead-generation.md` during Find mode to classify repo
  archetypes, generate high-risk leads, and account for rejected or routed
  candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps` instead when the user asks for a standalone missing or weak test coverage pass.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented fixes.
