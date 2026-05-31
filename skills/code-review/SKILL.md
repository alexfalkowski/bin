---
name: code-review
description: Reviews changed code for bugs, regressions, risky assumptions, missing tests, compatibility breaks, missing documentation, and language-specific maintainability or idiom risks. Use when the user asks for a general code review, diff review, PR check, or pre-merge issue pass; delegate explicit security scope to security-audit.
---

# Code Review

## Steps

1. Identify the changed files or requested review scope.
2. Read `references/findings-format.md` before producing review output.
3. Inspect behavior, tests, compatibility, security, docs, and maintenance risk before style preferences.
4. First identify high-risk review leads, especially deletions, cross-boundary drift, silent behavior changes, changed contracts, unhandled sibling cases, and error-path changes. Then verify concrete findings instead of reviewing every line uniformly.
5. Prefer precision over recall. Do not report plausible concerns unless they survive attempts to disprove them and are grounded in changed code, concrete evidence, and credible user, compatibility, security, maintenance, or test risk.
6. Pair with relevant language standards (`$go-standards`, `$ruby-standards`, `$shell-standards`) when reviewing language-specific code, APIs, docs, tests, or tooling behavior. Pair with `$naming-standards` when names create concrete ambiguity, misuse risk, public contract confusion, inconsistent vocabulary, or maintenance cost. Treat idiomatic style concerns as findings only when they create concrete readability, maintenance, correctness, compatibility, or public API risk.
7. Use `$testing-standards` when judging whether tests are missing, weak, overfit to internals, or at the wrong layer.
8. If the review scope includes security-sensitive code, configuration, dependencies, shell execution, filesystem writes/deletes, network/auth/TLS behavior, secrets/env handling, Docker helpers, or CI/security tooling, consult `$security-audit` and the smallest matching security reference; keep this skill's findings format.
9. Verify claims against concrete file and line references whenever possible.
10. When code review is the final response, use the exact structure in `references/findings-format.md`; do not add, remove, rename, or reorder sections.
11. When another skill embeds this review, preserve findings, open questions, testing gaps, and summary facts in the caller's output format.

## References

- Read `references/findings-format.md` for review priorities, output format, and what to say when no issues are found.
- Use relevant language standards for idiomatic code, API, docs, test, and tooling conventions.
