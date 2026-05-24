---
name: issues
description: Finds concrete bugs, security issues, compatibility breaks, and public contract violations in a package or folder, records them in ISSUES.md, and later proposes and implements explicitly agreed fixes issue by issue. Use when the user asks to find $issues, find issues, implement $issues, or implement issues.
---

# Issues

Use this skill in two distinct modes:

- **Find mode**: `Find $issues for <package/folder>` or `Find issues for <package/folder>`.
- **Implement mode**: `Implement $issues` or `Implement issues`.

Do not combine the two modes in one pass.

## Find Mode

1. Identify the requested package or folder scope.
2. Use `ISSUES.md` at the repository root as the review ledger.
3. If root `ISSUES.md` already exists, stop. Tell the user the existing issues must be resolved first, or the human must delete `ISSUES.md` before a new find pass.
4. Use sub-agents when the active runtime provides them, the runtime permits delegation for the request, and the scope benefits from parallel review. Do not stop with a generic "no permission to launch agents" message; if explicit delegation permission is required, ask once with the concrete read-only agent plan.
5. Sub-agents are optional. For a small scope, a single package, or a folder with no meaningful first-level subfolders/subpackages, review locally instead of spawning unnecessary agents.
6. Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation. Without that permission, agents should inspect code only and suggest validation.
7. Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
8. When using sub-agents, launch agents for:
   - files directly under the requested root package/folder.
   - each first-level subpackage/subfolder under the requested root.
9. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for its assigned scope.
10. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
11. Wait for all agents to finish before aggregating results.
12. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
13. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code directly.
14. Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
15. Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps or optional follow-up notes when relevant.
16. If no confirmed issues are found, report that no issues were found and do not create `ISSUES.md`.
17. If confirmed issues are found, write all findings to root `ISSUES.md` before making any fixes.
18. Assign every finding a unique ID for the session in the form `ISSUE-<number>`.
19. Present `ISSUES.md` and a proposed fix plan to the user.
20. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

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

1. Read root `ISSUES.md` first and treat it as the working review ledger.
   If `ISSUES.md` does not exist, stop and ask whether to run Find mode first.
2. Work through issues sequentially by ID unless the human explicitly names a different issue.
3. For each issue, first present:
   - the issue ID and current evidence.
   - the proposed solution.
   - compatibility or behavior tradeoffs.
   - the intended validation.
4. Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that issue's solution.
5. Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement issues" request as permission to start the proposal workflow, not as permission to code.
6. Once the solution for the current issue is agreed, implement only that issue with the smallest safe change.
7. Validate the fix using checks appropriate to the changed code.
8. Report the result for that issue and ask the human to verify and explicitly say `ISSUE-<number> is done`.
9. Do not move to the next issue until the human says `ISSUE-<number> is done`.
10. After the human confirms an issue is done, remove that issue from `ISSUES.md`. If an issue is deemed invalid or not actually an issue, remove it only after explaining why and getting human agreement.
11. Then propose the solution for the next remaining issue and repeat the same agreement gate.
12. Once all findings are resolved and confirmed done by the human, delete `ISSUES.md`.
13. Summarize what changed, which issues were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$change-validation` when selecting validation commands for implemented fixes.
