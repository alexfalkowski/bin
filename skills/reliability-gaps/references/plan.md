# Reliability Gaps Plan

Use this reference to instantiate the active execution plan for
`$reliability-gaps`. The active plan is runtime state. Do not write it into the
repository unless the human explicitly asks for a durable plan file. In
downstream repositories that vendor this project as `./bin`, instantiate the
plan from the consuming repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate based
  on silence or a broad request.
- Update the active plan when scope, reliability surface, validation,
  delegation, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Before checking, reading, creating, or updating the scoped `RELIABILITY.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `RELIABILITY.md` as a standalone pattern. If the pattern is missing, add it.
- Record durable findings only in the scoped `RELIABILITY.md` ledger defined by
  the skill.
- In downstream repositories that vendor this project as `./bin`, exclude
  `bin/**` from recursive inventory, review slices, and durable findings unless
  the requested scope is explicitly about shared `bin` tooling. Inspect only
  included shared fragments or selected skill guidance needed as evidence, and
  route upstream-only findings to a separate `bin`-scoped run.
- Track broad-scope coverage explicitly as reviewed deeply, skimmed, excluded,
  and deferred. Deferred entries must name runnable follow-up scopes.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed reliability gaps are
  found and reported, or when the scoped `RELIABILITY.md` ledger is written and
  presented.
- For broad scopes, a no-gap result is complete only when the summary states
  whether all high-risk slices were deeply reviewed. If any relevant slice was
  skimmed or deferred, completion requires coverage notes and runnable
  follow-up scopes, not an unqualified all-scope no-gap claim.
- In Implement mode, the goal is waiting while the human has not approved the
  proposed reliability-gap solution, or after validation until the human
  confirms `REL-<number> is done`.
- During automatic continuations while waiting for approval or done
  confirmation, state the waiting gate once and do not repeat the full
  proposal or result.
- In Implement mode, the goal is complete for a finding only after the human
  confirms it is done and the scoped ledger is updated accordingly.
- Record a blocked reason when a required scope is missing, the scoped ledger
  required by the mode is absent or already exists in a conflicting state,
  required permission is denied, or the selected finding cannot be re-checked
  without human input. Follow runtime rules for when that reason changes goal
  status.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `RELIABILITY.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   operational docs, release/config surfaces, and `./bin` wiring.
4. Identify the reliability surface in scope, including services, APIs, CLIs,
   jobs, scripts, deployment/config, observability, release, recovery, and
   operability evidence.
5. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, tests, public entrypoints, generated/vendor/build/cache
   exclusions, and reliability-sensitive surfaces.
6. Split the inventory into bounded reliability-risk or behavior-owned review
   slices. Use depth only as a discovery aid; do not assign a broad recursive
   subtree merely because it is a first-level subfolder.
7. If the scope is too broad for a credible single pass, select the highest-risk
   slices first and initialize coverage entries for reviewed deeply, skimmed,
   excluded, and deferred slices. Deferred entries must be exact follow-up
   scopes such as `path/to/package` or `path/to/package/subpackage`.
8. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, destructive, or otherwise approval-gated commands.
9. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
10. Wait for all review work to finish.
11. Update coverage state for every planned slice before judging the requested
    scope.
12. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against code, config, tests, docs, and CI.
13. For candidates based on prose contradicting implementation, prove with
    non-prose evidence that the implementation or repository-owned reliability
    control is wrong; otherwise classify the mismatch as a documentation gap.
14. Confirm each gap names a current reliability promise or operational
    expectation, trigger, failure mode, missing or weak control, and user or
    operator impact.
15. Run a final finding calibration pass:
    - Does the trigger exist in current supported operation?
    - Is the missing control repository-owned rather than normal review, CI, or
      deployment discipline?
    - Are existing controls insufficient for this repository's workflow?
    - Would a skeptical maintainer likely agree this is more than optional
      hardening?
    If any answer is no, discard the candidate or move it to optional follow-up.
16. Reject generic maturity advice, future-scale assumptions, private
    preferences, and findings that belong in code, security, test, or doc
    ledgers.
17. If no confirmed gaps remain, report that result with the coverage state, do
    not create `RELIABILITY.md`, and stop.
18. If confirmed gaps remain, write the scoped `RELIABILITY.md` with
    `REL-<number>` IDs.
19. Present the scoped ledger, proposed reliability-fix plan, coverage state for
    broad scopes, and runnable follow-up scopes for deferred slices.
20. Stop before making fixes.

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
