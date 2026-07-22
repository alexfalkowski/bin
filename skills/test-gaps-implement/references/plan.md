# Test Gaps Implement Plan

Use this reference to instantiate the test-gap-specific active plan for
`$test-gaps-implement`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and implementation gates.

Track test-gap-specific state for scope, dominant test harness, validation,
delegation, and ledger state.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected gap against current code, tests, fixtures, harnesses,
   and test-support surfaces.
3. Confirm the ledger entry's evidence, proposed test solution,
   repository-owned behavior, existing coverage gap, tradeoffs, and intended
   validation still fit the current repository.
4. Before editing, state the local test pattern, dominant relevant test
   harness, planned validation, and deviations.
5. Use `$testing-standards` and relevant language standards for test design,
   then validate with commands appropriate to the changed tests.
