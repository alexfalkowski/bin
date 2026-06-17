# Doc Gaps Plan

Use this reference to instantiate the active execution plan for `$doc-gaps`.
The active plan is runtime state. Do not write it into the repository unless the
human explicitly asks for a durable plan file. In downstream repositories that
vendor this project as `./bin`, instantiate the plan from the consuming
repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve stop gates as plan boundaries; do not continue past a stop gate based
  on silence or a broad request.
- Update the active plan when scope, documentation location, validation,
  delegation, edits, summary, or unresolved ledger state changes.
- Treat validation as stale when files change after a command ran.
- Before checking, reading, creating, or updating the scoped `DOCS.md` ledger,
  ensure the consuming repository root `.gitignore` exists and contains
  `DOCS.md` as a standalone pattern. If the pattern is missing, add it.
- Use a scoped `DOCS.md` ledger only for audit-only mode, unresolved confirmed
  gaps, or an existing doc-gap ledger being completed.
- Track broad-scope coverage explicitly as reviewed deeply, skimmed, excluded,
  and deferred. Deferred entries must name runnable follow-up scopes.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In one-pass mode, the goal is complete when confirmed gaps are fixed and
  validated, no confirmed gaps are found and reported, or unresolved findings
  are recorded because a stop gate prevents a correct fix.
- In audit-only mode, the goal is complete when no confirmed doc gaps are found
  and reported, or when the scoped `DOCS.md` ledger is written and presented.
- For broad scopes, a no-gap result is complete only when the summary states
  whether all high-risk slices were deeply reviewed. If any relevant slice was
  skimmed or deferred, completion requires coverage notes and runnable
  follow-up scopes, not an unqualified all-scope no-gap claim.
- Record a blocked reason when a required scope is missing, required permission
  is denied, an existing scoped ledger is unrelated or ambiguous, or a selected
  finding cannot be fixed or recorded without human input. Follow runtime rules
  for when that reason changes goal status.

## One-Pass Mode Plan

1. Confirm the requested package or folder scope.
2. If scoped `DOCS.md` exists, read it. Incorporate doc-gap ledger findings,
   or stop if the file is unrelated or ambiguous active work.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   public APIs, examples, and `./bin` wiring.
4. Identify existing documentation locations, examples, command help, package
   documentation, comments, docstrings, `$doc-standards`, and
   language-specific documentation standards for the requested scope.
5. Build a recursive documentation inventory for the requested scope: README
   files, user docs, examples, command help surfaces, package docs, exported
   API comments, code-comment/docstring surfaces, first-level subfolders,
   nested packages, generated/vendor/build/cache exclusions, and validation
   entrypoints.
6. Split the inventory into bounded documentation-owner or behavior-owned
   review slices. Use depth only as a discovery aid; do not assign a broad
   recursive subtree merely because it is a first-level subfolder.
7. If the scope is too broad for a credible single pass, select the highest-risk
   slices first and initialize coverage entries for reviewed deeply, skimmed,
   excluded, and deferred slices. Deferred entries must be exact follow-up
   scopes such as `path/to/package` or `path/to/package/subpackage`.
8. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
9. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
10. Wait for all review work to finish.
11. Update coverage state for every planned slice before judging the requested
    scope.
12. Deduplicate candidates and directly re-check conflicting or overlapping
    conclusions against code, docs, examples, command help, package docs, and
    public interfaces.
13. When prose contradicts implementation, require non-prose evidence before
    treating code as wrong or routing the candidate to code, security,
    reliability, or test workflows; otherwise classify stale prose as a doc gap.
14. Route each candidate through `$doc-standards`' adequacy gate and identify
    the public surface, intended audience, user action or maintenance decision
    at risk, current documentation surface, target surface, minimum successful
    example or command, adequacy failure, and any missing non-obvious contract.
15. Confirm each finding is a concrete missing, weak, stale, misleading, or
    wrong-location documentation gap with real user, operator, package
    consumer, or maintainer risk. Documentation length, heading count, lint
    shape, or comment presence is not sufficient evidence of adequacy.
16. Dismiss candidates already covered by the correct authoritative surface,
    candidates below the finding threshold, and candidates that belong to code,
    security, test, or reliability workflows. When dismissing, record why the
    existing surface owns the audience and action at risk.
17. If no confirmed gaps remain, report that result with the coverage state, do
    not create `DOCS.md`, and skip edit and validation steps.
18. Implement confirmed doc gaps with the smallest clear documentation changes.
19. If a confirmed gap cannot be fixed correctly in this pass, write or update
    the scoped `DOCS.md` with `DOC-<number>` entries for unresolved gaps.
20. If an existing doc-gap ledger is fully resolved, delete it.
21. Validate the documentation change with commands appropriate to the changed
    files.
22. Present fixed gaps, dismissed or out-of-scope candidates when relevant,
    coverage state for broad scopes, unresolved ledger entries if any, runnable
    follow-up scopes for deferred slices, and validation results.

## Audit-Only Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `DOCS.md` already exists and stop unless the human
   explicitly asked to refresh or overwrite that ledger.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   public APIs, examples, and `./bin` wiring.
4. Identify existing documentation locations, examples, command help, package
   documentation, comments, docstrings, `$doc-standards`, and
   language-specific documentation standards for the requested scope.
5. Build and launch the same recursive, bounded-slice documentation review
   delegation plan as one-pass mode.
6. Update coverage state for every planned slice before judging the requested
   scope.
7. Deduplicate, route, and confirm candidates against code, docs, examples,
   command help, package docs, and public interfaces. When prose contradicts
   implementation, require non-prose evidence before treating code as wrong;
   otherwise classify stale prose as a doc gap.
8. If no confirmed gaps remain, report that result with the coverage state, do
   not create `DOCS.md`, and stop.
9. If confirmed gaps remain, write the scoped `DOCS.md` with `DOC-<number>`
   IDs.
10. Present the scoped audit ledger, coverage state for broad scopes, and
    runnable follow-up scopes for deferred slices, then stop before making
    fixes.
