---
name: review-pr
description: Commits the current change, force-pushes the branch, and opens a draft pull request by using pr-summary output with the repository review make target. Use when the user asks to prepare a PR for review, open a draft PR, run the review flow, or create a review PR from local changes.
---

# Review PR

## Steps

1. Inspect the changed paths from the working tree first; if the working tree is clean, inspect the latest commit.
2. Use `$change-validation` to select and run credible validation before `make review`.
3. If the changed paths include Go code, Go tests, Go modules, Go docs, or Go tooling behavior, also use `$go-standards`.
4. If the changed paths include Ruby code, Ruby tests/features, Gemfiles, RuboCop config, Ruby docs, or Ruby tooling behavior, also use `$ruby-standards`.
5. If the changed paths include shell scripts, Bash helpers, ShellCheck config/directives, shell docs, or script behavior, also use `$shell-standards`.
6. Use `$pr-summary` to draft a lowercase commit message and Markdown PR summary from the current working tree.
7. Keep the commit message plain text and lowercase.
8. Pass only the unprefixed subject as `msg`; `make review` adds the branch-derived `type(scope):` prefix.
9. Treat the current branch as routing metadata, not `msg` source material.
10. Build a short exclusion list from every meaningful branch-path segment, including type, scope/name segments, and the hyphen- or slash-separated words inside those segments.
11. Do not repeat any branch-derived word in `msg` unless omitting it would make the subject misleading or ambiguous.
12. Before running `make review`, compare `msg` with the exclusion list and rewrite it if a branch-derived word can be replaced by a more concrete behavior from the diff.
13. Keep the summary in the `$pr-summary` format, including honest testing details.
14. When attribution is appropriate or requested, append this footer to the summary instead of a `Co-authored-by:` trailer:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
```

15. Run the review target with the drafted values:

```bash
make msg="unprefixed subject" desc="summary" review
```

16. Pass `desc` as the multiline Markdown summary from `$pr-summary`; do not flatten the summary into a single line.
17. Report the commit message, validation results, whether the review target succeeded, and any command failure that needs user action.

## Notes

- The `review` target commits, force-pushes the current branch, and opens a draft PR.
- Do not claim the PR exists if `make review` fails before the draft step.
- Do not claim unrun checks passed.
