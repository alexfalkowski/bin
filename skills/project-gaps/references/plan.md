# Project Gaps Plan

Use this reference to instantiate the project-gap-specific active plan for
`$project-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
shared gap workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, validation, and implementation gates.

Track project-gap-specific state for scope, audience, project workflow surface,
implementation home, validation, delegation, ledger state, and workflow routing.

## Find Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   find-mode sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Use `PROJECTS.md` as the scoped ledger and `PROJECT-<number>` IDs.
3. Inventory Make targets and fragments, CI jobs, setup flows, validation and
   local preflight flows, release/versioning/publishing paths, reusable scripts,
   command discovery, generated-artifact checks, downstream shared-tooling
   integration, and comparable workflow research when useful.
4. Apply `SKILL.md#acceptance-gate` to each candidate and confirm audience,
   current limitation, repository-owned project surface, implementation home,
   value evidence, repository fit, smallest plausible implementation path,
   compatibility and maintenance tradeoffs, validation path, upstream or
   third-party ownership when relevant, and correct workflow routing.
5. Reject novelty, competitor checklists, trend-following, broad rewrites,
   new-framework preferences, future-roadmap assumptions, optional polish, and
   findings belonging in feature, code, security, reliability, test, doc, or
   naming workflows.
6. Route candidates whose implementation home is outside the requested scope to
   routed follow-ups or to a separate project-gaps run; record a normal project
   gap only for the current scope's dependency or workflow response.
7. Before a no-gap closeout, name Make targets, CI jobs, scripts, setup flows,
   validation and release paths, command-discovery surfaces, implementation
   homes, routing decisions, validation evidence, and policy exclusions checked.
8. If confirmed gaps remain, write scoped `PROJECTS.md`, present the ledger,
   coverage state, proposed implementation plan, and runnable follow-up scopes,
   then stop before implementing project changes.

## Implement Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   implement-mode sequencing.
2. Re-check the selected proposal against current Makefiles, CI config, scripts,
   docs, tests, examples, command behavior, architecture, and comparable
   workflow evidence.
3. If the proposal is already supported, stale, duplicate, belongs elsewhere, or
   has an implementation home outside scope, propose removing, moving, or
   reclassifying it before local implementation.
4. Present project workflow evidence, audience, implementation home, repository
   fit, proposed solution, compatibility and maintenance tradeoffs, and intended
   validation before asking for agreement.
5. After agreement, state local project workflow pattern, dominant relevant
   validation path, planned validation, and deviations. For behavior-changing
   project workflow changes, state the project execution checklist: TDD
   decision, first test/scenario or dry-run, expected red, intended green
   change, refactor checkpoint, and validation.
6. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
   `$naming-standards`, relevant language standards, and `$change-validation`
   as required, then report `Red`, `Green`, `Refactor`, and `Validation`.
