# `RELIABILITY.md` Format

Each entry is a self-contained, debatable mini-RFC. A reviewer must be able to
understand the failure mode, the evidence, and the proposed control without
opening another file. Organize the entry as `What -> Why -> How`. Keep the
**required core** on every entry, and add the **expandable sections** only when
they help a real decision.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable service, command, config key, metric, alert, test, or symbol over
a bare line number. Add a line number only when it makes the source faster to
find. Include the relevant short excerpt or observed output when the reviewer
would otherwise need to reconstruct the claim from source.

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
| Confidence | 93% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Scope | path/to/file-or-folder |
| Impact | User, operator, incident, availability, recovery, data-integrity, or scaling risk. |

**Summary.** In one or two plain sentences, state the failure mode or missing
control, why it matters, and the proposed reliability direction.

### What

**Current.** State the operational trigger, failure mode or missing control, and
current system or operator outcome.

**Expected.** State how the system should contain, recover from, surface, or
prevent the failure.

### Why

**Impact.** Explain the blast radius and the SLO, availability, recovery,
data-integrity, scaling, or operator expectation at risk.

#### Evidence

- **Claim:** The plain-language reliability fact this evidence establishes.
- **Observed:** The actual failure, missing control, config behavior, command
  output, trace, or calculation, with enough detail to understand it here.
- **Reproduction:** Smallest supported trigger, workflow, config path, command,
  test, trace, or operational scenario that reproduces the failure mode or
  proves the missing reliability control.
- **Source:** `path/to/file` — stable service, command, config key, metric,
  alert, test, or symbol; line number optional.

### How

#### Proposal

Describe the smallest credible reliability improvement using established local
patterns and any compatibility or operational cost.

**Keep.** Name the existing SLO, default, failure behavior, operator workflow,
or compatibility boundary that must remain unchanged.

#### Alternatives Considered

- Chosen: the proposal above — why this control fits the failure mode.
- Other option: a different control (retry / timeout / circuit-break / bulkhead /
  alert / auto-recover) or wider redesign — why not.
- Do nothing: the operational risk of leaving the gap.

#### Definition of Success

- Observable proof the control works (for example, an injected fault is now
  contained or recovered).
- **Validation:** The repository command(s), fault scenario(s), or operational
  check(s) that prove the result.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
#### Situation Map

Place this directly after `**Expected.**` under `### What`.

Use only when a small visual explains a trigger, multi-step failure path,
boundary, ownership relationship, or current-versus-expected outcome better than
the prose. Do not turn the entry into an architecture document.

```text
[Trigger]
    |
    v
[Reliability surface]
    |-- today --> [Current outcome]
    +-- target -> [Expected outcome]
```

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
