---
name: review-pr
description: Reviews, validates, commits, force-pushes, and opens a draft pull request with the repository review target. Use only when the user explicitly asks to prepare, open, update, or run a review PR from local changes.
---

# Review PR

Before executing this workflow, read `references/plan.md` and use it to maintain
the active execution plan. The active plan is runtime state; do not write it
into the repository unless the human explicitly asks for a durable plan file.
When the runtime supports goals, bind this workflow to one active goal for the
review PR outcome and update that goal as permission, validation, review, PR
drafting, or remote-write state changes.

## Steps

Follow `references/plan.md#execution-plan`.

These rules remain mandatory:

- Confirm the user explicitly asked in the current request to commit, push, update, or open a review PR. If not, do not run `make review`, `make push`, or any equivalent push/PR update command.
- If new changes would make an existing PR description, review comment, or previously drafted summary obsolete, flag that and ask whether the user wants the PR updated before pushing anything.
- Make the remote-write behavior of `make review` explicit before running it: the target commits, force-pushes, and opens a draft PR.
- Use `$change-validation` to select and run credible validation for the full change before `make review`; language-specific standards may refine that validation.
- Use the relevant language standards for changed Go, Ruby, shell, and test paths.
- Use `$doc-standards` for changed README files, user-facing docs, examples, command/config docs, public API comments, docstrings, or behavior changes that may make nearby existing documentation stale.
- Use `$code-review` to inspect the current change before drafting PR text.
- If the user explicitly asks for style nits, polish, readability review, or non-blocking cleanup comments before the PR, also use `$style-review` after the code-review pass.
- Resolve any blocking review findings before continuing. Do not run `make review` while blocking findings remain unless the human explicitly says to open a draft PR with those findings unresolved; in that case, call them out in the PR summary.
- If `$code-review` reports security findings or security validation gaps, resolve them or document them in the PR summary before `make review`.
- Treat `$style-review` notes as non-blocking unless the user explicitly asks to resolve them before opening the PR.
- Read `references/summary-format.md`, then draft a lowercase, unprefixed `msg` and multiline Markdown `desc` from the current working tree.
- Follow the commit-subject rules: `make review` adds the branch-derived `type(scope):` prefix, so treat branch words as routing metadata rather than message source material and do not repeat the type or scope in `msg`.
- Keep `desc` in the summary format, including honest testing details.
- When attribution is appropriate or requested, append this footer to the summary instead of a `Co-authored-by:` trailer:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
```

- Write the multiline Markdown `desc` to a temporary file with `mktemp`, then run the review target with the drafted subject and file path:

```bash
make msg="unprefixed subject" desc_file="$desc_file" review
```

- Pass `desc_file` as the path to the multiline Markdown summary; do not flatten the summary into a single line or pass Markdown through a quoted shell argument.
- Read `references/output-format.md`, then report the result using that exact structure; do not add, remove, rename, or reorder sections.

## References

- Read `references/plan.md` before executing the review PR workflow.
- Read `references/summary-format.md` before drafting the `msg` value and PR summary content.
- Read `references/output-format.md` before producing the final review PR report.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before validation and `make review`.
- Use `$doc-standards` for review-time documentation judgment; use `$doc-gaps` only when the user explicitly asks for a scoped documentation audit.
- Use `$style-review` only when the user explicitly asks for non-blocking polish before the PR.

## Notes

- The `review` target commits, force-pushes the current branch, and opens a draft PR.
- Future changes do not imply permission to push again. Ask the user before updating an existing PR or replacing an existing PR description/comment.
- Do not claim a PR exists unless the review target output confirms it.
- Do not claim unrun checks passed.
