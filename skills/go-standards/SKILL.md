---
name: go-standards
description: Applies this repository ecosystem's Go coding, documentation, import, naming idiom, and testing conventions. Use when writing, reviewing, refactoring, or documenting Go packages in repos that use this shared ./bin tooling; pair with $naming-standards when names or renames are part of the change.
---

# Go Standards

## Steps

1. Confirm the task is in a Go repository or touches Go code, Go tests, Go documentation, or Go package APIs.
2. Read `references/conventions.md` before editing exported APIs, documentation, imports, naming, method layout, or tests.
3. Before writing Go code that adds or changes imports, inspect nearby files in the same package and adjacent packages for existing import names, package ownership, wrappers, and dependency direction.
4. Do not invent Go import aliases while writing code. Add an alias only after confirming the package's declared name would collide or create required disambiguation, and document that choice in your reasoning. When reviewing or cleaning existing code, do not remove or rename an existing alias solely because the collision is not obvious or the alias reads awkwardly; flag it for human review instead.
5. Preserve the repository's existing Go package shape and public API style.
6. Pair this skill with `$naming-standards` when creating, reviewing, or renaming Go identifiers, packages, files, tests, or documentation terms.
7. Add or update tests when behavior changes and the repository supports tests, but do not assume they should be Go tests just because the implementation is Go. Use `$testing-standards` to identify the majority relevant existing harness first, including cross-language harnesses.
8. Add or recommend Go `*_test.go` coverage only when the nearby majority relevant tests for that behavior are Go-based, the changed surface is a Go package/API contract, or the repository explicitly asks for Go-level coverage.
9. Before writing any Go `*_test.go` file, choose the test package deliberately. Default to an external `<package>_test` package. If you think the test must use the production package instead, stop and explain why the public or documented entrypoint cannot cover the behavior before writing that test.
10. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring Go test coverage.
11. Pair this skill with `$change-validation` when selecting Go test, lint, coverage, or benchmark commands.

## References

- Read `references/conventions.md` for Go API, GoDoc, testing, method layout, import, and naming idiom conventions.
