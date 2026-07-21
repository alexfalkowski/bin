# Test Gaps Plan

Use this reference to instantiate the test-gap-specific active plan for
`$test-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
shared gap workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, validation, and implementation gates.

Track test-gap-specific state for scope, dominant test harness, test-support
surface, validation, delegation, ledger state, and repository-owned behavior.

## Find Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Read `../ledger.yaml`; use its scoped ledger path and ID prefix.
3. Read `../../references/gap-lead-generation.md`, classify the repository
   archetype, and build a lead inventory for public behavior, dominant harness,
   fixtures, generated stubs, service-feature coverage, failure paths,
   determinism, and harness support in scope.
4. Inventory existing tests, fixtures, helpers, test-support code, dominant
   relevant harnesses, public entrypoints, documented workflows, generated and
   vendored exclusions, and repository-owned behavior in scope.
5. Confirm each gap protects repository-owned behavior or fixes a concrete
   test-harness weakness that makes coverage brittle, misleading, wrong-layer,
   duplicated, non-deterministic, environment-bound, or unavailable.
6. Reject duplicate, private-only, dependency-only, optional, implementation-only
   or no-front-door candidates, and route pure project workflow concerns to
   `$project-gaps`.
7. For prose mismatches, prove expected behavior with non-prose evidence before
   treating missing coverage as a test gap; otherwise route to documentation.
8. Before a no-gap closeout, name protected behaviors, public commands/APIs or
   documented workflows, dominant harnesses, nearby tests, test-support
   surfaces, rejected and routed leads, validation evidence, and policy
   exclusions checked.
9. If confirmed gaps remain, write the resolved scoped ledger, present it,
   coverage state, proposed test-fix plan, and runnable follow-up scopes, then
   stop before fixing.

## Implement Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected gap against current code, tests, fixtures, harnesses,
   and test-support surfaces.
3. Present finding evidence, proposed test solution, repository-owned behavior,
   existing coverage gap, tradeoffs, and intended validation before asking for
   agreement.
4. After agreement, state the local test pattern, dominant relevant test
   harness, planned validation, and deviations.
5. Use `$testing-standards` and relevant language standards for test design,
   then validate with commands appropriate to the changed tests.
