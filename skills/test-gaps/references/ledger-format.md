# `TESTS.md` Format

Each entry is a self-contained, debatable mini-RFC. A reviewer must be able to
understand the coverage risk, the evidence, and the proposed direction without
opening another file. Organize the entry as `What -> Why -> How`. Keep the
**required core** on every entry, and add the **expandable sections** only when
they help a real decision.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable behavior, test, scenario, command, target, or symbol over a bare
line number. Add a line number only when it makes the source faster to find.
Include the relevant short excerpt or observed output when the reviewer would
otherwise need to reconstruct the claim from source.

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
| Confidence | 93% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Scope | path/to/file-or-folder |
| Impact | Risk created by the missing, weak, misleading, flaky, or wrong-layer coverage. |

**Summary.** In one or two plain sentences, state which repository-owned
behavior is unprotected, why that matters, and the proposed coverage direction.

### What

**Current.** State the repository-owned behavior at risk, its current test
surface, and the missing, misleading, flaky, or wrong-layer coverage.

**Expected.** State the protection the established test layer should provide
and the signal a regression should produce.

### Why

**Impact.** Explain the concrete regression, false-confidence, maintenance, or
user risk created by the current coverage.

#### Evidence

- **Claim:** The plain-language coverage fact this evidence establishes.
- **Observed:** The actual missing assertion, misleading pass, flaky result,
  wrong-layer behavior, or command output, with enough detail to understand it
  here.
- **Reproduction:** Smallest supported command, scenario, test run, or
  front-door trace that shows the behavior is unprotected, misleadingly covered,
  flaky, or covered at the wrong layer.
- **Source:** `path/to/file` — stable behavior, test, scenario, target, or
  symbol; line number optional.

### How

#### Proposal

Name the narrowest credible established test layer and the smallest test or
harness change that protects the behavior.

**Keep.** Name the product behavior, unrelated test layers, fixtures, or harness
semantics that must remain unchanged.

#### Alternatives Considered

- Chosen: the proposal above — why this test layer and shape fit.
- Other layer: a different test layer (unit / feature / integration) — why not.
- Do nothing: the risk of leaving the behavior unprotected.

#### Definition of Success

- The new or fixed test fails against the unprotected behavior and passes once
  it is covered.
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
