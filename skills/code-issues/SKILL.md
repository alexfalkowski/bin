---
name: code-issues
description: Finds concrete bugs, security issues, compatibility breaks, and public contract violations in a package or folder, records them in that scope's ISSUES.md, and later proposes and implements explicitly agreed fixes one code issue at a time. Use when the user asks to find $code-issues in a package or folder, find code issues in a package or folder, implement $code-issues in a package or folder, or implement code issues in a package or folder.
---

# Code Issues

Use this skill in two distinct modes:

- **Find mode**: `Find $code-issues in <package/folder>` or `Find code issues in <package/folder>`.
- **Implement mode**: `Implement $code-issues in <package/folder>` or `Implement code issues in <package/folder>`.

Do not combine the two modes in one pass.

## Find Mode

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
3. If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
4. Treat `Find $code-issues in <package/folder>` or `Find code issues in <package/folder>` as the user's explicit request to delegate review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
5. Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the find review locally first.
6. Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
7. If the runtime still requires an approval step before launching sub-agents, ask once with the concrete read-only agent plan. If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
8. Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation. Without that permission, agents should inspect code only and suggest validation.
9. Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
10. Launch at least one sub-agent covering the requested root package/folder. Split agent assignments across:
   - files directly under the requested root package/folder.
   - each first-level subpackage/subfolder under the requested root.
11. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for its assigned scope, using `$testing-standards` for concrete missing-coverage or weak-test analysis.
12. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
13. Wait for all agents to finish before aggregating results.
14. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code directly.
15. Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
16. Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as code issues unless they are tied to a confirmed bug, security issue, compatibility break, or violated public contract. Use `$test-gaps` for standalone missing or weak test coverage passes.
17. Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps or optional follow-up notes when relevant.
18. If no confirmed code issues are found, report that no code issues were found and do not create `ISSUES.md`.
19. If confirmed code issues are found, write all findings to the scoped `ISSUES.md` before making any fixes.
20. Assign every finding a unique ID for the session in the form `ISSUE-<number>`.
21. Present the scoped `ISSUES.md` and a proposed fix plan to the user.
22. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

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

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Read `ISSUES.md` in the requested package or folder first and treat it as the working review ledger.
   If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
3. Work through code issues sequentially by ID unless the human explicitly names a different issue.
4. For each issue, first present:
   - the issue ID and current evidence.
   - the proposed solution.
   - compatibility or behavior tradeoffs.
   - the intended validation.
5. Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that issue's solution.
6. Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
7. Once the solution for the current issue is agreed, implement only that issue with the smallest safe change.
8. Use `$testing-standards` when deciding whether to add or update regression tests for the fix.
9. Validate the fix using checks appropriate to the changed code.
10. Report the result for that issue and ask the human to verify and explicitly say `ISSUE-<number> is done`.
11. Do not move to the next issue until the human says `ISSUE-<number> is done`.
12. After the human confirms an issue is done, remove that issue from scoped `ISSUES.md`. If an issue is deemed invalid or not actually a code issue, remove it only after explaining why and getting human agreement.
13. Then propose the solution for the next remaining issue and repeat the same agreement gate.
14. Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.
15. Summarize what changed, which code issues were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps` instead when the user asks for a standalone missing or weak test coverage pass.
- Use `$change-validation` when selecting validation commands for implemented fixes.
