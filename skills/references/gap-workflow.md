# Gap Workflow

Use this reference for scoped gap-finding and gap-implementation skills. The
selected skill owns domain judgment, ledger format, mode names, and final output.
These shared rules own workflow mechanics.

## Mode And Plan State

- If no scope is provided, stop and ask for the package or folder.
- Before starting a find, audit, one-pass, or implement mode, read the selected
  skill's `references/plan.md` and maintain it as active runtime state. Do not
  write the plan into the repository unless the human explicitly asks for a
  durable plan file.
- When the runtime supports goals, bind the selected mode and requested scope to
  one active goal and update it as ledger, proposal, approval, validation,
  summary, unresolved-ledger, or human-confirmation state changes.
- Do not combine find and implement modes in one pass unless the selected skill
  explicitly defines a one-pass mode.
- Preserve stop gates as plan boundaries. Do not continue past a stop gate based
  on silence or a broad request.
- Treat validation as stale when files change after a command ran.

## Scoped Ledgers

- Before checking, reading, creating, or updating a scoped ledger, ensure the
  consuming repository root `.gitignore` exists and contains that ledger
  filename as a standalone pattern. If the pattern is missing, add it.
- Use the selected skill's ledger filename in the requested package or folder,
  such as `PACKAGE_OR_FOLDER/ISSUES.md`, `TESTS.md`, `DOCS.md`,
  `FEATURES.md`, `PROJECTS.md`, or `RELIABILITY.md`.
- In find or audit-only modes, if the scoped ledger already exists, stop unless
  the selected skill explicitly allows reading or refreshing that ledger.
- In implement mode, read the scoped ledger first and treat it as the working
  ledger. If it does not exist, stop and ask whether to run the matching find
  mode first for that scope.
- Record durable findings or proposals only in the scoped ledger defined by the
  selected skill.
- Assign IDs using the selected skill's prefix, such as `ISSUE-N`, `TEST-N`,
  `DOC-N`, `FEATURE-N`, `PROJECT-N`, or `REL-N`.

## Delegation And Permissions

- Treat a find or audit invocation as the user's explicit request to delegate
  review for that scope when the selected skill says so. Do not require the
  user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for find or audit review whenever the active runtime provides
  them and runtime policy/tooling permits delegation. Do not perform the review
  locally first when delegation is available and required by the selected skill.
- If delegation is denied, stop instead of falling back to a local review. If
  sub-agents are unavailable, say so briefly and perform the review locally for
  the requested scope.
- Ask for human permission before agents run commands that require approval,
  such as network, SSH, GitHub auth, registry auth, cloning, destructive
  operations, remote writes, or non-read-only validation.

## Scope Inventory And Slicing

- Exclude generated files and folders, vendored dependencies, caches, build
  output, generated API docs, and generated lockfile churn unless the requested
  scope is explicitly about them.
- In downstream repositories that vendor this project as `./bin`, treat
  `bin/**` as vendored shared tooling unless the requested scope is explicitly
  about shared `bin` tooling, Makefile includes, skills, or submodule wiring.
  Exclude `bin/**` from recursive review and inventory by default; inspect only
  included `bin/build/make/*.mak` fragments or selected `bin/skills/**`
  guidance needed as evidence. Route upstream-only shared-tooling findings to a
  separate `bin`-scoped run instead of writing them into the consuming
  repository's scoped ledger.
- Before assigning review agents, build a recursive scope inventory for the
  requested package or folder. Include relevant file count, first-level
  subfolders, nested packages, dominant languages, public entrypoints,
  generated/vendor/build/cache exclusions, docs, examples, tests, validation
  entrypoints, and the selected skill's domain-specific surfaces.
- Do not assign broad recursive subtrees merely because they are first-level
  subfolders. When a subtree contains many independent owners, workflows,
  responsibilities, packages, products, or audiences, split it into smaller
  behavior-owned, documentation-owned, workflow-owned, or audience-owned slices.
- Use depth only as a discovery aid, not as the review boundary.
- If the requested scope is too broad to review credibly in one pass, review
  the highest-risk or highest-value slices first and record explicit coverage:
  reviewed deeply, skimmed, excluded, and deferred.
- Do not present a broad requested scope as fully reviewed when any relevant
  slice was only skimmed or deferred. Name those slices in the final coverage
  notes and provide runnable follow-up scopes for deferred review.

## Candidate Handling

- Require each assigned agent to return candidates in the selected skill's
  ledger format, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates
  before assigning severity or confidence when the selected skill records
  findings.
- Confirm each candidate against current code, docs, examples, tests, command
  behavior, CI config, generated contracts, and public interfaces relevant to
  the selected skill before recording, fixing, or dismissing it.
- For reusable library, helper, or shared-tooling scopes, inspect supported
  usage evidence before recording or accepting a high-confidence issue, gap, or
  proposal: a real consumer, executable example, integration test, module wiring
  path, documented contract, CI workflow, or comparable usage path that can
  trigger the candidate or show the audience/action at risk. Treat package-local
  fakes, synthetic tests, manual construction, and unsupported downstream
  patterns as leads only.
- When a candidate points to a third-party dependency, framework, tool, image,
  or project-owned upstream library defect, separate the defect from the
  repository-owned response before recording it. Record a scoped finding or
  proposal only when the selected scope owns the adapter behavior, dependency
  upgrade, pin, replacement, workaround, validation coverage, upstream issue
  tracking, or other project workflow response. If another project-owned
  library owns the broken behavior, route the candidate to that library's agent
  or ledger and keep the current scope only as supported usage evidence.
- When prose, comments, examples, or docs contradict implementation, require
  non-prose evidence before treating implementation as wrong or routing the
  candidate to code, security, reliability, or test workflows. If current code,
  tests, runtime behavior, generated contracts, CI, or history support the
  implementation, route stale prose to `$doc-gaps`.
- Dismiss candidates already covered by the correct authoritative surface,
  below the selected skill's threshold, duplicative, out of scope, or owned by a
  different workflow. When useful, state the authoritative surface or workflow
  that owns the concern.

## Find And Audit Outcomes

- If no confirmed gaps or proposals remain, report that result with a no-finding
  closeout and do not create a scoped ledger. The closeout must include:
  reviewed files or slices; supported usage, call sites, commands, tests, or CI
  evidence checked; excluded or deferred files; repository policy exclusions or
  suppressions applied; confidence as a percentage or narrow range; and the
  remaining limits on that confidence. Do not present "nothing found" as a
  broad assurance without this evidence.
- If confirmed gaps or proposals remain, write them to the scoped ledger before
  making changes unless the selected skill explicitly defines a one-pass fix
  mode.
- Stop after presenting the ledger and plan in find/audit modes when the
  selected skill requires a separate implementation pass.

## Implementation Gates

- Work through scoped ledger entries sequentially by ID unless the human
  explicitly names a different entry.
- Before proposing a fix for each entry, re-check current code, docs, tests,
  config, CI, command behavior, and nearby patterns. Treat ledgers as stale:
  dismiss or revise entries that are already addressed, duplicated, invalid, or
  owned by another workflow.
- Stop after proposing a solution. Do not edit files, update the scoped ledger,
  or start validation until the human explicitly agrees to that entry's
  solution.
- A request that names an entry and asks to fix, implement, or verify it is
  permission to select that entry, re-check current evidence, and present or
  refresh the proposal. It is not approval to edit unless the request also
  explicitly agrees to the proposed solution.
- Ask questions when behavior, compatibility, documentation location, test
  layer, implementation home, validation, operator workflow, or user intent is
  ambiguous enough that a correct change cannot be inferred from local context.
- After the human agrees and before editing, state the selected local pattern,
  dominant relevant test harness or validation path, planned validation command,
  and any deviation from `AGENTS.md` or selected skills. If a deviation is
  needed, stop and ask before editing.
- Implement only the agreed entry with the smallest clear change using existing
  local patterns.
- During automatic continuations while waiting for approval or an "`ID` is
  done" confirmation, do not repeat the full proposal or result. State the
  current waiting gate once, concisely.
- Do not move to the next entry until the human says the current entry is done.
- After the human confirms an entry is done, remove or revise that entry in the
  scoped ledger. If an entry is deemed invalid, remove it only after explaining
  why and getting human agreement.
- Once all entries are resolved and confirmed done by the human, delete the
  scoped ledger.
