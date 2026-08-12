# Gap Workflow: Find And Audit

Navigation: `SKILL.md` already requires the complete `../gap-workflow.md` read
before this reference. These mechanics apply only while finding, auditing, or
running a skill's one-pass mode.

## Review Mechanics

For find, audit-only, and one-pass modes:

1. Confirm the requested package or folder scope.
2. Check the selected skill's scoped-ledger policy. In normal find/audit modes,
   stop if an existing scoped ledger blocks review. In one-pass modes that
   allow reading a ledger, incorporate matching entries and stop on unrelated
   or ambiguous active work.
3. Run `$project-workflow` discovery for entrypoints, CI, documented commands,
   relevant public surfaces, and `./bin` wiring. Establish the exact-state CI
   baseline described below before selecting validation commands.
4. Build a recursive inventory and bounded review slices from the selected
   plan. After the repository archetype and audit scope make it relevant, read
   `../gap-lead-generation.md` to build the lead inventory. Use depth only as
   a discovery aid, not as the review boundary.
5. For broad scopes, prioritize high-risk or high-value slices and record
   `deep`, `skimmed`, `excluded`, and `deferred` coverage with exact follow-up
   scopes. A confidence closure audit may close only when every relevant slice
   is `deep` or `excluded`.
6. Identify whether review commands use authentication, SSH, registries,
   cloning, pushing, publishing, remote writes, or destructive effects. Rely on
   the active agent configuration for command approval behavior; do not add a
   separate model-level permission request.
7. Apply the shared gap-workflow delegation gate before review work.
8. Wait for review work, update coverage for every slice, and deduplicate or
   directly re-check conflicting candidates.
9. Classify validation as a repository finding, local environment issue,
   missing tool, or inconclusive result. For confidence closure, include
   current CI or equivalent repository-defined validation evidence before
   closing with no findings.

## Scope Inventory And Slicing

- Exclude generated files and folders, vendored dependencies, caches, build
  output, generated API docs, and generated lockfile churn unless explicitly in
  scope.
- In downstream repositories that vendor this project as `./bin`, exclude
  `bin/**` from recursive review by default. Inspect only included
  `bin/build/make/*.mak` fragments or selected `bin/skills/**` guidance needed
  as evidence, and route upstream-only findings to a separate bin-scoped run.
- Inventory relevant file counts, first-level folders, nested packages,
  languages, public entrypoints, generated/vendor/build/cache exclusions, docs,
  examples, tests, validation entrypoints, and domain-specific surfaces.
- When the repository has package, module, component, command, service, or
  area discovery, account for its major groups and explicitly named excluded or
  skipped slices.
- Do not assign broad recursive subtrees merely because they are first-level
  folders. Split independent owners, workflows, responsibilities, packages,
  products, or audiences into behavior-, documentation-, workflow-, or
  audience-owned slices.
- Do not present a broad scope as fully reviewed while a relevant slice is only
  skimmed, deferred, or blocked. Name the exact follow-up scope. Confidence
  closure requires every relevant slice to be deep-reviewed or explicitly
  excluded.

## Validation Baseline

- Before a long audit, use `$project-workflow` to identify the repository root,
  documented entrypoints, CI analogue, configured command environment, and
  applicable tool availability. Identify runtimes, analyzers, linters,
  scanners, generation tools, sidecars, or services only when repository
  workflow needs them. This discovery does not run those commands or tools.
- For a CircleCI repository, collect exact-revision evidence with this shared
  workflow's own collector; do not invoke another skill's collector:

  ```bash
  audit_revision="$(git rev-parse HEAD)"
  skills/references/gap-workflow/collect-ci --repo . --revision "$audit_revision"
  ```

  The collector reports the matching `vcs.revision`, selected most-recent
  pipeline, final workflow attempts, configuration files, and whether matching
  candidates exceeded its selection limit. A missing token, unmatched revision,
  collector error, or truncated candidate selection is unavailable evidence,
  not a green baseline. When
  `dynamic_config` is true, use every reported `.circleci` configuration file,
  including continuation files such as `.circleci/continue_config.yml`, to
  determine the workflows relevant to the audited scope; do not treat the
  setup workflow as the only required validation. For another CI provider,
  inspect that provider's exact-revision checks through its repository-owned
  evidence path; do not infer results from configuration or a status badge.
- Record the current revision, working-tree state, and current CI result for the tested
  revision. For CircleCI, use the collector's selected exact-revision pipeline,
  observed final workflow attempts, and reported configuration files. Do not
  require workflows filtered out by the exact revision's branch or path scope.
- Classify the baseline:
  - `green`: relevant required jobs passed and the files in scope match the
    tested revision. For CircleCI, this additionally requires `status: used`,
    `exact_revision_match: true`, `candidate_scan_truncated: false`, and final
    attempts with `success` status for every required workflow.
  - `stale`: files in scope differ from the tested revision.
  - `unknown`: CI status is unavailable or the tested state cannot be matched.
- Record skipped or no-op checks as uncovered. Continue discovery with a stale
  or unknown baseline, but require equivalent current evidence before claiming
  no-finding closure. Do not infer a green baseline from CI configuration, a
  status badge, a previous run, or a future run.

## When To Run Commands

- Treat preflight as evidence planning; it does not execute standard CI
  targets. Reuse exact-state green CI evidence instead of repeating matching
  checks. Do not rerun matching broad CI targets solely for lead generation,
  delegation, or no-finding closure.
- Use `$change-validation` only when selecting a command that will actually run.
- Run the smallest supported command only to reproduce or disprove a candidate,
  cover a relevant behavior or bug class absent from CI, investigate state or
  environment drift, or replace unavailable, stale, incomplete, skipped, or
  no-op CI evidence.
- When command execution is warranted, prefer fast, reproducible local evidence
  from the smallest supported command or dominant harness.
  Keep local tests scoped to changed packages and
  graph-proven direct dependents. Broaden lint, security, or CI-equivalent
  non-test checks only when exact-state CI does not already cover the needed
  evidence and the scope crosses boundaries, affects shared infrastructure, or
  needs higher confidence. CI owns complete-suite coverage.

## Result Classification

- After a repository-defined command, Make target, dominant harness, or
  skill-required workflow fails, classify it before considering any retry. Do
  not switch to an ad hoc command, validation layer, or alternate workflow just
  to obtain a result.
- Classify every failure or skip as exactly one of: repository finding, local
  environment issue, missing tool, or inconclusive. A sandbox failure is not a
  repository finding without repository-owned code, config, or workflow
  evidence.
- If a failure is clearly sandbox, cache-permission, localhost, network,
  credential, service, or shell-environment related, retry only through the
  approved escalation or configured command environment.
- Preserve analyzer nuance: a tool may no-op for missing packages, modules,
  files, or components; integration checks may need listeners or services; and
  dependency, security, or generation checks may need network or cache writes.

## Confidence Evidence

- CI raises confidence only when the validation baseline is green or an
  equivalent repository-defined command is observed and classified. CI is
  baseline or closure evidence, not reproduction evidence for a candidate.
  Confidence closure requires current CI or an equivalent clean validation,
  with unavailable checks explicitly classified.
- For high-assurance closure, account for relevant bug classes and missing
  assurance such as property/fuzz tests, round trips, boundary/default cases,
  race/stress tests, lifecycle repetition, fault injection, generated-contract
  freshness, security scanners, or sidecar integration. Missing evidence lowers
  confidence or routes to `$test-gaps-find` or `$project-gaps-find`; it is not
  silently converted into a finding.

## Candidate Handling

- Delegated reviewers must return candidates in the selected ledger format,
  rejected leads with reasons, risky surfaces still needing review, validation,
  and exact follow-up scopes. A delegated "nothing found" without coverage,
  rejected-lead, and follow-up evidence cannot close a broad slice.
- For broad confidence closure, use independent delegated review when agents
  are available and authorized. Assign disjoint behavior- or risk-owned slices,
  require coverage, rejected leads, validation, and follow-up scopes, and run a
  final local challenge pass. If delegation is needed but unavailable or not
  authorized, stop at the delegation gate instead of presenting closure.
- For high-assurance closure with authorized agents, use an adversarial review
  when practical. It should try to falsify the no-finding conclusion, confidence
  leaps, unreviewed bug classes, missing supported usage, and counterexamples.
  Do not pass intended conclusions, rejected-lead rationale, or proposed
  confidence numbers to the adversarial reviewer unless the validation task
  specifically requires that context.
- Read `../finding-severity.md` only when filtering or assigning a candidate's
  confidence or severity. The lead inventory is a recall aid and never lowers
  ownership, reproduction, validation, confidence, or implementation gates.
- Treat comparable repositories, local checkout mappings, sibling repositories,
  and external frameworks as lead generation only. Reproduce any candidate
  through the selected skill's normal evidence path before recording it.
- Challenge every candidate against authoritative existing surfaces: public
  APIs, commands, endpoints, generated contracts, health/metrics, helpers,
  framework behavior, config defaults, docs, examples, tests, and supported
  consumer workflows. Reject or route it when an existing surface already
  satisfies the workflow. Otherwise state the residual gap as: "Even with
  <existing surface>, the audience still cannot <specific supported
  action/outcome>."
- Confirm candidates against current code, docs, examples, tests, CI,
  generated contracts, public interfaces, and command behavior. Reproduce each
  candidate before recording it as a confirmed ledger entry or presenting it as
  a proposed finding. Prefer an executable dominant-harness or repository
  entrypoint; use a non-executable trace, lookup, or negative search only for
  documentary, structural, unsupported-mode, or absence-based candidates.
- Record what was run or inspected, the observed result, and why it proves the
  repository-owned issue or limitation. For absence-based gaps, name the
  supported user, maintainer, or operator action that currently fails or cannot
  be completed.
- If reproduction is blocked by sandbox limits, tools, credentials, network,
  optional services, or ambiguous setup, classify the blocker and keep the
  candidate below the recording threshold unless a separate supported path
  proves it.
- A suggested validation command is not itself reproduction. Either run or
  inspect the smallest supported reproducer and record its observed result, or
  name the blocker and keep the candidate below threshold.
- For reusable libraries, helpers, or shared tooling, inspect a real consumer,
  example, integration test, module wiring path, documented contract, CI
  workflow, or comparable supported usage before recording a high-confidence
  candidate. Local fakes, synthetic tests, manual construction, and unsupported
  downstream patterns are leads only.
- Separate third-party, framework, tool, image, or project-owned upstream
  defects from the repository-owned response. Record only an adapter, upgrade,
  pin, replacement, workaround, validation, tracking, or other response owned
  by the selected scope; route another project-owned library's defect to its
  agent or ledger.
- When prose, comments, examples, or docs contradict implementation, require
  non-prose evidence before routing the candidate to code, security,
  reliability, or test workflows. If code, tests, runtime, generated
  contracts, CI, or history support implementation, route stale prose to
  `$doc-gaps-audit` or `$doc-gaps-fix`.
- Dismiss candidates already covered by the authoritative surface, below
  threshold, duplicative, out of scope, or owned by another workflow. Preserve
  rejected, routed, deferred, and blocked lead notes for local and delegated
  review. A quiet audit without these notes is not enough evidence for broad
  no-finding confidence.
- Treat optional follow-ups, speculative improvements, and leads that need
  production evidence or a separate product, security, or reliability design
  as closeout notes only. Do not create a scoped ledger solely to store
  optional follow-ups when no confirmed entries survive the selected skill's
  evidence gate.

## Find And Audit Outcomes

Use exactly one closeout outcome:

- `Findings recorded`
- `No findings and validation clean`
- `No findings, but validation incomplete because X`
- `Audit incomplete: no confirmed findings so far`

Distinguish finding confidence (each finding is real and repository-owned),
coverage confidence (reviewed slices were checked adequately), and scope
no-finding confidence (no reportable finding remains in scope). Broad no-finding
closeouts must report all three, using `n/a` for finding confidence when there
are no findings.

- For broad repository, package-tree, or multi-component scopes, use a
  no-finding outcome only when scope no-finding confidence reaches the active
  threshold, with every relevant slice deep-reviewed or explicitly excluded.
  When no explicit target is given, the broad-scope default is 95%. Otherwise
  use the incomplete outcome and state the reduced assurance when an explicit
  target lowers that default.
- Confidence closure additionally requires current clean validation,
  coverage/rejected-lead/validation/follow-up evidence for each delegated slice,
  every candidate reproduced or rejected/routed, and a final challenge pass
  that names the strongest counterexamples and why they do not lower the
  requested threshold.
- High-assurance closure also requires compact accounting of relevant bug
  classes, evidence, missing assurance, and any confidence cap.
- If no findings survive but deferred slices remain, continue to the next
  highest-risk slice when tools, permissions, and the turn allow. Do not close
  merely because the first slices were clean.

For broad scopes, include this coverage table before a no-finding or incomplete
closeout:

```markdown
| Slice | Status | Evidence | Validation | Confidence | Next scope |
| --- | --- | --- | --- | --- | --- |
```

`Status` is `deep`, `skimmed`, `deferred`, `blocked`, or `excluded`, and `Next
scope` is an exact runnable package, folder, command, or `n/a`. For
high-assurance closure, also summarize:

```markdown
| Bug Class | Relevant Surface | Evidence | Missing Assurance | Confidence Cap |
| --- | --- | --- | --- | --- |
```

If no confirmed gaps remain and coverage and validation satisfy the selected
outcome, report the reviewed slices, inventory, supported usage, commands,
tests/CI, validation classifications, exclusions/deferred work, rejected/
routed/deferred/blocked leads, policy exclusions, confidence fields, and limits
on that confidence. If confirmed entries remain, write the selected scoped
ledger before fixes and stop after presenting the ledger and coverage state.
