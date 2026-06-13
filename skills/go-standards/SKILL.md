---
name: go-standards
description: Applies this repository ecosystem's Go coding, documentation, import, naming idiom, and testing conventions. Use when writing, reviewing, refactoring, or documenting Go packages in repos that use this shared ./bin tooling; pair with $naming-standards when names or renames are part of the change.
---

# Go Standards

## Steps

1. Confirm the task is in a Go repository or touches Go code, Go tests, Go documentation, or Go package APIs.
2. Read `references/conventions.md` before editing exported APIs, documentation, imports, naming, method layout, or tests.
3. Before writing Go code that adds or changes imports, inspect nearby files in the same package and adjacent packages for existing import names, package ownership, wrappers, and dependency direction.
4. Before adding an alias for a project package and the package it wraps, decide whether the code should use or extend the project wrapper instead. A wrapper-package collision is not enough reason to import the wrapped package with aliases such as `stdtime`.
5. Do not invent Go import aliases while writing code. Agents MUST NOT add an import alias unless the file would not compile without it or a confirmed repository pattern requires it. Readability, caution, brevity, personal clarity, or avoiding visual ambiguity are not valid reasons. Document every new alias choice in your reasoning, including why an existing wrapper package could not own the needed surface. When reviewing or cleaning existing code, do not remove or rename an existing alias solely because the collision is not obvious or the alias reads awkwardly; flag it for human review instead.
6. Preserve the repository's existing Go package shape and public API style.
7. Pair this skill with `$naming-standards` when creating, reviewing, or renaming Go identifiers, packages, files, tests, or documentation terms.
8. Add or update tests when behavior changes and the repository supports tests, but do not assume they should be Go tests just because the implementation is Go. Use `$testing-standards` to identify the majority relevant existing harness first, including cross-language harnesses.
9. Add or recommend Go `*_test.go` coverage only when the nearby majority relevant tests for that behavior are Go-based, the changed surface is a Go package/API contract that cannot be covered through the dominant harness, or the repository explicitly asks for Go-level coverage. Agents MUST stop and explain before creating Go tests when another harness owns the behavior.
10. Before writing any Go `*_test.go` file, choose the test package deliberately. Default to an external `<package>_test` package. If you think the test must use the production package instead, stop and explain why the public or documented entrypoint cannot cover the behavior before writing that test.
11. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring Go test coverage.
12. Pair this skill with `$change-validation` when selecting Go test, lint, coverage, or benchmark commands.

## References

- Read `references/conventions.md` for Go API, GoDoc, testing, method layout, import, and naming idiom conventions.
