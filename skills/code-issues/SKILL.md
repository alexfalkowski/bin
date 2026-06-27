---
name: code-issues
description: Use when the user asks to find $code-issues in a package or folder, find code issues in a package or folder, implement $code-issues in a package or folder, implement code issues in a package or folder, asks about issue IDs such as ISSUE-1, asks what the fix is for ISSUE-1, asks to fix or verify ISSUE-1, or says ISSUE-1 is done. Find concrete bugs, security issues, compatibility breaks, and public contract violations, record them in scoped ISSUES.md, and later propose and implement agreed fixes one code issue at a time.
---

# Code Issues

Use this skill in two distinct modes:

- **Find mode**: `Find $code-issues in PACKAGE_OR_FOLDER` or `Find code issues in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $code-issues in PACKAGE_OR_FOLDER` or `Implement code issues in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

## Operating Stance

Operate as a strict issue triager and ledger owner: separate confirmed code
defects from test gaps, doc gaps, polish, and speculation; keep the scoped
`ISSUES.md` actionable, deduplicated, and tied to user-visible or contract risk.

Code is the default source of behavioral truth. Comments, GoDoc, README prose,
examples, and other documentation can be stale. Do not record or implement a
code issue merely because prose and implementation disagree. First prove the
implementation is wrong using non-prose evidence such as executable behavior,
tests, schemas, wire/API contracts, external standards, runtime failures, or
history showing an unintended code regression. If implementation and tests agree
while prose disagrees, treat it as a documentation gap and update the docs.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These code-issue rules remain mandatory:

- Use `ISSUES.md` in the requested package or folder as the review ledger, for
  example `PACKAGE_OR_FOLDER/ISSUES.md`.
- Prefer slices based on repository-owned behavior and risk: public commands/APIs, changed or recently touched areas, auth/network/filesystem/process boundaries, config/CI/release paths, documented workflows, and nearby tests. Use depth only as a discovery aid, not as the review boundary.
- For delegated review, each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for that slice, using `$testing-standards` for concrete missing-coverage or weak-test analysis and `$change-validation` for likely validation commands.
- Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
- Treat provider-to-public-contract adapters, lookup tables, data enrichment,
  normalization maps, embedded assets, vendored static data, and generated
  schema/value translations as high-risk review slices when they affect API
  output, routing, auth, billing, persistence, or user-visible behavior.
- When reviewing code that maps provider, asset, generated, embedded, or
  vendored data values into repository-owned public values, inspect the actual
  emitted data set or representative fixtures. Do not assume names in a mapping
  table match provider output. Check for unmapped provider values, stale
  fixtures, fallback-to-empty behavior, and public contract violations caused
  by normalization drift.
- For candidates based on documentation or comments contradicting code, require non-prose proof that the implementation is wrong before recording a code issue. Existing tests, helper names, runtime behavior, or commit history that support the implementation mean the candidate is a doc gap, not a code issue.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as code issues unless they are tied to a confirmed bug, security issue, compatibility break, or violated public contract. Use `$test-gaps` for standalone missing or weak test coverage passes.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as code issues unless they reveal a confirmed bug, security issue, compatibility break, or violated public contract. Use `$doc-gaps` for standalone documentation review passes.
- Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps, doc gaps, or optional follow-up notes when relevant.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## ISSUE-1: Short concrete title

- Severity: Critical|High|Medium|Low
- Confidence: 93%
- Scope: path/to/file-or-folder
- Impact: User-visible impact or violated contract.
- Evidence: Concrete file and line references, command output, or code path.
- Reproduction: Smallest supported command, test, API call, workflow, or
  code-path trace that reproduces the bug or contract violation.
- Proposed fix: Brief implementation direction.
- Validation: Suggested checks for the fix.
```

Keep optional follow-up notes separate from findings:

```markdown
## Testing Gaps And Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These code-issue implementation rules remain mandatory:

- Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
- When re-checking an issue whose evidence depends on documentation or comments contradicting implementation, prove the code is wrong before proposing a code change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a code issue and propose reclassifying or fixing the documentation instead.
- After the human agrees and before editing, state the selected local code pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Use `$testing-standards` when deciding whether to add or update regression tests for the fix, and prefer its test-first or scenario-first loop when a behavior-changing fix has a credible test or BDD layer.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps` instead when the user asks for a standalone missing or weak test coverage pass.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented fixes.
