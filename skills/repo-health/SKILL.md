---
name: repo-health
description: Use when the user asks for repo health, repository health report, delivery health report, weekly or daily engineering metrics, repo health comparison, service health summary, library maintenance summary, or period-over-period view for a specific GitHub repository. Produce daily or weekly summaries across delivery flow, CI quality, release/deploy activity, and service reliability using local git, GitHub, CircleCI, Kubernetes/DigitalOcean, and UptimeRobot evidence.
---

# Repo Health

Use this skill to turn repository activity and operational evidence into a
concise daily or weekly engineering-health report. Report what changed, whether
delivery was smooth, and whether the repo or service looks healthier than the
comparison period. Convert measured bottlenecks into prioritized,
evidence-backed follow-up actions that repository owners can complete.

## Workflow

1. Identify the requested repository, period, comparison period, and summary
   mode.
   - Default to the current working repository when the user does not name one.
   - Default to weekly summary for the last complete 7 days when no period is
     provided.
   - Use the local timezone unless the user specifies another timezone.
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
6. Use `scripts/collect.rb` as the default collection path when Ruby is
   available. It performs the local, GitHub, CircleCI,
   DigitalOcean/Kubernetes, and UptimeRobot read-only collection in one command
   and returns report-ready JSON with metrics and source summaries.
7. Collect evidence manually only for requested scope that `scripts/collect.rb`
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

## Reporting Rules

- Do not rank individual developers, infer effort from lines of code, or call a
  person productive/unproductive from activity metrics.
- Do not collapse delivery, quality, and reliability into a single repository
  score.
- Do not fabricate missing GitHub, CircleCI, Kubernetes, DigitalOcean, or
  UptimeRobot values. State the missing source, credential, command, or mapping.
- Do not expose tokens, API keys, private URLs, or raw incident payloads in the
  final report.
- Prefer medians over averages for age, lead-time, duration, and recovery-time
  metrics.
- Prefer period-over-period deltas over standalone counts.
- Prefer threshold-backed action items over generic recommendations.
- Include four-window trend context when the collector returns enough data.
- Include exact window boundaries in the final report.
- Call out interpretation separately from measured facts.

## Summary Modes

- **Weekly**: Best for management rhythm, maintenance review, and service
  health. Include delivery flow, CI quality, release/deploy activity, service
  reliability when applicable, trend context, notable changes, and prioritized
  action items.
- **Daily**: Best for operational check-ins. Emphasize yesterday/today flow,
  failed checks, deploys, incidents, open review bottlenecks, and follow-up
  actions.
- **Library**: Omit service reliability unless monitors or deploys exist.
  Emphasize maintenance throughput, release readiness, CI, dependency/security
  signals when available, unreleased commits, latest release age, and
  downstream-impact notes visible in the repo.
- **Service**: Include deployment, uptime, incident, response-time, Kubernetes,
  monitor-health evidence, and operational follow-up actions when available.

## References

- Run `scripts/collect.rb --repo PATH` first for report-ready metrics and
  source summaries.
- Read `references/sources.md` for source priority, credential names, and
  collection boundaries.
- Read `references/metrics.md` for metric definitions, comparison logic, and
  anti-metrics.
- Read `references/output.md` for the required final report shape.
