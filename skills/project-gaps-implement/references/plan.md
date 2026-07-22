# Project Gaps Implement Plan

Use this reference to instantiate the project-gap-specific active plan for
`$project-gaps-implement`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and implementation gates.

Track project-gap-specific state for scope, audience, implementation home,
validation, delegation, and ledger state.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected proposal against current Makefiles, CI config, scripts,
   docs, tests, examples, command behavior, architecture, and comparable
   workflow evidence.
3. If the proposal is already supported, stale, duplicate, belongs elsewhere, or
   has an implementation home outside scope, propose removing, moving, or
   reclassifying it before local implementation.
4. Confirm the project workflow evidence, audience, implementation home,
   repository fit, proposal, compatibility and maintenance tradeoffs, and
   intended validation still fit the current repository.
5. Before editing, state local project workflow pattern, dominant relevant
   validation path, planned validation, and deviations. For behavior-changing
   project workflow changes, state the project execution checklist: TDD
   decision, first test/scenario or dry-run, expected red, intended green
   change, refactor checkpoint, and validation. When the harness is runnable,
   observe and paste the red before implementation edits; if it is not runnable,
   stop and request agreement to proceed test-after with the reason instead of
   skipping red silently.
6. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
   `$naming-standards`, relevant language standards, and `$change-validation`
   as required, then report `Red`, `Green`, `Refactor`, and `Validation`.
   `Red` and `Green` must each paste the actual command and its real output
   using the same command/selector; label work as `test-after (not TDD)` with
   the reason when red was never observed before implementation.
