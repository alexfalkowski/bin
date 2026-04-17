# Review Reference

Use this reference when the user asks for a review.

## Review Priorities

- Prioritize bugs, behavioral regressions, risky assumptions, and missing coverage.
- Flag poor public-facing docs as a real finding, including missing examples where the repo expects them.
- In Go reviews, flag import naming that favors a colliding standard-library package over the repository's own package when that makes the local code less natural or harder to follow.
- In Go reviews, flag unnecessary import aliases when there is no actual collision or readability need.
- In Ruby reviews, flag public APIs that drift from the repository's established style or rely on unnecessary metaprogramming or monkey patches.
- Flag missing tests for behavior changes as a real finding unless there is a clear reason they cannot be added.
- Flag unnecessary dependencies, silent compatibility breaks, insecure defaults, unsafe generated-file edits, and leftover debug scaffolding as real findings.
- Flag missing migration planning, benchmark consideration, or observability when the change makes them relevant.
- Focus on user-visible impact and maintenance risk before style nits.
- Prefer concrete findings over broad summaries.

## Severity

- Treat correctness, security, data loss, compatibility regressions, and broken automation as high-severity findings.
- Treat missing tests, weak docs, risky dependency additions, unclear migration impact, and insufficient operational visibility as medium-severity findings unless the impact is clearly minor.
- Treat style issues and minor clarity suggestions as low-severity feedback.

## Output Format

- Present findings first.
- Order findings by severity.
- Include file and line references for each finding when possible.
- Keep the summary brief and secondary to the findings.

## If No Findings

- Say explicitly that no findings were identified.
- Still mention residual risk, blind spots, or testing gaps if they remain.
