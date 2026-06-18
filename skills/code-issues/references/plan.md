# Code Issues Plan

Use this reference to instantiate the active execution plan for `$code-issues`.
The active plan is runtime state. Do not write it into the repository unless the
human explicitly asks for a durable plan file. In downstream repositories that
vendor this project as `./bin`, instantiate the plan from the consuming
repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate based
  on silence or a broad request.
- Update the active plan when scope, validation, delegation, or ledger state
  changes.
- Treat validation as stale when files change after a command ran.
- Before checking, reading, creating, or updating the scoped `ISSUES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `ISSUES.md` as a standalone pattern. If the pattern is missing, add it.
- Record durable findings only in the scoped `ISSUES.md` ledger defined by the
  skill.
- In downstream repositories that vendor this project as `./bin`, exclude
  `bin/**` from recursive inventory, review slices, and durable findings unless
  the requested scope is explicitly about shared `bin` tooling. Inspect only
  included shared fragments or selected skill guidance needed as evidence, and
  route upstream-only findings to a separate `bin`-scoped run.
- Track broad-scope coverage explicitly as reviewed deeply, skimmed, excluded,
  and deferred. Deferred entries must name runnable follow-up scopes.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed code issues are found and
  reported, or when the scoped `ISSUES.md` ledger is written and presented.
- For broad scopes, a no-issue result is complete only when the summary states
  whether all high-risk slices were deeply reviewed. If any relevant slice was
  skimmed or deferred, completion requires coverage notes and runnable
  follow-up scopes, not an unqualified all-scope no-issue claim.
- In Implement mode, the goal is waiting while the human has not approved the
  proposed issue solution, or after validation until the human confirms
  `ISSUE-<number> is done`.
- In Implement mode, the goal is complete for an issue only after the human
  confirms it is done and the scoped ledger is updated accordingly.
- Record a blocked reason when a required scope is missing, the scoped ledger
  required by the mode is absent or already exists in a conflicting state,
  required permission is denied, or the selected issue cannot be re-checked
  without human input. Follow runtime rules for when that reason changes goal
  status.

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
8. Stop until the human explicitly agrees to that issue's solution.
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
