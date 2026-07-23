# Test Gaps Find Plan

Use this reference to instantiate the test-gap-specific active plan for
`$test-gaps-find`. Read it with the shared gap workflow named in `SKILL.md`;
that shared gap workflow owns common plan state, optional goal state,
scoped-ledger, delegation, and coverage gates.

Track test-gap-specific state for scope, dominant test harness, test-support
surface, delegation, ledger state, and repository-owned behavior.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. When resolving a scoped ledger path or entry ID, read
   `../../test-gaps-implement/ledger.yaml`; use its scoped ledger path and ID
   prefix.
3. After the repository archetype and audit scope make lead generation
   relevant, read `../../references/gap-lead-generation.md` and build a lead
   inventory for public behavior, dominant harness,
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
   `$project-gaps-find`.
7. For prose mismatches, prove expected behavior with non-prose evidence before
   treating missing coverage as a test gap; otherwise route to documentation.
8. Before a no-gap closeout, name protected behaviors, public commands/APIs or
   documented workflows, dominant harnesses, nearby tests, test-support
   surfaces, rejected and routed leads, validation evidence, and policy
   exclusions checked.
9. If confirmed gaps remain, write the resolved scoped ledger, present it,
   coverage state, proposed test-fix plan, and runnable follow-up scopes, then
   stop before fixing. Fixing happens only in `$test-gaps-implement` after its
   ledger re-check.
