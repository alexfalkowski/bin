# PR Reference

Use this reference when the user asks for a PR or wants a shareable change summary.

## Scope

- Treat PR output as task output, not optional polish.
- Include both relevant committed work and current working-tree changes when both are part of the requested result.
- Use this reference as the house style for commit messages and PR summaries.

## Required Format

- Provide the commit message first, on its own line, when the user asks for one.
- Keep the commit message as plain text only.
- Keep the commit message entirely lowercase.
- Do not add markdown, labels, bullets, quotes, or surrounding commentary to the commit message.
- Write the PR summary in Markdown.
- Use exactly these section titles for the PR summary: `What`, `Why`, and `Testing`.
- Do not add extra sections or alternate titles.
- Keep the testing section honest about what ran, what passed, and what did not run.

## Validation Notes

- Include the actual commands run when they materially help the reader understand the verification.
- If validation was intentionally scoped, say so plainly.
- Do not imply that unrun or failing checks passed.
