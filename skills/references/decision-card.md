# Decision Card

Use this at a gap workflow's agreement gate to make agree, reject, or revise
easy. The mini-RFC ledger entry already carries the problem, evidence,
alternatives, and definition of success, so the card does not restate them: it
presents the concrete change and one crisp ask, then points back to the ledger
entry for the full reasoning.

Keep it to the required core. Add `## Solution Shape` only when there is a real
"how to build it" fork; that is mainly features, whose fuller packet is in
`implementation-proposal.md`.

## Required Core

Use this structure:

````markdown
## Decision

| Field | Value |
| --- | --- |
| Implement now? | Yes \| No \| Revise |
| Scope | ID-N and the smallest surfaces the change needs. |
| Compatibility | Additive \| Breaking \| Mixed, with the concrete reason. |
| Confidence | 94% |
| Watch | The main compatibility, maintenance, security, test-layer, or operational cost to weigh. |

Full context, evidence, and alternatives: see ID-N in its ledger.

Approval command:

- `Approved ID-N` approves this proposal and starts implementation.
- `Approved ID-N with agents` approves this proposal and authorizes sub-agents
  for implementation or fresh review when useful. The `with a goal` and
  `with agents and a goal` tails apply here too.
````

## Add When Warranted

Add a concrete implementation shape only when the change has a real design fork
in *how* to build it; omit it for straightforward fixes:

````markdown
## Solution Shape

```yaml
add:
  - New surface or behavior.
change:
  - Existing behavior or wiring to update.
keep:
  - Existing behavior intentionally preserved.
validation:
  - Targeted command or scenario.
```
````
