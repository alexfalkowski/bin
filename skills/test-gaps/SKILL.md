---
name: test-gaps
description: Use when the user asks to find $test-gaps in a package or folder, find test gaps in a package or folder, find flaky tests in a package or folder, find wrong-layer tests in a package or folder, find weak test harness or test-support-code gaps, implement $test-gaps in a package or folder, implement test gaps in a package or folder, asks about test gap IDs such as TEST-1, asks what the fix is for TEST-1, asks to fix or verify TEST-1, or says TEST-1 is done. Find concrete missing, weak, misleading, flaky, wrong-layer, or poorly supported test coverage, including test harness issues that make coverage brittle or misleading; record confirmed gaps in scoped TESTS.md; and later propose and implement agreed test fixes gap by gap.
---

# Test Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $test-gaps in PACKAGE_OR_FOLDER` or `Find test gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $test-gaps in PACKAGE_OR_FOLDER` or `Implement test gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

## Operating Stance

Operate as a coverage triager: protect repository-owned behavior through the
narrowest credible established test layer, and reject gaps that only test
dependency semantics, private implementation detail, implementation-only
optimizations, or coverage vanity. A missing test is a gap only when the
untested behavior belongs to a real caller-facing contract; a public helper,
exported function, or internal collaborator is not automatically a test boundary.

Use code, executable behavior, existing tests, schemas, generated contracts,
runtime evidence, external standards, and history to establish expected
behavior. Comments, GoDoc, README prose, examples, and other documentation can
be stale. Do not record a test gap merely to make tests enforce stale prose; if
prose and implementation disagree, first prove which behavior is wrong with
non-prose evidence, then route code bugs to `$code-issues` and stale prose to
`$doc-gaps`.

Treat test harnesses, test fixtures, feature helpers, test-support scripts,
cross-language acceptance layers, and test-only Ruby, shell, Go, or other code
as test surfaces when the proposed improvement primarily makes tests more
correct, representative, deterministic, maintainable, configurable, or
appropriately layered. Do not mistake test-support code for product code merely
because it has executable logic. Route pure build, CI, Makefile, release,
validation-preflight, command-discovery, setup, or repository workflow
improvements to `$project-gaps`.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These test-gap rules remain mandatory:

- Use `TESTS.md` in the requested package or folder as the review ledger, for
  example `PACKAGE_OR_FOLDER/TESTS.md`.
- Prefer slices based on repository-owned behavior and test risk: public commands/APIs, changed or recently touched areas, documented workflows, compatibility-sensitive behavior, release paths, and nearby existing tests. Use depth only as a discovery aid, not as the review boundary.
- Each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$testing-standards` review for that slice, pairing with relevant language standards and `$change-validation` for likely validation commands.
- Require each agent to return findings in the same shape as the `TESTS.md` format, without final IDs unless useful locally. Each finding must name the repository-owned behavior being protected; reject findings that only test dependency semantics, aliases, or pass-through wrappers.
- Confirm each candidate gap against the code and existing tests before recording it. Gaps must be concrete missing, weak, misleading, flaky, or wrong-layer coverage with credible risk to changed behavior, public contracts, compatibility, release-sensitive workflows, or documented command/API behavior.
- For each candidate, identify the real front door: the command, scenario,
  package/API consumer, service boundary, workflow, or documented entrypoint
  that would observe the behavior. Do not record a gap merely because an
  exported function, constructor, interface, or helper lacks direct tests.
- For candidates based on documentation or comments contradicting code, require non-prose evidence for the expected behavior before recording a test gap. If current code and tests support the implementation, treat the prose as a doc gap instead of adding tests that would encode stale documentation.
- For each candidate, explicitly identify the nearby existing test shape and why extending existing tests, fixtures, tables, helpers, or assertions does not already cover the behavior. Do not record a gap when the proposed fix would duplicate coverage already provided by that local shape.
- For each candidate involving test harness or test-support code, identify how
  the harness weakness can make tests brittle, misleading, wrong-layer,
  duplicated, non-deterministic, environment-bound, or unable to cover the
  repository-owned behavior through the dominant relevant harness.
- Do not record gaps whose only meaningful test would assert pass-through behavior to an upstream library, standard library, or framework. This includes aliases, type aliases, thin wrappers, direct option forwarding, direct global setter/getter calls, dependency injection container behavior, validator tag behavior, encoder/parser behavior, and constructors where the repository adds no branching, validation, transformation, error handling, lifecycle behavior, compatibility policy, or composition contract of its own.
- Only record a gap around third-party integration when the untested behavior is repository-owned. Examples include local validation/normalization before calling the dependency, local input/output mapping, local error wrapping/classification/recovery, lifecycle ordering or cleanup owned by the repository, documented compatibility behavior promised across dependency versions, or end-to-end behavior through a supported public repo entrypoint where multiple repo-owned pieces are composed.
- When a candidate gap touches a wrapper around a dependency, explicitly ask: "Would the proposed test fail because repository code changed, or only because the dependency's behavior/shape changed?" Record it only when repository code owns the failing behavior.
- When a candidate gap touches an optimization or refactor, explicitly ask:
  "Would the proposed test fail because an observable contract changed, or only
  because the implementation strategy changed?" Record it only for observable
  repository-owned contracts such as ordering, latency, cancellation,
  concurrency safety, cleanup, error aggregation, compatibility, or documented
  lifecycle behavior.
- Do not record gaps that require build tags, architecture-specific execution, optional services, integration environments, or other validation modes the repository does not normally run, unless the finding is explicitly that CI or the documented validation path must add that mode.
- Do not record standalone build, CI, Makefile, release, validation-preflight,
  command-discovery, setup, or repository workflow improvements as test gaps.
  Use `$project-gaps` when the improvement is about how the project discovers,
  runs, aggregates, or gates validation rather than about the correctness,
  representativeness, maintainability, or layer of the tests themselves.
- Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as test gaps. If such broken behavior is discovered during review, report it as out of scope for the test-gap ledger and recommend `$code-issues`; use this skill when the unprotected or poorly protected behavior is the finding.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as test gaps. Use `$doc-gaps` when documentation itself is the finding.
- Do not report optional nice-to-have tests, private implementation coverage, arbitrary coverage percentage improvements, style preferences, or docs-only validation as findings by themselves. List them only as doc gaps or optional follow-up notes when relevant.

## `TESTS.md` Format

Use this structure:

```markdown
# Tests

## TEST-1: Short concrete title

- Type: Test Gap
- Severity: Critical|High|Medium|Low
- Confidence: 93%
- Scope: path/to/file-or-folder
- Impact: Risk created by the missing, weak, misleading, flaky, or wrong-layer coverage.
- Evidence: Concrete file and line references, existing test behavior, command output, or untested code path.
- Proposed fix: Brief test or test-harness direction using the narrowest credible established test layer.
- Validation: Suggested checks for the test change.
```

Keep optional follow-up notes separate from findings:

```markdown
## Optional Test Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These test-gap implementation rules remain mandatory:

- Before proposing a fix for each finding, re-check the current code and nearby tests. Treat the ledger as something that can go stale: dismiss or revise findings that are already covered, would duplicate the local test shape, test only underlying libraries/frameworks, or require validation modes the repository does not run.
- When re-checking a finding whose evidence depends on documentation or comments contradicting implementation, prove the expected behavior with non-prose evidence before proposing tests. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a test gap and propose reclassifying or fixing documentation instead.
- Ask questions when behavior, compatibility, test layer, fixture strategy, validation, or user intent is ambiguous. Treat silence or a broad "implement test gaps" request as permission to start the proposal workflow, not as permission to code.
- After the human agrees and before editing, state the selected local test pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed finding with the smallest clear test change, preferring the existing local test shape over new standalone structure.
- Use `$testing-standards` for test design and pair with the relevant language standard for local idioms. If implementing the test gap requires production behavior to change, prefer the test-first or scenario-first loop from `$testing-standards`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$testing-standards` for cross-language test quality, coverage, fixtures, determinism, and test-layer decisions.
- Use relevant language standards for local test idioms.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-gaps` instead when the concern is build, CI, Makefile, release,
  setup, validation preflight, command discovery, or repository workflow rather
  than test correctness or harness quality.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented test fixes.
