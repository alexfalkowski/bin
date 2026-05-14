# Summary Format

Use this reference when the user asks for a PR or wants a shareable change summary.

## Scope

- Treat PR output as task output, not optional polish.
- Use current working-tree changes as the default summary source.
- If the working tree is clean, summarize the latest commit.
- Include committed work only when the user explicitly asks for a range or when those commits are relevant to the requested result.
- Use this reference as the default style for commit messages and PR summaries only when repository-local guidance does not define a different house style.

## Required Format

- Provide the commit message first, on its own line, when the user asks for one.
- Keep the commit message as plain text only.
- Keep the commit message entirely lowercase.
- Do not add markdown, labels, bullets, quotes, or surrounding commentary to the commit message.
- Write the PR summary in Markdown.
- Use Markdown headings for the PR summary sections: `## What`, `## Why`, and `## Testing`.
- Do not use bold text as section labels, such as `**What**`.
- Do not add extra sections or alternate titles.
- Keep the testing section honest about what ran, what passed, and what did not run.

## Validation Notes

- Include the actual commands run when they materially help the reader understand the verification.
- If validation was intentionally scoped, say so plainly.
- Do not imply that unrun or failing checks passed.
