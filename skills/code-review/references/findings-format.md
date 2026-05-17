# Findings Format

Use this reference when the user asks for a review.

## Review Priorities

- Prioritize bugs, behavioral regressions, risky assumptions, and missing coverage.
- Flag missing tests, compatibility breaks, unsafe defaults, and missing docs when they materially affect the change.
- Focus on user-visible impact and maintenance risk before style nits.
- Prefer concrete findings over broad summaries.
- Ground each finding in the inspected code and describe the consequence, not just the preference.

## Output Format

- Use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Findings

- [severity] path/to/file:line - Finding title
  Impact: Describe the concrete bug, regression, or risk.
  Evidence: Point to the inspected code or behavior.
  Recommendation: Describe the smallest credible fix.

## Open Questions

- None.

## Testing Gaps

- None.

## Summary

Brief one- or two-sentence summary.
```

- Use only these severities: `critical`, `high`, `medium`, `low`.
- Order findings by severity.
- Include file and line references for each finding when possible.
- If no line reference is available, use `path/to/file` without a line number and explain the location in `Evidence`.
- Keep the summary brief and secondary to the findings.
- When useful, state the condition or scenario that triggers the problem so the risk is easy to verify.
- If a section has no entries, write exactly `- None.`

## If No Findings

- In `Findings`, write exactly `- None.`
- Use `Testing Gaps` to mention residual risk, blind spots, or testing gaps if they remain.
