# `TESTS.md` Format

Use this structure:

````markdown
# Tests

## TEST-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Test Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | Risk created by the missing, weak, misleading, flaky, or wrong-layer coverage. |

### Evidence

```text
Evidence: Concrete file and line references, existing test behavior, command
output, or untested code path.
Reproduction: Smallest supported command, scenario, test run, or front-door
trace that shows the behavior is unprotected, misleadingly covered, flaky, or
covered at the wrong layer.
```

### Decision Trace

```text
repository-owned behavior
  -> current test surface
  -> uncovered or misleading path
  -> narrowest established test layer
  -> validation that proves the coverage
```

### Proposed Change

```yaml
proposed_fix: Brief test or test-harness direction using the narrowest credible established test layer.
validation:
  - Suggested checks for the test change.
```
````

Keep optional follow-up notes separate from findings:

```markdown
## Optional Test Follow-Ups

- Optional or non-blocking note.
```
