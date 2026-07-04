# Testing Principles

- Assert changed behavior and contracts, not incidental implementation details.
- Let tests validate the intended public caller experience, not design the API
  around the first convenient implementation seam.
- Outside-in means start from the real consumer-visible boundary, then let
  internal public functions, interfaces, and collaborators emerge only when the
  caller requires them.
- Do not add tests for refactors and optimizations that preserve the same
  contract unless the optimization creates observable risk such as concurrency,
  cleanup, cancellation, timing, error handling, compatibility, or documented
  lifecycle behavior.
- Do not turn a behavior-preserving fix into cryptic tests for internal order.
  If the order matters to users, document and test the observable contract. If
  it only explains implementation intent, prefer the fix, a small comment when
  future maintainers might remove it, and normal validation.
- Do not write source-inspection tests to enforce implementation absence unless
  the repository owns that rule as lint, static analysis, or generation.
- Keep each test or scenario narrow enough to guide the next useful behavior.
  Make the test-first decision before production edits when a credible harness
  exists; use validation instead for docs, policy, config, metadata, formatting,
  mechanical, generated, or non-executable changes.
- Treat Refactor as the TDD design payoff: inspect for real smells, remove only
  those supported by local evidence, and avoid broad rewrites, speculative
  abstraction, or unrelated polish.
- Prefer classicist behavior tests over mockist interaction tests. Test
  observable outcomes through real in-process collaborators where practical,
  and avoid mocking repository-owned code just to isolate a class, method,
  function, or file.
- Treat the unit under test as behavior at an appropriate boundary, not
  automatically a single file, class, method, or function.
- Do not map test files one-to-one with implementation files by default. Group
  tests around public behavior, commands, scenarios, or contracts.
- Do not extract production helpers only to make them directly testable.
- Re-check audit findings against nearby coverage before adding tests.
- Do not test that an underlying library or framework works. Test
  repository-owned validation, mapping, error handling, lifecycle,
  compatibility promises, or consumer-visible composition.
- Prefer extending the local test shape over inventing parallel structure.
- For DI, configuration, module, or wiring code, avoid exhaustive registration,
  pointer-projection, or container-resolution tests unless they protect a
  distinct repository-owned public contract not covered by a higher layer.
- Use test doubles mainly at true boundaries: network, databases, clocks,
  filesystem, subprocesses, randomness, third-party services, slow
  infrastructure, or hard-to-trigger failures.
- Treat coverage as a signal, not a blind target.
- Follow the majority relevant harness even when production code is written in
  another language.
- Prefer table-driven tests for multiple inputs, branches, edge cases, or
  examples unless local style uses another readable pattern.
- Cover meaningful consumer-visible decision points and failure paths: empty
  input, boundary values, malformed input, missing files or tools, non-zero
  commands, path errors, permissions, parsing failures, and argument
  pass-through.
- Keep tests deterministic: avoid uncontrolled network, wall-clock time, random
  data, ordering assumptions, real home directories, and shared mutable state.
- Build data with complete valid defaults and local overrides. Prefer existing
  production constructors, parsers, schemas, or validation helpers.
- Prefer fresh test data per test over shared mutable setup.
- Watch for coverage theater: tests that mock the code under test, assert only
  internal calls, exercise trivial accessors, or hit lines without branches,
  boundaries, errors, and observable outcomes.
- Do not add build-tagged, architecture-specific, integration,
  service-dependent, or environment-specific tests unless normal validation or
  CI runs that mode, or the change adds that mode.
- Structure tests so setup, action, and assertion are easy to follow; use
  Arrange-Act-Assert or Given-When-Then when local style has no clearer pattern.
- Make failures descriptive. For repeated low-information boolean or numeric
  assertions, add named subtests or assertion messages.
- Keep tests readable. Use helpers, fixtures, builders, or assertions only when
  they clarify behavior without hiding the scenario.
- Put repeated configuration literals in the established fixture/helper
  location and keep call sites focused on scenario-specific values.
- Use broader suites for shared infrastructure, compatibility-sensitive
  behavior, release-sensitive behavior, or cross-boundary changes.
- Use focused package, file, scenario, example, focus-tag, or test-name runs for
  fast feedback when the dominant harness supports them; broaden when risk,
  shared surface, or confidence target requires it.
- Do not add behavioral tests for docs-only or formatting-only changes; run
  relevant lint, docs, or formatting validation.
- When reviewing tests, flag private surfaces without approval, wrong harnesses,
  missed edge cases, unclear failures, and hard-to-read tests.
- For shared `./bin` scripts and make fragments, validate from the consuming
  repository root when downstream include wiring or test/build layout matters.
- Report validation gaps honestly, including lint-only coverage, missing tools,
  skipped checks, environment limits, and wrappers that no-op.
