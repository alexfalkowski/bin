# Review PR Output Format

Use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Commit Message

unprefixed subject

## PR Summary

<multiline Markdown summary passed via desc_file>

## Validation

- command: `make lint`
  result: passed
  coverage: Ruby linting for changed files.

- gaps: None.

## Code Review

- result: no blocking findings

## Review Target

- command: `make msg="..." desc_file="..." review`
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
