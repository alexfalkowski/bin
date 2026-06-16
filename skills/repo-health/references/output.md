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
2. `**Delivery Flow**`
3. `**CI Quality**`
4. `**Release And Deploy**`
5. `**Service Reliability**` for services only
6. `**Notable Work**`
7. `**Risks And Follow-Ups**`
8. `**Data Sources**`

Omit `Service Reliability` for libraries unless service evidence exists.

## Summary

Use 2-5 bullets. Separate measured facts from interpretation.

Good examples:

- `Delivery improved: 12 PRs merged versus 8 in the prior week, while median PR age fell from 2.1d to 1.3d.`
- `CI is the main weak spot: success rate dropped to 84% and the deploy workflow accounts for most failures.`
- `Service health was steady: uptime stayed at 99.99% with no visible incidents.`

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
