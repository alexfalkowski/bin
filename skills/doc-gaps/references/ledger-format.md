# Candidate And `DOCS.md` Format

Each review candidate and each unresolved or audit-only ledger entry is a
self-contained, debatable mini-RFC. A reviewer must be able to understand the
reader problem, the evidence, and the proposed direction without opening
another file. Organize the entry as `What -> Why -> How`. Keep the
**required core** on every entry, and add the **expandable sections** only when
they help a real decision.

Write short, direct sentences. Use the table for classification, the summary
for the main point, and the body for supporting detail. Do not repeat the
same prose across those layers.

Source locations support verification; they do not carry the explanation.
Prefer a stable command, API, heading, example, public symbol, or documented
surface over a bare line number. Add a line number only when it makes the source
faster to find. Include the relevant short excerpt or observed output when the
reviewer would otherwise need to reconstruct the claim from source.

## Required Core

Use this structure for every entry:

````markdown
# Docs

## DOC-1: Short concrete title

| Field | Value |
| --- | --- |
| Status | Proposed \| Accepted \| In progress \| Rejected |
| Type | Doc Gap |
| Severity | Critical \| High \| Medium \| Low |
| Confidence | 93% — one-line reason; active threshold is the explicit request, otherwise 90% (or 95% for high-risk acceptance). |
| Scope | path/to/file-or-folder |
| Public surface | Command \| API \| package \| service \| configuration \| example \| file format \| operator behavior. |
| Audience | Service author \| Operator \| Package consumer \| Maintainer |
| User action at risk | Concrete action or decision the reader cannot safely complete from current docs. |
| Impact | Risk created by the missing, weak, stale, misleading, or wrong-location documentation. |

**Summary.** In one or two plain sentences, state the action a reader cannot
safely complete, why that matters, and the proposed documentation direction.

### What

**Current.** State the reader action, the current documentation surface (or
`missing`), and what the reader can determine today.

**Expected.** State the behavior or contract the reader should be able to
understand and the action they should be able to complete.

### Why

**Impact.** Explain the concrete misuse, failed action, maintenance risk,
security risk, or unsafe decision caused by the gap.

#### Evidence

- **Claim:** The plain-language documentation fact this evidence establishes.
- **Observed:** The missing, stale, misleading, or misplaced information, with
  enough detail to understand it here.
- **Reproduction:** Smallest reader action, command/API lookup, example attempt,
  documentation search, or authoritative surface comparison that reproduces the
  documentation gap.
- **Source:** `path/to/file` — stable command, API, heading, example, or public
  symbol; line number optional.

### How

#### Proposal

Name the target surface (README / docs / example / command help / package docs /
API comment / code comment / docstring), the smallest successful usage path it
should support, and the established documentation style to follow.

**Keep.** Name the audiences, surfaces, examples, or contracts this change must
not duplicate or alter.

#### Alternatives Considered

- Chosen: the target surface above — why it is where the reader looks.
- Other surface: a different documentation location — why not.
- Do nothing: the risk of leaving the reader without the contract.

#### Definition of Success

- The reader can complete the action from the documented surface (any example
  or command runs as written).
- **Validation:** The repository command(s), example(s), or reader check(s) that
  prove the result.
````

## Add When Warranted

Add these sections only when the entry needs them; omit them otherwise.

````markdown
#### Situation Map

Place this directly after `**Expected.**` under `### What`.

Use only when a small visual explains a multi-step reader path, ownership
boundary, documentation location, or current-versus-expected outcome better than
the prose. Do not turn the entry into an architecture document.

```text
[Reader]
    |
    v
[Documented surface]
    |-- today --> [Current outcome]
    +-- target -> [Expected outcome]
```

### Goals / Non-goals
- Goal: which reader action the documentation must support.
- Non-goal: surfaces or audiences this deliberately does not document.

### Open Questions
- A documentation-location or scope decision that needs the human.

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
## Optional Doc Follow-Ups

- Optional or non-blocking note.
```
