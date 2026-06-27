# Finding Severity

Use this reference whenever a skill assigns severity or confidence to code,
test, doc, reliability, diagnostic, or security findings.

## Confidence And Actionability

Filter candidates before assigning severity. A finding should have concrete
evidence, a trigger condition, credible impact, and a plausible fix direction.
Recorded findings must state the agent's actual confidence percentage, for
example `Confidence: 93%`. Use 90% as the default minimum threshold. Use 95%
for high-risk findings and acceptance, including security findings, destructive
actions, public interface or compatibility conclusions, release or PR readiness,
CI/deployment root-cause conclusions, broad no-findings claims, and claims that
a problem is definitely fixed. Treat this percentage as an evidence-calibration
threshold, not a statistical claim: after trying to disprove the candidate and
asking the strongest reasonable challenge question, the inspected evidence
should make it at least roughly as likely as the required threshold that the
finding is real, repository-owned, and actionable.
Confidence must account for both the concrete failure path and the likelihood
that supported current operation admits the trigger. A technically real failure
path that depends on an unusual future bad commit, missed review, deliberately
invalid fixture, or unsupported manual construction is a lead, not a >=90%
finding, unless repository evidence shows that path is plausibly exercised
today.

Do not collapse different confidence claims into one number. Use:

- **Finding confidence** for the chance that a recorded finding is real,
  repository-owned, and actionable.
- **Coverage confidence** for the chance that reviewed slices were inspected
  deeply enough for their stated outcome.
- **Scope no-finding confidence** for the chance that no reportable finding
  remains in the requested scope.

For broad scopes, a high finding confidence or high coverage confidence for
selected slices does not imply high scope no-finding confidence. If coverage is
incomplete, say so directly instead of giving a low-value estimate that the
entire codebase has no issues.

Challenge confidence before accepting it. If an unresolved ownership, trigger,
impact, usage, contract, or counterexample question would drop confidence below
the threshold, gather evidence, lower confidence, route the concern, or state the
gap. Do not lower confidence merely because inspected evidence already answers a
question.

Discard candidates that are likely false positives, vague suggestions,
unsupported guesses, style-only preferences, nitpicks, or comments whose impact
cannot be explained from the inspected code, tests, docs, or command behavior.
Do not classify uncertain or low-confidence candidates as `Low`; `Low` still
means a real finding with limited impact.

If confidence is below the applicable confidence threshold, gather more evidence
through code inspection, current tests, command output, generated contracts,
scanner output, official sources, runtime behavior, or history. If confidence
still cannot reach the applicable threshold, do not record it as a finding. Use
the workflow's data-gap, open-question, or optional follow-up section only when
that section is explicitly meant for unresolved evidence; otherwise discard the
candidate.

For reusable libraries, helpers, and shared tooling, calibrate confidence
against supported usage evidence, not package-local possibility alone. Synthetic
tests, fakes, manual construction, unsupported downstream patterns, or private
implementation reachability are useful leads, but they do not justify a >=90%
durable finding unless a supported consumer, executable example, integration
test, module wiring path, documented contract, CI workflow, or comparable real
usage path can trigger the candidate. If that evidence is missing, gather it,
lower confidence below the recording threshold, route the concern to a better
workflow, or record only the evidence gap when the selected workflow has a
place for unresolved questions.

For third-party tools or project-owned upstream libraries, separate defect
evidence from fix ownership. A finding is local only when repository-owned
adapter, dependency policy, validation, compatibility, fallback, or documented
contract behavior is wrong. Otherwise route the dependency/tooling response to
project workflow, or route the defect to the owning library's agent or ledger.

When a candidate depends on comments, GoDoc, README text, examples, or other
prose contradicting implementation, do not treat the prose as source of truth.
First prove the implementation is wrong with non-prose evidence such as
runtime behavior, executable tests, schemas, generated or wire contracts,
external standards, scanner output, or history showing an unintended code
regression. If current code and tests support the implementation, classify the
candidate as a documentation gap or discard it instead of assigning severity to
a code, test, reliability, or security finding.

## Confidence Evidence Rubric

Use confidence as a compact statement of completed evidence, not optimism. The
same percentage can mean different work in a small package and a broad repo
audit, so state the evidence behind it. For broad no-findings claims, release or
PR readiness, compatibility conclusions, and definitely-fixed claims, require
95% confidence or state the remaining blocker.

- **Static/manual pass**: supports a scoped candidate or no-findings claim only
  for the files, packages, modules, components, commands, services, or areas
  actually inspected. It is not enough for a broad repo claim unless paired with
  inventory accounting and supported usage evidence.
- **Inventory/count reviewed**: raises confidence that the scope is complete
  when the count or inventory comes from the repository-defined discovery path,
  and exclusions like vendored dependencies, generated files, caches, ignored
  submodules, build output, or skipped slices are named.
- **Static analyzers**: increase confidence for the classes they analyze only
  when they ran against the intended files, packages, modules, components, or
  commands and did not no-op because of sandbox, cache, stale tool context, or
  discovery failures.
- **Unit or package tests**: increase confidence for behavior covered by the
  repository's language-native test layer. Listener, cache, service, or sandbox
  failures must be classified before treating them as repository evidence.
- **Repository spec or feature target, such as `make specs`**: increases
  confidence for supported end-to-end, integration, or service behavior when
  that target is the dominant relevant harness.
- **Lint target, such as `make lint` or the repository's exposed lint split**:
  increases confidence for style, static policy, generated metadata, and
  language/tooling checks that the target actually ran. Optional-tool no-ops do
  not provide full coverage.
- **Security target, such as `make sec`**: increases confidence for dependency,
  vulnerability, container, or security-policy coverage that the target owns.
  Network, cache, credential, or scanner failures must be reported as
  validation gaps unless repository-owned code caused them.
- **Generated freshness target**: increases confidence only for
  generated-contract drift covered by the repository's documented stale or
  generated check, such as `make proto-stale` when exposed.
- **Remaining missing tools or environment blockers**: cap confidence to the
  evidence still available. Record the blocker as missing tool, local
  environment issue, or inconclusive validation instead of treating it as a
  repository finding.

For no-findings results, distinguish `No findings and validation clean`,
`No findings, but validation incomplete because X`, and
`Audit incomplete: no confirmed findings so far`. Report residual risk in
concrete terms: unrun targets, no-op wrappers, skipped slices, unsupported
paths, missing sidecars, unavailable scanners, or evidence that was limited to
static review. Do not use a clean no-findings outcome for a broad scope unless
scope no-finding confidence reaches the required threshold and no relevant
slice remains skimmed, deferred, or blocked.

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
