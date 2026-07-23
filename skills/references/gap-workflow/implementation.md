# Gap Workflow: Implementation

Navigation: `SKILL.md` already requires the complete `../gap-workflow.md` read
before this reference. These mechanics apply only while implementing a
confirmed gap-ledger entry.

## Implement Mechanics

1. Confirm scope and selected ledger skill, read its `ledger.yaml`, resolve the
   exact scoped ledger path, and read only that path. Do not search the
   workspace for possible ledgers. If the resolved ledger is missing, stop and
   ask whether to run the matching find mode first.
2. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, relevant public surfaces, and `./bin` wiring.
3. Select the named entry or ordered batch, re-read the resolved ledger, and
   confirm every requested entry is a current, confirmed finding before the
   first edit. Then select only the first entry and re-check its evidence
   against current code, docs, tests, commands, and generated/workflow
   surfaces.
4. If it is resolved, stale, duplicated, out of scope, or owned elsewhere,
   explain the routing and propose removing, moving, or reclassifying it before
   editing.
5. State the local pattern, dominant harness or validation
   path, planned validation, and any deviation. Stop before deviating from
   repository instructions, the selected skill, or local workflow.
6. Implement the confirmed entry with the smallest clear change, using paired
   standards and validation skills from the selected plan.
7. Validate through repository Make targets or documented entrypoints. For a
   batch, re-read the resolved ledger and re-check the next requested entry
   before editing it.
8. After validating a single entry, remove or revise it in the ledger and report
   completion. For a batch, continue only after the previous entry is
   implemented and validated, without parallelizing entries. Re-check the next
   entry before editing it; delete the scoped ledger when all entries resolve.

## Implementation Gates

- Work through scoped entries sequentially by ID unless the human names a
  different entry. A named same-prefix batch is an ordered exception: work
  through only its listed entries, one at a time, in the order given.
- Before implementation, re-check current code, docs, tests, config, CI,
  command behavior, and nearby patterns. Treat ledgers as stale and dismiss or
  revise entries that are resolved, duplicated, invalid, or owned elsewhere.
- Ask when behavior, compatibility, documentation location, test layer,
  implementation home, validation, operator workflow, or intent is too
  ambiguous to infer safely.
- Before editing, state the selected local pattern, dominant relevant harness
  or validation path, planned command, and any deviation. If a deviation is
  needed, stop and ask before editing.
- When an execution checklist includes `Expected red`, confirm the harness can
  run and paste the exact failing command/output before behavior edits. The
  reported `Green` must use that same command and pass. If the harness is not
  runnable, stop and either make it runnable or request agreement for named
  test-after work. Silent test-after and invented red/green reports are
  prohibited.
- For substantial, ambiguous, or multi-iteration work, use
  `../long-running-work.md`. Keep progress in runtime state, work in thin
  validated slices, and do not use it to combine modes or edit outside scope.
- When the current request authorizes agents, use them for disjoint slices,
  validation support, or fresh review when they materially improve throughput,
  coverage, confidence, or implementation safety. Keep one active entry owner
  and preserve all validation and review gates.
- Implement only the confirmed entry using existing local patterns.
- After each implemented and validated batch item, re-read the resolved ledger
  and re-check the next entry before editing it. Stop the batch before editing
  that entry if the preceding change makes its proposal stale, conflicting,
  unnecessary, invalid, or otherwise unsafe; report the implemented and
  validated entries separately from the remaining entries and the stop reason.
- Before accepting substantial work as complete, run the fresh review gate from
  `../long-running-work.md`. Without authorized agents, perform a named local
  challenge pass and do not call it independent review. If agents were
  authorized and available but independent review did not run, do not report
  completion at or above the active confidence threshold.
- Within a named batch, move to the next listed entry only after the preceding
  one is implemented and validated and its successor passes the re-check above.
  After validation, remove or revise an entry; remove it only after explaining
  an invalidation. Delete the scoped ledger when all entries are resolved.
