# Reliability Gaps Plan

Use this reference to instantiate the active execution plan for
`$reliability-gaps`. The active plan is runtime state. Do not write it into the
repository unless the human explicitly asks for a durable plan file. In
downstream repositories that vendor this project as `./bin`, instantiate the
plan from the consuming repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate based
  on silence or a broad request.
- Update the active plan when scope, reliability surface, validation,
  delegation, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Record durable findings only in the scoped `ISSUES.md` ledger defined by the
  skill.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `ISSUES.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   operational docs, release/config surfaces, and `./bin` wiring.
4. Identify the reliability surface in scope, including services, APIs, CLIs,
   jobs, scripts, deployment/config, observability, release, recovery, and
   operability evidence.
5. Build the read-only reliability review delegation plan from the requested
   root and its first-level subfolders.
6. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, destructive, or otherwise approval-gated commands.
7. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
8. Wait for all review work to finish.
9. Deduplicate candidates and directly re-check conflicting or overlapping
   conclusions against code, config, tests, docs, and CI.
10. Confirm each gap names a current reliability promise or operational
    expectation, trigger, failure mode, missing or weak control, and user or
    operator impact.
11. Reject generic maturity advice, future-scale assumptions, private
    preferences, and findings that belong in code, security, test, or doc
    ledgers.
12. If no confirmed gaps remain, report that result and do not create
    `ISSUES.md`.
13. If confirmed gaps remain, write the scoped `ISSUES.md` with `REL-<number>`
    IDs.
14. Present the scoped ledger and proposed reliability-fix plan.
15. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `ISSUES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, operational docs, release/config surfaces, and `./bin` wiring.
4. Select the next finding by ID unless the human named a specific finding.
5. Re-check the finding against current code, config, tests, docs, and CI.
6. Present the finding evidence, affected reliability promise or operational
   expectation, proposed solution, tradeoffs, and intended validation.
7. Stop until the human explicitly agrees to that finding's solution.
8. After agreement, state the local code/config/docs pattern, dominant relevant
   test harness, planned validation, and any needed deviation.
9. If a deviation is needed, stop and ask before editing.
10. For behavior-changing fixes, state the reliability execution checklist:
    TDD decision, first test/scenario, expected red, intended green change,
    refactor checkpoint, and validation.
11. Implement only the agreed reliability gap with the smallest clear change.
12. Use `$reliability-standards`, `$change-safety`, `$testing-standards`,
    `$change-validation`, and `$security-audit` as required by the touched
    surface.
13. Validate the reliability change through repository Make targets or
    documented entrypoints.
14. Report `Red`, `Green`, `Refactor`, and `Validation`, then ask the human to
    verify with `REL-<number> is done`.
15. Stop until that confirmation arrives.
16. After confirmation, remove or revise the finding in scoped `ISSUES.md`.
17. Continue with the next finding, or delete scoped `ISSUES.md` after all gaps
    are confirmed resolved.
