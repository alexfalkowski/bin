---
name: code-issues
description: Finds concrete bugs, security issues, compatibility breaks, and public contract violations in a package or folder, records them in that scope's ISSUES.md, and later proposes and implements explicitly agreed fixes one code issue at a time. Use when the user asks to find $code-issues in a package or folder, find code issues in a package or folder, implement $code-issues in a package or folder, or implement code issues in a package or folder.
---

# Code Issues

Use this skill in two distinct modes:

- **Find mode**: `Find $code-issues in <package/folder>` or `Find code issues in <package/folder>`.
- **Implement mode**: `Implement $code-issues in <package/folder>` or `Implement code issues in <package/folder>`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.

## Operating Stance

Operate as a strict issue triager and ledger owner: separate confirmed code
defects from test gaps, doc gaps, polish, and speculation; keep the scoped
`ISSUES.md` actionable, deduplicated, and tied to user-visible or contract risk.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
- Treat `Find $code-issues in <package/folder>` or `Find code issues in <package/folder>` as the user's explicit request to delegate review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the find review locally first.
- Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
- Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for its assigned scope, using `$testing-standards` for concrete missing-coverage or weak-test analysis and `$change-validation` for likely validation commands.
- Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity.
- Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as code issues unless they are tied to a confirmed bug, security issue, compatibility break, or violated public contract. Use `$test-gaps` for standalone missing or weak test coverage passes.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as code issues unless they reveal a confirmed bug, security issue, compatibility break, or violated public contract. Use `$doc-gaps` for standalone documentation review passes.
- Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps, doc gaps, or optional follow-up notes when relevant.
- If no confirmed code issues are found, report that no code issues were found and do not create `ISSUES.md`.
- If confirmed code issues are found, write all findings to the scoped `ISSUES.md` before making any fixes.
- Assign every finding a unique ID for the session in the form `ISSUE-<number>`.
- Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## ISSUE-1: Short concrete title

- Severity: Critical|High|Medium|Low
- Scope: path/to/file-or-folder
- Impact: User-visible impact or violated contract.
- Evidence: Concrete file and line references, command output, or code path.
- Proposed fix: Brief implementation direction.
- Validation: Suggested checks for the fix.
```

Keep optional follow-up notes separate from findings:

```markdown
## Testing Gaps And Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Read `ISSUES.md` in the requested package or folder first and treat it as the working review ledger.
- If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
- Work through code issues sequentially by ID unless the human explicitly names a different issue.
- Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that issue's solution.
- Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
- After the human agrees and before editing, state the selected local code pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed issue with the smallest safe change.
- Use `$testing-standards` when deciding whether to add or update regression tests for the fix, and prefer its test-first or scenario-first loop when a behavior-changing fix has a credible test or BDD layer.
- Do not move to the next issue until the human says `ISSUE-<number> is done`.
- After the human confirms an issue is done, remove that issue from scoped `ISSUES.md`. If an issue is deemed invalid or not actually a code issue, remove it only after explaining why and getting human agreement.
- Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Use `../references/finding-severity.md` for confidence filtering and severity.
- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps` instead when the user asks for a standalone missing or weak test coverage pass.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented fixes.
