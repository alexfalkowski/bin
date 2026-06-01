# Findings Format

Use this reference when the user asks for a review.

## Review Priorities

- Prioritize bugs, behavioral regressions, risky assumptions, and missing coverage.
- Flag missing tests, compatibility breaks, unsafe defaults, and missing docs when they materially affect the change.
- Focus on user-visible impact and maintenance risk. Do not report style nits
  as findings; use `$style-review` when the user asks for non-blocking polish.
- Prefer concrete findings over broad summaries.
- Ground each finding in the inspected code and describe the consequence, not just the preference.
- Avoid broad "consider checking" comments. Each finding needs a concrete changed location, behavior at risk, evidence, and a clear place to start fixing.

## Severity

- `critical`: Near-certain production breakage, data loss or corruption, remote code execution, credential exposure, auth bypass, or a change that makes the project unusable for its primary path.
- `high`: Likely user-visible regression, compatibility break, security issue, CI or release blocker, or broken primary workflow with a clear trigger.
- `medium`: Real bug, missing validation, edge-case regression, or maintainability risk that can affect users but is scoped, recoverable, or not on the primary path.
- `low`: Minor correctness issue, hardening gap, confusing behavior, missing docs or tests for a low-risk path, or maintainability concern with limited impact.
- Do not inflate severity for style preferences, speculative risks, or missing tests without a concrete failure mode.
- If severity depends on assumptions about downstream use, state the triggering scenario in `Impact` or `Evidence`.

## Output Format

- When code review is the final response, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

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
- When another skill embeds the review, keep the same finding severity, evidence, impact, recommendation, open-question, and testing-gap facts but use the caller's required output sections.

## If No Findings

- In `Findings`, write exactly `- None.`
- Use `Testing Gaps` to mention residual risk, blind spots, or testing gaps if they remain.
