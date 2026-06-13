# Test Gaps Plan

Use this reference to instantiate the active execution plan for `$test-gaps`.
The active plan is runtime state. Do not write it into the repository unless the
human explicitly asks for a durable plan file. In downstream repositories that
vendor this project as `./bin`, instantiate the plan from the consuming
repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate based
  on silence or a broad request.
- Update the active plan when scope, dominant test harness, validation,
  delegation, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Record durable findings only in the scoped `ISSUES.md` ledger defined by the
  skill.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `ISSUES.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, and `./bin` wiring.
4. Identify the existing tests, fixtures, helpers, and dominant relevant harness
   for the requested scope.
5. Build the read-only test-gap delegation plan from the requested root and its
   first-level subfolders.
6. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
7. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
8. Wait for all review work to finish.
9. Deduplicate candidates and directly re-check conflicting or overlapping
   conclusions against code and tests.
10. Confirm each gap protects repository-owned behavior and is not duplicate,
    private-only, dependency-only, optional, or better handled by another skill.
11. If no confirmed gaps remain, report that result and do not create
    `ISSUES.md`.
12. If confirmed gaps remain, write the scoped `ISSUES.md` with `TEST-<number>`
    IDs.
13. Present the scoped ledger and proposed test-fix plan.
14. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `ISSUES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, and `./bin`
   wiring.
4. Select the next finding by ID unless the human named a specific finding.
5. Re-check the finding against current code, tests, fixtures, and harnesses.
6. Present the finding evidence, proposed test solution, repository-owned
   behavior, existing coverage gap, tradeoffs, and intended validation.
7. Stop until the human explicitly agrees to that finding's solution.
8. After agreement, state the local test pattern, dominant relevant test
   harness, planned validation, and any needed deviation.
9. If a deviation is needed, stop and ask before editing.
10. Implement only the agreed test gap with the smallest clear test change.
11. Use `$testing-standards` and the relevant language standard for test design.
12. Validate the test change with commands appropriate to the changed tests.
13. Report the result and ask the human to verify with `TEST-<number> is done`.
14. Stop until that confirmation arrives.
15. After confirmation, remove or revise the finding in scoped `ISSUES.md`.
16. Continue with the next finding, or delete scoped `ISSUES.md` after all gaps
    are confirmed resolved.
