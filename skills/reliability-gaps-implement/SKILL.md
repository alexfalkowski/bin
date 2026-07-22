---
name: reliability-gaps-implement
description: Use when the human says Approved <ID>-N or Start <ID> for a reliability-gap ledger entry, approves a same-prefix batch such as Approved <ID>-N[/N...], or asks what the fix is for a reliability-gap ledger entry. Implement agreed reliability fixes sequentially after explicit agreement, including contract-driven same-prefix approved batches; never starts work without that agreement.
---

# Reliability Gaps Implement

Enter only after the human explicitly agrees to a specific proposed solution,
typically with `Approved <ID>-N`, or a same-prefix batch
`Approved <ID>-N[/N...]`, using the prefix from `ledger.yaml`. The shared
workflow processes an approved batch sequentially. Use
`$reliability-gaps-find` first if no scoped ledger entry exists yet for this
scope.

Before starting, read `ledger.yaml`, `references/plan.md`,
`../references/gap-workflow.md`, and `../references/gap-workflow/implementation.md`;
they own runtime state, ledger, delegation, scope, and approval gates.

## Operating Stance

Operate as a production-readiness triager: implement only verified reliability
findings with concrete evidence, credible user or operator impact, and an
actionable fix.

Before proposing a fix for each finding, re-check the current code, config,
tests, docs, and CI. Treat the ledger as something that can go stale: dismiss
or revise findings that are already addressed, no longer have a concrete
failure mode, duplicate another issue, or belong in `$code-issues-implement`,
`$security-audit`, `$test-gaps-implement`, or `$doc-gaps-fix`. When
re-checking a finding whose evidence depends on documentation or comments
contradicting implementation, prove the implementation or reliability control
is wrong with non-prose evidence before proposing a reliability change. If
non-prose evidence supports the implementation, explain that the ledger item
is invalid as a reliability gap and propose reclassifying or fixing
documentation instead.

Follow `references/plan.md` and the implementation rules in
`../references/gap-workflow/implementation.md`.

These reliability implementation rules remain mandatory:

- Ask questions when SLOs, expected failure behavior, operator workflow, compatibility, rollout, validation, or user intent is ambiguous. Treat silence or a broad "implement reliability gaps" request as permission to start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing fixes, state the reliability execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Implement only the agreed finding with the smallest clear reliability change.
- Use `$reliability-standards` for reliability design, `$change-safety` for public or operational compatibility, `$testing-standards` for failure-path tests, and `$change-validation` for checks. Pair with `$security-audit` when the fix touches auth, secrets, privilege, DoS, logs, supply chain, or incident containment.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. For a single approval, ask the human to verify and say `Done <ID>-N` using the prefix from `ledger.yaml`; an approved batch follows the shared sequential re-check and stop rules.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml`
and `references/ledger-format.md`. This skill is the canonical owner of the
ledger contract; `$reliability-gaps-find` cross-references these same files by
relative path rather than duplicating them. Each entry is a self-contained
mini-RFC using `What -> Why -> How`. The required core must keep
`| Field | Value |`, `| Status |`, and `**Summary.**`; `### What` with
`**Current.**` and `**Expected.**`; `### Why` with `**Impact.**` and
`#### Evidence` containing `**Claim:**`, `**Observed:**`,
`**Reproduction:** Smallest supported trigger`, and `**Source:**`; and
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
- Use `$reliability-standards` for SRE, NALSD, resilience, recovery, overload,
  observability, release-safety, and production-readiness judgment.
- Use `$project-workflow` for repository command discovery, CI expectations,
  documented entrypoints, operational docs, and `./bin` wiring before
  validation.
- Use `$change-safety` when reliability changes affect public contracts,
  compatibility, migrations, config, deployment, security expectations, or
  documented operational behavior.
- Use `$testing-standards` when reliability fixes need failure-path or
  recovery tests.
- Use `$change-validation` when selecting validation commands for implemented
  reliability fixes.
- Use `$security-audit` when the confirmed problem is primarily
  security-sensitive.
- Use `$reliability-gaps-find` when no scoped ledger entry exists yet for this
  scope.
