# Reliability Gaps Plan

Use this reference to instantiate the reliability-gap-specific active plan for
`$reliability-gaps`. Read it with the shared gap workflow named in `SKILL.md`;
that workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, and implementation gates.

Track reliability-gap-specific state for scope, reliability surface,
validation, delegation, ledger state, operational expectation, and failure-mode
evidence.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `RELIABILITY.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   operational docs, release/config surfaces, and `./bin` wiring.
4. Run the shared audit preflight from `../../references/gap-workflow.md`,
   including applicable tool availability, service dependencies, validation
   ladder, and command-failure classification.
5. Identify the reliability surface in scope, including services, APIs, CLIs,
   jobs, scripts, deployment/config, observability, release, recovery, and
   operability evidence.
6. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, tests, public entrypoints, generated/vendor/build/cache
   exclusions, reliability-sensitive surfaces, inventory count when applicable,
   and the coverage accounting required by the shared workflow.
7. Split the inventory into bounded reliability-risk or behavior-owned review
   slices. Use depth only as a discovery aid; do not assign a broad recursive
   subtree merely because it is a first-level subfolder.
8. If the scope is too broad for a credible single pass, select the highest-risk
   slices first and initialize coverage entries for reviewed deeply, skimmed,
   excluded, and deferred slices. Deferred entries must be exact follow-up
   scopes such as `path/to/package` or `path/to/package/subpackage`.
9. Ask for required permission before any local reviewer or authorized agent
   runs non-read-only, network, auth, remote-write, destructive, or otherwise
   approval-gated commands.
10. Use review agents when the active runtime provides and permits sub-agents
    and they materially improve coverage, confidence, throughput, independent
    validation, forward-testing, or disjoint implementation, or when this skill
    requires delegated review. If sub-agents are unavailable, forbidden, or
    denied, perform local review only when credible completion does not depend
    on delegation; otherwise stop at the delegation gate.
11. Wait for all review work to finish.
12. Update coverage state for every planned slice before judging the requested
    scope.
13. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against code, config, tests, docs, and CI.
14. For candidates based on prose contradicting implementation, prove with
    non-prose evidence that the implementation or repository-owned reliability
    control is wrong; otherwise classify the mismatch as a documentation gap.
15. Confirm each gap names a current reliability promise or operational
    expectation, trigger, failure mode, missing or weak control, and user or
    operator impact.
16. Run a final finding calibration pass:
    - Does the trigger exist in current supported operation?
    - Is the missing control repository-owned rather than normal review, CI, or
      deployment discipline?
    - Are existing controls insufficient for this repository's workflow?
    - Would a skeptical maintainer likely agree this is more than optional
      hardening?
    If any answer is no, discard the candidate or move it to optional follow-up.
17. Reject generic maturity advice, future-scale assumptions, private
    preferences, and findings that belong in code, security, test, or doc
    ledgers.
18. Classify validation outcomes as repository finding, local environment
    issue, missing tool, or inconclusive; apply the confidence evidence rubric
    from `../../references/finding-severity.md`.
19. Before concluding there are no reliability gaps, run a final reliability
    closeout check. Name the cancellation/context handling, deadlines, timeouts,
    retries, backoff, bounded memory/network/file/process behavior, lifecycle
    cleanup, shutdown/drain/health/readiness behavior, observability or operator
    impact, and CI/sidecar/runtime controls that were checked. If any of these
    were not applicable, say why.
20. If no confirmed gaps remain, report that result with the no-finding closeout
    required by the shared gap workflow, do not create `RELIABILITY.md`, and
    stop.
21. If confirmed gaps remain, write the scoped `RELIABILITY.md` with
    `REL-<number>` IDs.
22. Present the scoped ledger, proposed reliability-fix plan, coverage state for
    broad scopes, and runnable follow-up scopes for deferred slices.
23. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `RELIABILITY.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, operational docs, release/config surfaces, and `./bin` wiring.
4. Select the next finding by ID unless the human named a specific finding.
5. Re-check the finding against current code, config, tests, docs, and CI.
6. If the finding depends on prose contradicting implementation, prove the
   implementation or reliability control is wrong with non-prose evidence
   before proposing a reliability change; otherwise propose reclassification as
   a documentation gap.
7. Present the finding evidence, affected reliability promise or operational
   expectation, proposed solution, tradeoffs, and intended validation.
8. Stop until the human explicitly agrees to that finding's solution. A named
   fix, implement, or verify request selects the finding and permits re-checking
   evidence and refreshing the proposal, but it is not approval to edit unless
   the request also explicitly agrees to the proposed solution. If the proposal
   was already presented and remains unchanged after re-checking, state only
   the concise approval gate instead of repeating the full proposal.
9. After agreement, state the local code/config/docs pattern, dominant relevant
   test harness, planned validation, and any needed deviation.
10. If a deviation is needed, stop and ask before editing.
11. For behavior-changing fixes, state the reliability execution checklist:
    TDD decision, first test/scenario, expected red, intended green change,
    refactor checkpoint, and validation.
12. Implement only the agreed reliability gap with the smallest clear change.
13. Use `$reliability-standards`, `$change-safety`, `$testing-standards`,
    `$change-validation`, and `$security-audit` as required by the touched
    surface.
14. Validate the reliability change through repository Make targets or
    documented entrypoints.
15. Report `Red`, `Green`, `Refactor`, and `Validation`, then ask the human to
    verify with `REL-<number> is done`.
16. Stop until that confirmation arrives.
17. After confirmation, remove or revise the finding in scoped `RELIABILITY.md`.
18. Continue with the next finding, or delete scoped `RELIABILITY.md` after all
    gaps are confirmed resolved.
