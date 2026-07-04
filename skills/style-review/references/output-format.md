# Style Review Output

Use exactly this Markdown structure for standalone `$style-review` output:

```markdown
## Style Notes

- path/to/file:line - Non-blocking note title.
  Why: Explain the readability, consistency, idiom, or maintenance benefit.
  Suggestion: Describe the smallest clear polish change.

## Optional Cleanups

- Optional cleanup that is not worth blocking the change.
```

Use `- None.` for empty sections. Keep notes short and explicitly non-blocking.
If a concern would block a change, route it to another review skill.
