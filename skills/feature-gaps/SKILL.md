---
name: feature-gaps
description: Use when the user asks to find or implement $feature-gaps/feature gaps in a package or folder, set a confidence closure target such as 95% or 99%, find main product capability gaps, find product-owned user/operator/service-author/package-consumer/CLI/API/library opportunities, uses Start, Approved, or Done with ledger entry IDs and optional agents or a goal, or asks what the proposal is for a feature-gap ledger entry. Find repository-fit feature opportunities with explicit audience benefit; record scoped ledger proposals; later propose and implement agreed changes one at a time. Do not use for standalone test, CI, build, Makefile, release, validation, or repository workflow gaps.
---

# Feature Gaps

Use Find mode by default when no mode is stated. Enter Implement mode only
after the human explicitly agrees to a specific proposed solution, typically
with `Approved <ID>-N` using the prefix from `ledger.yaml`. Do not combine modes in one pass:

- **Find mode**: `Find $feature-gaps in PACKAGE_OR_FOLDER` or `Find feature gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $feature-gaps in PACKAGE_OR_FOLDER` or `Implement feature gaps in PACKAGE_OR_FOLDER`.

Before either mode, read `ledger.yaml`, `references/plan.md`, and
`../references/gap-workflow.md` and the mode-specific reference below own
runtime state, ledger, delegation,
scope, coverage, confidence, and approval gates. Before Find mode, also read
`../references/gap-workflow/find-audit.md`; before Implement mode, also read
`../references/gap-workflow/implementation.md`.

## Operating Stance

Operate as a scoped product triager: propose only main product capabilities
that fit the repository's purpose, current architecture, documented workflows,
and likely user, operator, service-author, package-consumer, CLI, API, or
library needs. A feature gap is not a bug, test gap, doc gap, reliability gap,
project workflow gap, or style preference. It is an actionable improvement that
the repository does not currently provide and that would make an existing
product-facing workflow meaningfully better.

Do not record standalone improvements to tests, test harnesses, CI, build
systems, Make targets, release automation, validation preflight, command
discovery, repository setup, or local maintainer workflow as feature gaps. Use
`$test-gaps` for missing/weak tests and test-support or harness quality. Use
`$project-gaps` for build, CI, Makefile, release, setup, validation, command
discovery, and repository workflow improvements. In this shared `bin`
repository, reusable Make fragments and scripts can be product surfaces only
when the proposal improves downstream shared-tooling capability; improvements
whose value is local build/test/CI/release workflow hygiene still belong to
`$project-gaps`.

Treat local repository evidence as the primary source of fit. Comparable
products, libraries, CLIs, frameworks, and systems can reveal useful patterns,
but do not record a feature merely because another tool has it. First prove the
opportunity maps to this repository's scope, audience, and implementation
surface.

Use external product or library research when it would materially improve the
proposal and the runtime provides an allowed research tool. Prefer official
docs, project repositories, release notes, and mature tool behavior over blog
posts or generic trend lists. Identify whether research commands use SSH,
GitHub auth, registry auth, cloning, or remote writes. Rely on the active agent
configuration for command approval behavior; do not add a separate model-level
permission request.

## Acceptance Gate

Before recording any scoped-ledger candidate, read
`references/acceptance-gate.md`. A proposal must satisfy that gate at the
active confidence threshold or higher. Use an explicit confidence target from
the current request when provided; otherwise use the 90% default (or the 95%
high-risk default when applicable). A lower explicit target changes the
actionability threshold but does not waive the gate's evidence requirements.
Otherwise gather more evidence or reject the proposal.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Read `references/find-rules.md`; those feature-gap rules remain mandatory in
Find mode.

## Ledger Format

Before creating, updating, or interpreting the scoped ledger, read `ledger.yaml` and
`references/ledger-format.md`. Each entry is a self-contained mini-PRD organized
like the shared mini-RFC: `What -> Why -> How`. The required core must keep
`| Field | Value |`, `| Status |`, and `**Summary.**`; `### What` with
`**Current.**` and `**Expected.**`; `### Why` with `**Impact.**` and
`#### Evidence` containing `**Claim:**`, `**Observed:**`,
`**Reproduction:** Smallest supported user`, and `**Source:**`; and `### How`
with `#### Proposal`, `**Keep.**`, `#### Alternatives Considered`, and
`#### Definition of Success` containing `**Validation:**`. Add
`#### Situation Map`, `### Goals / Non-goals` (usually warranted for features),
`### Open Questions`, and `### Decision` when the entry warrants them.

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow/implementation.md`.

## Implementation Proposal Gate

Before asking for agreement to edit a feature, read
`references/implementation-proposal.md` and present that decision packet. It
must lead with `## Solution Shape` and include a self-contained `What`, `Why`,
and `How` decision summary. `Approved <ID>-N` using the prefix from `ledger.yaml` approves this solution shape and starts implementation. `Approved <ID>-N with agents` approves this solution shape and authorizes sub-agents for implementation or fresh review when useful. The `with a goal` and `with agents and a goal` tails apply here too.

These feature implementation rules remain mandatory:

- Before proposing an implementation for each feature, re-check the current
  code, generated surfaces, framework wrappers, shared helpers, vendored
  dependency behavior when delegated, docs, tests, examples, command behavior,
  and comparable-tool evidence. Treat the ledger as something that can go
  stale: dismiss or revise proposals that are already supported, duplicate
  another feature, no longer fit the repository, or belong in another workflow.
- Present the proposal using the implementation proposal gate format above
  before asking for agreement. Keep plan state separate from the decision
  packet; use the plan only to show workflow progress, not as the primary
  decision surface. Put `## Solution Shape` first so the human can judge the
  design shape before reading the self-contained decision summary or plan state.
- Ask questions when audience, product direction, compatibility, dependency
  policy, UX/DX behavior, test layer, validation, or user intent is ambiguous.
  Treat silence or a broad "implement feature gaps" request as permission to
  start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- In that pre-edit statement, also state the simplest implementation shape that
  satisfies the feature using existing local code, config, docs, harness,
  lifecycle, and validation patterns.
- Treat new orchestration, lifecycle, or harness machinery as a complexity
  trigger. Before adding extra processes, ports, config files, startup paths,
  lifecycle hooks, env/config indirection, harness classes, generated fixtures,
  or helper layers, stop and explain why the existing repository pattern cannot
  support the approved feature. If the reason is only flexibility,
  convenience, experimentation, or personal clarity, do not add the machinery.
- For behavior-changing features, state the feature execution checklist before
  editing: `TDD decision`, `First test/scenario`, `Expected red`, `Intended
  green change`, `Refactor checkpoint`, and `Validation`. When the harness is
  runnable, observe and paste the red (command + failing output) before
  implementation edits; if it is not runnable, stop and request agreement to
  proceed test-after with the reason rather than skipping red silently.
- Implement only the agreed feature with the smallest clear change that
  preserves existing public behavior unless the human explicitly approved a
  compatibility break.
- Use `$change-safety` for public interfaces, compatibility, migration,
  generated files, config, security-sensitive behavior, or dependencies.
- Use `$testing-standards` for test design and pair with relevant language
  standards for local idioms.
- Use `$doc-standards` when the feature changes public commands, APIs, examples,
  configuration, or documented workflows.
- Use `$change-validation` when selecting validation commands.
- Report `Red`, `Green`, `Refactor`, and `Validation` entries. `Red` and `Green` must each paste the actual command and its real output using the same command/selector; a label without pasted output is not acceptable, and work where red was never observed before implementation must be labeled `test-after (not TDD)` with the reason instead of a TDD cycle. Use `Refactor: none (<reason>)` when no cleanup was needed after green. Ask the human to verify and say `Done <ID>-N` using the prefix from `ledger.yaml`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `references/find-rules.md` during Find mode before reviewing or
  recording candidates.
- Read `references/acceptance-gate.md` before recording any scoped-ledger
  candidate.
- Read `ledger.yaml` and `references/ledger-format.md` before creating,
  updating, or interpreting the scoped ledger.
- Read `references/implementation-proposal.md` before asking for agreement to
  edit a feature.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for Find-mode rules and
  `../references/gap-workflow/implementation.md` for Implement-mode rules.
- Use `../references/gap-lead-generation.md` during Find mode to classify repo
  archetypes, generate product-surface leads, and account for rejected or routed
  candidates.
- Use `$project-workflow` for repository command discovery, documented
  entrypoints, CI expectations, examples, and `./bin` wiring before review
  planning or validation, and route standalone project workflow gaps to
  `$project-gaps`.
- Use `$change-safety` when a proposed feature affects public contracts,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$testing-standards` when deciding or reviewing tests for a feature.
- Use `$doc-standards` when feature behavior needs README, docs, examples,
  command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a feature creates or changes identifiers,
  commands, flags, files, test fixtures, public terminology, or documentation
  terms.
- Use `$change-validation` when selecting validation commands for implemented
  feature changes.
- Use `$code-issues`, `$security-audit`, `$reliability-gaps`, `$test-gaps`,
  `$doc-gaps`, or `$project-gaps` when the confirmed concern belongs to those
  ledgers instead of feature opportunities.
