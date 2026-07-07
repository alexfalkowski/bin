# `RELIABILITY.md` Format

Each entry is a short, debatable mini-RFC: skimmable at the top, with just
enough reasoning and alternatives for a reviewer to agree or push back. Keep the
**required core** on every entry. Add the **expandable sections** only when the
entry warrants them; do not pad a trivial gap.

## Required Core

Use this structure for every entry:

````markdown
# Reliability

## REL-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Reliability Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Impact | User, operator, incident, availability, recovery, data-integrity, or scaling risk. |

**Summary.** One or two sentences a reviewer can read on their own: the failure
mode or missing control and its operational impact.

### Context
The operational trigger, the failure mode or missing reliability control, the
blast radius, and any SLO, recovery, or data-integrity expectation it puts at
risk. Enough background to judge likelihood and severity.

### Evidence
Evidence: Concrete file and line references, command behavior, config, docs,
tests, missing control, failure mode, calculation gap, and the verification path
used to rule out a guess.
Reproduction: Smallest supported trigger, workflow, config path, command, test,
trace, or operational scenario that reproduces the failure mode or proves the
missing reliability control.

### Proposal
The recommended control: the smallest credible reliability improvement using
established local patterns, and any compatibility or operational cost.

### Alternatives Considered
- Chosen: the proposal above — why this control fits the failure mode.
- Other option: a different control (retry / timeout / circuit-break / bulkhead /
  alert / auto-recover) or wider redesign — why not.
- Do nothing: the operational risk of leaving the gap.

### Definition of Success
- Observable proof the control works (for example, an injected fault is now
  contained or recovered) plus the validation command(s) that show it.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
### Goals / Non-goals
- Goal: what the control must guarantee.
- Non-goal: failure modes or scaling concerns this deliberately does not address.

### Open Questions
- An SLO, rollout, or expected-failure-behavior decision that needs the human.

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
## Optional Reliability Follow-Ups

- Optional or non-blocking note.
```
