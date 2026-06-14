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
- Use a scoped `ISSUES.md` ledger only for audit-only mode, unresolved confirmed
  gaps, or an existing doc-gap ledger being completed.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In one-pass mode, the goal is complete when confirmed gaps are fixed and
  validated, no confirmed gaps are found and reported, or unresolved findings
  are recorded because a stop gate prevents a correct fix.
- In audit-only mode, the goal is complete when no confirmed doc gaps are found
  and reported, or when the scoped `ISSUES.md` ledger is written and presented.
- Record a blocked reason when a required scope is missing, required permission
  is denied, an existing scoped ledger is unrelated or ambiguous, or a selected
  finding cannot be fixed or recorded without human input. Follow runtime rules
  for when that reason changes goal status.

## One-Pass Mode Plan

1. Confirm the requested package or folder scope.
2. If scoped `ISSUES.md` exists, read it. Incorporate doc-gap ledger findings,
   or stop if the file is unrelated or ambiguous active work.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   public APIs, examples, and `./bin` wiring.
4. Identify existing documentation locations, examples, command help, package
   documentation, comments, docstrings, `$doc-standards`, and
   language-specific documentation standards for the requested scope.
5. Build the read-only documentation review delegation plan from root docs,
   README files, and first-level subfolders; use as many independent review
   agents as the runtime can safely run.
6. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
7. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
8. Wait for all review work to finish.
9. Deduplicate candidates and directly re-check conflicting or overlapping
   conclusions against code, docs, examples, command help, package docs, and
   public interfaces.
10. Route each candidate to the correct documentation surface by identifying
    the intended audience, user action or maintenance decision at risk, current
    documentation surface, target surface, and any missing non-obvious contract
    required by `$doc-standards`.
11. Confirm each finding is a concrete missing, weak, stale, misleading, or
    wrong-location documentation gap with real user, operator, package
    consumer, or maintainer risk.
12. Dismiss candidates already covered by the correct surface, candidates below
    the finding threshold, and candidates that belong to code, security, test,
    or reliability workflows.
13. If no confirmed gaps remain, report that result and do not create
    `ISSUES.md`.
14. Implement confirmed doc gaps with the smallest clear documentation changes.
15. If a confirmed gap cannot be fixed correctly in this pass, write or update
    the scoped `ISSUES.md` with `DOC-<number>` entries for unresolved gaps.
16. If an existing doc-gap ledger is fully resolved, delete it.
17. Validate the documentation change with commands appropriate to the changed
    files.
18. Present fixed gaps, dismissed or out-of-scope candidates when relevant,
    unresolved ledger entries if any, and validation results.

## Audit-Only Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `ISSUES.md` already exists and stop unless the human
   explicitly asked to refresh or overwrite that ledger.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   public APIs, examples, and `./bin` wiring.
4. Identify existing documentation locations, examples, command help, package
   documentation, comments, docstrings, `$doc-standards`, and
   language-specific documentation standards for the requested scope.
5. Build and launch the same documentation review delegation plan as one-pass
   mode.
6. Deduplicate, route, and confirm candidates against code, docs, examples,
   command help, package docs, and public interfaces.
7. If no confirmed gaps remain, report that result and do not create
   `ISSUES.md`.
8. If confirmed gaps remain, write the scoped `ISSUES.md` with `DOC-<number>`
   IDs.
9. Present the scoped audit ledger and stop before making fixes.
