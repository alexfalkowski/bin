# Gap Workflow

Use this reference for scoped gap-finding and gap-implementation skills. The
selected skill owns domain judgment, ledger format, mode names, and final output.
These shared rules own workflow mechanics.

## Mode And Plan State

- If no scope is provided, stop and ask for the package or folder.
- Treat remembered commands as gap-workflow shorthand:
  - `Work ID` or `Work ID1/ID2 in LEDGER_PATH` selects the matching gap skill
    from the ID prefix and enters implement mode for those IDs.
  - `Agent work ID` explicitly authorizes sub-agents for the current request.
  - `Goal work ID` explicitly authorizes a runtime goal for the current request
    when runtime goals are available and useful.
  - `Agent goal work ID` explicitly authorizes both sub-agents and a runtime
    goal for the current request.
  - `Approved. Continue.` approves the most recently proposed solution and
    permits implementation to continue under the selected skill.
  - `Agent approved. Continue.` approves the most recently proposed solution
    and explicitly authorizes sub-agents for the current implementation request.
    Use them for disjoint implementation slices, validation support, or fresh
    review when they materially improve throughput, coverage, confidence, or
    implementation safety.
  These shorthands do not bypass solution agreement, scoped ledger rules,
  validation freshness, confidence thresholds, remote-write permission, or the
  selected skill's output format.
- Before starting a find, audit, one-pass, or implement mode, read the selected
  skill's `references/plan.md` and maintain it as active runtime state. Do not
  write the plan into the repository unless the human explicitly asks for a
  durable plan file.
- If the human asks for an explicit or broad no-finding confidence target, such as
  "95% confidence", "99% closure", "max confidence", "full closure", "no
  issues anywhere", or equivalent broad assurance, treat the run as a
  **confidence closure audit**. A confidence closure audit is still the selected
  skill's find/audit mode, but it may not close with a no-finding outcome until
  the confidence closure requirements below are satisfied. Use the requested
  percentage as the scope no-finding confidence threshold, subject to mandatory
  repository confidence floors such as the 95% floor for broad no-finding claims.
  When no explicit percentage is given, use the broad no-finding default threshold
  of 95%. If the requested percentage is below the mandatory floor, apply the
  mandatory floor and say the lower request cannot waive repository confidence
  rules. Do not accept 100% as an achievable threshold for repository review; if
  the human asks for 100% certainty, explain that the workflow can pursue a lower
  explicit target or continue gathering evidence, but cannot truthfully close at
  100%.
- Treat a confidence closure audit as **high-assurance closure** when the
  requested threshold is higher than the broad no-finding default threshold, or
  when the human asks for "max confidence", "full closure", "no issues
  anywhere", "no possible bugs", or equivalent broad assurance. High-assurance
  closure scales evidence to the requested threshold; do not hard-code one
  percentage as the only trigger for stronger review.
- Distinguish scope no-finding confidence from a literal "no possible bugs"
  claim. The selected skill can close only on no remaining reportable findings
  in the requested scope under the skill's evidence rules. If the human asks
  about no possible bugs anywhere, report that as a separate residual
  correctness-risk statement with explicit limits; do not use a clean
  confidence-closure outcome as proof that unexercised state space, unsupported
  construction, environment-specific behavior, or future dependency behavior is
  bug-free.
- Use runtime goals only when the human explicitly requests them or
  higher-priority runtime instructions allow goal creation for this workflow.
  Otherwise maintain the selected mode, requested scope, and state transitions
  in the conversation or tool plan without creating a runtime goal.
- For substantial, ambiguous, or multi-iteration implementation work, read
  `long-running-work.md` before proposing or implementing the first slice, and
  keep its progress artifact as runtime state only.
  Do not write progress files, design docs, or orchestration artifacts into the
  repository unless the human explicitly asks for a durable file.
- Do not combine find and implement modes in one pass unless the selected skill
  explicitly defines a one-pass mode.
- Preserve stop gates as plan boundaries. Do not continue past a stop gate based
  on silence or a broad request.
- Treat validation as stale when files change after a command ran.

## Common Plan Mechanics

Use these mechanics with the selected skill's `references/plan.md`. The plan
names the domain-specific inventory surfaces, candidate tests, closeout
questions, ledger filename, ID prefix, and implementation pairings.
Use `gap-lead-generation.md` during find, audit-only, and one-pass modes to
classify repository archetypes, build a lead inventory, use comparable
repositories or framework checklists when useful, and account for confirmed,
rejected, routed, deferred, and blocked leads.

For find, audit-only, and one-pass modes:

1. Confirm the requested package or folder scope.
2. Check the selected skill's scoped ledger policy. For normal find/audit modes,
   stop if an existing scoped ledger blocks review. For one-pass modes that
   allow reading a ledger, incorporate matching ledger entries and stop on
   unrelated or ambiguous active work.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   relevant public surfaces, and `./bin` wiring.
4. Build a recursive inventory using the selected plan's domain-specific
   surfaces and `gap-lead-generation.md` archetypes, then split it into bounded
   review slices. Use depth only as a discovery aid, not as the review boundary.
5. For broad scopes, choose highest-risk or highest-value slices first and
   record `deep`, `skimmed`, `excluded`, and `deferred` coverage with exact
   follow-up scopes. For confidence closure audits, every relevant slice must
   route to `deep` or `excluded`; unfinished relevant slices keep the outcome
   incomplete.
6. Ask for required permission before a local reviewer or authorized agent runs
   non-read-only, network, auth, remote-write, destructive, or otherwise
   approval-gated commands.
7. Apply the shared gap-workflow delegation gate before review work.
8. Wait for review work to finish, update coverage for every planned slice, and
   deduplicate or directly re-check conflicting candidates.
9. Classify validation outcomes as repository finding, local environment issue,
   missing tool, or inconclusive; use `finding-severity.md` for
   confidence evidence. For confidence closure audits, include current CI or
   equivalent repository-defined validation evidence before no-finding
   closeout.
10. If no confirmed entries remain, report the coverage state, do not create a
    scoped ledger, and stop unless the selected one-pass mode has completed
    edits. If coverage is incomplete, report the incomplete audit state and do
    not present the requested scope as complete.
11. If confirmed entries remain in find/audit modes, write the selected scoped
    ledger with that skill's ID prefix, present the ledger and coverage state,
    name runnable follow-up scopes, and stop before making fixes.

For implement modes:

1. Confirm scope and read the selected scoped ledger, or stop and ask whether to
   run the matching find mode first.
2. Run `$project-workflow` discovery for current entrypoints, CI, documented
   commands, relevant public surfaces, and `./bin` wiring.
3. Select the named entry ID or the next entry, then re-check the evidence
   against current code, docs, tests, commands, and relevant generated or
   workflow surfaces.
4. If the entry is already resolved, stale, duplicated, outside scope, or owned
   by another workflow, explain the routing and propose removing, moving, or
   reclassifying it before editing.
5. Present the current evidence, proposed solution, tradeoffs, and intended
   validation as a decision card (see `../references/decision-card.md`) so the
   human can agree, reject, or revise quickly. Stop until the human explicitly
   agrees to that solution. A named fix, implement, or verify request selects the
   entry and permits evidence refresh, but it is not approval to edit unless it
   also agrees to the proposed solution. This remains true when the request says
   "implement", names multiple related IDs, or authorizes agents.
6. After agreement, state the local pattern, dominant relevant harness or
   validation path, planned validation, and any needed deviation. Stop before
   deviating from the selected skill, repository pattern, or documented
   workflow.
7. Implement only the agreed entry with the smallest clear change, using the
   paired standards and validation skills named by the selected plan.
8. Validate through repository Make targets or documented entrypoints, then ask
   the human to verify with the selected `ID-<number> is done` phrase.
9. Stop until confirmation. After confirmation, remove or revise the entry and
   continue with the next entry, or delete the scoped ledger when all entries
   are confirmed resolved.

## Scoped Ledgers

- Before creating or updating a scoped ledger, ensure the consuming repository
  root `.gitignore` exists and contains that ledger filename as a standalone
  pattern. If the pattern is missing, add it.
- Checking whether a scoped ledger exists or reading an existing scoped ledger
  must not modify `.gitignore`.
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

- Use sub-agents only when the active runtime provides them and the current user
  request explicitly asks for sub-agents, delegation, or parallel agent work.
- When sub-agents are authorized, use them for any skill combination when they
  materially improve coverage, confidence, throughput, independent validation,
  forward-testing, or disjoint implementation, or when they are required by the
  selected skill.
- If the current request does not authorize sub-agents, perform local review
  only when the selected skill does not require delegation and the requested
  review can still reach the required evidence and confidence threshold without
  it. If credible completion depends on delegation, stop at the delegation gate
  and ask for explicit current-request sub-agent authorization.
- If sub-agents are authorized but unavailable, forbidden, or denied by the
  runtime, perform local review only when the selected skill does not require
  delegation and the requested review can still reach the required evidence and
  confidence threshold without it. If credible completion depends on
  delegation, stop at the delegation gate and state the blocked delegation
  requirement plus runtime limitation.
- Do not silently downgrade to local-only review or present a single-agent
  substitute as equivalent.
- Ask for human permission before a local reviewer or authorized agent runs
  commands that require approval, such as network, SSH, GitHub auth, registry
  auth, cloning, destructive operations, remote writes, or non-read-only
  validation.

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
- Before assigning review agents or starting local review, build a recursive
  scope inventory for the requested package or folder. Include relevant file
  count, first-level subfolders, nested packages, dominant languages, public
  entrypoints, generated/vendor/build/cache exclusions, docs, examples, tests,
  validation entrypoints, and the selected skill's domain-specific surfaces.
- When the requested scope has repository-defined package, module, component,
  command, service, or area discovery, record coverage accounting from that
  discovery path: count or inventory summary; excluded paths such as `bin/**`,
  vendored dependencies, generated folders, caches, build output, and
  explicitly out-of-scope subtrees; major reviewed groups named in the
  repository's own terminology; and any slices intentionally skipped with the
  concrete reason.
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
- For confidence closure audits, plan the inventory so every relevant slice has a
  route to `deep` or `excluded`. Do not intentionally leave relevant slices as
  `skimmed` or `deferred` at closeout. If the scope is too large to finish in
  the current run, keep the outcome incomplete and name the exact remaining
  slices instead of lowering the standard.

## Audit Preflight And Validation Ladder

- Before a long find or audit pass, run a tool and environment preflight through
  `$project-workflow` and `$change-validation`: repository root, documented
  entrypoints, CI analogue, initialized user shell, and applicable tool
  availability or version checks. For toolchain-heavy audits, check required
  language runtimes, analyzers, linters, schema or generation tools, security
  scanners, sidecars, and service dependencies only when the repository's Make
  targets, CI, scripts, or tests actually require them.
- Preflight is evidence planning, not a reason to bypass repository Make
  targets. Prefer the repository-defined target that owns each tool or service.
- Run checks normally first. If a failure is clearly sandbox, cache-permission,
  localhost listener, network, credential, service-dependency, or user-shell
  environment related, retry only through the runtime's approved escalation or
  initialized-shell path.
- After a repository-defined command, Make target, dominant test harness, or
  skill-required workflow fails, do not switch to an ad hoc command, different
  validation layer, or alternate workflow merely to make progress. First
  classify the failure using the validation categories below; then retry only
  through the initialized-shell or approved escalation path, or report the
  blocker.
- Classify every failed or skipped validation command as exactly one of:
  repository finding, local environment issue, missing tool, or inconclusive.
  Do not treat a target failure in the sandbox as a repository finding unless
  repository-owned code, config, or workflow evidence proves it.
- Do not lower confidence for a sandbox-only failure when the same command
  passes through an approved outside-sandbox or initialized-shell path on the
  same file state. Do lower or cap confidence when validation remains blocked,
  missing, no-op, or inconclusive.
- Preserve analyzer nuance in audit notes when relevant: analyzers may no-op or
  report no matched packages, modules, files, or components in a restricted
  sandbox or stale tool context; integration tests may need localhost listener
  permissions or service dependencies; dependency, security, or generation
  tools may need network access or cache writes outside the workspace; and a
  target failing in the sandbox is not automatically a repository finding.
- Prefer fast, reproducible local evidence before relying on broad CI. For
  changed or suspect executable behavior, use the narrowest supported
  repository-defined command or dominant-harness selector that exercises the
  affected package, file, command, scenario, example, or test name. Broaden to
  suite, lint, security, or CI-equivalent checks only when the change crosses
  boundaries, affects shared infrastructure, or needs higher confidence.
- CI can raise confidence only when the relevant current run or equivalent
  repository-defined local command is observed and classified. The fact that CI
  exists or will run later is not reproduction evidence for a ledger finding.
- For confidence closure audits, collect current validation evidence from the
  repository-owned CI analogue before any no-finding closeout. Prefer the latest
  successful CI result for the exact commit when it is available; otherwise run
  or explicitly classify the repository-defined equivalent targets. The mere
  existence of CI is not validation evidence.
- For high-assurance closure, add evidence planning before closeout. Identify
  which bug classes are materially relevant to the requested scope and what
  current evidence exercises them, such as parser/decoder fuzzing or property
  tests, serialization round trips, boundary/default fixtures, race or stress
  tests for concurrent state, lifecycle start/stop repetition, dependency
  outage or fault-injection scenarios, generated-contract freshness checks,
  security scanners, and integration tests with required sidecars. Missing
  evidence is not itself a finding unless the selected skill says so, but it
  must appear as a confidence limiter or be routed to the appropriate workflow
  such as `$test-gaps` or `$project-gaps`.

## Candidate Handling

- For delegated review, require each assigned agent to return confirmed
  candidates in the selected skill's ledger format, without final IDs unless
  useful locally. Also require rejected leads with rejection reasons, risky
  files or surfaces that still deserve review, and exact follow-up scopes. A
  delegated "nothing found" response without coverage, rejected-lead, and
  follow-up-scope evidence is not enough to close a broad audit slice.
- For confidence closure audits over broad repository, package-tree, or
  multi-component scopes, use independent delegated review when the runtime
  provides agents and the current request authorizes them. Assign disjoint
  behavior-owned or risk-owned slices, require each agent to report coverage,
  rejected leads, validation, and follow-up scopes, and perform a final local
  challenge pass across the combined result. If agents are unavailable or not
  authorized and delegation is needed for credible closure, stop at the
  delegation gate or report the blocked requirement instead of presenting a
  confidence closure result.
- For high-assurance closure with authorized agents, assign at least one
  adversarial reviewer when practical. That reviewer should try to falsify the
  no-finding conclusion, look for unsupported confidence leaps, unreviewed bug
  classes, missing supported-usage evidence, and unresolved counterexamples.
  Resolve the adversarial review explicitly before closeout. Do not pass
  intended conclusions, rejected-lead rationale, or proposed confidence numbers
  to the adversarial reviewer unless the validation task specifically requires
  that context.
- Use `../references/finding-severity.md` to discard low-confidence candidates
  before assigning severity or confidence when the selected skill records
  findings.
- Before deep review, create a lead inventory for each planned slice using the
  selected skill's plan and `gap-lead-generation.md`. Lead inventory is a recall
  tool only: it does not lower the selected skill's confidence, ownership,
  reproduction, validation, or approval gates.
- Treat comparable repository and external-framework evidence as lead
  generation only. Before recording a candidate derived from GitHub owner
  inventory, local checkout mapping, sibling repositories, or external
  frameworks, reproduce the current repository-owned limitation through the
  selected skill's normal evidence path.
- Before recording a candidate, run an existing-surface challenge. List the
  authoritative repository surfaces that could already satisfy the proposed
  need, such as public APIs, commands, endpoints, generated contracts, runtime
  health or metrics, shared helpers, framework behavior, configuration
  defaults, docs, examples, tests, and supported consumer workflows. Reject or
  route the candidate when the correct surface already covers the workflow.
- For candidates that survive the existing-surface challenge, state the
  residual gap: "Even with <existing surface>, the audience still cannot
  <specific supported action/outcome>." If that sentence is weak, vague, or
  mostly describes optional convenience, keep the lead below the selected
  skill's ledger threshold and report it as rejected, routed, or deferred.
- Confirm each candidate against current code, docs, examples, tests, command
  behavior, CI config, generated contracts, and public interfaces relevant to
  the selected skill before recording, fixing, or dismissing it.
- Reproduce each candidate before recording it as a confirmed ledger entry or
  presenting it as a proposed finding. Use the smallest supported path that
  demonstrates the issue or gap: a repository command, test, fixture, API call,
  documented workflow, config path, command help lookup, reader action, CI path,
  code-path trace, or negative search across the authoritative surface. For
  absence-based gaps, reproduce the limitation by showing the supported user,
  maintainer, or operator action that currently fails, is unsupported, or cannot
  be completed from the existing surface.
- When an executable command can demonstrate the candidate through the dominant
  harness or repository entrypoint, prefer that command over a static trace.
  Use a non-executable trace, lookup, or negative search only for documentary,
  structural, unsupported-mode, or absence-based candidates where no supported
  command can demonstrate the gap.
- Record the reproduction path in the candidate and ledger entry. The path must
  name what was run or inspected, the observed result, and why that result
  demonstrates the repository-owned issue, gap, or limitation. A reproduction
  path can be non-executable only when the selected skill's surface is
  inherently documentary or structural; in that case, record the exact lookup,
  trace, negative search, or authoritative surface comparison that reproduces
  the gap.
- If reproduction is blocked by sandbox limits, missing tools, credentials,
  network, optional services, or ambiguous setup, classify the blocker through
  `$change-validation` and do not record the candidate as confirmed unless a
  separate supported reproduction path proves it. Report the evidence gap or
  deferred follow-up instead of raising confidence to the ledger threshold.
- A suggested validation command is not itself reproduction. Before recording a
  ledger entry, either run or inspect the smallest supported reproducer and
  record the observed result, or keep the candidate below the confidence
  threshold with the blocker named.
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
- Treat optional follow-ups, speculative improvements, and leads that need
  production evidence or a separate product/security/reliability design as
  closeout notes only. Do not create a scoped ledger solely to store optional
  follow-ups when no confirmed entries survive the selected skill's evidence
  gate.
- For local review as well as delegated review, preserve rejected, routed,
  deferred, and blocked lead notes. A quiet audit without these notes is not
  enough evidence for broad no-finding confidence.

## Find And Audit Outcomes

- Use exactly one of these outcomes for find or audit closeout:
  `Findings recorded`; `No findings and validation clean`;
  `No findings, but validation incomplete because X`; or
  `Audit incomplete: no confirmed findings so far`.
- Distinguish finding confidence from audit completion confidence:
  `Finding confidence` is confidence that each recorded finding is real and
  repository-owned; `Coverage confidence` is confidence that reviewed slices
  were checked adequately; `Scope no-finding confidence` is confidence that no
  reportable finding remains in the requested scope. Broad no-finding closeouts
  must report all three values, using `n/a` for finding confidence when no
  findings were recorded.
- For broad repository, package-tree, or multi-component scopes, do not use
  `No findings and validation clean` or `No findings, but validation incomplete
  because X` unless scope no-finding confidence is at least 95% and every
  relevant planned slice is deep-reviewed or explicitly excluded. If any
  relevant slice is skimmed, deferred, or blocked, the final outcome must be
  `Audit incomplete: no confirmed findings so far`.
- For confidence closure audits, do not use any no-finding closeout until all of
  these are true:
  - every relevant slice is `deep` or `excluded`;
  - current CI or equivalent repository-defined validation evidence is clean, or
    any unavailable check is classified and does not weaken the audited claim;
  - every delegated slice result has coverage, rejected-lead, validation, and
    follow-up-scope evidence;
  - all candidates have been reproduced and either recorded, rejected, or routed
    to the correct workflow;
  - a final challenge pass names the strongest remaining counterexamples and
    explains why they do not drop scope no-finding confidence below the requested
    confidence threshold.
- For high-assurance closure, do not use any no-finding closeout until an
  assurance matrix or equivalent compact accounting names the materially
  relevant bug classes, current evidence, missing assurance, and any confidence
  cap. If missing fuzz, race, stress, property, sidecar, scanner, or integration
  evidence would make the requested confidence misleading, lower the confidence
  or close with incomplete validation instead of stretching the number.
- If no findings survive in reviewed slices but deferred slices remain,
  continue to the next highest-risk deferred slice when the turn, tools, and
  permissions allow. Do not stop merely because the first reviewed slices
  produced no ledger entries.
- For broad scopes, include a durable coverage table before any no-finding or
  incomplete closeout:

  ```markdown
  | Slice | Status | Evidence | Validation | Confidence | Next scope |
  | --- | --- | --- | --- | --- | --- |
  ```

  `Status` must be one of `deep`, `skimmed`, `deferred`, `blocked`, or
  `excluded`. `Next scope` must be an exact runnable package, folder, command,
  or explicit `n/a`.
- For high-assurance closure, include or summarize this assurance accounting:

  ```markdown
  | Bug Class | Relevant Surface | Evidence | Missing Assurance | Confidence Cap |
  | --- | --- | --- | --- | --- |
  ```

  Keep it compact. Use `n/a` only when the bug class is not materially relevant
  to the requested scope, and say why in the evidence cell.
- If no confirmed gaps or proposals remain and the requested scope satisfies the
  selected outcome's confidence and coverage requirements, report that result
  with a no-finding closeout and do not create a scoped ledger. The closeout
  must include reviewed files or slices; package count or inventory summary
  when applicable; supported usage, call sites, commands, tests, or CI evidence
  checked; validation commands and their classified results; excluded or
  deferred files; rejected, routed, deferred, and blocked lead accounting;
  repository policy exclusions or suppressions applied; the confidence fields
  above; and the remaining limits on that confidence. Do not present "nothing
  found" as a broad assurance without this evidence.
- If confirmed gaps or proposals remain, write them to the scoped ledger before
  making changes unless the selected skill explicitly defines a one-pass fix
  mode. Record only high-confidence, actionable findings with file/line,
  command, config, runtime, supported-usage evidence, and a reproduction path.
  Do not record speculative exclusions, unsupported paths, unreproduced
  candidates, or examples already ruled out by `AGENTS.md` or the selected
  skill.
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
  explicitly agrees to the proposed solution. When the request names multiple
  related entries, present the combined or per-entry solution and stop before
  editing the first entry.
- Ask questions when behavior, compatibility, documentation location, test
  layer, implementation home, validation, operator workflow, or user intent is
  ambiguous enough that a correct change cannot be inferred from local context.
- After the human agrees and before editing, state the selected local pattern,
  dominant relevant test harness or validation path, planned validation command,
  and any deviation from `AGENTS.md` or selected skills. If a deviation is
  needed, stop and ask before editing.
- When the execution checklist includes `Expected red`, confirm the dominant
  harness can actually execute before behavior-changing edits, then paste the
  observed red (exact command + failing output) before making implementation
  edits; the reported `Green` MUST be that same command passing. If the harness
  is not runnable, STOP: make it runnable and observe the red, or explicitly
  request agreement to proceed test-after with the reason. Silent test-after and
  reporting a red/green cycle without pasted command output are prohibited.
- For substantial, ambiguous, or multi-iteration implementation work, use
  `long-running-work.md` after the agreement gate. Confirm the reference was
  read for the current task, maintain the progress artifact in runtime state,
  ask only blocking questions after research, and work in thin validated
  slices. This does not authorize combining find and implement modes or editing
  outside the agreed entry.
- When the current implementation request authorizes agents, use sub-agents for
  disjoint slices, validation support, or fresh review when they can materially
  improve throughput, coverage, confidence, or implementation safety. Keep one
  active ledger entry owner and do not let parallel work bypass the selected
  skill's validation, review, or human confirmation gates.
- Implement only the agreed entry with the smallest clear change using existing
  local patterns.
- Before accepting substantial implementation work as complete, apply the fresh
  review gate from `long-running-work.md`. Use an independent reviewer when
  sub-agents are explicitly authorized and available; otherwise perform a named
  local challenge pass and do not present it as equivalent to independent
  review. If agents were authorized and available but this independent review
  did not run, do not report the implementation complete at or above 90%
  confidence.
- During automatic continuations while waiting for approval or an "`ID` is
  done" confirmation, do not repeat the full proposal or result. State the
  current waiting gate once, concisely.
- Do not move to the next entry until the human says the current entry is done.
- After the human confirms an entry is done, remove or revise that entry in the
  scoped ledger. If an entry is deemed invalid, remove it only after explaining
  why and getting human agreement.
- Once all entries are resolved and confirmed done by the human, delete the
  scoped ledger.
