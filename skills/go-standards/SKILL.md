---
name: go-standards
description: Applies this repository ecosystem's Go coding, documentation, import, naming, and testing conventions. Use when writing, reviewing, refactoring, or documenting Go packages in repos that use this shared ./bin tooling.
---

# Go Standards

## Steps

1. Confirm the task is in a Go repository or touches Go code, Go tests, Go documentation, or Go package APIs.
2. Read `references/conventions.md` before editing exported APIs, documentation, imports, naming, method layout, or tests.
3. Before adding, changing, or reviewing imports, inspect nearby package ownership, wrappers, and dependency direction so import choices follow the repository's package model while code is written and reviewed.
4. Preserve the repository's existing Go package shape and public API style.
5. Add or update Go tests when behavior changes and the repository supports tests.
6. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring Go test coverage.
7. Pair this skill with `change-validation` when selecting Go test, lint, coverage, or benchmark commands.

## References

- Read `references/conventions.md` for Go API, GoDoc, testing, method layout, import, and naming conventions.
