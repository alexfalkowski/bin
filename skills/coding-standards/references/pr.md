# PR Reference

Use this reference when the user asks for a PR or wants a shareable change summary.

## Scope

- Treat PR output as task output, not optional polish.
- Check whether repository-local instructions define a house style before applying a shared default.
- Include both relevant committed work and current working-tree changes when both are part of the requested result.

## Shared Default

- Provide the commit message first, on its own line, when the user asks for one.
- Keep the commit message plain text and easy to reuse.
- When repository-local guidance does not say otherwise, organize the PR summary around `What`, `Why`, and `Testing`.
- Keep the testing section honest about what ran, what passed, and what did not run.

## Validation Notes

- Include the actual commands run when they materially help the reader understand the verification.
- If validation was intentionally scoped, say so plainly.
- Do not imply that unrun or failing checks passed.
