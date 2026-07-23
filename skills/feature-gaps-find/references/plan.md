# Feature Gaps Find Plan

Use this reference to instantiate the feature-gap-specific active plan for
`$feature-gaps-find`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and coverage gates.

Track feature-gap-specific state for scope, audience, product surface,
delegation, external research, ledger state, and workflow routing.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. When resolving a scoped ledger path or entry ID, read
   `../../feature-gaps-implement/ledger.yaml`; use its scoped ledger path and
   ID prefix.
3. After the repository archetype and audit scope make lead generation
   relevant, read `../../references/gap-lead-generation.md` and build a lead
   inventory for product-facing capabilities,
   package-consumer workflows, service-author workflows, operator surfaces, and
   shared-tooling capability when applicable.
4. Inventory product-owned CLIs, APIs, libraries, service/operator behavior,
   package-consumer or service-author workflows, shipped templates, examples,
   docs, integrations, setup/onboarding flows, extension points, and comparable
   product, library, CLI, or system research when it materially improves
   proposal quality.
5. Route standalone test-harness, CI, build, Makefile, release, validation,
   command discovery, setup, and repository workflow concerns to
   `$test-gaps-find` or `$project-gaps-find`.
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
10. If confirmed gaps remain, write the resolved scoped ledger, present it,
   coverage state, proposed implementation plan, and runnable follow-up scopes,
   then stop before implementing features. Implementing happens only in
   `$feature-gaps-implement` after its ledger re-check.
