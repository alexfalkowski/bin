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
  delegation, or ledger state changes.
- Treat validation as stale when files change after a command ran.
- Record durable findings only in the scoped `ISSUES.md` ledger defined by the
  skill.

## Goal State Rules

- Bind the active goal to the selected mode and requested scope.
- In Find mode, the goal is complete when no confirmed doc gaps are found and
  reported, or when the scoped `ISSUES.md` ledger is written and presented.
- In Implement mode, the goal is waiting while the human has not approved the
  proposed doc-gap solution, or after validation until the human confirms
  `DOC-<number> is done`.
- In Implement mode, the goal is complete for a finding only after the human
  confirms it is done and the scoped ledger is updated accordingly.
- Record a blocked reason when a required scope is missing, the scoped ledger
  required by the mode is absent or already exists in a conflicting state,
  required permission is denied, or the selected finding cannot be re-checked
  without human input. Follow runtime rules for when that reason changes goal
  status.

## Find Mode Plan

1. Confirm the requested package or folder scope.
2. Check whether scoped `ISSUES.md` already exists and stop if it does.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   public APIs, examples, and `./bin` wiring.
4. Identify existing documentation locations, examples, comments, docstrings,
   `$docs-standards`, and language-specific documentation standards for the
   requested scope.
5. Build the read-only documentation review delegation plan from the requested
   root and its first-level subfolders.
6. Ask for required permission before any agent runs non-read-only, network,
   auth, remote-write, or otherwise approval-gated commands.
7. Launch the required review agents when available, or perform the local
   fallback only when sub-agents are unavailable.
8. Wait for all review work to finish.
9. Deduplicate candidates and directly re-check conflicting or overlapping
   conclusions against code, docs, examples, and public interfaces.
10. Confirm each finding is a concrete missing, weak, stale, misleading, or
    wrong-location documentation gap with real user, operator, or maintainer
    risk.
11. If no confirmed gaps remain, report that result and do not create
    `ISSUES.md`.
12. If confirmed gaps remain, write the scoped `ISSUES.md` with `DOC-<number>`
    IDs.
13. Present the scoped ledger and proposed doc-fix plan.
14. Stop before making fixes.

## Implement Mode Plan

1. Confirm the requested package or folder scope.
2. Read scoped `ISSUES.md`, or stop and ask whether to run Find mode first.
3. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, public APIs, examples, and `./bin` wiring.
4. Select the next finding by ID unless the human named a specific finding.
5. Re-check the finding against current code, docs, examples, and public
   interfaces.
6. Present the finding evidence, proposed documentation solution, location,
   public-contract, example accuracy, compatibility, maintenance tradeoffs, and
   intended validation.
7. Stop until the human explicitly agrees to that finding's solution.
8. After agreement, state the local documentation pattern, dominant relevant
   validation path, planned validation, and any needed deviation.
9. If a deviation is needed, stop and ask before editing.
10. Implement only the agreed doc gap with the smallest clear documentation
    change.
11. Use `$docs-standards` and relevant language standards for comments,
    docstrings, and public API docs.
12. Validate the documentation change with commands appropriate to the changed
    files.
13. Report the result and ask the human to verify with `DOC-<number> is done`.
14. Stop until that confirmation arrives.
15. After confirmation, remove or revise the finding in scoped `ISSUES.md`.
16. Continue with the next finding, or delete scoped `ISSUES.md` after all gaps
    are confirmed resolved.
