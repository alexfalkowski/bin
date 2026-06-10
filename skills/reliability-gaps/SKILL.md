---
name: reliability-gaps
description: Finds verified missing or weak reliability, operability, SLO, overload, observability, release-safety, recovery, data-integrity, disaster-readiness, or NALSD design evidence in a package or folder, records confirmed gaps in that scope's ISSUES.md, and later proposes and implements explicitly agreed fixes gap by gap. Use when the user asks to find $reliability-gaps in a package or folder, find reliability gaps in a package or folder, review production readiness for a package or folder, implement $reliability-gaps in a package or folder, or implement reliability gaps in a package or folder.
---

# Reliability Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $reliability-gaps in <package/folder>` or `Find reliability gaps in <package/folder>`.
- **Implement mode**: `Implement $reliability-gaps in <package/folder>` or `Implement reliability gaps in <package/folder>`.

Do not combine the two modes in one pass.

## Operating Stance

Operate as a production-readiness triager: record only verified reliability gaps
with concrete evidence, credible user or operator impact, and an actionable fix.
Treat a candidate as unconfirmed until the current code, config, docs, tests, or
command behavior show how a repository-owned reliability control can fail.
Reject speculative scalability advice, generic SRE checklists, environment
preferences, and findings that depend on undocumented future requirements.

## Find Mode

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
3. If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
4. Use `$project-workflow` to discover repository entrypoints, CI expectations, documented commands, operational docs, release/config surfaces, and `./bin` wiring before planning reliability review agents or validation.
5. Treat `Find $reliability-gaps in <package/folder>` or `Find reliability gaps in <package/folder>` as the user's explicit request to delegate reliability review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
6. Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the reliability-gap review locally first.
7. Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
8. If the runtime still requires an approval step before launching sub-agents, ask once with the concrete read-only agent plan. If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
9. Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, destructive operations, or non-read-only validation. Without that permission, agents should inspect code, config, tests, docs, and CI only and suggest validation.
10. Exclude generated files and folders, vendored dependencies, caches, build output, generated API docs, and generated lockfile churn unless the requested scope is explicitly about them.
11. Launch at least one sub-agent covering the requested root package/folder. Split agent assignments across:
   - files directly under the requested root package/folder.
   - operational docs, config, deployment, CI, scripts, or Make targets directly under the requested root package/folder.
   - each first-level subpackage/subfolder under the requested root.
12. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough `$reliability-standards` review for its assigned scope, pairing with:
   - `$change-safety` for public APIs, commands, flags, env vars, file formats, migrations, config, deployment, or documented operator behavior.
   - `$security-audit` for auth, secrets, privilege, attacker-driven failure, DoS, logging privacy, supply chain, or incident containment.
   - `$testing-standards` and `$change-validation` for likely failure-path tests and validation commands.
13. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
14. Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity.
15. Wait for all agents to finish before aggregating results.
16. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code, config, tests, docs, and CI directly.
17. Confirm each candidate gap against current evidence before recording it. Try to disprove the candidate by tracing the current code path, reading the documented workflow, checking the relevant config, inspecting existing tests, or running an allowed local command. A gap must name the affected reliability promise or operational expectation, the trigger condition, the failure mode, the missing or weak control, and the likely user or operator impact.
18. Record reliability gaps only when they involve repository-owned behavior or documented/implicit operational contracts, such as:
   - missing or weak SLO, SLI, alertability, dashboard, runbook, or operator diagnostic coverage for behavior the repository claims or owns.
   - unbounded or unsafe timeouts, retries, backoff, jitter, concurrency, queues, subprocesses, files, disk, memory, network, or worker resources.
   - missing backpressure, load shedding, graceful degradation, or fallback for a meaningful dependency or overload failure mode.
   - release, config, feature-flag, rollback, migration, or post-deploy behavior that can strand users or operators.
   - missing idempotency, replay, deduplication, ordering, reconciliation, backup, restore, or data-integrity controls for stateful behavior.
   - missing health/readiness/shutdown/drain behavior for long-running services or workers.
   - missing concrete NALSD assumptions, capacity estimates, bottleneck analysis, or failure-domain reasoning where the code or docs already make scale or availability claims.
19. Do not record generic advice to add monitoring, runbooks, autoscaling, retries, queues, circuit breakers, chaos testing, load tests, Kubernetes probes, or dashboards unless a concrete current failure mode and repository-owned fix are identified.
20. Do not record findings whose evidence is only a repository preference, transport choice, hosting choice, cloud architecture preference, or environment setup assumption. For example, an SSH Git remote or submodule URL is not a reliability gap unless a documented repository-owned workflow currently fails for intended operators and the repository owns the fix.
21. Do not record reliability gaps whose only support is an undocumented future scale target, hypothetical product direction, architecture preference, or a conclusion reached from briefly noticing a pattern without verifying a concrete failure path.
22. Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as reliability gaps. If broken behavior is discovered during review, report it as out of scope for the reliability-gap ledger and recommend `$code-issues`, `$security-audit`, or `$change-safety` as appropriate.
23. Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as reliability gaps. Use `$test-gaps` when missing failure-path coverage is the finding.
24. Do not record standalone missing, weak, stale, misleading, or wrong-location operational docs as reliability gaps. Use `$doc-gaps` when documentation itself is the finding.
25. Do not report optional maturity improvements, cloud-architecture preferences, private implementation preferences, or "best practice" checkboxes as findings by themselves. List them only as optional follow-up notes when relevant.
26. If no confirmed reliability gaps are found, report that no reliability gaps were found and do not create `ISSUES.md`.
27. If confirmed reliability gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
28. Assign every finding a unique ID for the session in the form `REL-<number>`.
29. Present the scoped `ISSUES.md` and a proposed reliability-fix plan to the user.
30. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

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

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Read `ISSUES.md` in the requested package or folder first and treat it as the working reliability-gap ledger.
   If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
3. Use `$project-workflow` before proposing or running validation so repository entrypoints, CI expectations, documented commands, operational docs, release/config surfaces, and `./bin` wiring are current.
4. Work through findings sequentially by ID unless the human explicitly names a different finding.
5. Before proposing a fix for each finding, re-check the current code, config, tests, docs, and CI. Treat the ledger as something that can go stale: dismiss or revise findings that are already addressed, no longer have a concrete failure mode, duplicate another issue, or belong in `$code-issues`, `$security-audit`, `$test-gaps`, or `$doc-gaps`.
6. For each finding, first present:
   - the issue ID and current evidence.
   - the affected reliability promise or operational expectation.
   - the proposed reliability solution.
   - code, config, docs, test-layer, validation, compatibility, rollout, rollback, and operator tradeoffs.
   - the intended validation.
7. Stop after proposing the solution. Do not edit files, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
8. Ask questions when SLOs, expected failure behavior, operator workflow, compatibility, rollout, validation, or user intent is ambiguous. Treat silence or a broad "implement reliability gaps" request as permission to start the proposal workflow, not as permission to edit.
9. Once the solution for the current finding is agreed, implement only that finding with the smallest clear reliability change.
10. Use `$reliability-standards` for reliability design, `$change-safety` for public or operational compatibility, `$testing-standards` for failure-path tests, and `$change-validation` for checks. Pair with `$security-audit` when the fix touches auth, secrets, privilege, DoS, logs, supply chain, or incident containment.
11. Validate the reliability change using checks appropriate to the changed behavior. Prefer repository Make targets and documented entrypoints.
12. Report the result for that finding and ask the human to verify and explicitly say `REL-<number> is done`.
13. Do not move to the next finding until the human says `REL-<number> is done`.
14. After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a reliability gap, remove it only after explaining why and getting human agreement.
15. Then propose the solution for the next remaining finding and repeat the same agreement gate.
16. Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.
17. Summarize what changed, which reliability gaps were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `../references/finding-severity.md` for confidence filtering and severity.
- Use `$reliability-standards` for SRE, NALSD, resilience, recovery, overload, observability, release-safety, and production-readiness judgment.
- Use `$project-workflow` for repository command discovery, CI expectations, documented entrypoints, operational docs, and `./bin` wiring before review planning or validation.
- Use `$change-safety` when reliability changes affect public contracts, compatibility, migrations, config, deployment, security expectations, or documented operational behavior.
- Use `$testing-standards` when reliability fixes need failure-path or recovery tests.
- Use `$change-validation` when selecting validation commands for implemented reliability fixes.
- Use `$security-audit` when the confirmed problem is primarily security-sensitive.
- Use `$code-issues`, `$test-gaps`, or `$doc-gaps` when the confirmed problem belongs to those ledgers instead of reliability.
