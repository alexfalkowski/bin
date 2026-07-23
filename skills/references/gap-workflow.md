# Gap Workflow

Use this reference for scoped gap-finding and gap-implementation skills. The
selected skill owns domain judgment, ledger format, mode names, and mode-specific
final output. These shared rules own workflow mechanics and the common session
summary shape.

## Mode And Plan State

- If no scope is provided, stop and ask for the package or folder.
- A direct invocation such as `$skill-name in SCOPE` invokes exactly one
  skill directly. Mode is determined by which skill was invoked, not inferred
  from phrasing: a find/implement (or audit/fix) pair is two single-purpose
  skills, each named for the job it does (for example `$code-issues-find` and
  `$code-issues-implement`), and only the implement/fix half acts on an
  entry after re-checking that the ledger item still stands. An implement
  request may name one entry or an ordered same-prefix batch such as
  `ISSUE-1/2/3`; resolve the prefix and single ledger path from
  `ledger.yaml`, and reject a repeated or mixed prefix such as
  `ISSUE-1/FEATURE-2`. The `with agents`, `with a goal`, and `with agents and a
  goal` tails may follow any direct invocation and carry the same
  current-request authorization without changing which skill runs or
  bypassing implementation gates.
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
  in runtime state only. A find/implement (or audit/fix) skill only performs
  its own job, so combining find and implement in one turn is structurally
  impossible except for the documented `doc-gaps-fix` exception, which finds
  and fixes in the same pass by design. Preserve stop gates as boundaries.
- Treat validation as stale when files change after a command runs.

## Common Plan Mechanics

Use these mechanics with the selected skill's `references/plan.md`. The plan
names the domain-specific inventory surfaces, candidate tests, closeout
questions, and implementation pairings.

## Ledger Contract Resolution

- Each ledger skill owns `ledger.yaml`. It is the authoritative source of its
  `id_prefix`, `ledger_filename`, and `ledger_path_template` values.
- When the selected ledger skill and scope are known, read that contract and
  resolve the exact ledger path by substituting the scope and ledger filename
  into `ledger_path_template`. The version-1 template is
  `{scope}/{ledger_filename}`.
- When an implement/fix request names an ID, validate it against
  the resolved contract prefix, then read or update only the resolved ledger
  path. For a `PREFIX-N[/N...]` batch, validate the first prefix and every
  slash-delimited entry number against that one contract before interpreting it
  as a batch. Do not treat the batch as one malformed ID, search the workspace
  for possible ledgers, infer a different ledger path, or accept a mixed-prefix
  batch. Do not search the workspace for possible ledgers.
- An explicit `in LEDGER_PATH` tail remains available only when the selected
  skill or scope is ambiguous. Once both are known, the contract path wins.
- A find/implement (or audit/fix) pair split from one shared ledger has a
  single owner: only the implement (or fix) half's directory contains
  `ledger.yaml` and `references/ledger-format.md`. The find (or audit) half
  does not duplicate them; it cross-references the implement/fix half's
  copies by relative path (for example
  `../code-issues-implement/ledger.yaml`). This keeps exactly one
  `ledger.yaml` per `id_prefix`, which downstream tooling that scans
  `skills/*/ledger.yaml` for a prefix match relies on. Resolve the contract
  from whichever skill in the pair actually owns the file; never search the
  workspace for a second copy or treat an absent `ledger.yaml` in the
  find/audit half as an error.

## Mode-Specific References

- When beginning review mechanics for find, one-pass, or audit-only work, read
  `gap-workflow/find-audit.md`. It owns inventory, validation, candidate
  handling, coverage accounting, and closeout outcomes.
- When beginning an actual implementation path or unresolved-ledger fix, read
  `gap-workflow/implementation.md`. It owns ledger re-checks, implementation
  sequencing, and fresh review.
- After the repository archetype and audit scope make lead generation relevant,
  read `gap-lead-generation.md` to build a lead inventory and account for
  confirmed, rejected, routed, deferred, and blocked leads.

## Scoped Ledgers

- Before resolving a scoped ledger path or entry ID, read the selected skill's
  `ledger.yaml`. Before creating or updating a scoped ledger, ensure the
  consuming repository root `.gitignore` exists and contains its
  `ledger_filename` as a standalone pattern. Checking or reading an existing
  ledger must not modify `.gitignore`.
- Use the exact path resolved from the selected skill's `ledger.yaml` and the
  requested scope.
- In find or audit-only modes, stop when an existing scoped ledger blocks review
  unless the selected skill explicitly allows reading or refreshing it. In
  implement mode, read it first; if it does not exist, ask whether to run find
  mode first.
- Read entries in the previous `Context` / `Evidence` / `Proposal` shape
  without requiring migration. Rewrite them to the current `What` / `Why` /
  `How` shape only when creating or updating that entry.
- Record durable findings or proposals only in the selected scoped ledger and
  assign IDs using the contract's `id_prefix`.

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
  judgment, and adversarial verification. In a finder-plus-verifier pattern,
  where a strong orchestrator or a dedicated verifier independently
  re-verifies each delegated finding, the delegated review finders may also
  run one tier cheaper than the session model even when their sub-task is
  judgment-heavy, such as a slice-scoped `$code-review` or `$security-audit`;
  reserve the strongest tier for that final acceptance, confidence, and
  adversarial-verification pass, not for every finder. This does not change
  when sub-agents are authorized and does not lower any evidence, confidence,
  or challenge gate; if a cheaper model cannot reach the required evidence,
  escalate the model instead of accepting the weaker result.
- When the active runtime supports per-agent model selection, set the model
  explicitly for mechanical, disjoint, or read-only sub-tasks such as lookup,
  file discovery, lead generation, and non-mutating reproduction; an unset
  model silently inherits the parent session's model and defeats this
  section's cost intent. When a lighter read-only agent type is available and
  sufficient, prefer it over a full-toolset general-purpose agent. This
  changes only agent selection; it never relaxes scope, evidence,
  reproduction, confidence, challenge, or approval requirements.
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
