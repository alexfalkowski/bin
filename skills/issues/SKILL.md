---
name: issues
description: Finds concrete bugs, security issues, compatibility breaks, and public contract violations in a package or folder, records them in ISSUES.md, and later implements agreed fixes issue by issue. Use when the user asks to find $issues, find issues, implement $issues, or implement issues.
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
4. Ask for human permission before any agent runs commands. Without permission, agents should inspect code only and suggest validation.
5. Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
6. Launch agents for:
   - files directly under the requested root package/folder.
   - each first-level subpackage/subfolder under the requested root.
7. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for its assigned scope.
8. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
9. Wait for all agents to finish before aggregating results.
10. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code directly.
11. Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
12. Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps or optional follow-up notes when relevant.
13. If no confirmed issues are found, report that no issues were found and do not create `ISSUES.md`.
14. If confirmed issues are found, write all findings to root `ISSUES.md` before making any fixes.
15. Assign every finding a unique ID for the session in the form `ISSUE-<number>`.
16. Present `ISSUES.md` and a proposed fix plan to the user.
17. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

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
2. Work through issues sequentially by ID.
3. For each issue, propose a solution first. Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous, and continue only once the solution is agreed.
4. Once a solution is agreed, implement the fix with the smallest safe change.
5. Validate the fix using checks appropriate to the changed code.
6. If an issue is deemed invalid or not actually an issue, remove it from `ISSUES.md` after explaining why.
7. Remove the fixed issue from `ISSUES.md` only after the fix is implemented and validated, or after noting in the final summary which validation the human still needs to run.
8. Continue with the next issue only after updating `ISSUES.md`.
9. Once all findings are resolved, delete `ISSUES.md`.
10. Summarize what changed, which issues were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$change-validation` when selecting validation commands for implemented fixes.
