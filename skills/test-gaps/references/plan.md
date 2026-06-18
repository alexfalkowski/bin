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
- Update the active plan when scope, dominant test harness, test-support
  surface, validation, delegation, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Before checking, reading, creating, or updating the scoped `TESTS.md` ledger,
  ensure the consuming repository root `.gitignore` exists and contains
  `TESTS.md` as a standalone pattern. If the pattern is missing, add it.
- Record durable findings only in the scoped `TESTS.md` ledger defined by the
  skill.
- Track broad-scope coverage explicitly as reviewed deeply, skimmed, excluded,
  and deferred. Deferred entries must name runnable follow-up scopes.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed test gaps are found and
  reported, or when the scoped `TESTS.md` ledger is written and presented.
- For broad scopes, a no-gap result is complete only when the summary states
  whether all high-risk slices were deeply reviewed. If any relevant slice was
  skimmed or deferred, completion requires coverage notes and runnable
  follow-up scopes, not an unqualified all-scope no-gap claim.
- In Implement mode, the goal is waiting while the human has not approved the
  proposed test-gap solution, or after validation until the human confirms
  `TEST-<number> is done`.
- In Implement mode, the goal is complete for a finding only after the human
  confirms it is done and the scoped ledger is updated accordingly.
- Record a blocked reason when a required scope is missing, the scoped ledger
  required by the mode is absent or already exists in a conflicting state,
  required permission is denied, or the selected finding cannot be re-checked
  without human input. Follow runtime rules for when that reason changes goal
  status.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `TESTS.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, and `./bin` wiring.
4. Identify the existing tests, fixtures, helpers, test-support code, and
   dominant relevant harness for the requested scope.
5. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, public entrypoints, generated/vendor/build/cache exclusions,
   existing test harnesses, and test-support surfaces.
6. Split the inventory into bounded behavior-owned test-risk slices. Use depth
   only as a discovery aid; do not assign a broad recursive subtree merely
   because it is a first-level subfolder.
7. If the scope is too broad for a credible single pass, select the highest-risk
   slices first and initialize coverage entries for reviewed deeply, skimmed,
   excluded, and deferred slices. Deferred entries must be exact follow-up
   scopes such as `path/to/package` or `path/to/package/subpackage`.
8. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
9. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
10. Wait for all review work to finish.
11. Update coverage state for every planned slice before judging the requested
    scope.
12. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against code and tests.
13. For candidates based on prose contradicting implementation, prove the
    expected behavior with non-prose evidence before treating missing coverage
    as a test gap; otherwise classify the mismatch as a documentation gap.
14. Confirm each gap protects repository-owned behavior or removes a concrete
    test-harness weakness that makes such coverage brittle, misleading,
    wrong-layer, duplicated, non-deterministic, environment-bound, or
    unavailable. Reject candidates that are duplicate, private-only,
    dependency-only, optional, or better handled by another skill such as
    `$project-gaps`.
15. If no confirmed gaps remain, report that result with the coverage state, do
    not create `TESTS.md`, and stop.
16. If confirmed gaps remain, write the scoped `TESTS.md` with `TEST-<number>`
    IDs.
17. Present the scoped ledger, proposed test-fix plan, coverage state for broad
    scopes, and runnable follow-up scopes for deferred slices.
18. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `TESTS.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, and `./bin`
   wiring.
4. Select the next finding by ID unless the human named a specific finding.
5. Re-check the finding against current code, tests, fixtures, harnesses, and
   test-support surfaces.
6. If the finding depends on prose contradicting implementation, prove the
   expected behavior with non-prose evidence before proposing tests; otherwise
   propose reclassification as a documentation gap.
7. Present the finding evidence, proposed test solution, repository-owned
   behavior, existing coverage gap, tradeoffs, and intended validation.
8. Stop until the human explicitly agrees to that finding's solution.
9. After agreement, state the local test pattern, dominant relevant test
   harness, planned validation, and any needed deviation.
10. If a deviation is needed, stop and ask before editing.
11. Implement only the agreed test gap with the smallest clear test change.
12. Use `$testing-standards` and the relevant language standard for test design.
13. Validate the test change with commands appropriate to the changed tests.
14. Report the result and ask the human to verify with `TEST-<number> is done`.
15. Stop until that confirmation arrives.
16. After confirmation, remove or revise the finding in scoped `TESTS.md`.
17. Continue with the next finding, or delete scoped `TESTS.md` after all gaps
    are confirmed resolved.
