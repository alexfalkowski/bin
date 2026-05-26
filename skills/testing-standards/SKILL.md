---
name: testing-standards
description: Applies language-agnostic test design, coverage, fixtures, determinism, and test-layer conventions. Use when adding, reviewing, refactoring, or planning tests across languages; pair with language standards for language-specific idioms and change-validation for commands.
---

# Testing Standards

## Steps

1. Confirm the task involves adding tests, changing tests, reviewing test quality, planning coverage, or deciding where behavior should be exercised.
2. Inspect the repository's existing tests, fixtures, helpers, entrypoints, CI targets, and the language or harness used by most relevant tests before adding new structure.
3. Check whether the change should preserve, restore, or improve coverage; do not let meaningful behavior lose coverage without calling out the gap.
4. Choose the narrowest established test layer that credibly covers the changed behavior.
5. Test through public or documented APIs, commands, tasks, or service entrypoints so coverage reflects real consumer behavior.
6. Do not add tests against private functions, private methods, or internal-only seams unless the human explicitly asks for that approach; if private-surface testing seems necessary, ask first.
7. Preserve the repository's existing test framework, fixture layout, helper style, assertion idioms, and naming patterns unless the task explicitly changes testing infrastructure.
8. Pair with the relevant language standard skill for language-specific idioms, and with `change-validation` for selecting or reporting commands.
9. If another testing-focused skill applies, use this skill for cross-language test policy and the other skill only for specialized language, framework, or library details; this skill's cross-language rules take precedence unless the human or repository instructions explicitly say otherwise.
10. Before finishing test changes or reviews, scan changed tests for repeated boolean or numeric assertions whose default failure output would not identify the behavior under test; add named subtests or assertion messages where needed.

## Principles

- Assert changed behavior and contracts, not incidental implementation details.
- Treat coverage as a useful signal, not a blind target: preserve existing meaningful coverage where practical, improve it when new or risky behavior is under-tested, and explain when coverage cannot reasonably be added.
- Just because production code is written in one language does not mean new tests should be written in that language; follow the dominant relevant test harness when the repository tests behavior from another language or feature layer.
- Prefer table-driven tests when covering multiple inputs, branches, edge cases, or examples, unless the repository's local style clearly uses another readable pattern.
- Cover relevant edge cases and failure paths for changed behavior, especially empty input, boundary values, malformed input, missing files or tools, non-zero commands, path errors, permissions, parsing failures, and argument pass-through.
- Keep tests deterministic: avoid uncontrolled network, wall-clock time, random data, ordering assumptions, real home directories, and shared mutable state.
- Structure tests so the setup, action, and assertion are easy to follow; use Arrange-Act-Assert or Given-When-Then when the repository does not already have a clearer local pattern.
- Make failures obvious and descriptive. Avoid bare assertions such as `expected true but got false`; include the case, input, expected behavior, and observed behavior when the assertion framework does not do so clearly.
- For repeated low-information assertions, do not rely only on generic framework output such as `Should be false`, `expected true but got false`, or `expected 2, got 1`. Add a short assertion message or use named subtests so the failure identifies the specific scenario. This applies especially to repeated boolean and numeric assertions.
- Keep tests readable. Add small helpers, fixtures, builders, or assertions when they make behavior easier to read, but avoid abstractions that hide the scenario being tested.
- Use broader suites for shared infrastructure, compatibility-sensitive behavior, release-sensitive behavior, or changes that cross package, command, or service boundaries.
- Do not add behavioral tests for docs-only or formatting-only changes; run relevant lint, docs, or formatting validation when available.
- When reviewing tests, check these rules explicitly and flag tests that use private surfaces without approval, follow the wrong harness, miss important edge cases, produce unclear failures, or are hard to read.
- For shared `./bin` scripts and make fragments, validate from the consuming repository root when behavior depends on downstream `$(PWD)/bin/...` wiring.
- Report validation gaps honestly, including lint-only coverage, missing tools, skipped checks, environment limits, and wrappers that no-op.
