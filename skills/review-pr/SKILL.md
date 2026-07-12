---
name: review-pr
description: >-
  Use when, and only when, the user invokes $review-pr or explicitly asks to
  prepare, open, update, or run a review PR from local changes. A bare
  current-request invocation runs the full workflow: review, validate, commit,
  force-push, and open a draft pull request with the repository review target.
---

# Review PR

A bare `$review-pr` invocation is an explicit current-request instruction to
run the full workflow for the current repository: review and validate local
changes, commit them, force-push the branch, and open a draft pull request. It
does not require an `in SCOPE` suffix. If an existing PR or draft description
would be updated, ask before replacing it; future changes do not carry forward
permission to push again.

Before executing this workflow, read `references/plan.md` and use it to maintain
the active execution plan. The active plan is runtime state; do not write it
into the repository unless the human explicitly asks for a durable plan file.
Use runtime goals only when explicitly authorized; otherwise keep permission,
validation, review, PR drafting, and remote-write state in the active plan.

## Steps

Follow `references/plan.md#execution-plan`.

These rules remain mandatory:

- Confirm that the current request contains `$review-pr` or an equivalent explicit request to commit, push, update, or open a review PR. If not, do not run `make review`, `make push`, or any equivalent push/PR update command.
- If new changes would make an existing PR description, review comment, or previously drafted summary obsolete, flag that and ask whether the user wants the PR updated before pushing anything.
- Make the remote-write behavior of `make review` explicit before running it: the target commits, force-pushes, and opens a draft PR.
- Use `$change-validation`, relevant language standards, `$doc-standards`, and
  `$code-review` as directed by the execution plan before `make review`; use
  `$style-review` only when the user explicitly asks for non-blocking polish.
- Resolve any blocking review findings before continuing. Do not run
  `make review` while blocking findings remain unless the human explicitly says
  to open a draft PR with those findings unresolved; in that case, call them out
  in the PR summary.
- If `$code-review` reports security findings or security validation gaps, resolve them or document them in the PR summary before `make review`.
- Treat `$style-review` notes as non-blocking unless the user explicitly asks to resolve them before opening the PR.
- Draft the `msg` and `desc` from `references/summary-format.md`. Keep `msg`
  lowercase and unprefixed because `make review` adds the branch-derived
  `type(scope):` prefix; do not flatten the multiline Markdown `desc`.
- Do not hard-wrap `msg` or `desc` content to a fixed column width (for example
  ~80 characters). Write each subject line, bullet, and paragraph as a single
  logical line and let GitHub soft-wrap it; insert line breaks only where a real
  break belongs, between bullets, list items, or paragraphs. This governs the PR
  and commit text you generate, not this repository's own Markdown files.
- When attribution is appropriate or requested, append an `AI-assisted-by:`
  footer to the summary instead of a `Co-authored-by:` trailer. Name the
  assistant that actually did the work and link to its home page. Use the entry
  that matches the running tool:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
AI-assisted-by: [Claude Code](https://claude.com/claude-code)
```

- Create the temporary `desc_file` yourself; never ask the user to provide its
  path or populate it. Run this portable command and capture the returned path:

```bash
mktemp "${TMPDIR:-/tmp}/review-pr.XXXXXX"
```

- Write the multiline Markdown `desc` to that file, then substitute the returned
  path directly into the review command so the guarded Make target remains the
  command prefix:

```bash
make review msg="unprefixed subject" desc_file="/returned/path/review-pr.ABC123"
```

- Remove the temporary file after `make review`, including when the review
  command fails. Use a direct `rm -f -- /returned/path/review-pr.ABC123`
  invocation after substituting the captured path; do not wrap cleanup in
  `zsh -lic`, `sh -c`, or another shell command because the shared Codex rule
  allows direct non-recursive `rm -f` only. Do not flatten the summary into a
  single line or pass Markdown through a quoted shell argument.
- Read `references/output-format.md`, then report the result using that exact
  structure.

## References

- Read `references/plan.md` before executing the review PR workflow.
- Read `references/summary-format.md` before drafting the `msg` value and PR summary content.
- Read `references/output-format.md` before producing the final review PR report.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before validation and `make review`.
- Use `$doc-standards` for review-time documentation judgment; use `$doc-gaps`
  only when the user explicitly asks for a scoped documentation gap pass.
- Use `$style-review` only when the user explicitly asks for non-blocking polish before the PR.

## Notes

- Future changes do not imply permission to push again. Ask the user before updating an existing PR or replacing an existing PR description/comment.
- Do not claim a PR exists unless the review target output confirms it.
- Do not claim unrun checks passed.
