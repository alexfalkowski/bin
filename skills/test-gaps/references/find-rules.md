# Test-Gap Find Rules

These rules remain mandatory:

- Read `../ledger.yaml` and use its resolved scoped path as the review ledger.
- Prefer slices based on repository-owned behavior and test risk: public commands/APIs, changed or recently touched areas, documented workflows, compatibility-sensitive behavior, release paths, and nearby existing tests. Use depth only as a discovery aid, not as the review boundary.
- For delegated review, each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$testing-standards` review for that slice, pairing with relevant language standards and `$change-validation` for likely validation commands.
- For delegated review, require each agent to return findings in the same shape as the scoped ledger format, without final IDs unless useful locally. Each finding must name the repository-owned behavior being protected; reject findings that only test dependency semantics, aliases, or pass-through wrappers.
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
