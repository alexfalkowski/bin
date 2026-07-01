# Metrics

Use this reference for metric names and calculations. Prefer a few trustworthy
metrics over a large table of weak proxies.

## Window Logic

- `current period`: the requested daily or weekly window.
- `comparison period`: the immediately preceding window of the same length.
- `delta`: current period minus comparison period.
- `direction`: `better`, `worse`, `up`, `down`, `flat`, or `n/a`.

Use exact timestamps in the local timezone in the final report.
For GitHub search date ranges, use inclusive date syntax for the calendar dates
that correspond to the requested window, then filter timestamps precisely when
the API returns full timestamps.

## Action Thresholds

Use thresholds to turn measured facts into follow-up work. Thresholds are
triage triggers, not hard service objectives, unless the repository documents a
stricter target.

| Trigger | Suggested Priority | Action |
| --- | --- | --- |
| Workflow success rate below 90% | P1 | Inspect failed workflows before merging or releasing. |
| Any failed deploy job | P1 | Inspect failed deploy jobs before the next release. |
| Any incident, rollback, revert, or uptime below 99.9% | P1 | Review the incident, release, or rollback path and confirm recovery. |
| Any stale PR older than 7 days | P2 | Close, merge, or revive each stale PR. |
| Median PR age, review latency, p95 workflow duration, or response time worsens by more than 25% | P2 or P3 | Inspect the bottleneck owner: review, CI, runtime, or dependencies. |
| Any flaky test reported by CircleCI | P2 | Fix or quarantine the named flaky tests. |
| Unreleased commits exist and no release/tag was created in the period | P3 | Decide whether accumulated library changes need a release. |
| Unreleased commits exist and the latest release is older than 90 days | P2 | Review release readiness and downstream impact. |

Use `P1` for work that can block release, deployment, or reliable operation.
Use `P2` for active bottlenecks or trust issues. Use `P3` for maintenance work
that should be scheduled but is not blocking the current flow.

## Trend Context

When data is available, include a four-window trend for high-signal metrics:
the current window, previous window, and two older same-length windows. Report
the current value, previous value, four-window median, delta from median, and
signal.

Use trend context for:

- median PR age and review latency;
- workflow success rate, failed workflow count, and p95 workflow duration;
- tag/release count, deploy failures, and rollback or revert count;
- uptime, incident count, downtime, and average response time.

Do not over-interpret trends with missing source data or very small sample
sizes. Call those limits out in `Risks And Follow-Ups` or `Data Quality
Actions`.

## Delivery Flow

| Metric | Definition |
| --- | --- |
| Commits | Non-merge commits authored or committed in the period, depending on the available source. State which timestamp is used. |
| PRs opened | Pull requests created in the period. |
| PRs merged | Pull requests merged in the period. |
| PRs closed unmerged | Pull requests closed without merge in the period. |
| Open PRs | Pull requests open at the end of the current period. |
| Stale PRs | Open PRs with no commits, comments, review, or status update for at least 7 days unless the repo has another documented threshold. |
| Median PR age | Median time from PR creation to merge for PRs merged in the period. |
| Median review latency | Median time from PR creation to first human review or review comment when available. |
| Release readiness | Latest tag, latest tag age, and unreleased commit count when tag history is available. |

Interpretation:

- More merged PRs is not automatically better; compare it with CI failures,
  incident rate, and PR age.
- Rising open or stale PR counts are bottleneck signals.
- Very small sample sizes should be labeled as low confidence.
- If all sampled PRs lack review records, report review latency as `n/a`.

## CI Quality

| Metric | Definition |
| --- | --- |
| Workflow success rate | Successful workflows divided by completed workflows in the period. |
| Failed workflows | Failed, errored, canceled, or timed-out workflows in the period. State the source categories when available. |
| Median workflow duration | Median duration of completed workflows. |
| p95 workflow duration | 95th percentile duration when enough runs exist. |
| Flaky tests | Tests identified by CircleCI or the dominant test harness as flaky in the period. |

Interpretation:

- Success-rate improvement is meaningful only when workflow volume is similar or
  the sample size is stated.
- Faster workflows are useful when success rate and coverage are not degrading.
- Flaky tests are a quality and trust signal; report the workflow or test names
  when available.
- CircleCI's flaky-test endpoint can report a total count that is higher than
  the number of returned example rows. Use the total count as the metric and
  list returned rows as examples.

## Release And Deployment

| Metric | Definition |
| --- | --- |
| Releases | GitHub releases, version tags, or documented release artifacts created in the period. |
| Deploys | Production or environment deployments completed in the period. State the environment if known. |
| Deploy frequency | Deploy count divided by period length. |
| Lead time to deploy | Median time from merge to deployment for merged PRs that can be matched to deploys. |
| Rollbacks | Reverts, rollback deploys, or documented rollback events in the period. |

For libraries, treat releases as the deployment analogue. For services, prefer
actual deploy events over inferred tag or image activity.
When CI has explicit deploy jobs, report successful deploy jobs and failed
deploy jobs separately from releases/tags.
For library repos, call out unreleased commits, latest release age, and whether
the current period produced a tag or release.

## Service Reliability

| Metric | Definition |
| --- | --- |
| Uptime | Percentage of time monitors were up during the period. |
| Downtime | Total monitor downtime in the period. |
| Incidents | Distinct downtime or degraded-service windows in the period. |
| MTTR | Median time from incident start to recovery when incident windows are available. |
| Average response time | Average external monitor response time in the period. |
| Pod readiness | Ready replicas divided by desired replicas at collection time. |
| Restarts | Pod/container restarts during the period or current restart count when period data is unavailable. |
| Runtime image | Deployed image tag at collection time. |

Interpretation:

- External uptime is the user-visible reliability signal; Kubernetes readiness
  is supporting evidence.
- Do not infer customer impact from internal Kubernetes events alone.
- Correlate failed deploys, incidents, and rollbacks only when timestamps
  overlap credibly.
- Treat Kubernetes readiness, restart count, and runtime image as
  collection-time values unless historical metrics are available.

## Anti-Metrics

Do not use these as individual performance claims:

- lines added or deleted;
- number of comments by person;
- commit count by person;
- PR size as a standalone good/bad score;
- individual rankings;
- a single repository health score.

These may be mentioned only as context when the user explicitly asks and the
limitations are stated.
