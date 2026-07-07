# Implementation Proposal Gate

Before asking for agreement to edit a feature, present a compact decision card.
Its job is the *how* and the *ask*: the concrete implementation shape you
propose, one crisp decision, and the main cost to watch. The *what* and *why*
already live in the `FEATURES.md` entry, so point back to `FEATURE-N` instead of
restating the problem, evidence, or feature-level alternatives. Lead with
`## Solution Shape`; do not bury the ask after a long plan update. The
`## Decision` block is the shared decision card (`../../references/decision-card.md`);
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
| Scope | FEATURE-N and the smallest package/config/doc surfaces needed. |
| Compatibility | Additive \| Breaking \| Mixed, with the concrete reason. |
| Confidence | 94% |
| Watch | The main compatibility, maintenance, dependency, security, or config-surface cost to weigh. |

Full problem, evidence, and alternatives: see FEATURE-N in `FEATURES.md`.

Approval command:

- `Approved. Continue.` approves this solution shape and starts implementation.
- `Agent approved. Continue.` approves this solution shape and authorizes
  sub-agents for implementation or fresh review when useful.
````

Add this section only when a real fork exists in *how* to implement the feature;
omit it otherwise (feature-level alternatives stay in the `FEATURES.md` entry):

````markdown
### Other Shapes Considered

- Chosen shape: why it fits the existing local patterns.
- Alternative shape: a different implementation approach — why not.
````
