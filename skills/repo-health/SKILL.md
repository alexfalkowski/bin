---
name: repo-health
description: Use when a user asks for a daily or weekly engineering, project, service, library, or repository health report; a delivery or reliability trend; or a period-over-period comparison for a GitHub repository. Summarize delivery flow, CI quality, release/deploy activity, and service reliability from available evidence.
---

# Repo Health

Use this skill to turn repository activity and operational evidence into a
concise daily or weekly engineering-health report. Report what changed, whether
delivery was smooth, and whether the repo or service looks healthier than the
comparison period. Convert measured bottlenecks into prioritized,
evidence-backed follow-up actions that repository owners can complete.

For a generic invocation, `SCOPE` is a repository together with its requested
reporting period and comparison period, not necessarily a local folder.

## Workflow

1. Identify the requested repository, period, comparison period, and summary
   mode.
   - Default to the current working repository when the user does not name one.
   - Default to weekly summary for the last complete 7 days when no period is
     provided.
   - Use the local timezone (via `TZ`) unless the user specifies another; the
     collector falls back to `Europe/Berlin` when `TZ` is unset.
   - Compare weekly summaries with the preceding 7 days; compare daily summaries
     with the preceding 24 hours or preceding calendar day, matching the
     requested window.
2. Classify the repo as `library`, `service`, or `unknown`.
   - Treat a `.cd` file as a service signal: the repo is deployed, uses
     DigitalOcean, and has UptimeRobot monitoring.
   - Treat deploy manifests, Docker release targets, Kubernetes objects, service
     monitors, or UptimeRobot evidence as service signals.
   - Treat packages, reusable modules, CLIs, or shared Make/tooling repos with no
     deployment evidence as library signals.
   - If classification affects the requested answer and evidence is ambiguous,
     ask one concise question before collecting service-only metrics.
3. Read `references/sources.md` before collecting data.
4. Read `references/metrics.md` before calculating or naming metrics.
5. Read `references/output.md` before writing the final summary.
6. Use `scripts/collect` as the default collection path when Ruby is
   available. It performs the local, GitHub, CircleCI,
   DigitalOcean/Kubernetes, and UptimeRobot read-only collection in one command
   and returns report-ready JSON with metrics and source summaries.
   - Run it in the runtime's persistent command session; do not run one process
     per metric or source. `scripts/collect` itself runs one collector attempt,
     validates the completed output, and retries exactly once only after a
     completed run fails validation, writing progress to standard error and
     validated JSON to standard output. Record its exit code in `rc`, never
     `status`: `status` is read-only in zsh.
   - Use `--sources local,github` to limit collection when the report needs a
    subset, or `--timeout SECONDS` to override the 240-second overall deadline.
   - Full collection can take time, especially when CircleCI is selected. After
     starting it, poll the same persistent session until it exits; do not use a
     30-second command wait as the session lifetime. Agents must not kill,
     cancel, or switch to manual fallback because a poll returns before the
     collector exits. Allow at least the configured 240-second timeout plus
     final-output time before declaring the invocation timed out.
   - Do not retry an interruption or timeout: a session without a completed exit
     code or final output is an invocation failure, not source data. A completed
     zero-exit valid JSON result with an unavailable source is a
     collector-generated unavailable source and must be reported as such, not
     retried.
7. Collect evidence manually only for requested scope that `scripts/collect`
   cannot cover or when Ruby is unavailable. Keep the manual collection as
   narrow as possible, and state why the collector was insufficient before
   relying on local repository facts, authenticated source APIs, or CLIs.
8. Keep missing data explicit. Use `n/a` only when the source is unavailable,
   not when the metric is inconvenient to compute.
9. Keep collection read-only. API calls, `gh`, `curl`, `git log`, and
   repository searches are acceptable; do not modify remote systems, clusters,
   monitors, branches, PRs, or releases while producing the summary.
10. Identify the top bottleneck from the collected evidence. Use `None from the
   available data` when no threshold-backed bottleneck is present.
11. Produce a prioritized action queue from stale PRs, review latency, CI
   failures, deploy failures, flaky tests, release readiness, rollbacks,
   incidents, uptime, response time, Kubernetes readiness, and missing material
   data sources.
12. Produce the summary in Markdown tables with a short narrative. Do not create
   files unless the user asks for a durable report.

## References

- Run `scripts/collect --repo PATH` first for report-ready metrics and
  source summaries.
- Read `references/sources.md` for source priority, credential names, and
  collection boundaries.
- Read `references/metrics.md` for metric definitions, comparison logic, and
  anti-metrics.
- Read `references/output.md` for reporting rules, summary modes, and the
  required final report shape.
