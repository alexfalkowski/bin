# Finding Severity

Use this reference whenever a skill assigns severity or confidence to code,
test, doc, reliability, diagnostic, or security findings.

## Confidence And Actionability

Filter candidates before assigning severity. A finding should have concrete
evidence, a trigger condition, credible impact, and a plausible fix direction.
Recorded findings must have `Confidence: High (>=80%)`. Treat this percentage
as an evidence-calibration threshold, not a statistical claim: after trying to
disprove the candidate, the inspected evidence should make it at least roughly
80% likely that the finding is real, repository-owned, and actionable.

Discard candidates that are likely false positives, vague suggestions,
unsupported guesses, style-only preferences, nitpicks, or comments whose impact
cannot be explained from the inspected code, tests, docs, or command behavior.
Do not classify uncertain or low-confidence candidates as `Low`; `Low` still
means a real finding with limited impact.

If confidence is below the high-confidence threshold, gather more evidence
through code inspection, current tests, command output, generated contracts,
scanner output, official sources, runtime behavior, or history. If confidence
still cannot reach `High (>=80%)`, do not record it as a finding. Use the
workflow's data-gap, open-question, or optional follow-up section only when that
section is explicitly meant for unresolved evidence; otherwise discard the
candidate.

When a candidate depends on comments, GoDoc, README text, examples, or other
prose contradicting implementation, do not treat the prose as source of truth.
First prove the implementation is wrong with non-prose evidence such as
runtime behavior, executable tests, schemas, generated or wire contracts,
external standards, scanner output, or history showing an unintended code
regression. If current code and tests support the implementation, classify the
candidate as a documentation gap or discard it instead of assigning severity to
a code, test, reliability, or security finding.

## Severity

- `Critical`: Near-certain severe production breakage, data loss or corruption,
  remote code execution, credential exposure, auth bypass, project unusability
  on its primary path, or a public contract violation with broad severe impact.
- `High`: Likely user-visible regression, compatibility break, security issue,
  CI or release blocker, broken primary workflow, or high-risk test or doc gap
  with a clear trigger.
- `Medium`: Real bug, missing validation, edge-case regression, weak test
  coverage, stale or misleading documentation, or maintainability risk that can
  affect users but is scoped, recoverable, or not on the primary path.
- `Low`: Minor correctness issue, hardening gap, confusing behavior, missing
  docs or tests for a low-risk path, or maintainability concern with limited
  impact.

## Domain Notes

- For code findings, severity tracks the behavior or contract at risk, not how
  easy the fix is.
- For test gaps, severity tracks the risk created by missing, weak, misleading,
  flaky, or wrong-layer coverage, not the amount of test code needed.
- For doc gaps, severity tracks the risk of user, operator, API, setup, or
  maintenance misunderstanding, not wording preference.
- For security findings, use the security-audit reference for domain-specific
  examples and reporting values; those examples should still follow this
  impact-based scale.
- If severity depends on assumptions about downstream use, state the triggering
  scenario in the finding's impact or evidence.
