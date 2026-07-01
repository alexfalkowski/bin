# Output

Use this final report shape unless the user asks for a different format.

## Required Shape

Start with the repository and exact window:

```markdown
**Repository:** owner/repo
**Window:** 2026-06-08 00:00 to 2026-06-15 00:00 Europe/Berlin
**Mode:** service weekly summary
```

Then include these sections:

1. `**Summary**`
2. `**Top Bottleneck**`
3. `**Action Queue**`
4. `**Delivery Flow**`
5. `**CI Quality**`
6. `**Release And Deploy**`
7. `**Service Reliability**` for services only
8. `**Trend Context**`
9. `**Notable Work**`
10. `**Risks And Follow-Ups**`
11. `**Data Quality Actions**`
12. `**Data Sources**`

Omit `Service Reliability` for libraries unless service evidence exists.

## Summary

Use 2-5 bullets. Separate measured facts from interpretation.

Good examples:

- `Delivery improved: 12 PRs merged versus 8 in the prior week, while median PR age fell from 2.1d to 1.3d.`
- `CI is the main weak spot: success rate dropped to 84% and the deploy workflow accounts for most failures.`
- `Service health was steady: uptime stayed at 99.99% with no visible incidents.`

## Top Bottleneck

Name the highest-priority actionable bottleneck from the measured data. Keep it
to one line. If there is no evidence-backed bottleneck, write:

```markdown
- None from the available data.
```

Good example:

```markdown
- P1 CI: workflow success rate is 82.0% with 3 failed workflows; inspect the latest failed workflows before merging or releasing.
```

## Action Queue

List actionable work in priority order. Use only evidence-backed actions from
the collected data or write `- None from the available data.`

```markdown
| Priority | Area | Evidence | Suggested Action |
| --- | --- | --- | --- |
| P1 | CI | Workflow success rate is 82.0% with 3 failed workflows. | Inspect the latest failed workflows before merging or releasing. |
| P2 | Review | 4 open PRs are stale for more than 7 days. | Close, merge, or revive each stale PR. |
```

Use priorities as:

- `P1`: blocks release, deployment, or reliable operation;
- `P2`: active bottleneck, quality issue, or reliability trust issue;
- `P3`: maintenance follow-up that should be scheduled.

## Metric Tables

Use compact Markdown tables:

```markdown
| Metric | Current | Previous | Delta | Signal |
| --- | ---: | ---: | ---: | --- |
| PRs merged | 12 | 8 | +4 | better |
| Median PR age | 1.3d | 2.1d | -0.8d | better |
```

Use `n/a` for unavailable values. In `Signal`, use:

- `better`
- `worse`
- `up`
- `down`
- `flat`
- `n/a`

Use `better` or `worse` only when direction clearly maps to health. Use `up` or
`down` for neutral volume changes.

## Trend Context

When the collector returns trend context, include compact trend tables for the
most useful metrics. Prefer one table per area only when data is available.

```markdown
| Metric | Current | Previous | 4-window Median | Delta From Median | Signal |
| --- | ---: | ---: | ---: | ---: | --- |
| Workflow success rate | 82.0% | 96.0% | 94.0% | -12.0pp | worse |
| p95 workflow duration | 18.2m | 12.1m | 12.5m | +5.7m | worse |
```

If trend data is missing or partial, say which source is missing rather than
filling trend values with guessed numbers.

## Notable Work

List up to 5 concrete items visible from commits, merged PRs, releases, or
deploys. Prefer merged PR titles and release names over commit noise.

```markdown
- Merged #123, "Add retry budget to webhook delivery".
- Released v1.8.0.
```

## Risks And Follow-Ups

List only actionable risks supported by evidence:

```markdown
- Deploy workflow failed 3 times; inspect the failed `deploy` jobs before the next release.
- 4 PRs are stale for more than 7 days; decide whether to close or revive them.
```

If there are no evidence-backed risks, write `- None from the available data.`
If a metric is collection-time only, stale, or based on partial samples, call
that out here rather than hiding it in the data-source table.
If CircleCI has `max_auto_reruns`, mention the rerun context when discussing
workflow failure counts.

## Data Quality Actions

List source setup work that would make the report more actionable:

```markdown
| Source | Missing Impact | Setup Action |
| --- | --- | --- |
| CircleCI | Cannot measure workflow reliability, duration, deploy, or flaky-test metrics. | Ensure CircleCI API access and set `CIRCLE_TOKEN` or configure the CLI token. |
| UptimeRobot | Cannot measure external uptime, incident, MTTR, or response-time metrics. | Ensure UptimeRobot API access and set `UPTIMEROBOT_API_KEY` plus `UPTIMEROBOT_MONITOR_IDS`. |
```

If all material sources were available or intentionally skipped, write:

```markdown
- None.
```

## Data Sources

End with source coverage and gaps:

```markdown
| Source | Status | Notes |
| --- | --- | --- |
| Local git | used | Commit and tag history. |
| GitHub | used | PRs, releases, checks. |
| CircleCI | unavailable | `CIRCLE_TOKEN` is not set. |
| UptimeRobot | skipped | Library repo; no service monitor mapping found. |
```

Do not include secrets, full API payloads, or private incident URLs.
