---
name: reliability-gaps-find
description: Use when the user asks to find $reliability-gaps-find/reliability gaps in a package or folder, review production readiness, set a confidence closure target such as 95% or 99%, or asks what evidence backs a reliability-gap ledger entry. Find verified reliability, operability, SLO, overload, observability, release-safety, recovery, data-integrity, disaster-readiness, or NALSD gaps and record scoped ledger entries; never edits code. Use $reliability-gaps-implement to act on an entry after explicit agreement.
---

# Reliability Gaps Find

Trigger phrases: `Find $reliability-gaps-find in PACKAGE_OR_FOLDER` or
`Find reliability gaps in PACKAGE_OR_FOLDER`. This skill only discovers and
records candidates; it never edits code. `Start <ID>` and `Approved <ID>-N`
select `$reliability-gaps-implement` instead, using the ledger contract in
`../reliability-gaps-implement/ledger.yaml`.

Before starting, read `../reliability-gaps-implement/ledger.yaml`,
`references/plan.md`, `../references/gap-workflow.md`, and
`../references/gap-workflow/find-audit.md`; they own runtime state, ledger,
delegation, scope, coverage, and confidence gates.

## Operating Stance

Operate as a production-readiness triager: record only verified reliability gaps
with concrete evidence, credible user or operator impact, and an actionable fix.
Treat a candidate as unconfirmed until the current code, config, docs, tests, or
command behavior show how a repository-owned reliability control can fail.
Reject speculative scalability advice, generic SRE checklists, environment
preferences, and findings that depend on undocumented future requirements.
Do not record a reliability gap whose trigger is primarily a future bad code,
config, data, or asset change that would need to be committed, reviewed, and
deployed first, unless current repository evidence shows that such changes are
automated, frequent, externally supplied, weakly reviewed, already failing, or
otherwise reasonably admitted by a supported workflow. Treat normal code review,
CI, typed or generated contracts, and documented manual update procedures as
real controls when calibrating likelihood.

Comments, GoDoc, README prose, examples, and operational docs can reveal leads,
but they are not source of truth when they contradict implementation. Before
recording a reliability gap from such a mismatch, prove with non-prose evidence
that the repository-owned reliability behavior or control is wrong. If code,
tests, runtime behavior, CI, generated contracts, or history support the
implementation, route the mismatch to `$doc-gaps-audit` or `$doc-gaps-fix`
instead.

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those reliability-gap rules remain mandatory.

## Ledger Format

Before recording a candidate, read `../reliability-gaps-implement/ledger.yaml`
and `../reliability-gaps-implement/references/ledger-format.md` —
`$reliability-gaps-implement` owns the ledger contract and entry-format
definition so there is one canonical copy. Each entry is a self-contained
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
- Read `references/find-rules.md` before reviewing or recording candidates.
- Read `../reliability-gaps-implement/ledger.yaml` and
  `../reliability-gaps-implement/references/ledger-format.md` before creating
  or updating the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate reliability leads, and account for rejected or routed candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence
  labels, and severity.
- Use `$reliability-standards` for SRE, NALSD, resilience, recovery, overload,
  observability, release-safety, and production-readiness judgment.
- Use `$project-workflow` for repository command discovery, CI expectations,
  documented entrypoints, operational docs, and `./bin` wiring before review
  planning.
- Use `$code-issues-find`, `$test-gaps-find`, or `$doc-gaps-audit`/`$doc-gaps-fix`
  when the confirmed problem belongs to those ledgers instead of reliability.
- Use `$security-audit` when the confirmed problem is primarily
  security-sensitive.
