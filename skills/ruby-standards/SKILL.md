---
name: ruby-standards
description: Applies this repository ecosystem's Ruby coding, API, documentation, naming idiom, style, and test-entrypoint conventions. Use when writing, reviewing, refactoring, documenting, linting, or validating Ruby code in repos that use this shared ./bin tooling; pair with $naming-standards when names or renames are part of the change.
---

# Ruby Standards

## Steps

1. Confirm the task touches Ruby code, Ruby APIs, Ruby docs, Ruby linting, or Ruby feature/benchmark flows.
2. Read `references/conventions.md` before editing documented modules, classes, methods, commands, or task interfaces.
3. Before adding or changing documented Ruby modules, classes, methods,
   commands, tasks, DSL entrypoints, or examples, sketch the intended Ruby call
   site or command invocation first. Use that caller shape to decide public
   names, ownership, lifecycle, and documentation before writing tests or
   implementation.
4. Preserve the repository's existing Ruby style, naming, error handling, and test idioms. Do not assume Ruby changes require Ruby tests; use `$testing-standards` to identify the majority relevant existing harness first.
5. Avoid clever metaprogramming or monkey patches unless the repository already relies on them or the task requires them.
6. Pair this skill with `$naming-standards` when creating, reviewing, or renaming Ruby modules, classes, methods, commands, tests, fixtures, or documentation terms.
7. Pair this skill with `$change-safety` when Ruby changes affect documented commands, public methods, task interfaces, or migration expectations.
8. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring Ruby test or feature coverage.
9. Pair this skill with `$change-validation` when selecting Ruby lint, feature, benchmark, or security commands.

## References

- Read `references/conventions.md` for Ruby API, documentation, and convention guidance.
