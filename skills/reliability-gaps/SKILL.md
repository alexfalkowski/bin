---
name: reliability-gaps
description: Finds verified missing or weak reliability, operability, SLO, overload, observability, release-safety, recovery, data-integrity, disaster-readiness, or NALSD design evidence in a package or folder, records confirmed gaps in that scope's ISSUES.md, and later proposes and implements explicitly agreed fixes gap by gap. Use when the user asks to find $reliability-gaps in a package or folder, find reliability gaps in a package or folder, review production readiness for a package or folder, implement $reliability-gaps in a package or folder, implement reliability gaps in a package or folder, asks what the fix is for REL-<number>, asks to fix REL-<number>, asks to verify REL-<number>, or says REL-<number> is done.
---

# Reliability Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $reliability-gaps in <package/folder>` or `Find reliability gaps in <package/folder>`.
- **Implement mode**: `Implement $reliability-gaps in <package/folder>` or `Implement reliability gaps in <package/folder>`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as ledger, proposal, approval, validation,
or human-confirmation state changes.

## Operating Stance

Operate as a production-readiness triager: record only verified reliability gaps
with concrete evidence, credible user or operator impact, and an actionable fix.
Treat a candidate as unconfirmed until the current code, config, docs, tests, or
command behavior show how a repository-owned reliability control can fail.
Reject speculative scalability advice, generic SRE checklists, environment
preferences, and findings that depend on undocumented future requirements.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
- Treat `Find $reliability-gaps in <package/folder>` or `Find reliability gaps in <package/folder>` as the user's explicit request to delegate reliability review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the reliability-gap review locally first.
- Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, destructive operations, or non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, generated API docs, and generated lockfile churn unless the requested scope is explicitly about them.
- Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough `$reliability-standards` review for its assigned scope, pairing with `$change-safety`, `$security-audit`, `$testing-standards`, and `$change-validation` as the surface requires.
- Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity.
- Confirm each candidate gap against current evidence before recording it. Try to disprove the candidate by tracing the current code path, reading the documented workflow, checking the relevant config, inspecting existing tests, or running an allowed local command. A gap must name the affected reliability promise or operational expectation, the trigger condition, the failure mode, the missing or weak control, and the likely user or operator impact.
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
- Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as reliability gaps. If broken behavior is discovered during review, report it as out of scope for the reliability-gap ledger and recommend `$code-issues`, `$security-audit`, or `$change-safety` as appropriate.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as reliability gaps. Use `$test-gaps` when missing failure-path coverage is the finding.
- Do not record standalone missing, weak, stale, misleading, or wrong-location operational docs as reliability gaps. Use `$doc-gaps` when documentation itself is the finding.
- Do not report optional maturity improvements, cloud-architecture preferences, private implementation preferences, or "best practice" checkboxes as findings by themselves. List them only as optional follow-up notes when relevant.
- If no confirmed reliability gaps are found, report that no reliability gaps were found and do not create `ISSUES.md`.
- If confirmed reliability gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
- Assign every finding a unique ID for the session in the form `REL-<number>`.
- Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## REL-1: Short concrete title

- Type: Reliability Gap
- Severity: Critical|High|Medium|Low
- Scope: path/to/file-or-folder
- Impact: User, operator, incident, availability, recovery, data-integrity, or scaling risk.
- Evidence: Concrete file and line references, command behavior, config, docs, tests, missing control, failure mode, calculation gap, and the verification path used to rule out a guess.
- Proposed fix: Smallest credible reliability improvement using established local patterns.
- Validation: Suggested checks for the reliability change.
```

Keep optional follow-up notes separate from findings:

```markdown
## Optional Reliability Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Read `ISSUES.md` in the requested package or folder first and treat it as the working reliability-gap ledger.
- If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
- Work through findings sequentially by ID unless the human explicitly names a different finding.
- Before proposing a fix for each finding, re-check the current code, config, tests, docs, and CI. Treat the ledger as something that can go stale: dismiss or revise findings that are already addressed, no longer have a concrete failure mode, duplicate another issue, or belong in `$code-issues`, `$security-audit`, `$test-gaps`, or `$doc-gaps`.
- Stop after proposing the solution. Do not edit files, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
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
- Report the result for that finding with `Red`, `Green`, `Refactor`, and `Validation` entries. Use `Refactor: none` when no cleanup was needed after green. Then ask the human to verify and explicitly say `REL-<number> is done`.
- Do not move to the next finding until the human says `REL-<number> is done`.
- After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a reliability gap, remove it only after explaining why and getting human agreement.
- Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Use `../references/finding-severity.md` for confidence filtering and severity.
- Use `$reliability-standards` for SRE, NALSD, resilience, recovery, overload, observability, release-safety, and production-readiness judgment.
- Use `$project-workflow` for repository command discovery, CI expectations, documented entrypoints, operational docs, and `./bin` wiring before review planning or validation.
- Use `$change-safety` when reliability changes affect public contracts, compatibility, migrations, config, deployment, security expectations, or documented operational behavior.
- Use `$testing-standards` when reliability fixes need failure-path or recovery tests.
- Use `$change-validation` when selecting validation commands for implemented reliability fixes.
- Use `$security-audit` when the confirmed problem is primarily security-sensitive.
- Use `$code-issues`, `$test-gaps`, or `$doc-gaps` when the confirmed problem belongs to those ledgers instead of reliability.
