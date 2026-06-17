---
name: doc-gaps
description: Use when the user asks to run $doc-gaps in a package or folder, find doc gaps in a package or folder, fix doc gaps in a package or folder, review docs for gaps, audit-only doc gaps, asks about doc gap IDs such as DOC-1, asks what the fix is for DOC-1, asks to fix or verify DOC-1, or says DOC-1 is done. Find and fix concrete missing, weak, stale, or misleading documentation in one pass, including README files, user-facing docs, examples, command help, package docs, public API comments, code comments, and docstrings required by $doc-standards and relevant language standards.
---

# Doc Gaps

Use this skill in one-pass mode by default:

- **One-pass mode**: `Run $doc-gaps in PACKAGE_OR_FOLDER`, `Find doc gaps in PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER`.
- **Audit-only mode**: `Audit-only $doc-gaps in PACKAGE_OR_FOLDER` or `Find doc gaps in PACKAGE_OR_FOLDER without editing`.

Before starting one-pass mode or audit-only mode, read `references/plan.md` and
use it to maintain the active execution plan. The active plan is runtime state;
do not write it into the repository unless the human explicitly asks for a
durable plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as delegation, edit, validation, summary,
or unresolved-ledger state changes.

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

Follow `references/plan.md#one-pass-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Treat `Run $doc-gaps in PACKAGE_OR_FOLDER`, `Find doc gaps in PACKAGE_OR_FOLDER`, or `Fix doc gaps in PACKAGE_OR_FOLDER` as permission to delegate review, edit documentation in scope, run appropriate validation, and summarize the result in one pass.
- Use audit-only mode only when the user explicitly asks not to edit or asks only for an audit or ledger. When a stop gate prevents a correct documentation fix during one-pass mode, record unresolved confirmed findings instead of switching modes.
- If scoped `ISSUES.md` already exists, read it before reviewing. If it is a doc-gap ledger, include unresolved findings in the candidate set and update or delete the ledger after fixing them. If it is unrelated or ambiguous active work, stop and ask before editing it.
- Use as many independent review agents as the runtime can safely run when the active runtime provides sub-agents and runtime policy/tooling permits delegation. Do not perform the doc-gap review locally first when delegation is available.
- Treat the doc-gap invocation as the user's explicit request to delegate documentation review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, generated API docs, and generated lockfile churn unless the requested scope is explicitly about them.
- Before assigning review agents, build a recursive documentation inventory for the requested package or folder: README files, docs, examples, command help surfaces, package docs, public API comments, code-comment/docstring surfaces, first-level subfolders, nested packages, generated/vendor/build/cache exclusions, and relevant validation entrypoints.
- Do not assign broad recursive subtrees merely because they are first-level subfolders. When a subtree contains many independent documentation owners, mixed audiences, or too many relevant files for a credible single pass, split it into smaller documentation-surface or behavior-owned slices before delegation.
- Prefer slices based on authoritative documentation owner and user risk: README or user docs, command help, examples, public API/package docs, documented workflows, changed or recently touched areas, and code areas with public interfaces. Use depth only as a discovery aid, not as the review boundary.
- If the requested scope is too broad to review credibly in one pass, review the highest-risk slices first and record explicit coverage: reviewed deeply, skimmed, excluded, and deferred.
- Do not present a broad requested scope as fully reviewed when any relevant slice was only skimmed or deferred. Name those slices in the final coverage notes and provide runnable follow-up scopes for deferred review.
- Each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough documentation review for that slice, pairing with `$doc-standards`, relevant language standards, `$naming-standards` when terminology is unclear or inconsistent, and `$change-validation` for likely validation commands.
- Each agent must audit the relevant documentation surfaces before returning candidates: README files, docs, examples, command help, package documentation, exported API comments, code comments, and docstrings. For each candidate, apply `$doc-standards`' adequacy gate by identifying the public surface, intended audience, user action or maintenance decision at risk, existing documentation surface, correct target surface, minimum successful example or command, and missing non-obvious contract.
- Require each agent to return candidates in the candidate format below, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity and confidence.
- Confirm each candidate gap against the code, current docs, examples, and documented interfaces before fixing it, using `$doc-standards` as the finding threshold. Do not confirm or dismiss a candidate merely because documentation exists; verify adequacy, ownership, discoverability, example coverage, and the relevant non-obvious contract.
- When prose and implementation disagree, require non-prose evidence before treating the code as wrong or routing the candidate out to another workflow. If code, tests, runtime behavior, generated contracts, or history support the implementation, fix the stale prose as a doc gap.
- Before fixing or dismissing a candidate, route it to the correct documentation surface: README, docs, examples, command help, package documentation, exported API comment, code comment, docstring, or no change. Do not treat package GoDoc or code-comment improvements as sufficient when first-use, setup, configuration, operational behavior, security expectations, or service-author workflows would reasonably be expected in README files, user-facing docs, examples, or command help. Do not treat README prose as sufficient when `$doc-standards` and the paired language standard route reusable API contracts to GoDoc, RDoc, docstrings, executable examples, specs, or features.
- When dismissing a candidate because existing documentation is sufficient, identify the existing surface that covers the audience and action at risk in the final summary, and state why that surface is the authoritative owner under `$doc-standards`.
- Do not fix candidates that `$doc-standards` routes to `$code-review`, `$code-issues`, `$security-audit`, `$testing-standards`, or `$test-gaps`. Report those as out of scope when relevant.
- Before editing in one-pass mode, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For unresolved-ledger fixes or any case where human approval is still required: After the human agrees and before editing, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement confirmed doc gaps with the smallest clear documentation change using the established documentation location and style.
- Stop and ask before editing when behavior, audience, documentation location, public-contract wording, examples, validation, or user intent is ambiguous enough that a correct documentation change cannot be inferred from local context.
- Write unresolved confirmed findings to the scoped `ISSUES.md` only when they cannot be fixed in the same pass, the user requested audit-only mode, validation or permission is blocked, or the scope is too large to complete.
- Validate documentation changes with commands appropriate to the changed files.
- If no confirmed doc gaps are found, report that no doc gaps were found and do not create `ISSUES.md`.
- If all confirmed doc gaps are fixed, do not leave a new `ISSUES.md` behind. If an existing doc-gap ledger is fully resolved, delete it.
- Final output must summarize fixed gaps, dismissed or out-of-scope candidates when relevant, broad-scope coverage notes when the requested scope was too broad for complete deep review, unresolved findings written to `ISSUES.md` if any, and validation results.

## Audit-Only Mode

Follow `references/plan.md#audit-only-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Use `ISSUES.md` in the requested package or folder as the audit ledger, for example `PACKAGE_OR_FOLDER/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop unless the human explicitly asked to refresh or overwrite that scoped ledger.
- Use the same delegation, surface-routing, candidate confirmation, severity, and out-of-scope rules as one-pass mode.
- If no confirmed doc gaps are found, report that no doc gaps were found and do not create `ISSUES.md`.
- If confirmed doc gaps are found, write all findings to the scoped `ISSUES.md` with `DOC-N` IDs.
- Stop after presenting the audit ledger. Do not make fixes in audit-only mode.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to fix or record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before fixing or
recording findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

## Candidate And `ISSUES.md` Format

Use this structure for review candidates and unresolved or audit-only ledger
entries:

```markdown
# Issues

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
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
