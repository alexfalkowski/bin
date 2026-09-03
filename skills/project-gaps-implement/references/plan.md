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
   project workflow changes, use the same execution fields before editing and
   at completion: `Behavior`, `Evidence`, `Change`, `Refactor`, and
   `Validation`. Do not prescribe whether tests or implementation must be
   written first.
6. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
   `$naming-standards`, relevant language standards, and `$change-validation`
   as required, then report those fields using the observed behavior, actual
   change, evidence, refactor assessment, validation commands, and outcomes
   observed.
