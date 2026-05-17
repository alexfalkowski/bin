---
name: review-pr
description: Commits the current change, force-pushes the branch, and opens a draft pull request by reviewing the change before using pr-summary output with the repository review make target. Use when the user asks to prepare a PR for review, open a draft PR, run the review flow, or create a review PR from local changes.
---

# Review PR

## Steps

1. Inspect the changed paths from the working tree first; if the working tree is clean, inspect the latest commit.
2. Use `$change-validation` to select and run credible validation for the full change before `make review`; language-specific standards may refine that validation.
3. If the changed paths include Go code, Go tests, Go modules, Go docs, or Go tooling behavior, also use `$go-standards`.
4. If the changed paths include Ruby code, Ruby tests/features, Gemfiles, RuboCop config, Ruby docs, or Ruby tooling behavior, also use `$ruby-standards`.
5. If the changed paths include shell scripts, Bash helpers, ShellCheck config/directives, shell docs, or script behavior, also use `$shell-standards`.
6. Use `$code-review` to inspect the current change before drafting PR text.
7. Resolve any blocking review findings before continuing; if findings remain intentionally unresolved, call them out in the PR summary.
8. Use `$pr-summary` to draft a lowercase, unprefixed `msg` and Markdown PR summary from the current working tree.
9. Follow `$pr-summary` commit-subject rules: `make review` adds the branch-derived `type(scope):` prefix, so treat branch words as routing metadata rather than message source material.
10. Keep the summary in the `$pr-summary` format, including honest testing details.
11. When attribution is appropriate or requested, append this footer to the summary instead of a `Co-authored-by:` trailer:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
```

12. Run the review target with the drafted values:

```bash
make msg="unprefixed subject" desc="summary" review
```

13. Pass `desc` as the multiline Markdown summary from `$pr-summary`; do not flatten the summary into a single line.
14. Report the result using the exact structure in `Output Format`; do not add, remove, rename, or reorder sections.

## Output Format

Use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Commit Message

unprefixed subject

## PR Summary

<multiline Markdown summary passed as desc>

## Validation

- command: `make lint`
  result: passed
  coverage: Ruby linting for changed files.

- gaps: None.

## Code Review

- result: no blocking findings

## Review Target

- command: `make msg="..." desc="..." review`
  result: passed
  pr: https://github.com/org/repo/pull/123

## Notes

- None.
```

- In `Validation`, include one item per command plus a final `gaps` item.
- In `Code Review`, state whether there were no findings, blocking findings were resolved, or unresolved findings were documented in the PR summary.
- If a command was not run, write `not run` as the result and explain why in `coverage`.
- If `make review` fails before opening the PR, set `pr: unavailable`.
- If `make review` succeeds but the PR URL is not visible in the command output, set `pr: unavailable`.
- If there are no notes, write exactly `- None.`

## Notes

- The `review` target commits, force-pushes the current branch, and opens a draft PR.
- Do not claim a PR exists unless the review target output confirms it.
- Do not claim unrun checks passed.
