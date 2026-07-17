# Gap Workflow

Use this reference for scoped gap-finding and gap-implementation skills. The
selected skill owns domain judgment, ledger format, mode names, and mode-specific
final output. These shared rules own workflow mechanics and the common session
summary shape.

## Mode And Plan State

- If no scope is provided, stop and ask for the package or folder.
- Treat remembered commands as gap-workflow shorthand. `Start` begins the
  workflow, `Approved` accepts the presented solution, and `Done` confirms an
  entry is verified. Each takes the optional tail `in LEDGER_PATH` when an ID
  is ambiguous, and `with agents`, `with a goal`, or `with agents and a goal`:
  - `Start ID` selects the matching gap skill and enters implement mode for the
    entry. `Start ID1/ID2 in LEDGER_PATH` selects multiple entries.
  - `Start ID with agents` explicitly authorizes sub-agents for the current
    request.
  - `Start ID with a goal` explicitly authorizes a runtime goal when goals are
    available and useful.
  - `Start ID with agents and a goal` explicitly authorizes both.
  - `Approved ID` approves the presented solution and permits implementation.
    The `with agents`, `with a goal`, and `with agents and a goal` tails apply.
  - `Done ID` confirms the entry is verified and complete. Its authorization
    tail carries forward to the next entry.
  These shorthands do not bypass solution agreement, scoped ledgers, validation
  freshness, confidence thresholds, remote-write permission, or output format.

- A generic invocation such as `$skill-name in SCOPE` uses the selected skill's
  declared default mode. One-pass skills execute that pass; two-phase gap
  skills default to Find mode and must present a proposal before entering
  Implement mode. The `with agents`, `with a goal`, and `with agents and a goal`
  tails may follow generic, Find, or Implement invocations and carry the same
  current-request authorization without changing mode selection or bypassing
  approval gates.
- Before starting find, audit, one-pass, or implement mode, read the selected
  skill's `references/plan.md` and keep it as runtime state. Do not write it to
  the repository unless the human explicitly asks for a durable plan file.
- Determine the active confidence threshold before reviewing. Use an explicit
  confidence target from the current request, such as "50% confidence", for
  the selected finding, proposal, or audit scope. When no explicit target is
  given, use 90% for an individual finding or proposal and 95% for a broad
  no-finding claim or other high-risk acceptance. An explicit percentage may be
  lower or higher than those defaults; when it is lower, state the reduced
  assurance and residual risks rather than silently raising it. This threshold
  choice does not waive evidence, challenge-pass, approval, validation,
  security, compatibility, or truthful-reporting requirements.
- If the human asks for a broad no-finding target, such as "95% confidence",
  "99% closure", "max confidence", "full closure", "no issues anywhere", or
  equivalent broad assurance, treat the run as a **confidence closure audit**.
  Use the requested percentage as the active scope no-finding confidence
  threshold. When no explicit percentage is given for a broad audit, use the
  95% default. Do not accept 100% as an achievable threshold for repository
  review; if the human asks for 100% certainty, explain that the workflow can
  pursue that target but cannot truthfully claim 100% closure.
- Treat a confidence closure audit as **high-assurance closure** when the active
  threshold is higher than the broad no-finding default threshold, or when the
  human asks for "max confidence", "full closure", "no issues anywhere", "no
  possible bugs", or equivalent broad assurance. High-assurance closure scales
  evidence to the active threshold; do not hard-code one percentage as the only
  trigger for stronger review.
- Distinguish scope no-finding confidence from a literal no-possible-bugs
  claim. Close only on reportable findings under the selected skill's evidence
  rules and state residual risks from unsupported paths, environments, future
  dependencies, or unexercised state space.
- Use runtime goals only when the human explicitly requests them or higher
  priority runtime instructions allow them. Otherwise use conversation or the
  tool plan for state.
- For substantial, ambiguous, or multi-iteration work, read
  `long-running-work.md` before the first slice and keep its progress artifact
  in runtime state only. Do not combine find and implement modes unless the
  selected skill defines a one-pass mode. Preserve stop gates as boundaries.
- Treat validation as stale when files change after a command runs.

## Common Plan Mechanics

Use these mechanics with the selected skill's `references/plan.md`. The plan
names the domain-specific inventory surfaces, candidate tests, closeout
questions, ledger filename, ID prefix, and implementation pairings.

## Mode-Specific References

- Before Find, one-pass, or audit-only work, also read
  `gap-workflow/find-audit.md`. It owns inventory, validation, candidate
  handling, coverage accounting, and closeout outcomes.
- Before Implement work, also read `gap-workflow/implementation.md`. It owns
  ledger re-checks, agreement gates, implementation sequencing, and fresh
  review.

Use `gap-lead-generation.md` during find, audit-only, and one-pass modes to
classify repository archetypes, build a lead inventory, use comparable
repositories or framework checklists when useful, and account for confirmed,
rejected, routed, deferred, and blocked leads.

## Scoped Ledgers

- Before creating or updating a scoped ledger, ensure the consuming repository
  root `.gitignore` exists and contains that ledger filename as a standalone
  pattern. Checking or reading an existing ledger must not modify `.gitignore`.
- Use the selected skill's ledger filename in the requested package or folder,
  such as `PACKAGE_OR_FOLDER/ISSUES.md`, `TESTS.md`, `DOCS.md`, `FEATURES.md`,
  `PROJECTS.md`, or `RELIABILITY.md`.
- In find or audit-only modes, stop when an existing scoped ledger blocks review
  unless the selected skill explicitly allows reading or refreshing it. In
  implement mode, read it first; if it does not exist, ask whether to run find
  mode first.
- Read entries in the previous `Context` / `Evidence` / `Proposal` shape
  without requiring migration. Rewrite them to the current `What` / `Why` /
  `How` shape only when creating or updating that entry.
- Record durable findings or proposals only in the selected scoped ledger and
  assign IDs using its prefix, such as `ISSUE-N`, `TEST-N`, `DOC-N`,
  `FEATURE-N`, `PROJECT-N`, or `REL-N`.

## Session Summary

When the final response reports one or more confirmed, fixed, or remaining
ledger entries, use exactly this compact summary shape:

```markdown
## Summary

| Title | What | Why |
| --- | --- | --- |
| ID: Short concrete title | One short sentence describing the gap or completed change. | One short sentence describing why it matters to the affected audience. |
```

Use the selected ledger ID and entry title in `Title`. Keep `What` and `Why` to
one short, plain sentence each. Do not replace this table with bullets or prose,
and do not add columns. Keep evidence, proposals, status, confidence,
validation, coverage, and follow-up detail in their required sections outside
the summary; do not repeat them in the table. Omit the table when there are no
confirmed, fixed, or remaining entries to summarize.

## Delegation And Permissions

- Use sub-agents only when the active runtime provides them and the current user
  request explicitly asks for sub-agents, delegation, or parallel agent work.
- When sub-agents are authorized, use them for disjoint implementation,
  independent validation, forward-testing, or fresh review when they
  materially improve coverage, confidence, throughput, or implementation safety,
  or when the selected skill requires them.
- If the current request does not authorize sub-agents, perform local review
  only when the selected skill does not require delegation and the requested
  review can still reach its evidence and confidence threshold. If credible
  completion depends on delegation, stop and ask for explicit current-request
  sub-agent authorization. This is the current-request sub-agent authorization
  gate; do not infer it from a remembered command or a prior turn.
- If authorized sub-agents are unavailable, forbidden, or denied by the
  runtime, perform local review only when the selected skill does not require
  delegation and confidence can still be reached. Otherwise state the blocked
  delegation requirement plus runtime limitation.
- Do not silently downgrade to local-only review or present a single-agent
  substitute as equivalent.
- When the runtime supports per-sub-agent model selection, match the model to
  the sub-task: use a cheaper or faster model for mechanical, disjoint, or
  read-only sub-agents such as search, file discovery, and reproduction, and
  reserve the strongest model for synthesis, acceptance and confidence
  judgment, and adversarial verification. This does not change when sub-agents
  are authorized and does not lower any evidence, confidence, or challenge gate;
  if a cheaper model cannot reach the required evidence, escalate the model
  instead of accepting the weaker result.
- Brief each sub-agent with the minimum references and context its sub-task
  needs, including all mandatory instructions and current evidence for that
  slice, rather than the full skill reference chain, so parallel sub-agents
  stay cheaper.
- Identify whether review commands use authentication, SSH, registries,
  cloning, pushing, publishing, remote writes, or destructive effects. Rely on
  the active agent configuration for command approval behavior; do not add a
  separate model-level permission request.

## Candidate Integrity

- Reproduce each candidate before recording it as a confirmed ledger entry or
  presenting it as a proposed finding. Use the smallest supported path. Record the reproduction path in the candidate and ledger entry.
- For reusable libraries, helpers, or shared tooling, high-confidence review
  requires current code evidence, supported-usage evidence, and a reproduction path.
  Package-local fakes, synthetic tests, manual construction, and unsupported
  downstream patterns remain leads only.
- If reproduction is blocked by sandbox limits, missing tools, credentials,
  network, optional services, or ambiguous setup, do not record the candidate as confirmed unless a separate supported reproduction path proves it.
- Make every ledger entry understandable without opening source files. State
  the plain-language claim and observed result before the source locator.
