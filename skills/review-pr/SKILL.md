---
name: review-pr
description: Reviews, validates, commits, force-pushes, and opens a draft pull request with the repository review target. Use only when the user explicitly asks to prepare, open, update, or run a review PR from local changes.
---

# Review PR

## Steps

1. Inspect the changed paths from the working tree first; if the working tree is clean, inspect the latest commit.
2. Confirm the user explicitly asked in the current request to commit, push, update, or open a review PR. If not, do not run `make review`, `make push`, or any equivalent push/PR update command.
3. If new changes would make an existing PR description, review comment, or previously drafted summary obsolete, flag that and ask whether the user wants the PR updated before pushing anything.
4. Use `$project-workflow` before validation or `make review` so repository entrypoints, CI expectations, and `./bin` wiring are discovered first.
5. Make the remote-write behavior of `make review` explicit before running it: the target commits, force-pushes, and opens a draft PR.
6. Use `$change-validation` to select and run credible validation for the full change before `make review`; language-specific standards may refine that validation.
7. If the changed paths include Go code, Go tests, Go modules, Go docs, or Go tooling behavior, also use `$go-standards`.
8. If the changed paths include Ruby code, Ruby tests/features, Gemfiles, RuboCop config, Ruby docs, or Ruby tooling behavior, also use `$ruby-standards`.
9. If the changed paths include shell scripts, Bash helpers, ShellCheck config/directives, shell docs, or script behavior, also use `$shell-standards`.
10. If the changed paths include tests, test helpers, fixtures, or changes that raise test coverage or test-design questions, also use `$testing-standards`.
11. Use `$code-review` to inspect the current change before drafting PR text.
12. If the user explicitly asks for style nits, polish, readability review, or non-blocking cleanup comments before the PR, also use `$style-review` after the code-review pass.
13. Resolve any blocking review findings before continuing. Do not run `make review` while blocking findings remain unless the human explicitly says to open a draft PR with those findings unresolved; in that case, call them out in the PR summary.
14. If `$code-review` reports security findings or security validation gaps, resolve them or document them in the PR summary before `make review`.
15. Treat `$style-review` notes as non-blocking unless the user explicitly asks to resolve them before opening the PR.
16. Read `references/summary-format.md`, then draft a lowercase, unprefixed `msg` and multiline Markdown `desc` from the current working tree.
17. Follow the commit-subject rules: `make review` adds the branch-derived `type(scope):` prefix, so treat branch words as routing metadata rather than message source material and do not repeat the type or scope in `msg`.
18. Keep `desc` in the summary format, including honest testing details.
19. When attribution is appropriate or requested, append this footer to the summary instead of a `Co-authored-by:` trailer:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
```

20. Write the multiline Markdown `desc` to a temporary file with `mktemp`, then run the review target with the drafted subject and file path:

```bash
make msg="unprefixed subject" desc_file="$desc_file" review
```

21. Pass `desc_file` as the path to the multiline Markdown summary; do not flatten the summary into a single line or pass Markdown through a quoted shell argument.
22. Read `references/output-format.md`, then report the result using that exact structure; do not add, remove, rename, or reorder sections.

## References

- Read `references/summary-format.md` before drafting the `msg` value and PR summary content.
- Read `references/output-format.md` before producing the final review PR report.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before validation and `make review`.
- Use `$style-review` only when the user explicitly asks for non-blocking polish before the PR.

## Notes

- The `review` target commits, force-pushes the current branch, and opens a draft PR.
- Future changes do not imply permission to push again. Ask the user before updating an existing PR or replacing an existing PR description/comment.
- Do not claim a PR exists unless the review target output confirms it.
- Do not claim unrun checks passed.
