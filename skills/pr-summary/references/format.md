# Summary Format

Use this reference when the user asks for a PR or wants a shareable change summary.

## Scope

- Treat PR output as task output, not optional polish.
- Use current working-tree changes as the default summary source.
- If the working tree is clean, summarize the latest commit.
- Include committed work only when the user explicitly asks for a range or when those commits are relevant to the requested result.
- Use this reference as the default style for commit messages and PR summaries only when repository-local guidance does not define a different house style.

## Required Format

- When the user asks for a commit message and PR summary, use exactly this structure and do not add, remove, rename, or reorder sections:

```markdown
commit message subject

## What

- Describe the concrete change.

## Why

- Describe why the change was made.

## Testing

- `command` - passed
```

- When the user asks only for a commit message, output only the commit message subject.
- When the user asks only for a PR summary, output only the `## What`, `## Why`, and `## Testing` sections from the template.
- Keep the commit message as plain text only.
- Keep the commit message entirely lowercase.
- Do not add markdown, labels, bullets, quotes, or surrounding commentary to the commit message.
- Do not add extra PR summary sections or alternate titles.
- When another skill requires a footer, append it after `## Testing`; footers are allowed and are not sections.
- If a PR summary section has no entries, write exactly `- None.`
- Keep the testing section honest about what ran, what passed, and what did not run.
- Include unresolved review findings, security findings, or validation gaps from caller workflows under `## Why` or `## Testing`; do not add a separate risk section.

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
