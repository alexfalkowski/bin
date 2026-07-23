---
name: feature-gaps-find
description: Find repository-fit product capability gaps without editing; use $feature-gaps-implement for confirmed entries, not test or project-workflow gaps.
---

# Feature Gaps Find

Trigger phrases: `Find $feature-gaps-find in PACKAGE_OR_FOLDER` or
`Find feature gaps in PACKAGE_OR_FOLDER`. This skill only discovers and
records candidates; it never edits code. Use `$feature-gaps-implement` to
re-check and implement a specific ledger entry, using the contract in
`../feature-gaps-implement/ledger.yaml`.

Before starting, read `../references/gap-workflow.md` completely, then
`references/plan.md`; they own runtime state, delegation, scope, coverage, and
confidence gates. Read `references/find-rules.md` when beginning review and
`references/acceptance-gate.md` before recording a candidate. Read
`../references/gap-workflow/find-audit.md` when beginning review mechanics.
Read `../feature-gaps-implement/ledger.yaml` only when resolving the scoped
ledger path or an entry ID, and its ledger format only before interpreting,
creating, or updating an entry.

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
`$test-gaps-find` for missing/weak tests and test-support or harness quality. Use
`$project-gaps-find` for build, CI, Makefile, release, setup, validation, command
discovery, and repository workflow improvements. In this shared `bin`
repository, reusable Make fragments and scripts can be product surfaces only
when the proposal improves downstream shared-tooling capability; improvements
whose value is local build/test/CI/release workflow hygiene still belong to
`$project-gaps-find`.

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

Follow `references/plan.md` and the find/audit rules in
`../references/gap-workflow/find-audit.md`.

Those feature-gap rules remain mandatory.

## Ledger Format

Before recording a candidate, read `../feature-gaps-implement/ledger.yaml` and
`../feature-gaps-implement/references/ledger-format.md` —
`$feature-gaps-implement` owns the ledger contract and entry-format definition
so there is one canonical copy. Each entry is a self-contained mini-PRD
organized like the shared mini-RFC: `What -> Why -> How`. The required core
must keep `| Field | Value |`, `| Status |`, and `**Summary.**`; `### What`
with `**Current.**` and `**Expected.**`; `### Why` with `**Impact.**` and
`#### Evidence` containing `**Claim:**`, `**Observed:**`,
`**Reproduction:** Smallest supported user`, and `**Source:**`; and `### How`
with `#### Proposal`, `**Keep.**`, `#### Alternatives Considered`, and
`#### Definition of Success` containing `**Validation:**`. Add
`#### Situation Map`, `### Goals / Non-goals` (usually warranted for
features), `### Open Questions`, and `### Decision` when the entry warrants
them.

## References

- Read `references/plan.md` before starting.
- Read `references/find-rules.md` before reviewing or recording candidates.
- Read `references/acceptance-gate.md` before recording any scoped-ledger
  candidate.
- Read `../feature-gaps-implement/ledger.yaml` and
  `../feature-gaps-implement/references/ledger-format.md` before creating or
  updating the scoped ledger.
- Read `../references/gap-workflow.md` for shared scoped-ledger and delegation
  gates; read `../references/gap-workflow/find-audit.md` for review mechanics.
- Use `../references/gap-lead-generation.md` to classify repo archetypes,
  generate product-surface leads, and account for rejected or routed
  candidates.
- Use `$project-workflow` for repository command discovery, documented
  entrypoints, CI expectations, examples, and `./bin` wiring before review
  planning, and route standalone project workflow gaps to `$project-gaps-find`.
- Use `$change-safety` when a proposed feature affects public contracts,
  compatibility, migrations, config, generated files, dependencies, deployment,
  security expectations, or documented operational behavior.
- Use `$doc-standards` when feature behavior needs README, docs, examples,
  command help, package docs, comments, or docstrings.
- Use `$naming-standards` when a feature creates or changes identifiers,
  commands, flags, files, test fixtures, public terminology, or documentation
  terms.
- Use `$code-issues-find`, `$security-audit`, `$reliability-gaps-find`,
  `$test-gaps-find`, `$doc-gaps-audit`/`$doc-gaps-fix`, or `$project-gaps-find`
  when the confirmed concern belongs to those ledgers instead of feature
  opportunities.
