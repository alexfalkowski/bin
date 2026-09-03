# Feature Gaps Implement Plan

Use this reference to instantiate the feature-gap-specific active plan for
`$feature-gaps-implement`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and implementation gates.

Track feature-gap-specific state for scope, audience, product surface,
validation, delegation, ledger state, and workflow routing.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected proposal against current code, generated surfaces,
   framework wrappers, shared helpers, vendored dependency behavior when
   delegated, docs, tests, examples, command behavior, architecture, and
   comparable-tool evidence.
3. Confirm the ledger entry's product evidence, solution shape, tradeoffs, and
   intended validation still fit the current repository.
4. Before editing, state local code/config/docs pattern, dominant relevant
   test harness, planned validation, and deviations. For behavior-changing
   features, use the same execution fields before editing and at completion:
   `Behavior`, `Coverage`, `Change`, `Refactor`, and `Validation`. Do not
   prescribe whether tests or implementation must be written first.
5. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
   `$naming-standards`, relevant language standards, and `$change-validation`
   as required, then report those fields using the observed behavior, actual
   change, coverage, refactor assessment, validation commands, and outcomes
   observed.
