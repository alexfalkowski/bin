# Reliability-Gap Find Rules

These rules remain mandatory:

- Read `../../reliability-gaps-implement/ledger.yaml` and use its resolved scoped path as the review ledger.
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
- Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as reliability gaps. If broken behavior is discovered during review, report it as out of scope for the reliability-gap ledger and recommend `$code-issues-find`, `$security-audit`, or `$change-safety` as appropriate.
- If investigation finds current valid user input producing the wrong API
  response, error, status code, persisted value, generated artifact, or public
  contract output, stop treating it as a reliability gap. Route it to
  `$code-issues-find` unless the primary missing control is operational rather than
  behavioral.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as reliability gaps. Use `$test-gaps-find` when missing failure-path coverage is the finding.
- Do not record standalone missing, weak, stale, misleading, or wrong-location operational docs as reliability gaps. Use `$doc-gaps-audit` or `$doc-gaps-fix` when documentation itself is the finding.
- Do not report optional maturity improvements, cloud-architecture preferences, private implementation preferences, or "best practice" checkboxes as findings by themselves. List them only as optional follow-up notes when relevant.
