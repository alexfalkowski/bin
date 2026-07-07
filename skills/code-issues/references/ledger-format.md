# `ISSUES.md` Format

Each entry is a short, debatable mini-RFC: skimmable at the top, with just
enough reasoning and alternatives for a reviewer to agree or push back. Keep the
**required core** on every entry. Add the **expandable sections** only when the
entry warrants them; do not pad a trivial fix.

## Required Core

Use this structure for every entry:

````markdown
# Issues

## ISSUE-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Code Issue |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | User-visible impact or violated contract. |

**Summary.** One or two sentences a reviewer can read on their own: what breaks
and why it matters.

### Context
Current behavior, where it happens, who hits it, and the contract or expectation
it violates. Enough background for someone new to the code to follow the rest.

### Evidence
Evidence: Concrete file and line references, command output, or code path.
Reproduction: Smallest supported command, test, API call, workflow, or
code-path trace that reproduces the bug or contract violation.

### Proposal
The recommended fix: the smallest safe change using existing local patterns, and
the direction it takes.

### Alternatives Considered
- Chosen: the proposal above — why it is the safest, smallest fix.
- Other option: an alternative fix, workaround, or wider refactor — why not.
- Do nothing: the cost of leaving the bug in place.

### Definition of Success
- Observable result that proves the bug is gone (for example, the previously
  failing case now passes) and the validation command(s) that show it.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
### Goals / Non-goals
- Goal: what the fix must achieve.
- Non-goal: what it deliberately does not change (bounds an easy-to-overshoot fix).

### Open Questions
- A decision that needs the human before or during the fix.

### Decision
> Accepted 2026-07-07 — chose <option> because <reason>.
````

## Status And Lifecycle

`Status` is a lightweight hint for where the entry stands in the current
conversation, not a durable record:

- `Proposed`: recorded in Find mode, not yet agreed.
- `Accepted`: the human agreed to the proposal at the agreement gate.
- `In progress`: the agreed fix is being implemented.
- `Rejected`: ruled out but kept for context.

The `### Decision` line is an optional one-line record of the agreement-gate
outcome, not a permanent log. Per the shared gap workflow, remove the entry once
the fix is confirmed done and delete the ledger once every entry is resolved.

Keep optional follow-up notes separate from findings:

```markdown
## Optional Issue Follow-Ups

- Optional or non-blocking note.
```
