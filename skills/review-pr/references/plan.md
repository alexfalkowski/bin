# Review PR Plan

Use this reference to instantiate the active execution plan for `$review-pr`.
The active plan is runtime state. Do not write it into the repository unless the
human explicitly asks for a durable plan file. In downstream repositories that
vendor this project as `./bin`, instantiate the plan from the consuming
repository root and keep `bin/` as shared guidance.

## Plan State Rules

- Keep exactly one active phase in progress at a time.
- Preserve permission gates as plan boundaries.
- Update the active plan when changed files, validation, review findings,
  drafted summary, or remote-write permission changes.
- Treat validation as stale when files change after a command ran.
- Do not run `make review`, `make push`, or any equivalent remote-write command
  unless the current request explicitly asked for that PR flow.

## Goal State Rules

- Bind the active goal to opening or updating the review PR for the current
  change.
- Record a waiting reason when explicit PR-flow permission, obsolete PR text
  direction, remote-write permission, or unresolved-finding approval is needed.
- Record a blocked reason only when a required permission is denied, validation
  cannot be run or interpreted, or blocking findings cannot be resolved without
  human input. Follow runtime rules for when that reason changes goal status.
- Treat the goal as complete only after the review target confirms the commit,
  push, and draft PR result and the required output format has been reported.
- Do not treat a prepared summary, clean validation, or finished review as goal
  completion before the remote-write flow succeeds.

## Execution Plan

1. Inspect changed paths from the working tree, or the latest commit if the
   working tree is clean.
2. Confirm the current user request explicitly asks to commit, push, update, or
   open a review PR.
3. If existing PR text may become obsolete, ask whether to update it before
   pushing.
4. Run `$project-workflow` discovery for entrypoints, CI, and `./bin` wiring.
5. Make the remote-write behavior explicit: the review target commits,
   force-pushes, and opens a draft PR.
6. Select and run credible validation for the full change with
   `$change-validation`.
7. Apply relevant language and test standards for the changed paths.
8. Run `$code-review` on the current change.
9. Run `$style-review` only when the human explicitly asked for non-blocking
   polish.
10. Resolve blocking review findings or get explicit approval to open the draft
    PR with unresolved findings documented.
11. Read `references/summary-format.md`.
12. Draft the lowercase, unprefixed `msg` and multiline Markdown `desc`.
13. Write `desc` to a temporary file.
14. Run `make msg="..." desc_file="$desc_file" review`.
15. Read `references/output-format.md`.
16. Report the result in the required output format.
