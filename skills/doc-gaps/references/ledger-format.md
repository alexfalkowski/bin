# Candidate And `DOCS.md` Format

Each review candidate and each unresolved or audit-only ledger entry is a short,
debatable mini-RFC: skimmable at the top, with just enough reasoning and
alternatives for a reviewer to agree or push back. Keep the **required core** on
every entry. Add the **expandable sections** only when the entry warrants them;
do not pad a trivial gap.

## Required Core

Use this structure for every entry:

````markdown
# Docs

## DOC-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Doc Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Public surface | Command \| API \| package \| service \| configuration \| example \| file format \| operator behavior. |
| Audience | Service author \| Operator \| Package consumer \| Maintainer |
| User action at risk | Concrete action or decision the reader cannot safely complete from current docs. |
| Impact | Risk created by the missing, weak, stale, misleading, or wrong-location documentation. |

**Summary.** One or two sentences a reviewer can read on their own: the action a
reader cannot safely complete today and why.

### Context
The reader action, the current documentation surface (or "missing"), and which
contract is missing: behavior/purpose; error/panic/nil/empty/zero-value; side
effect/lifecycle/cleanup; concurrency/cache/retry/timeout/cancellation/
idempotency; config default/limit/validation/fallback; security/operations/
compatibility/data-loss; or alias/wrapper/re-export/dependency boundary.

### Evidence
Evidence: Concrete file and line references, command/API behavior, existing
docs, examples, or comment/docstring gap.
Reproduction: Smallest reader action, command/API lookup, example attempt,
documentation search, or authoritative surface comparison that reproduces the
documentation gap.

### Proposal
The recommended documentation: the target surface (README / docs / example /
command help / package docs / API comment / code comment / docstring) and the
smallest successful usage path it should support, using the established
documentation location and style.

### Alternatives Considered
- Chosen: the target surface above — why it is where the reader looks.
- Other surface: a different documentation location — why not.
- Do nothing: the risk of leaving the reader without the contract.

### Definition of Success
- The reader can complete the action from the documented surface (any example
  or command runs as written) plus the validation command(s) that show it.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
### Goals / Non-goals
- Goal: which reader action the documentation must support.
- Non-goal: surfaces or audiences this deliberately does not document.

### Open Questions
- A documentation-location or scope decision that needs the human.

### Decision
> Accepted 2026-07-07 — chose <option> because <reason>.
````

## Status And Lifecycle

`Status` is a lightweight hint for where the entry stands in the current
conversation, not a durable record: `Proposed` when first recorded, `Accepted`
after the human agrees, `In progress` while implementing, and `Rejected` for an
entry ruled out but kept for context. The `### Decision` line is an optional
one-line record of the agreement-gate outcome. Per the shared gap workflow,
remove the entry once the fix is confirmed done and delete the ledger once every
entry is resolved.

Keep optional follow-up notes separate from findings:

```markdown
## Optional Doc Follow-Ups

- Optional or non-blocking note.
```
