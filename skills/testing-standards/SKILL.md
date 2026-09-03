---
name: testing-standards
description: Use when adding, reviewing, refactoring, or planning tests across languages. Apply language-agnostic behavior-focused test design, coverage, fixtures, determinism, and test-layer conventions; pair with $go-standards, $ruby-standards, or $shell-standards for language-specific idioms and $change-validation for commands.
---

# Testing Standards

## Operating Stance

Operate as a behavior-focused test designer. Make tests act as executable
specifications for observable repository-owned behavior when a credible test
harness owns that behavior, and use test feedback to verify implementation and
guide refactoring. Do not force new tests onto docs, policy, configuration,
metadata, formatting-only changes, or command glue that is better validated by
lint, schema checks, dry-runs, or repository-defined validation. Treat public
functions, exported symbols, helper APIs, and collaborator calls as possible
implementation details until the intended caller or scenario proves they are
the behavior boundary. Prefer established local test shapes and keep coverage
useful, deterministic, and readable rather than mechanically broad. Prefer
simple tests that make the behavior obvious; when no observable
repository-owned behavior changes and the only possible test would encode
internal order, provider wiring, dependency call shape, or timing, use
repository validation and a clarifying code comment when the fix would
otherwise look unnecessary.

## Mandatory Stop Gates

These are mandatory gates, not guidance.

- Before adding or changing tests, agents MUST identify the dominant relevant
  test harness for the affected behavior.
- Before adding or changing tests, agents MUST identify the intended caller,
  scenario, command, package/API consumer, or service boundary that owns the
  behavior. A public or exported function is not automatically the right test
  boundary; if it is not the real front door, test from the real front door or
  sketch the caller before editing.
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
- Tests MUST use the existing harness lifecycle and configuration shape unless
  the changed behavior cannot be exercised through it. Before adding a second
  process, port, config file, startup mode, lifecycle hook, env/config
  indirection, custom harness class, fixture generator, or helper layer, agents
  MUST stop and explain why the current harness cannot cover the behavior. If a
  simpler existing config or scenario edit can cover it, use that path.
- If the human asks to remove, skip, or simplify a test during a behavior
  change, agents MUST NOT infer that coverage is waived. Ask whether to replace
  it with better-shaped coverage or explicitly accept no test for that change.
- Agents MUST NOT accept a newly added or changed test that can pass without
  exercising the intended behavior. Before accepting coverage, agents MUST
  perform a mutation-style gap scan: determine whether changes to comparisons,
  boundaries, booleans, error paths, collection or string operations, defaults,
  or observable side effects could escape detection. If they could, strengthen
  the test, choose a better layer, or remove it and report that existing
  coverage already protects the behavior.
- Tests MUST NOT invent public constructors, callbacks, interfaces, modules,
  packages, commands, or helper seams before the intended caller-facing API is
  clear. If a test needs implementation-shaped API, private access, or callback
  injection, stop and sketch the intended public caller before editing.
- Tests MUST NOT lock in implementation-only optimizations or internal
  collaboration choices such as serial versus concurrent execution, goroutine
  use, batching, caching, retry internals, provider registration shape, or
  helper extraction unless that choice changes an observable contract such as
  ordering, latency, cancellation, concurrency safety, resource cleanup, error
  aggregation, compatibility, or documented behavior.
- Tests MUST NOT encode internal call order, provider registration order,
  callback timing, pointer projection, dependency invocation shape, or other
  implementation sequencing merely to prove a behavior-preserving fix. If the
  sequencing is an observable contract, test that contract through the
  caller-facing boundary. If it is not observable and a test would be cryptic,
  skip the test, keep the fix small, add a short intent comment only when the
  code would otherwise look removable or wrong, and validate through the
  repository-defined command.
- Tests MUST NOT inspect source code, ASTs, generated files, strings, imports,
  or dependency call sites to prove an implementation detail is absent unless
  the repository explicitly owns that rule as lint, static analysis, or a code
  generation contract. Prefer public behavior tests; otherwise validate through
  review, lint/static analysis, or report the coverage gap.
- Agents MUST NOT force new tests for docs, policy, configuration, metadata,
  formatting-only changes, generated artifacts, or shell/Make/Docker glue
  unless the changed behavior has an established executable test harness. Use
  `$change-validation` to select lint, schema, dry-run, or repository validation
  instead.
- Before relying on behavioral tests, agents MUST confirm the dominant harness
  can actually execute. If it cannot, agents MUST stop and either make it
  runnable or ask the human whether to proceed without executed behavioral
  tests, stating the validation gap and the other supported checks available.
  Other checks do not silently replace required behavior coverage.

## Steps

1. Confirm the task involves adding tests, changing tests, reviewing test quality, planning coverage, or deciding where behavior should be exercised.
2. Decide whether the change has repository-owned executable behavior. For docs, policy, configuration, metadata, formatting-only edits, generated artifacts, and simple shell/Make/Docker glue, default to validation unless an established harness owns the behavior.
3. Inspect existing tests, fixtures, helpers, entrypoints, CI targets, and the language or harness used by most relevant tests before recommending, adding, or changing test structure.
4. Do not infer the repository's test strategy or test language from implementation language or `*_test.go` files alone. Agents MUST follow the majority relevant test pattern, including cross-language harnesses such as `test/`, `features/`, and `spec/`; add language-native tests only when that layer owns the behavior, the surface is a language-level package/API contract, or the user asks for it.
5. Detect the dominant local test style before choosing the test shape. When multiple layers exist, choose the narrowest established layer that protects the changed behavior.
6. Check whether the change should preserve, restore, or improve coverage; do not let meaningful behavior lose coverage without calling out the gap.
7. Before adding a new standalone test, check whether existing tests already cover the behavior or should be extended through a table, fixture, helper, or assertion block.
8. Before choosing the test boundary, identify the front door that will call the
   new or changed behavior. Use the narrowest established layer that still
   exercises that caller-facing contract; do not start from an exported helper,
   method, constructor, interface, or package merely because it is public.
9. Before editing behavior-changing production code that adds or changes a
   public or documented API, sketch the intended caller or scenario so tests and
   implementation share a deliberate caller-facing contract.
10. Before editing behavior-changing production code, identify the expected
    observable behavior and the evidence that will validate it. Do not prescribe
    whether tests or implementation must be written first.
11. For behavior-changing code with an established runnable harness, complete
    both the smallest clear implementation and the narrowest credible test or
    scenario; either may be written first.
    Run the focused selector after both are in place, and earlier whenever it
    provides useful feedback. Inspect failures to distinguish missing behavior
    from setup, harness, dependency, fixture, timeout, compilation, or unrelated
    failures, use test feedback while iterating, and keep relevant tests passing.
12. Choose the narrowest established test layer that credibly covers the changed behavior.
13. While editing, get fast feedback from the narrowest supported selector in
    that layer: package, file, scenario, example, focus tag, test name, command,
    or documented entrypoint. Do not use speed as a reason to switch to a
    different layer, skip required setup, or test private surfaces.
14. Test through public or documented APIs, commands, tasks, or service entrypoints so coverage reflects real consumer behavior.
15. Do not add tests against private functions, private methods, or internal-only seams unless the human explicitly asks for that approach. If private-surface testing seems necessary, first explain why a public or documented entrypoint cannot cover it, then ask before writing it.
16. Preserve the repository's existing test framework, fixture layout, helper style, assertion idioms, and naming patterns unless the task explicitly changes testing infrastructure.
17. Pair with the relevant language standard skill for language-specific idioms, and with `$change-validation` for commands.
18. If another testing-focused skill applies, use this skill for cross-language policy and the other skill only for specialized language, framework, or library details.
19. When tests use mocks, stubs, spies, fakes, or other test doubles, check whether each double protects a true boundary or only mirrors internal implementation.
20. Before accepting or repeating a coverage claim, run the selected coverage command when practical and inspect every reported metric, not only line coverage.
21. Before broad validation, perform an explicit Refactor assessment on changed production code and tests. Refactor is a mandatory assessment step, not an optional cleanup note. Use behavior-preserving, step-by-step changes only; propose behavior-changing cleanup separately.
22. Run a two-pass refactor assessment: inspect local code smells and test smells, then boundary fit. Use a third pass when the change touches shared tooling, public or documented interfaces, compatibility-sensitive behavior, security-sensitive behavior, release or CI workflow, or when either earlier pass still leaves a credible smell. Use the Refactoring Guru catalog categories as checklist prompts, including composing methods, moving features, organizing data, simplifying conditionals, simplifying method calls, and generalization cleanup, only when they fit local patterns.
23. If no cleanup is needed, record `Refactor: none (<reason>)` after stating which refactor passes were considered.
24. Before finishing, do a readability pass after formatting and scan changed tests for low-information repeated boolean or numeric assertions; add named subtests or assertion messages where needed.
25. When reviewing test quality, evaluate whether tests are understandable, maintainable, repeatable, atomic, necessary, granular, and fast enough for their layer. Use scores only when asked.
26. For behavior-changing code with an established test harness, report the test strategy, style detected, coverage changes, focused validation, refactor assessment, mutation/coverage gaps, and broader validation. Never invent or reconstruct command output or claim a check ran when it did not. Use `Refactor: none (<reason>)` when no cleanup was needed.

## References

- Read `references/principles.md` when designing, adding, reviewing, or
  refactoring non-trivial tests; when choosing between public boundaries,
  fixtures, doubles, coverage, determinism, or validation breadth; or when a
  test candidate risks encoding implementation detail instead of behavior.
