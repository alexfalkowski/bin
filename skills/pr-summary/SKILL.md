---
name: pr-summary
description: Drafts commit messages and pull request summaries from repository changes. Use when the user asks for a commit message, PR description, pull request body, changelog-style summary, release-note draft, or shareable summary of work and testing.
---

# PR Summary

## Steps

1. Inspect the working-tree changes first.
2. If the working tree is clean, inspect the latest commit instead.
3. Inspect the current branch and commit workflow before drafting a commit message.
4. Read `references/format.md` before drafting the output.
5. When the workflow adds a branch-derived prefix, draft `msg` from the diff or latest commit only; do not use branch words as source material.
6. Keep the commit message plain text and lowercase when the user asks for one.
7. Include what changed, why it changed, documentation/example updates or why none were needed, and honest testing details in the PR summary.
8. Include unresolved review or security findings from caller workflows in `## Why` or `## Testing`; do not add extra sections.
9. When the summary is the final response, use the exact structure in `references/format.md`; do not add, remove, rename, or reorder sections.
10. When another skill embeds this summary, provide the subject and Markdown body content in the caller's output format.
11. Do not claim unrun checks passed.

## References

- Read `references/format.md` for commit-message and PR-summary formatting.
