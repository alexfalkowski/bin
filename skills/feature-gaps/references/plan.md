# Feature Gaps Plan

Use this reference to instantiate the active execution plan for
`$feature-gaps`. The active plan is runtime state. Do not write it into the
repository unless the human explicitly asks for a durable plan file. In
downstream repositories that vendor this project as `./bin`, instantiate the
plan from the consuming repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate
  based on silence or a broad request.
- Update the active plan when scope, audience, product surface, validation,
  delegation, external research, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Before checking, reading, creating, or updating the scoped `FEATURES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `FEATURES.md` as a standalone pattern. If the pattern is missing, add it.
- Record durable feature proposals only in the scoped `FEATURES.md` ledger
  defined by the skill.
- In downstream repositories that vendor this project as `./bin`, exclude
  `bin/**` from recursive inventory, review slices, and durable proposals unless
  the requested scope is explicitly about shared `bin` tooling. Inspect only
  included shared fragments or selected skill guidance needed as evidence, and
  route upstream-only proposals to a separate `bin`-scoped run.
- Track broad-scope coverage explicitly as reviewed deeply, skimmed, excluded,
  and deferred. Deferred entries must name runnable follow-up scopes.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed feature gaps are found
  and reported, or when the scoped `FEATURES.md` ledger is written and
  presented.
- For broad scopes, a no-gap result is complete only when the summary states
  whether all high-value slices were deeply reviewed. If any relevant slice was
  skimmed or deferred, completion requires coverage notes and runnable
  follow-up scopes, not an unqualified all-scope no-gap claim.
- In Implement mode, the goal is waiting while the human has not approved the
  proposed feature solution, or after validation until the human confirms
  `FEATURE-<number> is done`.
- During automatic continuations while waiting for approval or done
  confirmation, state the waiting gate once and do not repeat the full
  proposal or result.
- In Implement mode, the goal is complete for a proposal only after the human
  confirms it is done and the scoped ledger is updated accordingly.
- Record a blocked reason when a required scope is missing, the scoped ledger
  required by the mode is absent or already exists in a conflicting state,
  required permission is denied, or the selected feature cannot be re-checked
  without human input. Follow runtime rules for when that reason changes goal
  status.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `FEATURES.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   docs, examples, public APIs, product-owned workflows, and `./bin` wiring.
4. Identify the product feature surface in scope, including CLIs, APIs,
   libraries, service/operator behavior, package-consumer or service-author
   workflows, shipped templates, examples, docs, integrations, product
   extension points, and product-owned setup or onboarding flows. Route
   standalone test-harness, CI, build, Makefile, release, validation, command
   discovery, setup, and repository workflow concerns to `$test-gaps` or
   `$project-gaps`.
5. Build a recursive scope inventory for the requested package or folder:
   relevant file count, first-level subfolders, nested packages, dominant
   languages, tests, public entrypoints, generated/vendor/build/cache
   exclusions, user-facing product surfaces, package-consumer or service-author
   surfaces, operator-facing surfaces, and likely product extension points.
6. Split the inventory into bounded feature-surface, workflow-owned, or
   audience-owned review slices. Use depth only as a discovery aid; do not
   assign a broad recursive subtree merely because it is a first-level
   subfolder.
7. If the scope is too broad for a credible single pass, select the highest-
   value slices first and initialize coverage entries for reviewed deeply,
   skimmed, excluded, and deferred slices. Deferred entries must be exact
   follow-up scopes such as `path/to/package` or `path/to/package/subpackage`.
8. Decide whether comparable product, library, CLI, or system research is
   needed. Use allowed research tools when they materially improve proposal
   quality; ask permission before approval-gated network, auth, clone, or
   remote-write commands.
9. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
10. Wait for all review work to finish.
11. Update coverage state for every planned slice before judging the requested
    scope.
12. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against code, generated surfaces, framework wrappers, shared
    helpers, vendored dependency behavior when delegated, docs, tests, examples,
    command behavior, current architecture, and comparable-tool evidence.
13. Apply `SKILL.md#acceptance-gate` to each candidate and confirm the feature
    gap names the audience, current product limitation, practical audience
    benefit, repository-owned product surface, evidence of value, repository
    fit, smallest plausible implementation path, compatibility and maintenance
    tradeoffs, validation path, and correct workflow routing.
14. Reject novelty, competitor checklists, trend-following, broad rewrites,
    new-framework preferences, future-roadmap assumptions, optional polish,
    vague benefits without a concrete audience outcome, and findings that
    belong in project, code, security, reliability, test, doc, or naming
    workflows.
15. If no confirmed feature gaps remain, report that result with the coverage
    state, do not create `FEATURES.md`, and stop.
16. If confirmed feature gaps remain, write the scoped `FEATURES.md` with
    `FEATURE-<number>` IDs.
17. Present the scoped ledger, proposed implementation plan, coverage state for
    broad scopes, and runnable follow-up scopes for deferred slices.
18. Stop before implementing features.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `FEATURES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, docs, examples, public APIs, developer workflows, and `./bin`
   wiring.
4. Select the next proposal by ID unless the human named a specific feature.
5. Re-check the proposal against current code, generated surfaces, framework
   wrappers, shared helpers, vendored dependency behavior when delegated, docs,
   tests, examples, command behavior, architecture, and comparable-tool
   evidence.
6. If the proposal is already supported, no longer fits, duplicates another
   proposal, or belongs in another workflow, explain that and propose removing
   or reclassifying it.
7. Present the feature evidence, audience benefit, repository fit, proposed
   solution, compatibility and maintenance tradeoffs, and intended validation.
8. Stop until the human explicitly agrees to that feature's solution. A named
   fix, implement, or verify request selects the feature and permits re-checking
   evidence and refreshing the proposal, but it is not approval to edit unless
   the request also explicitly agrees to the proposed solution. If the proposal
   was already presented and remains unchanged after re-checking, state only
   the concise approval gate instead of repeating the full proposal.
9. After agreement, state the local code/config/docs pattern, dominant relevant
   test harness, planned validation, and any needed deviation.
10. If a deviation is needed, stop and ask before editing.
11. For behavior-changing features, state the feature execution checklist:
    TDD decision, first test/scenario, expected red, intended green change,
    refactor checkpoint, and validation.
12. Implement only the agreed feature with the smallest clear change.
13. Use `$change-safety`, `$testing-standards`, `$doc-standards`,
    `$naming-standards`, relevant language standards, and `$change-validation`
    as required by the touched surface.
14. Validate the feature change through repository Make targets or documented
    entrypoints.
15. Report `Red`, `Green`, `Refactor`, and `Validation`, then ask the human to
    verify with `FEATURE-<number> is done`.
16. Stop until that confirmation arrives.
17. After confirmation, remove or revise the proposal in scoped `FEATURES.md`.
18. Continue with the next proposal, or delete scoped `FEATURES.md` after all
    feature gaps are confirmed resolved.
