---
name: style-review
description: Reviews code, tests, docs-adjacent comments, scripts, and diffs for non-blocking style polish, readability, local consistency, idiom, small simplifications, naming polish, and maintainability cleanup suggestions. Use when the user asks for style nits, polish, readability review, cleanup suggestions, non-blocking review comments, idiomatic cleanup, or a softer pass after code-review; do not use for bugs, security issues, compatibility breaks, or missing test/doc findings.
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
5. Do not report bugs, regressions, security risks, compatibility breaks,
   missing tests, missing docs, or broken public contracts as style notes.
   Recommend `$code-review`, `$security-audit`, `$test-gaps`, or `$doc-gaps`
   instead when those are the real issue.
6. Treat GoDoc link syntax, comment wording, and local readability as style
   notes only when the existing documentation is accurate enough. If the note
   would add, remove, or materially change public API behavior, safety
   constraints, panic/error behavior, lifecycle semantics, defaults, or
   operational guidance, route it to `$doc-gaps` or `$code-review` instead.
7. Prefer concrete suggestions over taste. Each note should explain why the
   change would make the code easier to read, maintain, or align with local
   patterns.
8. Do not create or update `ISSUES.md`; style notes are not ledger findings.
9. When style-review is the final response, use the exact structure below; do
   not add, remove, rename, or reorder sections.
10. When another skill embeds style notes, preserve the non-blocking nature,
   file references, suggestions, and rationale in the caller's output format.

## Output Format

Use exactly this Markdown structure:

```markdown
## Style Notes

- path/to/file:line - Non-blocking note title.
  Why: Explain the readability, consistency, idiom, or maintenance benefit.
  Suggestion: Describe the smallest clear polish change.

## Optional Cleanups

- Optional cleanup that is not worth blocking the change.
```

Use `- None.` for any empty section. Keep notes short and explicitly
non-blocking. If a concern would be worth blocking a change, it belongs in
another review skill instead.

## References

- Use relevant language standards for language-specific readability, idiom, and
  local convention checks.
- Use `$naming-standards` when names create unclear or inconsistent style.
- Use `$code-review` instead when a concern has correctness, compatibility,
  maintenance-risk, security, documentation, or testing impact strong enough to
  be a finding.
