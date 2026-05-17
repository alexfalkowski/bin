---
name: code-review
description: Reviews code changes for bugs, regressions, risky assumptions, missing tests, compatibility breaks, unsafe defaults, and missing documentation. Use when the user asks for review, code review, audit, inspect a diff, check a PR, or find issues before merging.
---

# Code Review

## Steps

1. Identify the changed files or requested review scope.
2. Read `references/findings-format.md` before producing review output.
3. Inspect behavior, tests, compatibility, security, docs, and maintenance risk before style preferences.
4. Verify claims against concrete file and line references whenever possible.
5. Use the exact structure in `references/findings-format.md`; do not add, remove, rename, or reorder sections.

## References

- Read `references/findings-format.md` for review priorities, output format, and what to say when no issues are found.
