# Ledger Format

Each entry is a self-contained, debatable mini-RFC. A reviewer must be able to
understand the problem, the evidence, and the proposed direction without opening
another file. Organize the entry as `What -> Why -> How`. Keep the
**required core** on every entry, and add the **expandable sections** only when
they help a real decision.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable function, type, command, target, scenario, or heading over a
bare line number. Add a line number only when it makes the source faster to
find. Include the relevant short excerpt or observed output when the reviewer
would otherwise need to reconstruct the claim from source.

## Required Core

Use this structure for every entry:

````markdown
# Issues

## <ID>-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Code Issue |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Scope | path/to/file-or-folder |
| Impact | One-line user-visible impact or violated contract. |

**Summary.** In one or two plain sentences, state what breaks, why it matters,
and the proposed direction.

### What

**Current.** State the observable behavior, where it occurs, and who encounters
it.

**Expected.** State the contract or user-visible result that should hold.

### Why

**Impact.** Explain the concrete user, consumer, maintainer, security, or
compatibility consequence.

#### Evidence

- **Claim:** The plain-language fact this evidence establishes.
- **Observed:** The actual behavior, output, or trace, with enough detail to
  understand it here.
- **Reproduction:** Smallest supported command, test, API call, workflow, or
  code-path trace that reproduces the bug or contract violation.
- **Source:** `path/to/file` — stable symbol, target, scenario, or heading; line
  number optional.

### How

#### Proposal

State the smallest safe fix using existing local patterns and the direction it
takes.

**Keep.** Name the public behavior, compatibility boundary, or nearby scope that
must remain unchanged.

#### Alternatives Considered

- Chosen: the proposal above — why it is the safest, smallest fix.
- Other option: an alternative fix, workaround, or wider refactor — why not.
- Do nothing: the cost of leaving the bug in place.

#### Definition of Success

- Observable result that proves the bug is gone (for example, the previously
  failing case now passes).
- **Validation:** The repository command(s) or scenario(s) that prove the result.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
#### Situation Map

Place this directly after `**Expected.**` under `### What`.

Use only when a small visual explains a multi-step flow, boundary, ownership
relationship, or current-versus-expected outcome better than the prose. Do not
turn the entry into an architecture document.

```text
[Audience]
    |
    v
[Supported surface]
    |-- today --> [Current outcome]
    +-- target -> [Expected outcome]
```

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
