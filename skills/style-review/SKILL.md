---
name: style-review
description: Use when the user asks for style nits, polish, readability review, cleanup suggestions, non-blocking review comments, idiomatic cleanup, or a softer pass after code-review. Review code, tests, docs-adjacent comments, scripts, and diffs for non-blocking style polish, readability, local consistency, idiom, small simplifications, naming polish, and maintainability cleanup suggestions; do not use for bugs, security issues, compatibility breaks, or missing test/doc findings.
---

# Style Review

## Operating Stance

Operate as a non-blocking polish reviewer: prefer local consistency and
readability over personal taste, and never present style notes as correctness,
security, compatibility, testing, or documentation findings.

## Steps

1. Identify the changed files or requested style-review scope.
2. Inspect nearby code, tests, docs, scripts, and project conventions before
   suggesting style changes.
3. Pair with relevant language standards (`$go-standards`, `$ruby-standards`,
   `$shell-standards`) for language-specific idiom. Pair with
   `$naming-standards` when a style note depends on name clarity, vocabulary, or
   consistency.
4. Keep this skill limited to non-blocking polish: readability, structure,
   local consistency, unnecessary cleverness, small simplifications, comment
   clarity, naming polish, assertion clarity, fixture readability, and idiom.
5. Suggest inlining one-line helpers, wrappers, functions, methods, modules, or
   shell functions when they merely restate their only call. Do not suggest
   inlining when the abstraction names a real domain concept, centralizes a
   boundary, preserves compatibility, hides non-obvious error/lifecycle
   semantics, removes repeated tricky logic, or matches an established local
   pattern.
6. Do not report bugs, regressions, security risks, compatibility breaks,
   missing tests, missing docs, or broken public contracts as style notes.
   Recommend `$code-review`, `$security-audit`, `$test-gaps`, or `$doc-gaps`
   instead when those are the real issue.
7. Treat GoDoc link syntax, comment wording, and local readability as style
   notes only when the existing documentation is accurate enough. If the note
   would add, remove, or materially change public API behavior, safety
   constraints, panic/error behavior, lifecycle semantics, defaults, or
   operational guidance, route it to `$doc-gaps` or `$code-review` instead.
8. Prefer concrete suggestions over taste. Each note should explain why the
   change would make the code easier to read, maintain, or align with local
   patterns.
9. Do not create or update a code-issue ledger; style notes are not ledger findings.
10. For standalone output, use `references/output-format.md`.
11. When another skill embeds style notes, preserve the non-blocking nature,
   file references, suggestions, and rationale in the caller's output format.

## References

- Read `references/output-format.md` before producing standalone style-review
  output.
- Use relevant language standards for language-specific readability, idiom, and
  local convention checks.
- Use `$naming-standards` when names create unclear or inconsistent style.
- Use `$code-review` instead when a concern has correctness, compatibility,
  maintenance-risk, security, documentation, or testing impact strong enough to
  be a finding.
