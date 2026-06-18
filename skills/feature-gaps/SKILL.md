---
name: feature-gaps
description: Use when the user asks to find $feature-gaps in a package or folder, find feature gaps in a package or folder, find main product capability gaps, find product-owned user, operator, service-author, package-consumer, CLI, API, or library feature opportunities, implement $feature-gaps in a package or folder, implement feature gaps in a package or folder, asks about feature IDs such as FEATURE-1, asks what the proposal is for FEATURE-1, asks to fix or verify FEATURE-1, or says FEATURE-1 is done. Find concrete repository-fit product feature opportunities, record confirmed proposals in scoped FEATURES.md, and later propose and implement agreed feature changes one at a time. Do not use for standalone test, CI, build, Makefile, release, validation, or repository workflow gaps.
---

# Feature Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $feature-gaps in PACKAGE_OR_FOLDER` or `Find feature gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $feature-gaps in PACKAGE_OR_FOLDER` or `Implement feature gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as ledger, proposal, approval, validation,
or human-confirmation state changes.

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
posts or generic trend lists. Ask for human permission before running commands
that require network, SSH, GitHub auth, registry auth, remote writes, cloning,
or other approval-gated access.

## Acceptance Gate

Apply this gate before recording any candidate in `FEATURES.md`. A feature
proposal must satisfy every item below at 90% confidence or higher. If any item
cannot be answered from concrete evidence, gather more evidence or reject the
candidate instead of recording it as low priority.

- **Audience**: Name the user, developer, maintainer, operator, package
  consumer, or service author who benefits.
- **Current limitation**: State the existing workflow limitation, missing
  capability, or friction. The limitation must exist today and must not already
  be solved by current code, docs, examples, or command behavior.
- **Repository ownership**: Show that this repository owns the behavior,
  interface, workflow, helper, or documentation surface where the feature
  belongs.
- **Product surface**: Identify the main product surface being improved: public
  command, API, library behavior, service/operator behavior, package-consumer
  workflow, shipped integration, reusable template, or documented product
  extension point. Reject candidates whose primary surface is test harnesses,
  CI, build, Makefile, release, validation, command discovery, or repository
  workflow plumbing.
- **Evidence**: Cite concrete local evidence such as code, docs, examples,
  command behavior, tests, recurring maintainer workflow, or comparable mature
  tool behavior. Comparable-tool evidence is supporting evidence, not a
  sufficient reason by itself.
- **Repository fit**: Explain why the feature matches the repository purpose,
  current architecture, local naming, file layout, command style, dependency
  posture, and downstream `./bin` reuse model.
- **Smallest useful version**: Define the smallest feature slice that creates
  real value without a broad rewrite or speculative platform work.
- **Compatibility and maintenance**: Identify public behavior, migration,
  dependency, security, support, and long-term maintenance tradeoffs. Reject
  proposals whose cost or compatibility risk outweighs the demonstrated value.
- **Validation path**: Name the repository-defined command, test, lint, docs
  check, or manual verification path that can credibly validate the change.
- **Correct workflow**: Confirm the candidate is not primarily a code bug,
  security issue, reliability gap, test gap, doc gap, project workflow gap,
  naming issue, style preference, or unsupported roadmap decision.

Reject ideas whose support is only novelty, taste, competitor parity, a trend,
an imagined future user, framework preference, private implementation
preference, or generic "nice to have" polish.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Before checking, reading, creating, or updating the scoped `FEATURES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `FEATURES.md` as a standalone pattern. If the pattern is missing, add it.
- Use `FEATURES.md` in the requested package or folder as the proposal ledger,
  for example `PACKAGE_OR_FOLDER/FEATURES.md`.
- If `FEATURES.md` already exists in the requested package or folder, stop.
  Tell the user the existing scoped feature ledger must be resolved first, or
  the human must delete that scoped `FEATURES.md` before a new find pass there.
- Treat `Find $feature-gaps in PACKAGE_OR_FOLDER` or `Find feature gaps in
  PACKAGE_OR_FOLDER` as the user's explicit request to delegate feature-gap
  discovery for that scope. Do not require the user to separately say "use
  sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and
  runtime policy/tooling permits delegation. Do not treat sub-agents as
  optional based on scope size, and do not perform the feature-gap review
  locally first.
- Do not claim that extra delegation wording is needed before launching review
  agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If
  sub-agents are unavailable, say so briefly and perform the review locally for
  the requested scope.
- Ask for human permission before agents run commands that require approval,
  such as network, SSH, GitHub auth, registry auth, remote writes, cloning,
  destructive operations, or non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build
  output, generated API docs, and generated lockfile churn unless the requested
  scope is explicitly about them.
- Before assigning review agents, build a recursive scope inventory for the
  requested package or folder: relevant file count, first-level subfolders,
  nested packages, dominant languages, tests, public entrypoints, generated,
  vendor, build, and cache exclusions, user-facing product surfaces,
  package-consumer or service-author surfaces, operator-facing surfaces, docs,
  examples, command help, and likely product extension points.
- Do not assign broad recursive subtrees merely because they are first-level
  subfolders. When a subtree contains many independent products, packages,
  workflows, or audiences, split it into smaller behavior-owned or
  audience-owned slices before delegation.
- Prefer slices based on repository-owned feature surface and user value:
  public commands/APIs, library or service behavior, package-consumer and
  service-author workflows, documented product examples, product onboarding
  paths, integrations, extension points, changed or recently touched product
  areas, and nearby tests. Use depth only as a discovery aid, not as the review
  boundary.
- If the requested scope is too broad to review credibly in one pass, review
  the highest-value slices first and record explicit coverage: reviewed deeply,
  skimmed, excluded, and deferred.
- Do not present a broad requested scope as fully reviewed when any relevant
  slice was only skimmed or deferred. Name those slices in the final coverage
  notes and provide runnable follow-up scopes for deferred review.
- Each assigned agent owns recursive review only within its bounded slice. Each
  agent must perform feature-gap discovery for that slice, pairing with
  `$project-workflow`, `$doc-standards`, `$naming-standards`, relevant language
  standards, `$change-safety`, `$testing-standards`, and `$change-validation`
  as the proposed feature surface requires. Agents must use `$testing-standards`
  and `$project-workflow` to route test-harness, build, CI, Makefile, release,
  validation, command-discovery, or repository-workflow candidates away from
  `FEATURES.md` before returning feature proposals.
- Require each agent to return proposals in the same shape as the `FEATURES.md`
  format, without final IDs unless useful locally.
- Confirm each candidate feature against the acceptance gate, code, docs,
  tests, examples, command behavior, current architecture, and available
  comparable-tool evidence before recording it. Try to disprove the candidate
  by asking whether the workflow is already supported, whether the repository
  owns the behavior, whether the likely audience exists, and whether the
  feature can be added incrementally using local patterns.
- Record feature gaps only when the proposal names the audience, current
  product workflow limitation, repository-owned product surface, evidence of
  user, operator, service-author, package-consumer, CLI, API, or library value,
  fit with existing patterns, smallest plausible implementation path,
  compatibility risk, and validation path.
- Do not record confirmed bugs, security issues, compatibility breaks,
  reliability gaps, missing tests, test-harness quality issues, stale docs,
  project workflow gaps, or unclear naming as feature gaps. Route them to
  `$code-issues`, `$security-audit`, `$reliability-gaps`, `$test-gaps`,
  `$doc-gaps`, `$project-gaps`, or `$naming-standards` as appropriate.
- Do not record feature ideas whose evidence is only novelty, personal
  preference, a competitor checklist, a trend, an undocumented future roadmap,
  a broad rewrite, a new framework preference, or optional polish with no
  concrete workflow improvement.
- Do not record feature proposals that require a new product direction,
  breaking public behavior, new external service, new dependency class, or
  significant maintenance commitment unless the current repository already
  points to that direction and the proposal explains the compatibility and
  maintenance tradeoff.
- If a candidate would mostly require documentation, examples, tests, or
  reliability controls for existing behavior, route it to the matching gap
  workflow instead of recording it here.
- If a candidate would mostly require CI, build, Makefile, release, validation
  preflight, command discovery, setup, or repository workflow changes, route it
  to `$project-gaps` instead of recording it here.
- If no confirmed feature gaps are found, report that no feature gaps were
  found and do not create `FEATURES.md`.
- If confirmed feature gaps are found, write all proposals to the scoped
  `FEATURES.md` before making any changes.
- Assign every proposal a unique ID for the session in the form `FEATURE-N`.
- Stop after presenting the ledger and plan. Do not implement proposals in the
  same pass.

## `FEATURES.md` Format

Use this structure:

```markdown
# Features

## FEATURE-1: Short concrete title

- Type: Feature Gap
- Priority: High|Medium|Low
- Confidence: 93%
- Scope: path/to/file-or-folder
- Audience: User|Developer|Maintainer|Operator|Package consumer|Service author
- Current limitation: The workflow limitation, missing capability, or friction.
- Evidence: Concrete file and line references, command behavior, docs, examples, comparable-tool evidence, or user/developer workflow evidence.
- Repository fit: Why this belongs in the current repository and matches existing patterns.
- Product surface: Public command|API|library behavior|service/operator behavior|package-consumer workflow|integration|template|extension point.
- Proposed feature: Smallest useful capability to add.
- Compatibility and maintenance: Public behavior, dependency, migration, support, or maintenance tradeoffs.
- Validation: Suggested checks for the feature change.
```

Keep optional follow-up notes separate from proposals:

```markdown
## Optional Feature Follow-Ups

- Optional or non-blocking idea.
```

## Priority And Confidence

Use confidence as a hard actionability gate: record only proposals at 90%
confidence or higher. Below 90%, gather more evidence or discard the candidate.
Confidence means the inspected evidence makes it very likely that the feature
is repository-owned, not already supported, valuable to the named audience, and
implementable without violating local patterns.

Assign priority by user value and fit, not implementation ease:

- `High`: Improves a primary workflow, unlocks a documented use case, removes
  recurring maintainer/developer friction, or aligns strongly with comparable
  mature tools while fitting the repository's existing direction.
- `Medium`: Improves a real secondary workflow or extension point with clear
  fit and manageable maintenance cost.
- `Low`: Useful but narrow improvement with limited audience, limited urgency,
  or meaningful tradeoffs that still fit the repository.

Do not use `Low` for vague ideas. Low-priority proposals still need concrete
evidence, audience, fit, and a plausible implementation path.

## Implement Mode

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Before checking, reading, creating, or updating the scoped `FEATURES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `FEATURES.md` as a standalone pattern. If the pattern is missing, add it.
- Read `FEATURES.md` in the requested package or folder first and treat it as
  the working feature ledger.
- If scoped `FEATURES.md` does not exist, stop and ask whether to run Find mode
  first for that scope.
- Work through feature proposals sequentially by ID unless the human explicitly
  names a different proposal.
- Before proposing an implementation for each feature, re-check the current
  code, docs, tests, examples, command behavior, and comparable-tool evidence.
  Treat the ledger as something that can go stale: dismiss or revise proposals
  that are already supported, duplicate another feature, no longer fit the
  repository, or belong in another workflow.
- Stop after proposing the solution. Do not edit files, update `FEATURES.md`,
  or start validation until the human explicitly agrees to that feature's
  solution.
- Ask questions when audience, product direction, compatibility, dependency
  policy, UX/DX behavior, test layer, validation, or user intent is ambiguous.
  Treat silence or a broad "implement feature gaps" request as permission to
  start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local code/config/docs pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- For behavior-changing features, state the feature execution checklist before
  editing:
   - `TDD decision`: yes/no, with the concrete reason if no.
   - `First test/scenario`: the narrowest test, fixture, example, or scenario
     to add or update first.
   - `Expected red`: the command and failure expected before production edits.
   - `Intended green change`: the smallest implementation expected to pass.
   - `Refactor checkpoint`: the cleanup pass planned after green, or `none`.
   - `Validation`: the focused and expanded commands intended after refactor.
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
- Report the result for that feature with `Red`, `Green`, `Refactor`, and
  `Validation` entries. Use `Refactor: none` when no cleanup was needed after
  green. Then ask the human to verify and explicitly say `FEATURE-N is done`.
- Do not move to the next proposal until the human says `FEATURE-N is done`.
- After the human confirms a proposal is done, remove that proposal from scoped
  `FEATURES.md`. If a proposal is deemed invalid or not actually a feature gap,
  remove it only after explaining why and getting human agreement.
- Once all proposals are resolved and confirmed done by the human, delete the
  scoped `FEATURES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
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
