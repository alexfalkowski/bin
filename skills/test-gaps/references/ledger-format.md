# `TESTS.md` Format

Each entry is a short, debatable mini-RFC: skimmable at the top, with just
enough reasoning and alternatives for a reviewer to agree or push back. Keep the
**required core** on every entry. Add the **expandable sections** only when the
entry warrants them; do not pad a trivial gap.

## Required Core

Use this structure for every entry:

````markdown
# Tests

## TEST-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Test Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | Risk created by the missing, weak, misleading, flaky, or wrong-layer coverage. |

**Summary.** One or two sentences a reviewer can read on their own: which
repository-owned behavior is unprotected and why that matters.

### Context
The repository-owned behavior at risk, its current test surface, and the
uncovered, misleading, flaky, or wrong-layer path. Name the narrowest
established test layer that should own it.

### Evidence
Evidence: Concrete file and line references, existing test behavior, command
output, or untested code path.
Reproduction: Smallest supported command, scenario, test run, or front-door
trace that shows the behavior is unprotected, misleadingly covered, flaky, or
covered at the wrong layer.

### Proposal
The recommended coverage: the narrowest credible established test layer and the
smallest test or harness change that protects the behavior.

### Alternatives Considered
- Chosen: the proposal above — why this test layer and shape fit.
- Other layer: a different test layer (unit / feature / integration) — why not.
- Do nothing: the risk of leaving the behavior unprotected.

### Definition of Success
- The new or fixed test fails against the unprotected behavior and passes once
  it is covered, plus the validation command(s) that show it.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
### Goals / Non-goals
- Goal: which behavior the coverage must protect.
- Non-goal: behavior or layers this deliberately does not test.

### Open Questions
- A test-layer, fixture, or determinism decision that needs the human.

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
## Optional Test Follow-Ups

- Optional or non-blocking note.
```
