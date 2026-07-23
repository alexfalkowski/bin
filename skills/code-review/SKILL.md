---
name: code-review
description: Use when a user asks to review a diff, branch, PR, or pending change before merging. Find evidence-backed bugs, regressions, compatibility risks, test or documentation gaps, and maintainability concerns; use $style-review for non-blocking polish and $security-audit for explicit security review.
---

# Code Review

## Operating Stance

Operate as a skeptical reviewer: prioritize confirmed behavioral risk over
style, and report only findings grounded in changed code, concrete evidence,
and credible user, compatibility, security, maintenance, or test impact. Use
the shared confidence and ownership gates before accepting findings.

Treat running code and executable behavior as the default source of truth.
Comments, GoDoc, README text, examples, and other prose can be stale. A mismatch
between prose and implementation is not a code bug by itself; prove the
implementation is wrong with non-prose evidence such as failing or missing
behavioral coverage, a violated external standard, a schema or wire contract,
runtime behavior, public API usage, or history showing an unintended code
regression. If implementation and tests agree while prose disagrees, route the
finding to documentation instead of changing code.

## Steps

1. Identify the changed files or requested review scope. Include README,
   docs, examples, and other prose files in this inventory; do not filter the
   changed-file list to source-code extensions.
2. Read `references/findings-format.md` before producing review output.
3. Inspect behavior, tests, compatibility, security, docs, and maintenance risk before style preferences.
4. First identify high-risk review leads, especially deletions, cross-boundary drift, silent behavior changes, changed contracts, unhandled sibling cases, and error-path changes. Then verify concrete findings instead of reviewing every line uniformly.
5. Prefer precision over recall. Do not report plausible concerns unless they survive attempts to disprove them and are grounded in changed code, concrete evidence, supported usage, correct ownership, and credible user, compatibility, security, maintenance, or test risk.
6. When a candidate depends on prose contradicting code, first disprove the implementation with non-prose evidence. If the code, tests, helper names, commit history, or runtime behavior support the implementation, do not report a code finding; use `$doc-standards`, `$doc-gaps-audit`, or `$doc-gaps-fix` for the stale prose.
7. If any changed path from step 1 is a README, user-facing doc, example, or command/config doc, you MUST apply `$doc-standards` to that file as part of this review; this is not optional based on scope size. Also use `$doc-standards` for public API comments, docstrings, or changed behavior that may make nearby existing documentation stale. Keep review scope to the current change and directly affected nearby docs unless the user explicitly asks for `$doc-gaps-fix` or a broader documentation audit.
8. Pair with relevant language standards (`$go-standards`, `$ruby-standards`, `$shell-standards`) when reviewing language-specific code, APIs, docs, tests, or tooling behavior. Pair with `$naming-standards` when names create concrete ambiguity, misuse risk, public contract confusion, inconsistent vocabulary, or maintenance cost. Treat idiomatic style concerns as findings only when they create concrete readability, maintenance, correctness, compatibility, or public API risk; use `$style-review` instead for non-blocking polish when the user asks for style nits or a readability pass.
9. Use `$testing-standards` when judging whether tests are missing, weak, overfit to internals, hard to read, cryptic, or at the wrong layer.
10. Route dependency, tool, framework, and upstream-library defects to the owner
    of the fix before recording a local finding.
11. Treat unnecessary abstraction as a code-review finding only when it creates
    concrete maintenance, compatibility, correctness, or public API risk. A
    one-line helper or wrapper is not a finding by itself; it becomes a finding
    when it obscures behavior, spreads a misleading concept, freezes a bad API,
    duplicates an existing local abstraction, or makes future changes riskier
    without adding domain clarity or boundary ownership.
12. If the review scope includes security-sensitive code, configuration, dependencies, shell execution, filesystem writes/deletes, network/auth/TLS behavior, secrets/env handling, Docker helpers, or CI/security tooling, consult `$security-audit` and the smallest matching security reference; keep this skill's findings format.
13. Verify claims against concrete file and line references whenever possible.
14. For standalone output, use `references/findings-format.md`; when embedded,
    preserve findings, open questions, testing gaps, and summary facts in the
    caller's format.

## References

- Read `references/findings-format.md` for review priorities, output format, and what to say when no issues are found.
- Use `$doc-standards` for documentation quality, stale-doc, public API comment, README, example, command, and configuration documentation judgment.
- Use relevant language standards for idiomatic code, API, docs, test, and tooling conventions.
- Use `$style-review` for non-blocking style, readability, consistency, idiom, or cleanup suggestions that do not rise to code-review findings.
