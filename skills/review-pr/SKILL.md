---
name: review-pr
description: Commits the current change, force-pushes the branch, and opens a draft pull request by using pr-summary output with the repository review make target. Use when the user asks to prepare a PR for review, open a draft PR, run the review flow, or create a review PR from local changes.
---

# Review PR

## Steps

1. Use `$pr-summary` first to draft a lowercase commit message and Markdown PR summary from the current working tree.
2. Keep the commit message plain text and lowercase.
3. Pass only the unprefixed subject as `msg`; `make review` adds the branch-derived `type(scope):` prefix.
4. Avoid repeating branch-derived type, scope, or name words in `msg` unless they are essential to the meaning.
5. Keep the summary in the `$pr-summary` format, including honest testing details.
6. When attribution is appropriate or requested, append this footer to the summary instead of a `Co-authored-by:` trailer:

```text
AI-assisted-by: [Codex](https://openai.com/codex/)
```

7. Run the review target with the drafted values:

```bash
make msg="unprefixed subject" desc="summary" review
```

8. Pass `desc` as the multiline Markdown summary from `$pr-summary`; do not flatten the summary into a single line.
9. Report the commit message, whether the review target succeeded, and any command failure that needs user action.

## Notes

- The `review` target commits, force-pushes the current branch, and opens a draft PR.
- Do not claim the PR exists if `make review` fails before the draft step.
- Do not claim unrun checks passed.
