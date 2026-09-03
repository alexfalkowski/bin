# Reliability Gaps Implement Plan

Use this reference to instantiate the reliability-gap-specific active plan for
`$reliability-gaps-implement`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and implementation gates.

Track reliability-gap-specific state for scope, validation, delegation, ledger
state, operational expectation, and failure-mode evidence.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected finding against current code, config, tests, docs, and
   CI.
3. If the finding depends on prose contradicting implementation, prove the
   implementation or reliability control is wrong with non-prose evidence
   before proposing a reliability change; otherwise propose documentation
   reclassification via `$doc-gaps-fix`.
4. Confirm the finding evidence, affected reliability promise or operational
   expectation, proposal, tradeoffs, and intended validation still fit the
   current repository.
5. Before editing, state local code/config/docs pattern, dominant relevant
   test harness, planned validation, and deviations. For behavior-changing
   fixes, use the same execution fields before editing and at completion:
   `Behavior`, `Coverage`, `Change`, `Refactor`, and `Validation`. Do not
   prescribe whether tests or implementation must be written first.
6. Use `$reliability-standards`, `$change-safety`, `$testing-standards`,
   `$change-validation`, and `$security-audit` as required, then report those
   fields using the observed behavior, actual change, coverage, refactor
   assessment, validation commands, and outcomes observed.
