# Gap Workflow: Implementation

Read `../gap-workflow.md` first. This reference contains mechanics that apply only
while implementing an agreed gap-ledger entry.

## Implement Mechanics

1. Confirm scope and selected ledger skill, read its `ledger.yaml`, resolve the
   exact scoped ledger path, and read only that path. Do not search the
   workspace for possible ledgers. If the resolved ledger is missing, stop and
   ask whether to run the matching find mode first.
2. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, relevant public surfaces, and `./bin` wiring.
3. Select the named entry or next entry and re-check its evidence against
   current code, docs, tests, commands, and generated/workflow surfaces.
4. If it is resolved, stale, duplicated, out of scope, or owned elsewhere,
   explain the routing and propose removing, moving, or reclassifying it before
   editing.
5. Present evidence, solution, tradeoffs, and validation as a self-contained
   decision card using `../decision-card.md`. It must restate enough `What`,
   `Why`, and `How` that the human need not open the ledger or source files.
   Stop until the human explicitly agrees. A named fix, implement, or verify
   request selects an entry and permits evidence refresh, but is not approval to
   edit unless it also agrees to the proposed solution.
6. After agreement, state the local pattern, dominant harness or validation
   path, planned validation, and any deviation. Stop before deviating from
   repository instructions, the selected skill, or local workflow.
7. Implement only the agreed entry with the smallest clear change, using paired
   standards and validation skills from the selected plan.
8. Validate through repository Make targets or documented entrypoints, then ask
   the human to verify with `Done ID`.
9. Stop until confirmation. After confirmation, remove or revise the entry and
   continue with the next, or delete the scoped ledger when all entries are
   confirmed resolved.

## Implementation Gates

- Work through scoped entries sequentially by ID unless the human names a
  different entry.
- Before proposing a fix, re-check current code, docs, tests, config, CI,
  command behavior, and nearby patterns. Treat ledgers as stale and dismiss or
  revise entries that are resolved, duplicated, invalid, or owned elsewhere.
- Stop after proposing a solution. Do not edit files, update the ledger, or
  start validation until the human explicitly agrees to that solution. A request
  naming multiple entries does not permit editing the first one.
- Ask when behavior, compatibility, documentation location, test layer,
  implementation home, validation, operator workflow, or intent is too
  ambiguous to infer safely.
- After agreement, state the selected local pattern, dominant relevant harness
  or validation path, planned command, and any deviation. If a deviation is
  needed, stop and ask before editing.
- When an execution checklist includes `Expected red`, confirm the harness can
  run and paste the exact failing command/output before behavior edits. The
  reported `Green` must use that same command and pass. If the harness is not
  runnable, stop and either make it runnable or request agreement for named
  test-after work. Silent test-after and invented red/green reports are
  prohibited.
- For substantial, ambiguous, or multi-iteration work, use
  `../long-running-work.md` after the agreement gate. Keep progress in runtime
  state, work in thin validated slices, and do not use it to combine modes,
  bypass approval, or edit outside scope.
- When the current request authorizes agents, use them for disjoint slices,
  validation support, or fresh review when they materially improve throughput,
  coverage, confidence, or implementation safety. Keep one active entry owner
  and preserve all validation, review, and human-confirmation gates.
- Implement only the agreed entry using existing local patterns.
- Before accepting substantial work as complete, run the fresh review gate from
  `../long-running-work.md`. Without authorized agents, perform a named local
  challenge pass and do not call it independent review. If agents were
  authorized and available but independent review did not run, do not report
  completion at or above the active confidence threshold.
- During automatic continuations while waiting for approval or `Done ID`, state
  the waiting gate once without repeating the full proposal.
- Do not move to the next entry until the human confirms `Done ID`. After that
  confirmation, remove or revise the entry; remove it only after explaining an
  invalidation and getting agreement. Delete the scoped ledger when all entries
  are confirmed done.
