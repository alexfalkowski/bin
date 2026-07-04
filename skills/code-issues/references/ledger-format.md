# `ISSUES.md` Format

Use this structure:

````markdown
# Issues

## ISSUE-1: Short concrete title

| Field | Value |
| --- | --- |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | User-visible impact or violated contract. |

### Evidence

```text
Evidence: Concrete file and line references, command output, or code path.
Reproduction: Smallest supported command, test, API call, workflow, or
code-path trace that reproduces the bug or contract violation.
```

### Decision Trace

```text
supported entrypoint
  -> observed behavior
  -> violated contract or user-visible failure
  -> smallest safe fix
  -> validation that proves the fix
```

### Proposed Change

```yaml
proposed_fix: Brief implementation direction.
validation:
  - Suggested checks for the fix.
```
````

Keep optional follow-up notes separate from findings:

```markdown
## Testing Gaps And Follow-Ups

- Optional or non-blocking note.
```
