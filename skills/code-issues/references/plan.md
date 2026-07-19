# Code Issues Plan

Use this reference to instantiate the code-issue-specific active plan for
`$code-issues`. Read it with the shared gap workflow named in `SKILL.md`; that
shared gap workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, validation, and implementation gates.

Track code-issue-specific state for scope, validation, delegation, ledger
state, code/security/compatibility evidence, and public contract evidence.

## Find Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Before spawning slice reviewers, assign each an explicit model by risk
   class: a cheaper tier for lower-judgment slices such as configuration
   parsing, test-support/fixtures, and file-tracing, and the strongest tier
   for high-judgment slices such as crypto/token, concurrency/proxy, and
   security-sensitive code, unless the finder-plus-verifier exception in
   `../../references/gap-workflow.md#delegation-and-permissions` applies.
   Prefer a read-only agent type when one is available, because Find-mode
   reviewers do not edit. Never leave a sub-agent's model unset; an unset
   model silently inherits the session model.
3. Use `ISSUES.md` as the scoped ledger and `ISSUE-<number>` IDs.
4. Run `$project-workflow` discovery and the shared audit preflight, including
   applicable tools, service dependencies, validation ladder, and command
   failure classification.
5. Read `../../references/gap-lead-generation.md`, classify the repository
   archetype, and build a lead inventory for code, compatibility, security,
   mapping, generated-contract, and supported-usage risks in scope.
6. Inventory tests, public entrypoints, security-sensitive surfaces, supported
   construction/wiring paths, generated/provider mappings, and repository policy
   exclusions relevant to the requested scope.
7. Confirm each finding is a concrete code issue, security issue,
   compatibility break, or public contract violation. For prose mismatches,
   prove implementation is wrong with non-prose evidence; otherwise route to a
   documentation gap.
8. Before a no-issue closeout, name the public APIs, constructors, exported
   helpers, supported DI or documented usage paths, real call sites,
   nil/error/edge behavior, tests or CI evidence, and policy exclusions
   checked, plus rejected, routed, deferred, and blocked leads. For
   high-assurance closure, also account for materially relevant bug classes such
   as parser/decoder behavior, serialization, boundary/default values,
   nil/error/panic paths, concurrency, resource limits, mapping drift, public
   API compatibility, and supported construction paths.
9. If representative fuzz, property, race, stress, fixture, integration,
   analyzer, or generated freshness evidence is missing for a relevant class,
   report it as a confidence limiter or route it to the right workflow; do not
   record it as a code issue unless a concrete bug or violated contract is
   confirmed.
10. If confirmed issues remain, write scoped `ISSUES.md`, present the ledger,
    coverage state, proposed fix plan, and runnable follow-up scopes, then stop
    before fixing.

## Implement Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected issue against current code and tests. If it depends on
   prose contradicting implementation, prove the code is wrong with non-prose
   evidence before proposing a code change; otherwise propose documentation
   reclassification or fix.
3. Present issue evidence, proposed solution, compatibility or behavior
   tradeoffs, and intended validation before asking for agreement.
4. After agreement, state the local code pattern, dominant relevant test
   harness, planned validation, and deviations.
5. Use `$testing-standards` for regression coverage decisions and validate with
   commands appropriate to the changed files.
