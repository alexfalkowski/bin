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
- Record durable findings only in the scoped `ISSUES.md` ledger defined by the
  skill.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed code issues are found and
  reported, or when the scoped `ISSUES.md` ledger is written and presented.
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
4. Build the read-only review delegation plan from the requested root and its
   first-level subfolders.
5. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
6. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
7. Wait for all review work to finish.
8. Deduplicate candidates and directly re-check conflicting or overlapping
   conclusions.
9. Confirm each finding is a concrete code issue, security issue,
   compatibility break, or public contract violation.
10. If no confirmed issues remain, report that result and do not create
    `ISSUES.md`.
11. If confirmed issues remain, write the scoped `ISSUES.md` with
    `ISSUE-<number>` IDs.
12. Present the scoped ledger and proposed fix plan.
13. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `ISSUES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, and `./bin`
   wiring.
4. Select the next issue by ID unless the human named a specific issue.
5. Re-check the issue evidence against current code and tests.
6. Present the issue evidence, proposed solution, compatibility or behavior
   tradeoffs, and intended validation.
7. Stop until the human explicitly agrees to that issue's solution.
8. After agreement, state the local code pattern, dominant relevant test
   harness, planned validation, and any needed deviation.
9. If a deviation is needed, stop and ask before editing.
10. Implement only the agreed issue with the smallest safe change.
11. Use `$testing-standards` for regression coverage decisions.
12. Validate the fix with commands appropriate to the changed files.
13. Report the result and ask the human to verify with `ISSUE-<number> is done`.
14. Stop until that confirmation arrives.
15. After confirmation, remove or revise the issue in scoped `ISSUES.md`.
16. Continue with the next issue, or delete scoped `ISSUES.md` after all issues
    are confirmed resolved.
