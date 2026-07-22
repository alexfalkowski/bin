# Project Gaps Find Plan

Use this reference to instantiate the project-gap-specific active plan for
`$project-gaps-find`. Read it with the shared gap workflow named in
`SKILL.md`; that shared gap workflow owns common plan state, optional goal
state, scoped-ledger, delegation, and coverage gates.

Track project-gap-specific state for scope, audience, project workflow
surface, implementation home, delegation, ledger state, and workflow routing.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Read `../../project-gaps-implement/ledger.yaml`; use its scoped ledger path
   and ID prefix.
3. Read `../../references/gap-lead-generation.md`, classify the repository
   archetype, and build a lead inventory for build, CI, release, setup,
   validation, command-discovery, dependency/tooling, generated-artifact, and
   shared `./bin` workflow surfaces in scope.
4. Inventory Make targets and fragments, CI jobs, setup flows, validation and
   local preflight flows, release/versioning/publishing paths, reusable scripts,
   command discovery, generated-artifact checks, downstream shared-tooling
   integration, and comparable workflow research when useful.
5. Apply `SKILL.md#acceptance-gate` to each candidate and confirm audience,
   current limitation, repository-owned project surface, implementation home,
   value evidence, repository fit, smallest plausible implementation path,
   compatibility and maintenance tradeoffs, validation path, upstream or
   third-party ownership when relevant, and correct workflow routing.
6. Reject novelty, competitor checklists, trend-following, broad rewrites,
   new-framework preferences, future-roadmap assumptions, optional polish, and
   findings belonging in feature, code, security, reliability, test, doc, or
   naming workflows.
7. Route candidates whose implementation home is outside the requested scope to
   routed follow-ups or to a separate project-gaps-find run; record a normal
   project gap only for the current scope's dependency or workflow response.
8. Before a no-gap closeout, name Make targets, CI jobs, scripts, setup flows,
   validation and release paths, command-discovery surfaces, implementation
   homes, rejected and routed leads, validation evidence, and policy exclusions
   checked.
9. If confirmed gaps remain, write the resolved scoped ledger, present it,
   coverage state, proposed implementation plan, and runnable follow-up scopes,
   then stop before implementing project changes. Implementing happens only in
   `$project-gaps-implement` after its ledger re-check.
