---
name: doc-gaps-audit
description: Audit scoped documentation for concrete gaps without editing; use $doc-gaps-fix to find and fix documentation gaps.
---

# Doc Gaps Audit

Trigger phrases: `Audit-only $doc-gaps-audit in PACKAGE_OR_FOLDER` or
`Find doc gaps in PACKAGE_OR_FOLDER without editing`. This skill only
discovers and records candidates; it never edits documentation. Use
`$doc-gaps-fix` for the default find-and-fix pass.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, coverage, and
confidence gates. Read `references/audit-rules.md` when beginning review.
Read `../references/gap-workflow/find-audit.md` when beginning review
mechanics. Read `../doc-gaps-fix/ledger.yaml` only when resolving the scoped
ledger path or an entry ID, and its ledger format only before interpreting,
creating, or updating an entry.

## Operating Stance

Operate as a scoped documentation auditor: use `$doc-standards` for
documentation quality judgment and this skill for scope control, delegation,
and ledger recording. Never edit documentation in this skill.

When documentation contradicts implementation, treat current code, tests,
schemas, generated contracts, runtime behavior, external standards, and history
as the evidence for actual behavior. Do not route the mismatch to code,
security, reliability, or test workflows unless non-prose evidence proves the
implementation is wrong; otherwise record a doc gap so `$doc-gaps-fix` can
correct the documentation.

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Those doc-gap rules remain mandatory.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before recording
findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

## Candidate And Ledger Format

Before recording a candidate, read `../doc-gaps-fix/ledger.yaml` and
`../doc-gaps-fix/references/ledger-format.md` — `$doc-gaps-fix` owns the
ledger contract and entry-format definition so there is one canonical copy.
Each entry is a self-contained mini-RFC using `What -> Why -> How`. The
required core must keep `| Field | Value |`, `| Status |`, and
`**Summary.**`; `### What` with `**Current.**` and `**Expected.**`; `### Why`
with `**Impact.**` and `#### Evidence` containing `**Claim:**`,
`**Observed:**`, `**Reproduction:** Smallest reader action`, and
`**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`,
`### Goals / Non-goals`, `### Open Questions`, and `### Decision` only when the
entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `references/audit-rules.md` before reviewing or recording candidates.
- Read `../doc-gaps-fix/ledger.yaml` and
  `../doc-gaps-fix/references/ledger-format.md` before creating or updating
  the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate documentation leads, and account for rejected or routed candidates.
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
- Use `$doc-gaps-fix` for the default find-and-fix pass, or to implement an
  entry this skill recorded.
