---
name: reliability-gaps
description: Use when the user asks to find or implement $reliability-gaps/reliability gaps in a package or folder, review production readiness, set a confidence closure target such as 95% or 99%, uses Work REL-1 or Agent goal work REL-1, asks about reliability gap IDs such as REL-1, asks what the fix is for REL-1, asks to fix or verify REL-1, or says REL-1 is done. Find verified reliability, operability, SLO, overload, observability, release-safety, recovery, data-integrity, disaster-readiness, or NALSD gaps; record scoped RELIABILITY.md entries; implement agreed fixes gap by gap.
---

# Reliability Gaps

Use this skill in two distinct modes; do not combine them in one pass:

- **Find mode**: `Find $reliability-gaps in PACKAGE_OR_FOLDER` or `Find reliability gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $reliability-gaps in PACKAGE_OR_FOLDER` or `Implement reliability gaps in PACKAGE_OR_FOLDER`.

Before either mode, read `references/plan.md` and
`../references/gap-workflow.md`; they own runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates.

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
implementation, route the mismatch to `$doc-gaps` instead.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

Read `references/find-rules.md`; those reliability-gap rules remain mandatory
in Find mode.

## `RELIABILITY.md` Format

Before creating, updating, or interpreting `RELIABILITY.md`, read
`references/ledger-format.md`. The ledger format must keep `| Field | Value |`,
`Reproduction: Smallest supported trigger`, `### Decision Trace`, and
`### Proposed Change`.

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These reliability implementation rules remain mandatory:

- Before proposing a fix for each finding, re-check the current code, config, tests, docs, and CI. Treat the ledger as something that can go stale: dismiss or revise findings that are already addressed, no longer have a concrete failure mode, duplicate another issue, or belong in `$code-issues`, `$security-audit`, `$test-gaps`, or `$doc-gaps`.
- When re-checking a finding whose evidence depends on documentation or comments contradicting implementation, prove the implementation or reliability control is wrong with non-prose evidence before proposing a reliability change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a reliability gap and propose reclassifying or fixing documentation instead.
- Ask questions when SLOs, expected failure behavior, operator workflow, compatibility, rollout, validation, or user intent is ambiguous. Treat silence or a broad "implement reliability gaps" request as permission to start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing fixes, state the reliability execution checklist before editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended green change`, `Refactor checkpoint`, and `Validation`. When the harness is runnable, observe and paste the red (command + failing output) before implementation edits; if it is not runnable, stop and request agreement to proceed test-after with the reason rather than skipping red silently.
- Implement only the agreed finding with the smallest clear reliability change.
- Use `$reliability-standards` for reliability design, `$change-safety` for public or operational compatibility, `$testing-standards` for failure-path tests, and `$change-validation` for checks. Pair with `$security-audit` when the fix touches auth, secrets, privilege, DoS, logs, supply chain, or incident containment.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. Ask the human to verify and say `REL-N is done`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `references/find-rules.md` during Find mode before reviewing or
  recording candidates.
- Read `references/ledger-format.md` before creating, updating, or interpreting
  `RELIABILITY.md`.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
- Use `../references/gap-lead-generation.md` during Find mode to classify repo
  archetypes, generate reliability leads, and account for rejected or routed
  candidates.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$reliability-standards` for SRE, NALSD, resilience, recovery, overload, observability, release-safety, and production-readiness judgment.
- Use `$project-workflow` for repository command discovery, CI expectations, documented entrypoints, operational docs, and `./bin` wiring before review planning or validation.
- Use `$change-safety` when reliability changes affect public contracts, compatibility, migrations, config, deployment, security expectations, or documented operational behavior.
- Use `$testing-standards` when reliability fixes need failure-path or recovery tests.
- Use `$change-validation` when selecting validation commands for implemented reliability fixes.
- Use `$security-audit` when the confirmed problem is primarily security-sensitive.
- Use `$code-issues`, `$test-gaps`, or `$doc-gaps` when the confirmed problem belongs to those ledgers instead of reliability.
