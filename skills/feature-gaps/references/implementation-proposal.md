# Implementation Proposal Gate

Before asking for agreement to edit a feature, present a compact decision card.
Its job is to make the *what*, *why*, *how*, and ask understandable without
opening `FEATURES.md` or source files. Lead with `## Solution Shape` (the
concrete implementation shape), then give a self-contained decision summary and
the main cost to watch. Keep `FEATURE-N` as the full mini-PRD and include its ID
so the reader can find it; do not use it as a substitute for the summary or bury
the ask after a long plan update. The `## Decision` block is the shared decision
card (`../../references/decision-card.md`);
`## Solution Shape` and `### Other Shapes Considered` are the feature-specific
additions for a design-heavy gate.

Use this structure:

````markdown
## Solution Shape

```text
config/client.Config
  -> shared feature config
  -> protocol-specific adapter
  -> existing runtime option or behavior
```

```yaml
add:
  - New public/config/API surface.
change:
  - Existing behavior or wiring to update.
keep:
  - Existing APIs, defaults, or behavior intentionally preserved.
validation:
  - Targeted command or scenario.
```

## Decision

| Field | Value |
| --- | --- |
| Implement now? | Yes \| No \| Revise |
| What | Current audience outcome -> expected audience outcome, in one plain sentence. |
| Why | Audience impact plus the strongest observed evidence. |
| How | This solution shape, what remains unchanged, and how success will be proved. |
| Scope | FEATURE-N and the smallest package/config/doc surfaces needed. |
| Compatibility | Additive \| Breaking \| Mixed, with the concrete reason. |
| Confidence | 94% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Watch | The main compatibility, maintenance, dependency, security, or config-surface cost to weigh. |

Source mini-PRD: FEATURE-N in `FEATURES.md`. This locator is for deeper
verification; the decision above must stand on its own.

Approval command:

- `Approved FEATURE-N` approves this solution shape and starts implementation.
- `Approved FEATURE-N with agents` approves this solution shape and authorizes
  sub-agents for implementation or fresh review when useful. The `with a goal`
  and `with agents and a goal` tails apply here too.
````

Add this section only when a real fork exists in *how* to implement the feature;
omit it otherwise (feature-level alternatives stay in the `FEATURES.md` entry):

````markdown
### Other Shapes Considered

- Chosen shape: why it fits the existing local patterns.
- Alternative shape: a different implementation approach — why not.
````
