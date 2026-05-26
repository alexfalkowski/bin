---
name: code-review
description: Reviews changed code for bugs, regressions, risky assumptions, missing tests, compatibility breaks, and missing documentation. Use when the user asks for a general code review, diff review, PR check, or pre-merge issue pass; delegate explicit security scope to security-audit.
---

# Code Review

## Steps

1. Identify the changed files or requested review scope.
2. Read `references/findings-format.md` before producing review output.
3. Inspect behavior, tests, compatibility, security, docs, and maintenance risk before style preferences.
4. Use `$testing-standards` when judging whether tests are missing, weak, overfit to internals, or at the wrong layer.
5. If the review scope includes security-sensitive code, configuration, dependencies, shell execution, filesystem writes/deletes, network/auth/TLS behavior, secrets/env handling, Docker helpers, or CI/security tooling, consult `$security-audit` and the smallest matching security reference; keep this skill's findings format.
6. Verify claims against concrete file and line references whenever possible.
7. When code review is the final response, use the exact structure in `references/findings-format.md`; do not add, remove, rename, or reorder sections.
8. When another skill embeds this review, preserve findings, open questions, testing gaps, and summary facts in the caller's output format.

## References

- Read `references/findings-format.md` for review priorities, output format, and what to say when no issues are found.
