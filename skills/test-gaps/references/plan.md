# Test Gaps Plan

Use this reference to instantiate the test-gap-specific active plan for
`$test-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, and implementation gates.

Track test-gap-specific state for scope, dominant test harness, test-support
surface, validation, delegation, ledger state, and repository-owned behavior.

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
8. Ask for required permission before any local reviewer or authorized agent
   runs non-read-only, network, auth, remote-write, or otherwise approval-gated
   commands.
9. Use review agents when this skill authorizes delegated review and the active
   runtime provides and permits sub-agents. If a higher-priority runtime rule
   requires explicit user delegation authorization and the current request does
   not provide it, ask for permission instead of downgrading silently. If
   sub-agents are unavailable, forbidden, or denied, perform local review only
   when credible completion does not depend on delegation; otherwise stop at the
   delegation gate.
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
8. Stop until the human explicitly agrees to that finding's solution. A named
   fix, implement, or verify request selects the finding and permits re-checking
   evidence and refreshing the proposal, but it is not approval to edit unless
   the request also explicitly agrees to the proposed solution. If the proposal
   was already presented and remains unchanged after re-checking, state only
   the concise approval gate instead of repeating the full proposal.
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
