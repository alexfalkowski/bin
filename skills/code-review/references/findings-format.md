# Findings Format

Use this reference when the user asks for a review.

## Review Priorities

- Prioritize bugs, behavioral regressions, risky assumptions, and missing coverage.
- Flag missing tests, compatibility breaks, unsafe defaults, and missing docs when they materially affect the change.
- Flag unnecessary defensive complexity when it creates a concrete maintenance,
  concurrency, compatibility, or readability risk without a supported failure
  mode. Prefer the simplest contract that matches normal repository wiring, and
  ask for evidence before accepting guards for impossible nils, repeated calls,
  unreachable states, or hypothetical misuse.
- Focus on user-visible impact and maintenance risk. Do not report style nits
  as findings; use `$style-review` when the user asks for non-blocking polish.
- Prefer concrete findings over broad summaries.
- Ground each finding in the inspected code and describe the consequence, not just the preference.
- Avoid broad "consider checking" comments. Each finding needs a concrete changed location, behavior at risk, evidence, and a clear place to start fixing.
- Do not report code findings based only on comments, GoDoc, README text, examples, or other prose contradicting implementation. Prose can be stale; cite non-prose evidence that proves the implementation is wrong, or report the mismatch as a documentation issue instead.
- Do not report a third-party library, framework, tool, or upstream
  project-owned library bug as a local code finding unless local code violates
  its own documented adapter, mapping, compatibility, validation, or fallback
  contract. Route dependency/tooling follow-up to `$project-gaps-find`; route bugs in
  another project-owned library to that library's agent or ledger, using the
  current repository only as evidence of supported usage.
- Do not flag a missing regression test when the fix preserves observable
  behavior and the only plausible test would encode internal order, provider
  wiring, dependency call shape, or third-party behavior. Mention validation or
  an optional coverage gap only when there is a concrete repository-owned
  contract that remains unprotected.

## Severity

- Use `../../references/finding-severity.md` to filter low-confidence
  candidates before assigning severity and confidence.
- Every finding must include the agent's actual confidence percentage, for
  example `Confidence: 93%`. If confidence cannot reach the applicable
  threshold after reasonable verification, do not report the candidate as a
  finding.
- Confidence must survive a challenge pass. Before reporting the percentage,
  ask what reasonable question, alternate owner, unsupported usage path, or
  counterexample would derail the finding; if that answer is unresolved, lower
  confidence below the threshold, gather more evidence, or move the concern to
  `Open Questions` or the appropriate routed workflow. Do not lower confidence
  merely because a question can be asked when the inspected evidence already
  answers it.
- For code-review output, write severity values in lowercase:
  `critical`, `high`, `medium`, or `low`.
- Do not inflate severity for style preferences, speculative risks, or missing
  tests without a concrete failure mode.
- If severity depends on assumptions about downstream use, state the triggering
  scenario in `Impact` or `Evidence`.

## Output Format

- When code review is the final response, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Findings

- [severity] path/to/file:line - Finding title
  Confidence: 93%
  Impact: Describe the concrete bug, regression, or risk.
  Evidence: Point to the inspected code or behavior, supported usage path, and
    ownership reason.
  Recommendation: Describe the smallest credible fix.

## Open Questions

- None.

## Testing Gaps

- None.

## Documentation

- None.

## Summary

Brief one- or two-sentence summary.
```

- In `Documentation`, state whether any changed README, doc, example, or
  command/config doc from the changed-file inventory needed an update for
  this change, and whether it got one. Report this even when the answer is
  "no doc changes were needed" — do not omit the section.
- Use only these severities: `critical`, `high`, `medium`, `low`.
- Order findings by severity.
- Include file and line references for each finding when possible.
- If no line reference is available, use `path/to/file` without a line number and explain the location in `Evidence`.
- Keep the summary brief and secondary to the findings.
- When useful, state the condition or scenario that triggers the problem so the risk is easy to verify.
- If a section has no entries, write exactly `- None.`
- When another skill embeds the review, keep the same finding severity, confidence, evidence, impact, recommendation, open-question, testing-gap, and documentation facts but use the caller's required output sections.

## If No Findings

- In `Findings`, write exactly `- None.`
- Use `Testing Gaps` to mention residual risk, blind spots, or testing gaps if they remain.
