# Feature Gaps Plan

Use this reference to instantiate the feature-gap-specific active plan for
`$feature-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
shared gap workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, validation, and implementation gates.

Track feature-gap-specific state for scope, audience, product surface,
validation, delegation, external research, ledger state, and workflow routing.

## Find Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Use `FEATURES.md` as the scoped ledger and `FEATURE-<number>` IDs.
3. Read `../../references/gap-lead-generation.md`, classify the repository
   archetype, and build a lead inventory for product-facing capabilities,
   package-consumer workflows, service-author workflows, operator surfaces, and
   shared-tooling capability when applicable.
4. Inventory product-owned CLIs, APIs, libraries, service/operator behavior,
   package-consumer or service-author workflows, shipped templates, examples,
   docs, integrations, setup/onboarding flows, extension points, and comparable
   product, library, CLI, or system research when it materially improves
   proposal quality.
5. Route standalone test-harness, CI, build, Makefile, release, validation,
   command discovery, setup, and repository workflow concerns to `$test-gaps` or
   `$project-gaps`.
6. Challenge each candidate against existing product surfaces before accepting
   it: APIs, commands, endpoints, generated contracts, runtime health/metrics,
   docs, examples, configuration, supported workflows, framework behavior, and
   shared helpers. Keep only candidates with a concrete residual gap after that
   coverage is accounted for.
7. Apply `SKILL.md#acceptance-gate` to each candidate and confirm audience,
   current product limitation, existing coverage, residual gap, practical
   audience benefit, common-operation evidence, repository-owned surface, value
   evidence, repository fit, smallest plausible implementation path,
   compatibility and maintenance tradeoffs, validation path, and correct
   workflow routing.
8. Reject novelty, competitor checklists, trend-following, broad rewrites,
   new-framework preferences, future-roadmap assumptions, optional polish, vague
   benefits without concrete audience outcome, uncommon operations without
   evidence that the named audience needs them, and findings belonging to other
   workflows.
9. Before a no-gap closeout, name audiences, product surfaces, documented
   workflows, public commands/APIs or package-consumer paths, comparable-tool
   research decisions, rejected and routed leads, validation evidence, and
   policy exclusions checked.
10. If confirmed gaps remain, write scoped `FEATURES.md`, present the ledger,
   coverage state, proposed implementation plan, and runnable follow-up scopes,
   then stop before implementing features.

## Implement Mode Plan

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
   the canonical `Approved. Continue.` and `Agent approved. Continue.`
   approval commands.
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
