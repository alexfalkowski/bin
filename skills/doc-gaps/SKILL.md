---
name: doc-gaps
description: Use when the user asks to run $doc-gaps, find/fix doc gaps in a package or folder, set a confidence closure target such as 95% or 99%, review docs for gaps, run audit-only doc gaps, uses Start DOC-1 or Approved DOC-1 with agents and a goal, asks about doc gap IDs such as DOC-1, asks what the fix is for DOC-1, asks to fix or verify DOC-1, or uses Done DOC-1. Find and fix concrete missing, weak, stale, or misleading README, docs, examples, command help, package docs, public API comments, code comments, and docstrings.
---

# Doc Gaps

Use one-pass mode by default; use audit-only mode only when explicitly asked:

- **One-pass mode**: `Run $doc-gaps in PACKAGE_OR_FOLDER`, `Find doc gaps in PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER`.
- **Audit-only mode**: `Audit-only $doc-gaps in PACKAGE_OR_FOLDER` or `Find doc gaps in PACKAGE_OR_FOLDER without editing`.

Before either mode, read `references/plan.md` and
`../references/gap-workflow.md` and the mode-specific reference below own
runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates. Before one-pass or audit-only
mode, also read `../references/gap-workflow/find-audit.md`.
Before implementation of a scoped entry, also read
`../references/gap-workflow/implementation.md`.

## Operating Stance

Operate as a scoped documentation maintainer: use `$doc-standards` for
documentation quality judgment, use this skill for scope control and
delegation, and fix confirmed documentation gaps in the same pass unless a stop
gate requires human input.

When documentation contradicts implementation, treat current code, tests,
schemas, generated contracts, runtime behavior, external standards, and history
as the evidence for actual behavior. Do not route the mismatch to code,
security, reliability, or test workflows unless non-prose evidence proves the
implementation is wrong; otherwise fix the documentation to match the behavior
the repository implements.

## One-Pass Mode

Follow `references/plan.md#one-pass-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/one-pass-rules.md`; those doc-gap rules remain mandatory in
one-pass mode. Before editing in one-pass mode, state the selected local
documentation pattern, dominant relevant validation path, planned validation
command, and any deviation from `AGENTS.md` or selected skills.
For unresolved-ledger fixes or any case where human approval is still required: After the human agrees and before editing, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills.

## Audit-Only Mode

Follow `references/plan.md#audit-only-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/audit-rules.md`; those doc-gap rules remain mandatory in
audit-only mode.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to fix or record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before fixing or
recording findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

## Candidate And `DOCS.md` Format

Before creating, updating, or interpreting `DOCS.md`, read
`references/ledger-format.md`. Each entry is a self-contained mini-RFC using
`What -> Why -> How`. The required core must keep `| Field | Value |`,
`| Status |`, and `**Summary.**`; `### What` with `**Current.**` and
`**Expected.**`; `### Why` with `**Impact.**` and `#### Evidence` containing
`**Claim:**`, `**Observed:**`, `**Reproduction:** Smallest reader action`, and
`**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`,
`### Goals / Non-goals`, `### Open Questions`, and `### Decision` only when the
entry warrants them.

## References

- Read `references/plan.md` before starting one-pass mode or audit-only mode.
- Read `references/one-pass-rules.md` during one-pass mode before reviewing,
  editing, or recording candidates.
- Read `references/audit-rules.md` during audit-only mode before reviewing or
  recording candidates.
- Read `references/ledger-format.md` before creating, updating, or interpreting
  `DOCS.md`.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for one-pass/audit-only
  rules and `../references/gap-workflow/implementation.md` for entry fixes.
- Use `../references/decision-card.md` to present the agreement-gate proposal as a self-contained decision card for unresolved-ledger fixes.
- Use `../references/gap-lead-generation.md` during one-pass and audit-only
  modes to classify repo archetypes, generate documentation leads, and account
  for rejected or routed candidates.
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
