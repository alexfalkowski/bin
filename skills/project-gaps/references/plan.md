# Project Gaps Plan

Use this reference to instantiate the project-gap-specific active plan for
`$project-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, and implementation gates.

Track project-gap-specific state for scope, audience, project workflow surface,
implementation home, validation, delegation, ledger state, and workflow routing.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `PROJECTS.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   Make targets, scripts, release/versioning flows, validation entrypoints, and
   `./bin` wiring.
4. Identify the project workflow surface in scope, including Make targets and
   fragments, CI jobs, setup flows, validation and local preflight flows,
   release/versioning/publishing paths, reusable scripts, command discovery,
   generated-artifact checks, and downstream shared-tooling integration.
5. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, Makefiles, CI config, scripts, validation entrypoints,
   release/deploy/versioning surfaces, setup flows, command discovery surfaces,
   generated/vendor/build/cache exclusions, tests, docs, examples, and likely
   project workflow extension points.
6. Split the inventory into bounded project-workflow, command-surface, or
   audience-owned review slices. Use depth only as a discovery aid; do not
   assign a broad recursive subtree merely because it is a first-level
   subfolder.
7. If the scope is too broad for a credible single pass, select the highest-
   value slices first and initialize coverage entries for reviewed deeply,
   skimmed, excluded, and deferred slices. Deferred entries must be exact
   follow-up scopes such as `path/to/package` or `path/to/package/subpackage`.
8. Decide whether comparable CI, build, release, or developer workflow research
   is needed. Use allowed research tools when they materially improve proposal
   quality; ask permission before approval-gated network, auth, clone, or
   remote-write commands.
9. Apply the shared gap-workflow delegation gate before review work.
10. Wait for all review work to finish.
11. Update coverage state for every planned slice before judging the requested
    scope.
12. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against Makefiles, CI config, scripts, docs, tests, examples,
    command behavior, and current architecture.
13. Apply `SKILL.md#acceptance-gate` to each candidate and confirm the project
    gap names the audience, current limitation, repository-owned project
    surface, implementation home, evidence of value, repository fit, smallest
    plausible implementation path, compatibility and maintenance tradeoffs,
    validation path, upstream or third-party ownership when relevant, and
    correct workflow routing.
14. Reject novelty, competitor checklists, trend-following, broad rewrites,
    new-framework preferences, future-roadmap assumptions, optional polish, and
    findings that belong in feature, code, security, reliability, test, doc, or
    naming workflows.
15. Route candidates whose implementation home is outside the requested scope to
    `Routed Project Follow-Ups` or to a separate project-gaps run in the owning
    repository or shared tooling scope; do not record them as normal
    `PROJECT-<number>` entries for the current scope. For third-party
    dependency, tool, image, or project-owned upstream-library defects, record a
    normal project gap only for the current scope's dependency/workflow response
    such as upgrade, pin, workaround, replacement, validation, or upstream issue
    tracking.
16. If no confirmed project gaps remain, report that result with the coverage
    state, do not create `PROJECTS.md`, and stop.
17. If confirmed project gaps remain, write the scoped `PROJECTS.md` with
    `PROJECT-<number>` IDs.
18. Present the scoped ledger, proposed implementation plan, coverage state for
    broad scopes, and runnable follow-up scopes for deferred slices.
19. Stop before implementing project changes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `PROJECTS.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, Make targets, scripts, release/versioning flows, validation
   entrypoints, and `./bin` wiring.
4. Select the next proposal by ID unless the human named a specific project
   gap.
5. Re-check the proposal against current Makefiles, CI config, scripts, docs,
   tests, examples, command behavior, architecture, and comparable workflow
   evidence.
6. If the proposal is already supported, no longer fits, duplicates another
   proposal, belongs in another workflow, or has an implementation home outside
   the requested scope, explain that and propose removing, moving, or
   reclassifying it before any local implementation.
7. Present the project workflow evidence, audience, implementation home,
   repository fit, proposed solution, compatibility and maintenance tradeoffs,
   and intended validation.
8. Stop until the human explicitly agrees to that project-gap solution. A named
   fix, implement, or verify request selects the project gap and permits
   re-checking evidence and refreshing the proposal, but it is not approval to
   edit unless the request also explicitly agrees to the proposed solution. If
   the proposal was already presented and remains unchanged after re-checking,
   state only the concise approval gate instead of repeating the full proposal.
9. After agreement, state the local project workflow pattern, dominant relevant
   validation path, planned validation, and any needed deviation.
10. If a deviation is needed, stop and ask before editing.
11. For behavior-changing project workflow changes, state the project execution
    checklist: TDD decision, first test/scenario or dry-run, expected red,
    intended green change, refactor checkpoint, and validation.
12. Implement only the agreed project gap with the smallest clear change.
13. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
    `$naming-standards`, relevant language standards, and `$change-validation`
    as required by the touched surface.
14. Validate the project workflow change through repository Make targets,
    documented entrypoints, CI dry-runs, lint, or manual checks.
15. Report `Red`, `Green`, `Refactor`, and `Validation`, then ask the human to
    verify with `PROJECT-<number> is done`.
16. Stop until that confirmation arrives.
17. After confirmation, remove or revise the proposal in scoped `PROJECTS.md`.
18. Continue with the next proposal, or delete scoped `PROJECTS.md` after all
    project gaps are confirmed resolved.
