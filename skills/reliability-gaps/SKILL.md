---
name: reliability-gaps
description: Use when the user asks to find $reliability-gaps in a package or folder, find reliability gaps in a package or folder, review production readiness for a package or folder, find reliability gaps with a specific confidence closure target such as 95% or 99%, implement $reliability-gaps in a package or folder, implement reliability gaps in a package or folder, uses a remembered command such as Work REL-1 or Agent goal work REL-1, asks about reliability gap IDs such as REL-1, asks what the fix is for REL-1, asks to fix or verify REL-1, or says REL-1 is done. Find verified reliability, operability, SLO, overload, observability, release-safety, recovery, data-integrity, disaster-readiness, or NALSD evidence gaps, record confirmed gaps in scoped RELIABILITY.md, and implement agreed fixes gap by gap.
---

# Reliability Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $reliability-gaps in PACKAGE_OR_FOLDER` or `Find reliability gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $reliability-gaps in PACKAGE_OR_FOLDER` or `Implement reliability gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

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

These reliability-gap rules remain mandatory:

- Use `RELIABILITY.md` in the requested package or folder as the review ledger,
  for example `PACKAGE_OR_FOLDER/RELIABILITY.md`.
- Prefer slices based on repository-owned reliability and operational risk: public commands/APIs, changed or recently touched areas, retries/timeouts/backpressure, config/CI/release paths, observability/runbook surfaces, documented workflows, and nearby tests. Use depth only as a discovery aid, not as the review boundary.
- For delegated review, each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough `$reliability-standards` review for that slice, pairing with `$change-safety`, `$security-audit`, `$testing-standards`, and `$change-validation` as the surface requires.
- Confirm each candidate gap against current evidence before recording it. Try to disprove the candidate by tracing the current code path, reading the documented workflow, checking the relevant config, inspecting existing tests, or running an allowed local command. A gap must name the affected reliability promise or operational expectation, the trigger condition, the failure mode, the missing or weak control, and the likely user or operator impact.
- For candidates based on documentation or comments contradicting code, require non-prose proof that the implementation or repository-owned reliability control is wrong before recording a reliability gap. If current code, tests, runtime behavior, CI, or history support the implementation, treat the prose as a doc gap.
- Record reliability gaps only when they involve repository-owned behavior or documented/implicit operational contracts, such as:
   - missing or weak SLO, SLI, alertability, dashboard, runbook, or operator diagnostic coverage for behavior the repository claims or owns.
   - unbounded or unsafe timeouts, retries, backoff, jitter, concurrency, queues, subprocesses, files, disk, memory, network, or worker resources.
   - missing backpressure, load shedding, graceful degradation, or fallback for a meaningful dependency or overload failure mode.
   - release, config, feature-flag, rollback, migration, or post-deploy behavior that can strand users or operators.
   - missing idempotency, replay, deduplication, ordering, reconciliation, backup, restore, or data-integrity controls for stateful behavior.
   - missing health/readiness/shutdown/drain behavior for long-running services or workers.
   - missing concrete NALSD assumptions, capacity estimates, bottleneck analysis, or failure-domain reasoning where the code or docs already make scale or availability claims.
- Do not record generic advice to add monitoring, runbooks, autoscaling, retries, queues, circuit breakers, chaos testing, load tests, Kubernetes probes, or dashboards unless a concrete current failure mode and repository-owned fix are identified.
- Do not record findings whose evidence is only a repository preference, transport choice, hosting choice, cloud architecture preference, or environment setup assumption. For example, an SSH Git remote or submodule URL is not a reliability gap unless a documented repository-owned workflow currently fails for intended operators and the repository owns the fix.
- For release or supply-chain findings involving Docker/image scans, first trace the exact artifacts through CI, Make targets, scripts, Dockerfiles, tags, build arguments, and push commands. Do not record a pre-publish scan or release-gate gap merely because CI scans a test image or runs scan jobs on non-release branches. Record the gap only when the scanned artifact and published artifact can materially differ, the release build bypasses a repository-owned required scan, or a documented release contract is violated.
- Do not record reliability gaps whose only support is an undocumented future scale target, hypothetical product direction, architecture preference, or a conclusion reached from briefly noticing a pattern without verifying a concrete failure path.
- Do not record future bad commits, invalid future fixtures, or missed-review
  scenarios as reliability gaps unless the repository currently admits that
  trigger through automation, external input, frequent operational data changes,
  or another supported path that existing controls do not cover.
- Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as reliability gaps. If broken behavior is discovered during review, report it as out of scope for the reliability-gap ledger and recommend `$code-issues`, `$security-audit`, or `$change-safety` as appropriate.
- If investigation finds current valid user input producing the wrong API
  response, error, status code, persisted value, generated artifact, or public
  contract output, stop treating it as a reliability gap. Route it to
  `$code-issues` unless the primary missing control is operational rather than
  behavioral.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as reliability gaps. Use `$test-gaps` when missing failure-path coverage is the finding.
- Do not record standalone missing, weak, stale, misleading, or wrong-location operational docs as reliability gaps. Use `$doc-gaps` when documentation itself is the finding.
- Do not report optional maturity improvements, cloud-architecture preferences, private implementation preferences, or "best practice" checkboxes as findings by themselves. List them only as optional follow-up notes when relevant.

## `RELIABILITY.md` Format

Use this structure:

````markdown
# Reliability

## REL-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Reliability Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | User, operator, incident, availability, recovery, data-integrity, or scaling risk. |

### Evidence

```text
Evidence: Concrete file and line references, command behavior, config, docs,
tests, missing control, failure mode, calculation gap, and the verification path
used to rule out a guess.
Reproduction: Smallest supported trigger, workflow, config path, command, test,
trace, or operational scenario that reproduces the failure mode or proves the
missing reliability control.
```

### Decision Trace

```text
operational trigger
  -> failure mode or missing control
  -> user/operator/recovery risk
  -> smallest credible reliability fix
  -> validation that proves the control
```

### Proposed Change

```yaml
proposed_fix: Smallest credible reliability improvement using established local patterns.
validation:
  - Suggested checks for the reliability change.
```
````

Keep optional follow-up notes separate from findings:

```markdown
## Optional Reliability Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These reliability implementation rules remain mandatory:

- Before proposing a fix for each finding, re-check the current code, config, tests, docs, and CI. Treat the ledger as something that can go stale: dismiss or revise findings that are already addressed, no longer have a concrete failure mode, duplicate another issue, or belong in `$code-issues`, `$security-audit`, `$test-gaps`, or `$doc-gaps`.
- When re-checking a finding whose evidence depends on documentation or comments contradicting implementation, prove the implementation or reliability control is wrong with non-prose evidence before proposing a reliability change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a reliability gap and propose reclassifying or fixing documentation instead.
- Ask questions when SLOs, expected failure behavior, operator workflow, compatibility, rollout, validation, or user intent is ambiguous. Treat silence or a broad "implement reliability gaps" request as permission to start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing fixes, state the reliability execution checklist before editing:
   - `TDD decision`: yes/no, with the concrete reason if no.
   - `First test/scenario`: the narrowest test, table, fixture, or scenario to add or update first.
   - `Expected red`: the command and failure expected before production edits.
   - `Intended green change`: the smallest code/config/docs change expected to pass.
   - `Refactor checkpoint`: the cleanup pass planned after green, or `none`.
   - `Validation`: the focused and expanded commands intended after refactor.
- Implement only the agreed finding with the smallest clear reliability change.
- Use `$reliability-standards` for reliability design, `$change-safety` for public or operational compatibility, `$testing-standards` for failure-path tests, and `$change-validation` for checks. Pair with `$security-audit` when the fix touches auth, secrets, privilege, DoS, logs, supply chain, or incident containment.
- Report the result for that finding with `Red`, `Green`, `Refactor`, and
  `Validation` entries. Use `Refactor: none (<reason>)` when no cleanup was
  needed after green. Then ask the human to verify and explicitly say `REL-N is
  done`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
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
