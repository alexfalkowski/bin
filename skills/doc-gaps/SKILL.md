---
name: doc-gaps
description: Use when the user asks to run $doc-gaps in a package or folder, find doc gaps in a package or folder, find doc gaps with a specific confidence closure target such as 95% or 99%, fix doc gaps in a package or folder, review docs for gaps, audit-only doc gaps, uses a remembered command such as Work DOC-1 or Agent goal work DOC-1, asks about doc gap IDs such as DOC-1, asks what the fix is for DOC-1, asks to fix or verify DOC-1, or says DOC-1 is done. Find and fix concrete missing, weak, stale, or misleading documentation in one pass, including README files, user-facing docs, examples, command help, package docs, public API comments, code comments, and docstrings required by $doc-standards and relevant language standards.
---

# Doc Gaps

Use this skill in one-pass mode by default:

- **One-pass mode**: `Run $doc-gaps in PACKAGE_OR_FOLDER`, `Find doc gaps in PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER`.
- **Audit-only mode**: `Audit-only $doc-gaps in PACKAGE_OR_FOLDER` or `Find doc gaps in PACKAGE_OR_FOLDER without editing`.

Before starting one-pass mode or audit-only mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

## Operating Stance

Operate as a scoped documentation maintainer: use `$doc-standards` for
documentation quality judgment, use this skill for scope control and
delegation, and fix confirmed documentation gaps in the same pass unless a stop
gate requires human input.

When documentation contradicts implementation, treat current code, tests,
schemas, generated contracts, runtime behavior, external standards, and history
as the evidence for actual behavior. Do not route the mismatch to code,
security, reliability, or test workflows unless non-prose evidence proves the
implementation is wrong; otherwise fix the documentation to match the behavior
the repository implements.

## One-Pass Mode

Follow `references/plan.md#one-pass-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These doc-gap rules remain mandatory:

- Treat `Run $doc-gaps in PACKAGE_OR_FOLDER`, `Find doc gaps in PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER` as permission to edit documentation in scope, run appropriate validation, and summarize the result in one pass.
- Use audit-only mode only when the user explicitly asks not to edit or asks only for an audit or ledger. When a stop gate prevents a correct documentation fix during one-pass mode, record unresolved confirmed findings instead of switching modes.
- Use `DOCS.md` in the requested package or folder as the scoped ledger.
- If scoped `DOCS.md` already exists, read it before reviewing. If it is a doc-gap ledger, include unresolved findings in the candidate set and update or delete the ledger after fixing them. If it is unrelated or ambiguous active work, stop and ask before editing it.
- Before assigning review agents or starting local review, build a recursive documentation inventory for the requested package or folder: README files, docs, examples, command help surfaces, package docs, public API comments, code-comment/docstring surfaces, first-level subfolders, nested packages, generated/vendor/build/cache exclusions, and relevant validation entrypoints.
- Prefer slices based on authoritative documentation owner and user risk: README or user docs, command help, examples, public API/package docs, documented workflows, changed or recently touched areas, and code areas with public interfaces. Use depth only as a discovery aid, not as the review boundary.
- For delegated review, each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough documentation review for that slice, pairing with `$doc-standards`, relevant language standards, `$naming-standards` when terminology is unclear or inconsistent, and `$change-validation` for likely validation commands.
- For delegated review, each agent must audit the relevant documentation surfaces before returning candidates: README files, docs, examples, command help, package documentation, exported API comments, code comments, and docstrings. For each candidate, apply `$doc-standards`' adequacy gate by identifying the public surface, intended audience, user action or maintenance decision at risk, existing documentation surface, correct target surface, minimum successful example or command, and missing non-obvious contract.
- For delegated review, require each agent to return candidates in the candidate format below, without final IDs unless useful locally.
- Confirm each candidate gap against the code, current docs, examples, and documented interfaces before fixing it, using `$doc-standards` as the finding threshold. Do not confirm or dismiss a candidate merely because documentation exists; verify adequacy, ownership, discoverability, example coverage, and the relevant non-obvious contract.
- Before fixing or dismissing a candidate, route it to the correct documentation surface: README, docs, examples, command help, package documentation, exported API comment, code comment, docstring, or no change. Do not treat package GoDoc or code-comment improvements as sufficient when first-use, setup, configuration, operational behavior, security expectations, or service-author workflows would reasonably be expected in README files, user-facing docs, examples, or command help. Do not treat README prose as sufficient when `$doc-standards` and the paired language standard route reusable API contracts to GoDoc, RDoc, docstrings, executable examples, specs, or features.
- When dismissing a candidate because existing documentation is sufficient, identify the existing surface that covers the audience and action at risk in the final summary, and state why that surface is the authoritative owner under `$doc-standards`.
- Do not fix candidates that `$doc-standards` routes to `$code-review`, `$code-issues`, `$security-audit`, `$testing-standards`, or `$test-gaps`. Report those as out of scope when relevant.
- Before editing in one-pass mode, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For unresolved-ledger fixes or any case where human approval is still required: After the human agrees and before editing, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement confirmed doc gaps with the smallest clear documentation change using the established documentation location and style.
- Stop and ask before editing when behavior, audience, documentation location, public-contract wording, examples, validation, or user intent is ambiguous enough that a correct documentation change cannot be inferred from local context.
- Write unresolved confirmed findings to the scoped `DOCS.md` only when they cannot be fixed in the same pass, the user requested audit-only mode, validation or permission is blocked, or the scope is too large to complete.
- Validate documentation changes with commands appropriate to the changed files.
- If all confirmed doc gaps are fixed, do not leave a new `DOCS.md` behind. If an existing doc-gap ledger is fully resolved, delete it.
- Final output must summarize fixed gaps, dismissed or out-of-scope candidates when relevant, broad-scope coverage notes when the requested scope was too broad for complete deep review, unresolved findings written to `DOCS.md` if any, and validation results.

## Audit-Only Mode

Follow `references/plan.md#audit-only-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These rules remain mandatory:

- Use `DOCS.md` in the requested package or folder as the audit ledger, for example `PACKAGE_OR_FOLDER/DOCS.md`.
- If `DOCS.md` already exists in the requested package or folder, stop unless the human explicitly asked to refresh or overwrite that scoped ledger.
- Use the same delegation, surface-routing, candidate confirmation, severity, and out-of-scope rules as one-pass mode.
- Stop after presenting the audit ledger. Do not make fixes in audit-only mode.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to fix or record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before fixing or
recording findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

## Candidate And `DOCS.md` Format

Use this structure for review candidates and unresolved or audit-only ledger
entries:

```markdown
# Docs

## DOC-1: Short concrete title

- Type: Doc Gap
- Severity: Critical|High|Medium|Low
- Confidence: 93%
- Scope: path/to/file-or-folder
- Public surface: Command|API|package|service|configuration|example|file format|operator behavior.
- Audience: Service author|Operator|Package consumer|Maintainer
- User action at risk: Concrete action or decision the reader cannot safely complete from current docs.
- Current surface: Existing README/docs/examples/command help/package docs/API comments/code comments coverage, or "missing".
- Target surface: README|docs|example|command help|package docs|API comment|code comment|docstring.
- Minimum example or command: Smallest successful usage path the documentation should support, or "none" when not applicable.
- Adequacy failure: Missing, weak, stale, misleading, wrong-location, not discoverable, non-executable example, or "none" for dismissed candidates.
- Missing contract: Behavior/purpose|error/panic/nil/empty/zero-value|side effect/lifecycle/cleanup|concurrency/cache/retry/timeout/cancellation/idempotency|config default/limit/validation/fallback|security/operations/compatibility/data-loss|alias/wrapper/re-export/dependency boundary|none.
- Impact: Risk created by the missing, weak, stale, misleading, or wrong-location documentation.
- Evidence: Concrete file and line references, command/API behavior, existing docs, examples, or comment/docstring gap.
- Reproduction: Smallest reader action, command/API lookup, example attempt,
  documentation search, or authoritative surface comparison that reproduces the
  documentation gap.
- Proposed fix: Brief documentation direction using the established documentation location and style.
- Validation: Suggested checks for the documentation change.
```

Keep optional follow-up notes separate from findings:

```markdown
## Optional Doc Follow-Ups

- Optional or non-blocking note.
```

## References

- Read `references/plan.md` before starting one-pass mode or audit-only mode.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
- Use `../references/gap-lead-generation.md` during one-pass and audit-only
  modes to classify repo archetypes, generate documentation leads, and account
  for rejected or routed candidates.
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
