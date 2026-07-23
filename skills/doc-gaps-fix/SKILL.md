---
name: doc-gaps-fix
description: Find and fix scoped documentation gaps when edits are requested; use $doc-gaps-audit for an audit-only or no-edit pass.
---

# Doc Gaps Fix

Trigger phrases: `Run $doc-gaps-fix in PACKAGE_OR_FOLDER`, `Find doc gaps in
PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER`. This skill finds
and fixes documentation gaps in the same pass — it is the only skill in this
pair that edits. Use `$doc-gaps-audit` instead when the user explicitly asks
not to edit or asks only for an audit or ledger.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, coverage, and
confidence gates. Read `references/fix-rules.md` and
`../references/gap-workflow/find-audit.md` when beginning review. Read
`ledger.yaml` when resolving the scoped ledger path or entry ID, and
`references/ledger-format.md` only before interpreting, creating, or updating
an entry. Read `../references/gap-workflow/implementation.md` only for an
actual unresolved-ledger fix; a simple new documentation correction does not
need that reference.

To revisit an unresolved scoped entry, invoke this skill with its ID. Re-check
that it still stands before editing, then fix it. Name an ordered same-prefix batch as `PREFIX-N[/N...]`, using the prefix from `ledger.yaml`.

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

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Those doc-gap rules remain mandatory. Before
editing, state the selected local documentation pattern, dominant relevant
validation path, planned validation command, and any deviation from
`AGENTS.md` or selected skills.
Before editing an unresolved-ledger fix, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to fix or record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before fixing or
recording findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

## Candidate And Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml` and
`references/ledger-format.md`. This skill is the canonical owner of the ledger
contract; `$doc-gaps-audit` cross-references these same files by relative
path rather than duplicating them. Each entry is a self-contained mini-RFC
using `What -> Why -> How`. The required core must keep `| Field | Value |`,
`| Status |`, and `**Summary.**`; `### What` with `**Current.**` and
`**Expected.**`; `### Why` with `**Impact.**` and `#### Evidence` containing
`**Claim:**`, `**Observed:**`, `**Reproduction:** Smallest reader action`, and
`**Source:**`; and `### How` with `#### Proposal`, `**Keep.**`,
`#### Alternatives Considered`, and `#### Definition of Success` containing
`**Validation:**`. Add `#### Situation Map`,
`### Goals / Non-goals`, `### Open Questions`, and `### Decision` only when the
entry warrants them.

## References

- Read `references/plan.md` before starting.
- Read `references/fix-rules.md` before reviewing, editing, or recording
  candidates.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review rules and
  `../references/gap-workflow/implementation.md` for fixing an unresolved
  entry.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate documentation leads, and account for rejected or routed candidates.
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
- Use `$doc-gaps-audit` instead when the user explicitly asks not to edit or asks only for an audit or ledger.
