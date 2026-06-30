# Reliability Gaps Plan

Use this reference to instantiate the reliability-gap-specific active plan for
`$reliability-gaps`. Read it with the shared gap workflow named in `SKILL.md`;
that shared gap workflow owns common plan state, optional goal state,
scoped-ledger, delegation, coverage, validation, and implementation gates.

Track reliability-gap-specific state for scope, reliability surface,
validation, delegation, ledger state, operational expectation, and failure-mode
evidence.

## Find Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Use `RELIABILITY.md` as the scoped ledger and `REL-<number>` IDs.
3. Run `$project-workflow` discovery and the shared audit preflight, including
   applicable tools, service dependencies, validation ladder, and command
   failure classification.
4. Inventory services, APIs, CLIs, jobs, scripts, deployment/config,
   observability, release, recovery, operability evidence, tests, public
   entrypoints, reliability-sensitive surfaces, and generated/vendor/build/cache
   exclusions.
5. For prose mismatches, prove with non-prose evidence that the implementation
   or repository-owned reliability control is wrong; otherwise route to a
   documentation gap.
6. Confirm each gap names a current reliability promise or operational
   expectation, trigger, failure mode, missing or weak control, and user or
   operator impact.
7. Calibrate each candidate: the trigger exists in current supported operation,
   the missing control is repository-owned, existing controls are insufficient,
   and a skeptical maintainer would likely agree it is more than optional
   hardening. Reject generic maturity advice, future-scale assumptions, private
   preferences, and findings belonging in code, security, test, or doc ledgers.
8. Before a no-gap closeout, name cancellation/context handling, deadlines,
   timeouts, retries, backoff, bounded memory/network/file/process behavior,
   lifecycle cleanup, shutdown/drain/health/readiness behavior, observability or
   operator impact, and CI/sidecar/runtime controls checked.
9. For high-assurance closure, also account for dependency outage and recovery,
   cancellation and deadline propagation, retry/backoff/load-shedding
   interaction, shutdown ordering, repeated lifecycle start/stop behavior, queue
   or worker bounds, durable idempotency or reconciliation, telemetry of failure
   modes, release or rollback controls, and generated/config drift. Missing
   representative stress, race, outage, fault-injection, sidecar, integration,
   freshness, or operator-scenario evidence is a confidence limiter or routed
   follow-up unless a current repository-owned failure mode is confirmed.
10. If confirmed gaps remain, write scoped `RELIABILITY.md`, present the ledger,
    coverage state, proposed reliability-fix plan, and runnable follow-up
    scopes, then stop before fixing.

## Implement Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected finding against current code, config, tests, docs, and
   CI.
3. If the finding depends on prose contradicting implementation, prove the
   implementation or reliability control is wrong with non-prose evidence
   before proposing a reliability change; otherwise propose documentation
   reclassification.
4. Present finding evidence, affected reliability promise or operational
   expectation, proposed solution, tradeoffs, and intended validation before
   asking for agreement.
5. After agreement, state local code/config/docs pattern, dominant relevant
   test harness, planned validation, and deviations. For behavior-changing
   fixes, state the reliability execution checklist: TDD decision, first
   test/scenario, expected red, intended green change, refactor checkpoint, and
   validation.
6. Use `$reliability-standards`, `$change-safety`, `$testing-standards`,
   `$change-validation`, and `$security-audit` as required, then report `Red`,
   `Green`, `Refactor`, and `Validation`.
