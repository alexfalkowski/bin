---
name: go-standards
description: Applies this repository ecosystem's Go coding, documentation, import, naming, and testing conventions. Use when writing, reviewing, refactoring, or documenting Go packages in repos that use this shared ./bin tooling.
---

# Go Standards

## Steps

1. Confirm the task is in a Go repository or touches Go code, Go tests, Go documentation, or Go package APIs.
2. Read `references/conventions.md` before editing exported APIs, documentation, imports, naming, method layout, or tests.
3. Before writing Go code that adds or changes imports, inspect nearby files in the same package and adjacent packages for existing import names, package ownership, wrappers, and dependency direction.
4. Do not invent Go import aliases while writing code. Add an alias only after confirming the package's declared name would collide or create required disambiguation, and document that choice in your reasoning.
5. Preserve the repository's existing Go package shape and public API style.
6. Add or update Go tests when behavior changes and the repository supports tests.
7. Before writing any Go `*_test.go` file, choose the test package deliberately. Default to an external `<package>_test` package. If you think the test must use the production package instead, stop and explain why the public or documented entrypoint cannot cover the behavior before writing that test.
8. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring Go test coverage.
9. Pair this skill with `change-validation` when selecting Go test, lint, coverage, or benchmark commands.

## References

- Read `references/conventions.md` for Go API, GoDoc, testing, method layout, import, and naming conventions.
