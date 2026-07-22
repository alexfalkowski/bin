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
3. Present the `SKILL.md#implementation-proposal-gate` decision packet before
   asking for agreement. It must lead with `## Solution Shape`, make the
   proposed design visually scannable before confidence or evidence details,
   show tradeoffs visually, name intended validation, and end by pointing to
   the canonical `Approved <ID>-N`, `Approved <ID>-N[/N...]`, and
   `Approved <ID>-N with agents` approval commands.
4. After agreement, state local code/config/docs pattern, dominant relevant
   test harness, planned validation, and deviations. For behavior-changing
   features, also state the feature execution checklist: TDD decision, first
   test/scenario, expected red, intended green change, refactor checkpoint, and
   validation. When the harness is runnable, observe and paste the red before
   implementation edits; if it is not runnable, stop and request agreement to
   proceed test-after with the reason instead of skipping red silently.
5. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
   `$naming-standards`, relevant language standards, and `$change-validation`
   as required, then report `Red`, `Green`, `Refactor`, and `Validation`.
   `Red` and `Green` must each paste the actual command and its real output
   using the same command/selector; label work as `test-after (not TDD)` with
   the reason when red was never observed before implementation.
