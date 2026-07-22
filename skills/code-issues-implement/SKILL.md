---
name: code-issues-implement
description: Use when the human says Approved <ID>-N or Start <ID> for a code-issue ledger entry, approves a same-prefix batch such as Approved <ID>-N[/N...], or asks what the fix is for a code-issue ledger entry. Implement agreed code-issue fixes sequentially after explicit agreement, including contract-driven same-prefix approved batches; never starts work without that agreement.
---

# Code Issues Implement

Enter only after the human explicitly agrees to a specific proposed solution,
typically with `Approved <ID>-N`, or a same-prefix batch
`Approved <ID>-N[/N...]`, using the prefix from `ledger.yaml`. The shared
workflow processes an approved batch sequentially. Use `$code-issues-find`
first if no scoped ledger entry exists yet for this scope.

Before starting, read `ledger.yaml`, `references/plan.md`,
`../references/gap-workflow.md`, and `../references/gap-workflow/implementation.md`;
they own runtime state, ledger, delegation, scope, and approval gates.

## Operating Stance

Operate as a strict issue triager and ledger owner: implement only confirmed
code defects tied to user-visible or contract risk, and keep the scoped ledger
accurate as entries resolve.

Code is the default source of behavioral truth. When re-checking an issue
whose evidence depends on documentation or comments contradicting
implementation, prove the code is wrong before proposing a code change. If
non-prose evidence supports the implementation, explain that the ledger item
is invalid as a code issue and propose reclassifying or fixing the
documentation instead via `$doc-gaps-fix`.

Follow `references/plan.md` and the implementation rules in
`../references/gap-workflow/implementation.md`.

These code-issue implementation rules remain mandatory:

- Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
- When re-checking an issue whose evidence depends on documentation or comments contradicting implementation, prove the code is wrong before proposing a code change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a code issue and propose reclassifying or fixing the documentation instead.
- After the human agrees and before editing, state the selected local code pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Use `$testing-standards` when deciding whether to add or update regression tests for the fix, and prefer its test-first or scenario-first loop when a behavior-changing fix has a credible test or BDD layer.
- For behavior-changing fixes, state the issue execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. For a single approval, ask the human to verify and say `Done <ID>-N` using the prefix from `ledger.yaml`; an approved batch follows the shared sequential re-check and stop rules.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml`
and `references/ledger-format.md`. This skill is the canonical owner of the
ledger contract; `$code-issues-find` cross-references these same files by
relative path rather than duplicating them. Each entry is a self-contained
mini-RFC using `What -> Why -> How`. The required core must keep
`| Field | Value |`, `| Status |`, and `**Summary.**`; `### What` with
`**Current.**` and `**Expected.**`; `### Why` with `**Impact.**` and
`#### Evidence` containing `**Claim:**`, `**Observed:**`,
`**Reproduction:** Smallest supported command`, and `**Source:**`; and
`### How` with `#### Proposal`, `**Keep.**`, `#### Alternatives Considered`,
and `#### Definition of Success` containing `**Validation:**`. Add
`#### Situation Map`, `### Goals / Non-goals`, `### Open Questions`, and
`### Decision` only when the entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/implementation.md` for
  implementation sequencing and fresh review.
- Use `../references/decision-card.md` to present the agreement-gate proposal
  as a self-contained decision card.
- Use `../references/finding-severity.md` for confidence filtering, confidence
  labels, and severity.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$project-workflow` for repository command discovery, CI expectations,
  and `./bin` wiring before validation.
- Use `$change-validation` when selecting validation commands for implemented
  fixes.
- Use `$code-issues-find` when no scoped ledger entry exists yet for this scope.
