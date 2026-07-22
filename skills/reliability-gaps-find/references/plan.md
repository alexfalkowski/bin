# Reliability Gaps Find Plan

Use this reference to instantiate the reliability-gap-specific active plan for
`$reliability-gaps-find`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and coverage gates.

Track reliability-gap-specific state for scope, reliability surface,
delegation, ledger state, operational expectation, and failure-mode evidence.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Read `../../reliability-gaps-implement/ledger.yaml`; use its scoped ledger
   path and ID prefix.
3. Run `$project-workflow` discovery and the shared audit preflight, including
   applicable tools, service dependencies, validation ladder, and command
   failure classification.
4. Read `../../references/gap-lead-generation.md`, classify the repository
   archetype, and build a lead inventory for operational, overload, lifecycle,
   release-safety, observability, recovery, data-integrity, and operator
   diagnostic risks in scope.
5. Inventory services, APIs, CLIs, jobs, scripts, deployment/config,
   observability, release, recovery, operability evidence, tests, public
   entrypoints, reliability-sensitive surfaces, and generated/vendor/build/cache
   exclusions.
6. For prose mismatches, prove with non-prose evidence that the implementation
   or repository-owned reliability control is wrong; otherwise route to a
   documentation gap.
7. Confirm each gap names a current reliability promise or operational
   expectation, trigger, failure mode, missing or weak control, and user or
   operator impact.
8. Calibrate each candidate: the trigger exists in current supported operation,
   the missing control is repository-owned, existing controls are insufficient,
   and a skeptical maintainer would likely agree it is more than optional
   hardening. Reject generic maturity advice, future-scale assumptions, private
   preferences, and findings belonging in code, security, test, or doc ledgers.
9. Before a no-gap closeout, name cancellation/context handling, deadlines,
   timeouts, retries, backoff, bounded memory/network/file/process behavior,
   lifecycle cleanup, shutdown/drain/health/readiness behavior, observability or
   operator impact, CI/sidecar/runtime controls checked, and rejected, routed,
   deferred, or blocked leads.
10. For high-assurance closure, also account for dependency outage and recovery,
   cancellation and deadline propagation, retry/backoff/load-shedding
   interaction, shutdown ordering, repeated lifecycle start/stop behavior, queue
   or worker bounds, durable idempotency or reconciliation, telemetry of failure
   modes, release or rollback controls, and generated/config drift. Missing
   representative stress, race, outage, fault-injection, sidecar, integration,
   freshness, or operator-scenario evidence is a confidence limiter or routed
   follow-up unless a current repository-owned failure mode is confirmed.
11. If confirmed gaps remain, write the resolved scoped ledger, present it,
    coverage state, proposed reliability-fix plan, and runnable follow-up
    scopes, then stop before fixing. Fixing happens only in
    `$reliability-gaps-implement` after its ledger re-check.
