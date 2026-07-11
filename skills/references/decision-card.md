# Decision Card

Use this at a gap workflow's agreement gate to make agree, reject, or revise
easy. The card is a compact view of the mini-RFC, not a reference-only pointer.
Restate enough `What`, `Why`, and `How` for the human to decide without opening
the ledger or source files. Keep the ledger entry as the full RFC
and include its ID after the self-contained summary so the reader can find it.

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
| What | Current outcome -> expected outcome, in one plain sentence. |
| Why | Audience impact plus the strongest observed evidence. |
| How | Proposed change, what remains unchanged, and how success will be proved. |
| Scope | ID-N and the smallest surfaces the change needs. |
| Compatibility | Additive \| Breaking \| Mixed, with the concrete reason. |
| Confidence | 94% — one-line reason; minimum 90%, or 95% for high-risk acceptance. |
| Watch | The main compatibility, maintenance, security, test-layer, or operational cost to weigh. |

Source RFC: ID-N in its ledger. This locator is for deeper verification; the
decision above must stand on its own.

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
