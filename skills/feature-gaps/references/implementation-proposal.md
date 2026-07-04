# Implementation Proposal Gate

Before asking for agreement to edit a feature, present a compact decision
packet that helps the human decide quickly. The packet is primarily for judging
whether the solution shape looks right, not for re-proving the feature's
accuracy. Do not bury the ask after a long plan update or repeated prose. Lead
with the implementation shape, then separate decision metadata, rationale,
tradeoffs, and validation visually.

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

## Decision Needed

| Question | Recommendation |
| --- | --- |
| Implement now? | Yes \| No \| Revise |
| Scope | FEATURE-N and the smallest package/config/doc surfaces needed. |
| Compatibility | Additive \| Breaking \| Mixed, with the concrete reason. |
| Confidence | 94% |

### Why This Is Still Worth Doing

```text
current gap: The supported workflow still unavailable today.
existing coverage: What the repository already provides.
residual need: What the audience still cannot do.
audience payoff: The concrete outcome gained.
```

### Decision Trace

```text
audience workflow
  -> current supported surface
  -> residual gap
  -> proposed smallest shape
  -> validation proving it works
```

### Tradeoffs

| Accept | Watch |
| --- | --- |
| Benefit or simplification gained. | Compatibility, maintenance, dependency, security, or config-surface cost. |

Approval command:

- `Approved. Continue.` approves this solution shape and starts implementation.
- `Agent approved. Continue.` approves this solution shape and authorizes
  sub-agents for implementation or fresh review when useful.
````
