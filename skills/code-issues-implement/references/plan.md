# Code Issues Implement Plan

Use this reference to instantiate the code-issue-specific active plan for
`$code-issues-implement`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and implementation gates.

Track code-issue-specific state for scope, validation, delegation, ledger
state, and code/security/compatibility evidence.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected issue against current code and tests. If it depends on
   prose contradicting implementation, prove the code is wrong with non-prose
   evidence before proposing a code change; otherwise propose documentation
   reclassification or fix via `$doc-gaps-fix`.
3. Present issue evidence, proposed solution, compatibility or behavior
   tradeoffs, and intended validation before asking for agreement.
4. After agreement, state the local code pattern, dominant relevant test
   harness, planned validation, and deviations.
5. Use `$testing-standards` for regression coverage decisions and validate with
   commands appropriate to the changed files.
