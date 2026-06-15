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

Do not use these as productivity claims:

- lines added or deleted;
- number of comments by person;
- commit count by person;
- PR size as a standalone good/bad score;
- individual rankings;
- a single productivity score.

These may be mentioned only as context when the user explicitly asks and the
limitations are stated.
