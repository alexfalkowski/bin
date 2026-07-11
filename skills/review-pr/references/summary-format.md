# Summary Format

Use this reference when drafting the `msg` value and PR summary content for `make review`.

## Scope

- Treat PR output as task output, not optional polish.
- Use current working-tree changes as the default summary source.
- If the working tree is clean, summarize the latest commit.
- Include committed work only when the user explicitly asks for a range or when those commits are relevant to the requested result.
- Use this reference as the default style for commit messages and PR summaries only when repository-local guidance does not define a different house style.

## Required Format

- Draft `msg` as a plain-text, lowercase, unprefixed commit message subject.
- Draft `desc` as exactly these Markdown sections and do not add, remove, rename, or reorder sections:

```markdown
## What

- Describe what changed in terms of behavior, documentation, commands, configuration, or public/reviewer-visible outcomes.
- Mention the context the code cannot fully tell the reviewer, such as scope, intentional boundaries, compatibility notes, non-goals, or user-facing effect.
- Avoid implementation mechanics unless they are the observable change.

## Why

- Explain why the PR matters: the problem, risk, workflow gap, maintenance benefit, or user value it addresses.
- Make this the selling point of the PR.
- Do not repeat the What section or rely on the diff to imply motivation.

## Testing

- `command` - passed
- Mention new or changed tests and what behavior, edge case, or risk they cover.
- Mention expected CI coverage only as additional verification, not as a replacement for unrun local checks.
- Call out validation gaps, manual verification still needed, or intentionally scoped testing.
```

- Do not add markdown, labels, bullets, quotes, or surrounding commentary to `msg`.
- Do not add extra PR summary sections or alternate titles to `desc`.
- Do not hard-wrap `msg` or `desc` content to a fixed line width (for example ~80 characters); write each subject, bullet, and paragraph as one logical line and let GitHub soft-wrap it. Insert line breaks only where a real break belongs, between bullets, list items, or paragraphs.
- When a footer is needed, append it after `## Testing`; footers are allowed and are not sections.
- If a PR summary section has no entries, write exactly `- None.`
- Keep the testing section honest about what ran, what passed, and what did not run.
- Include unresolved review findings, security findings, or validation gaps under `## Why` or `## Testing`; do not add a separate risk section.

## Commit Message Subject

- Check whether the local commit workflow adds a conventional-commit prefix from the current branch.
- In repositories using this shared `bin` workflow, `build/make/git.mak` derives `type(scope):` from branches shaped like `user/type/scope` and prepends it in `make commit`, `make review`, and related targets.
- When the workflow prepends a branch-derived prefix, output only the unprefixed subject intended for `msg`; do not include a conventional prefix such as `feat(scope):`.
- Treat the current branch as routing metadata, not summary source material.
- Do not repeat the branch-derived conventional-commit type or scope in `msg`; the final commit subject will already include them in `type(scope):`.
- Before returning the subject, compare it with the branch type, scope/name segments, and hyphen- or slash-separated words inside those segments; rewrite it if a branch word appears in `msg`.
- Prefer the concrete behavioral change over branch wording. For example, on `user/feat/skills`, use `avoid duplicate commit subject wording`, not `feat(skills): update skills pr summary`.
- If the scope word is the obvious domain noun, still avoid restating it when a more specific object is available from the diff. For example, on `user/docs/location`, use `clarify metadata diagnostics`, not `clarify location metadata diagnostics`.

## Validation Notes

- Include the actual commands run when they materially help the reader understand the verification.
- If validation was intentionally scoped, say so plainly.
- Do not imply that unrun or failing checks passed.
