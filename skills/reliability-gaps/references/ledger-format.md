# `RELIABILITY.md` Format

Use this structure:

````markdown
# Reliability

## REL-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Reliability Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | User, operator, incident, availability, recovery, data-integrity, or scaling risk. |

### Evidence

```text
Evidence: Concrete file and line references, command behavior, config, docs,
tests, missing control, failure mode, calculation gap, and the verification path
used to rule out a guess.
Reproduction: Smallest supported trigger, workflow, config path, command, test,
trace, or operational scenario that reproduces the failure mode or proves the
missing reliability control.
```

### Decision Trace

```text
operational trigger
  -> failure mode or missing control
  -> user/operator/recovery risk
  -> smallest credible reliability fix
  -> validation that proves the control
```

### Proposed Change

```yaml
proposed_fix: Smallest credible reliability improvement using established local patterns.
validation:
  - Suggested checks for the reliability change.
```
````

Keep optional follow-up notes separate from findings:

```markdown
## Optional Reliability Follow-Ups

- Optional or non-blocking note.
```
