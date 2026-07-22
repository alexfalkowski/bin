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
   fixes, state the reliability execution checklist: TDD decision, first
   test/scenario, expected red, intended green change, refactor checkpoint, and
   validation. When the harness is runnable, observe and paste the red before
   implementation edits; if it is not runnable, stop and request agreement to
   proceed test-after with the reason instead of skipping red silently.
6. Use `$reliability-standards`, `$change-safety`, `$testing-standards`,
   `$change-validation`, and `$security-audit` as required, then report `Red`,
   `Green`, `Refactor`, and `Validation`. `Red` and `Green` must each paste the
   actual command and its real output using the same command/selector; label
   work as `test-after (not TDD)` with the reason when red was never observed
   before implementation.
