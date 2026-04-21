# Review Reference

Use this reference when the user asks for a review.

## Review Priorities

- Prioritize bugs, behavioral regressions, risky assumptions, and missing coverage.
- Flag missing tests, compatibility breaks, unsafe defaults, and missing docs when they materially affect the change.
- Focus on user-visible impact and maintenance risk before style nits.
- Prefer concrete findings over broad summaries.
- Ground each finding in the inspected code and describe the consequence, not just the preference.

## Output Format

- Present findings first.
- Order findings by severity.
- Include file and line references for each finding when possible.
- Keep the summary brief and secondary to the findings.
- When useful, state the condition or scenario that triggers the problem so the risk is easy to verify.

## If No Findings

- Say explicitly that no findings were identified.
- Still mention residual risk, blind spots, or testing gaps if they remain.
