# Candidate And `DOCS.md` Format

Use this structure for review candidates and unresolved or audit-only ledger
entries:

````markdown
# Docs

## DOC-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Doc Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Public surface | Command \| API \| package \| service \| configuration \| example \| file format \| operator behavior. |
| Audience | Service author \| Operator \| Package consumer \| Maintainer |
| User action at risk | Concrete action or decision the reader cannot safely complete from current docs. |
| Impact | Risk created by the missing, weak, stale, misleading, or wrong-location documentation. |

### Documentation Map

```text
current surface: Existing README/docs/examples/command help/package docs/API comments/code comments coverage, or "missing".
target surface: README|docs|example|command help|package docs|API comment|code comment|docstring.
minimum example or command: Smallest successful usage path the documentation should support, or "none" when not applicable.
adequacy failure: Missing, weak, stale, misleading, wrong-location, not discoverable, non-executable example, or "none" for dismissed candidates.
missing contract: Behavior/purpose|error/panic/nil/empty/zero-value|side effect/lifecycle/cleanup|concurrency/cache/retry/timeout/cancellation/idempotency|config default/limit/validation/fallback|security/operations/compatibility/data-loss|alias/wrapper/re-export/dependency boundary|none.
```

### Evidence

```text
Evidence: Concrete file and line references, command/API behavior, existing
docs, examples, or comment/docstring gap.
Reproduction: Smallest reader action, command/API lookup, example attempt,
documentation search, or authoritative surface comparison that reproduces the
documentation gap.
```

### Decision Trace

```text
reader action
  -> current documentation surface
  -> missing or misleading contract
  -> target documentation surface
  -> validation that proves the fix
```

### Proposed Change

```yaml
proposed_fix: Brief documentation direction using the established documentation location and style.
validation:
  - Suggested checks for the documentation change.
```
````

Keep optional follow-up notes separate from findings:

```markdown
## Optional Doc Follow-Ups

- Optional or non-blocking note.
```
