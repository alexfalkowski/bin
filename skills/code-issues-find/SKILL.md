---
name: code-issues-find
description: Find scoped code bugs, security issues, compatibility breaks, and public-contract violations without editing; use $code-issues-implement to implement a confirmed entry.
---

# Code Issues Find

Trigger phrases: `Find $code-issues-find in PACKAGE_OR_FOLDER` or
`Find code issues in PACKAGE_OR_FOLDER`. This skill only discovers and records
candidates; it never edits code. Use `$code-issues-implement` to re-check and
implement a specific ledger entry, using the contract in
`../code-issues-implement/ledger.yaml`.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, coverage, and
confidence gates. Read `references/find-rules.md` when beginning review. Read
`../references/gap-workflow/find-audit.md` when beginning review mechanics.
Read `../code-issues-implement/ledger.yaml` only when resolving the scoped
ledger path or an entry ID, and its ledger format only before interpreting,
creating, or updating an entry.

## Operating Stance

Operate as a strict issue triager and ledger owner: separate confirmed code
defects from test gaps, doc gaps, polish, and speculation; keep the scoped
ledger actionable, deduplicated, and tied to user-visible or contract risk.

Code is the default source of behavioral truth. Comments, GoDoc, README prose,
examples, and other documentation can be stale. Do not record a code issue
merely because prose and implementation disagree. First prove the
implementation is wrong using non-prose evidence such as executable behavior,
tests, schemas, wire/API contracts, external standards, runtime failures, or
history showing an unintended code regression. If implementation and tests agree
while prose disagrees, treat it as a documentation gap and route it to
`$doc-gaps-audit` or `$doc-gaps-fix` instead of recording it here.

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Those code-issue rules remain mandatory.

## Ledger Format

Before recording a candidate, read `../code-issues-implement/ledger.yaml` and
`../code-issues-implement/references/ledger-format.md` — `$code-issues-implement`
owns the ledger contract and entry-format definition so there is one canonical
copy; this skill only writes conforming entries into the path they resolve.
Each entry is a self-contained mini-RFC using `What -> Why -> How`. The
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
- Read `../code-issues-implement/ledger.yaml` and
  `../code-issues-implement/references/ledger-format.md` before creating or
  updating the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate high-risk leads, and account for rejected or routed candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence
  labels, and severity.
- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps-find` instead when the user asks for a standalone missing or
  weak test coverage pass.
- Use `$doc-gaps-audit` or `$doc-gaps-fix` instead when the user asks for a
  standalone missing, stale, misleading, or weak documentation, README,
  example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations,
  and `./bin` wiring before review planning.
- Use `$change-validation` when selecting validation commands.
