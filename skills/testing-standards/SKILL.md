---
name: testing-standards
description: Applies language-agnostic test design, test-first/TDD or scenario-first/BDD workflow, coverage, fixtures, determinism, and test-layer conventions. Use when adding, reviewing, refactoring, or planning tests across languages; pair with $go-standards, $ruby-standards, or $shell-standards for language-specific idioms and $change-validation for commands.
---

# Testing Standards

## Operating Stance

Operate as a behavior-focused test designer: make tests act as executable
specifications for observable repository-owned behavior, prefer established
local test shapes, and keep coverage useful, deterministic, and readable rather
than mechanically broad.

## Mandatory Stop Gates

These are mandatory gates, not guidance.

- Before adding or changing tests, agents MUST identify the dominant relevant
  test harness for the affected behavior.
- If the dominant relevant harness is Cucumber, Gherkin, RSpec-style features,
  another cross-language harness, or another repository-defined layer, agents
  MUST NOT add language-native tests unless the user explicitly asks for that
  layer or the behavior cannot be exercised through the dominant harness.
- If an exception is claimed, agents MUST stop before editing and explain why
  the dominant harness cannot cover the behavior.
- If a wrong-layer test is added, agents MUST remove it immediately and continue
  with the dominant relevant harness.
- Personal clarity, convenience, faster local execution, implementation
  language, or direct access to private functions are not valid reasons to
  bypass the dominant harness.
- If the human asks to remove, skip, or simplify a test during a behavior
  change, agents MUST NOT infer that test-first workflow or coverage is waived.
  Ask whether to replace it with better-shaped coverage or explicitly accept no
  test for that change.
- If the intended red test or scenario passes unexpectedly, agents MUST stop
  before production edits and either strengthen the test, choose a better layer,
  or report that existing coverage already protects the behavior.

## Steps

1. Confirm the task involves adding tests, changing tests, reviewing test quality, planning coverage, or deciding where behavior should be exercised.
2. Inspect the repository's existing tests, fixtures, helpers, entrypoints, CI targets, and the language or harness used by most relevant tests before recommending, adding, or changing test structure.
3. Do not infer the repository's test strategy or test language from the implementation language. Agents MUST follow the majority pattern of the relevant existing tests for the behavior, even when that means testing one implementation language from another language or harness. Add language-native tests only when that is the majority relevant local pattern, the changed surface is a language-level package/API contract, or the user explicitly asks for that level of coverage.
4. Do not infer the repository's test strategy only from language-native test files such as `*_test.go`; inspect cross-language harness directories such as `test/`, `features/`, and `spec/`, plus CI or make targets, before adding tests.
5. Detect the dominant local test style before choosing the loop: prefer BDD/scenario-first when behavior is primarily exercised through `features/`, Cucumber/Gherkin, RSpec-style specs, acceptance tests, or Given/When/Then scenarios; prefer TDD/test-first when behavior is primarily exercised through unit, package, table-driven, or assertion-based tests. When both exist, choose the narrowest established layer that protects the changed behavior.
6. Check whether the change should preserve, restore, or improve coverage; do not let meaningful behavior lose coverage without calling out the gap.
7. Before adding a new standalone test, check whether the behavior is already covered by existing tests and whether the right change is to extend an existing table, fixture, helper, or assertion block.
8. Before editing behavior-changing production code, make an explicit test-first decision. State either `TDD: yes` with the first test/scenario you will add or update, or `TDD: no` with the concrete reason test-first is not practical. Do this before production edits, not retroactively after implementation.
9. For behavior-changing code, prefer a test-first loop. In TDD-style projects, write or update the narrowest credible test first; in BDD-style projects, write or update the narrowest credible scenario, feature, or spec first. Run it and confirm it fails for the expected reason when practical. If the test passes unexpectedly, stop before production edits and re-check whether the behavior is already covered, whether the assertion is too weak, or whether a different test layer is needed. Implement the smallest code change to pass it, then perform a refactor pass while keeping tests green.
10. If behavior-changing production code was edited before the test-first decision, stop and correct course: add or update the narrowest credible test immediately, run it against the current state when practical, and explicitly report that the red step was missed before continuing.
11. Choose the narrowest established test layer that credibly covers the changed behavior.
12. Test through public or documented APIs, commands, tasks, or service entrypoints so coverage reflects real consumer behavior.
13. Do not add tests against private functions, private methods, or internal-only seams unless the human explicitly asks for that approach. If private-surface testing seems necessary, first explain why the behavior cannot be covered through a public or documented entrypoint, then ask before writing it.
14. Preserve the repository's existing test framework, fixture layout, helper style, assertion idioms, and naming patterns unless the task explicitly changes testing infrastructure.
15. Pair with the relevant language standard skill for language-specific idioms, and with `$change-validation` for selecting or reporting commands.
16. If another testing-focused skill applies, use this skill for cross-language test policy and the other skill only for specialized language, framework, or library details; this skill's cross-language rules take precedence unless the human or repository instructions explicitly say otherwise.
17. When tests use mocks, stubs, spies, fakes, or other test doubles, check whether each double protects a true boundary or only mirrors internal implementation; flag interaction-only tests that could pass while real behavior is broken.
18. Before finishing test changes or reviews, do a mutation-style gap scan against changed behavior. Ask whether the tests would fail if a comparison changed, a boundary moved, a boolean flipped, an error path returned success, a collection or string operation changed, a fallback/default was removed, or an observable side effect disappeared. Strengthen the behavior test when the answer is no. Ask the human only when the correct boundary or product behavior is ambiguous.
19. Before accepting or repeating a coverage claim, run the repository's selected coverage command when practical and inspect every metric the tool reports, not only line coverage. If coverage drops or a metric is weak, ask what repository-owned behavior is untested before adding line-targeted tests.
20. After green and before broad validation, perform an explicit refactor pass on changed production code and tests. Remove duplication, simplify awkward setup, align with local naming/helpers, and keep behavior unchanged. If no cleanup is needed, record `Refactor: none`.
21. Before finishing test changes or reviews, do a readability pass after formatting. Check that tests describe observable behavior, avoid hard-coded private implementation details unless those details are the public contract, keep setup expressions simple enough for review, and place helper functions according to the local or language-specific convention.
22. Before finishing test changes or reviews, scan changed tests for repeated boolean or numeric assertions whose default failure output would not identify the behavior under test; add named subtests or assertion messages where needed.
23. When reviewing test quality, evaluate whether the tests are understandable, maintainable, repeatable, atomic, necessary, granular, fast enough for their layer, and first/test-driven where that is relevant. Use scores only when the human asks for a scored review; otherwise turn the rubric into concrete findings and improvements.
24. For behavior-changing code, report the trace in the final update using this shape: `TDD decision`, `Style detected`, `First test/scenario`, `Red`, `Green`, and `Refactor`. Include the test, scenario, feature, or spec added or updated first; whether the red step failed for the expected reason, passed unexpectedly, was not practical to run, or was missed; the implementation change that made it green; any mutation-style or coverage gap found; and any refactor after green. Use `Refactor: none` when no cleanup was needed.

## Principles

- Assert changed behavior and contracts, not incidental implementation details.
- Use tests as self-validating specifications that guide small, controlled implementation steps. Do not turn TDD into a large upfront specification exercise; keep each test or scenario narrow enough to drive the next useful behavior.
- Use test-first or scenario-first development for behavior changes when the repository has a credible test or BDD layer. Make the test-first decision before production edits. If the change is docs-only, formatting-only, mechanical, or cannot reasonably be exercised first, call out the exception and validate with the appropriate lint or check instead.
- Prefer classicist, behavior-oriented tests over mockist, interaction-heavy tests: test observable outcomes through real in-process collaborators where practical, and avoid mocking your own code just to isolate a class, method, function, or file.
- Treat the unit under test as a behavior at an appropriate boundary, not automatically a single class, method, function, or file.
- Do not create a one-to-one mapping between test files and implementation files by default. Group tests around public behavior, commands, scenarios, or contracts so implementation can be reorganized without invalidating the test suite.
- Do not extract production helpers only to make them directly testable. Extract for readability, shared domain knowledge, or separation of concerns, then test the behavior through the owning public entrypoint unless the helper is itself a documented API.
- Treat audit findings as candidates, not marching orders. Re-check whether nearby tests already cover the behavior before adding new tests.
- Do not add tests whose main assertion is that an underlying library or framework works correctly, including dependency injection containers, validators, encoders, parsers, serializers, client libraries, or standard-library behavior. Test repository-owned validation, mapping, error handling, lifecycle, compatibility promises, or consumer-visible composition instead.
- Prefer extending the local test shape over inventing parallel structure. If an existing fixture, table, scenario helper, or assertion helper already carries the behavior, add the missing assertion there rather than creating a separate test.
- For DI, configuration, module, or wiring code, avoid exhaustive provider-registration, pointer-projection, or container-resolution tests unless they protect a distinct repository-owned public contract that is not covered by a higher-level consumer path.
- Use test doubles mainly at true boundaries: network calls, databases, clocks, filesystem, subprocesses, randomness, third-party services, slow infrastructure, or hard-to-trigger failures. Avoid stubbing internal collaborators unless it makes the test more deterministic, focused, or practical without hiding the behavior under test.
- Treat coverage as a useful signal, not a blind target: preserve existing meaningful coverage where practical, improve it when new or risky behavior is under-tested, and explain when coverage cannot reasonably be added.
- Just because production code is written in one language does not mean new tests should be written in that language; follow the majority relevant test harness when the repository tests behavior from another language or feature layer.
- Prefer table-driven tests when covering multiple inputs, branches, edge cases, or examples, unless the repository's local style clearly uses another readable pattern.
- When writing or reviewing tests for changed behavior, inspect the changed decision points: conditionals, early returns, error handling, loops, switch/case branches, parsing paths, and fallback/default behavior. Cover the meaningful consumer-visible paths, not every implementation branch mechanically.
- Cover relevant edge cases and failure paths for changed behavior, especially empty input, boundary values, malformed input, missing files or tools, non-zero commands, path errors, permissions, parsing failures, and argument pass-through.
- Keep tests deterministic: avoid uncontrolled network, wall-clock time, random data, ordering assumptions, real home directories, and shared mutable state.
- Build test data with complete, valid defaults and local overrides so each test can show only the meaningful difference. Prefer existing production constructors, parsers, schemas, or validation helpers when the repository already uses them; do not redefine production validation rules inside tests.
- Prefer fresh test data per test over shared mutable setup. Use setup hooks only when they improve clarity without creating order dependence or hidden state.
- Watch for coverage theater: tests that mock the code being tested, assert only that an internal collaborator was called, exercise trivial getters or setters without meaningful behavior, or hit lines without covering branches, boundaries, errors, and observable outcomes.
- Do not add build-tagged, architecture-specific, integration, service-dependent, or environment-specific tests unless the repository's normal validation or CI actually runs that mode, or the change explicitly adds that validation mode.
- Structure tests so the setup, action, and assertion are easy to follow; use Arrange-Act-Assert or Given-When-Then when the repository does not already have a clearer local pattern.
- Make failures obvious and descriptive. Avoid bare assertions such as `expected true but got false`; include the case, input, expected behavior, and observed behavior when the assertion framework does not do so clearly.
- For repeated low-information assertions, do not rely only on generic framework output such as `Should be false`, `expected true but got false`, or `expected 2, got 1`. Add a short assertion message or use named subtests so the failure identifies the specific scenario. This applies especially to repeated boolean and numeric assertions.
- Keep tests readable. Add small helpers, fixtures, builders, or assertions when they make behavior easier to read, but avoid abstractions that hide the scenario being tested. If a test needs a derived value, prefer a named local or helper whose name explains the behavior over dense inline setup.
- Use broader suites for shared infrastructure, compatibility-sensitive behavior, release-sensitive behavior, or changes that cross package, command, or service boundaries.
- Do not add behavioral tests for docs-only or formatting-only changes; run relevant lint, docs, or formatting validation when available.
- When reviewing tests, check these rules explicitly and flag tests that use private surfaces without approval, follow the wrong harness, miss important edge cases, produce unclear failures, or are hard to read.
- For shared `./bin` scripts and make fragments, validate from the consuming repository root when behavior depends on downstream include wiring or test/build layout.
- Report validation gaps honestly, including lint-only coverage, missing tools, skipped checks, environment limits, and wrappers that no-op.
