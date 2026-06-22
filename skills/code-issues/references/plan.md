# Code Issues Plan

Use this reference to instantiate the code-issue-specific active plan for
`$code-issues`. Read it with the shared gap workflow named in `SKILL.md`; that
workflow owns common plan state, goal state, scoped-ledger, delegation,
coverage, and implementation gates.

Track code-issue-specific state for scope, validation, delegation, ledger
state, code/security/compatibility evidence, and public contract evidence.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `ISSUES.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, and `./bin` wiring.
4. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, tests, public entrypoints, generated/vendor/build/cache
   exclusions, and security-sensitive surfaces.
5. Split the inventory into bounded behavior-owned review slices. Use depth
   only as a discovery aid; do not assign a broad recursive subtree merely
   because it is a first-level subfolder.
6. If the scope is too broad for a credible single pass, select the highest-risk
   slices first and initialize coverage entries for reviewed deeply, skimmed,
   excluded, and deferred slices. Deferred entries must be exact follow-up
   scopes such as `path/to/package` or `path/to/package/subpackage`.
7. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
8. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
9. Wait for all review work to finish.
10. Update coverage state for every planned slice before judging the requested
    scope.
11. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions.
12. Confirm each finding is a concrete code issue, security issue,
    compatibility break, or public contract violation. If the evidence is a
    documentation/comment mismatch, prove the implementation is wrong with
    non-prose evidence before treating it as a code issue; otherwise classify it
    as a documentation gap.
13. If no confirmed issues remain, report that result with the coverage state,
    do not create `ISSUES.md`, and stop.
14. If confirmed issues remain, write the scoped `ISSUES.md` with
    `ISSUE-<number>` IDs.
15. Present the scoped ledger, proposed fix plan, coverage state for broad
    scopes, and runnable follow-up scopes for deferred slices.
16. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `ISSUES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, and `./bin`
   wiring.
4. Select the next issue by ID unless the human named a specific issue.
5. Re-check the issue evidence against current code and tests.
6. If the issue depends on prose contradicting implementation, prove the code is
   wrong with non-prose evidence before proposing a code change. If code and
   tests support the implementation, stop and propose reclassifying or fixing
   the documentation instead.
7. Present the issue evidence, proposed solution, compatibility or behavior
   tradeoffs, and intended validation.
8. Stop until the human explicitly agrees to that issue's solution. A named
   fix, implement, or verify request selects the issue and permits re-checking
   evidence and refreshing the proposal, but it is not approval to edit unless
   the request also explicitly agrees to the proposed solution. If the proposal
   was already presented and remains unchanged after re-checking, state only
   the concise approval gate instead of repeating the full proposal.
9. After agreement, state the local code pattern, dominant relevant test
   harness, planned validation, and any needed deviation.
10. If a deviation is needed, stop and ask before editing.
11. Implement only the agreed issue with the smallest safe change.
12. Use `$testing-standards` for regression coverage decisions.
13. Validate the fix with commands appropriate to the changed files.
14. Report the result and ask the human to verify with `ISSUE-<number> is done`.
15. Stop until that confirmation arrives.
16. After confirmation, remove or revise the issue in scoped `ISSUES.md`.
17. Continue with the next issue, or delete scoped `ISSUES.md` after all issues
    are confirmed resolved.
