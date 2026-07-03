---
name: feature-gaps
description: Use when the user asks to find $feature-gaps in a package or folder, find feature gaps in a package or folder, find feature gaps with a specific confidence closure target such as 95% or 99%, find main product capability gaps, find product-owned user, operator, service-author, package-consumer, CLI, API, or library feature opportunities, implement $feature-gaps in a package or folder, implement feature gaps in a package or folder, uses a remembered command such as Work FEATURE-1 or Agent goal work FEATURE-1, asks about feature IDs such as FEATURE-1, asks what the proposal is for FEATURE-1, asks to fix or verify FEATURE-1, or says FEATURE-1 is done. Find concrete repository-fit product feature opportunities with explicit audience benefit, record confirmed proposals in scoped FEATURES.md, and later propose and implement agreed feature changes one at a time. Do not use for standalone test, CI, build, Makefile, release, validation, or repository workflow gaps.
---

# Feature Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $feature-gaps in PACKAGE_OR_FOLDER` or `Find feature gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $feature-gaps in PACKAGE_OR_FOLDER` or `Implement feature gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and
`../references/gap-workflow.md`. The plan owns active runtime state; the shared
gap workflow owns ledger, delegation, scope, coverage, confidence, and approval
gates.

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
- **Existing coverage**: Name the current product surfaces that already address
  part or all of the need, including APIs, commands, endpoints, generated
  contracts, runtime health or metrics, docs, examples, configuration, and
  supported workflows. Reject the candidate if an existing surface already
  solves the practical user action.
- **Residual gap**: After accounting for existing coverage, state the remaining
  supported action or outcome the audience still cannot complete. Reject the
  candidate if the residual is only a weaker spelling of "more flexible",
  "more convenient", or "another way to do the same thing".
- **Negative capability proof**: If the proposal depends on a capability being
  absent, verify that absence across every layer that could already provide it:
  local code, generated code, framework wrappers, shared helpers, vendored
  dependencies, configuration defaults, command behavior, docs, examples, and
  tests. If the behavior is delegated to a framework, shared helper, generated
  surface, or vendored dependency, inspect that delegated implementation before
  assigning 90% or higher confidence.
- **Benefit**: Explain why this matters to the named audience and the concrete
  outcome they gain, such as saved time, fewer mistakes, clearer decisions,
  unlocked use cases, safer operation, or reduced support burden. Reject the
  candidate if the benefit cannot be stated as a specific improvement to the
  named audience's workflow.
- **Common operation**: For new product capability, show that the action is a
  normal or credibly recurring workflow for the named audience in this
  repository's domain. Comparable-tool support alone is not enough; reject or
  defer candidates whose value is mostly rare operator preference, library
  affordance parity, or speculative future use.
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
an imagined future user, uncommon operation, framework preference, private
implementation preference, generic "nice to have" polish, or a vague benefit
such as "more flexible", "better", "cleaner", or "more powerful" without a
concrete audience outcome.

## Find Mode

Follow `references/plan.md#find-mode-plan` and the find/audit rules in
`../references/gap-workflow.md`.

These feature-gap rules remain mandatory:

- Use `FEATURES.md` in the requested package or folder as the proposal ledger,
  for example `PACKAGE_OR_FOLDER/FEATURES.md`.
- Before assigning review agents or starting local review, build a recursive
  scope inventory for the requested package or folder: relevant file count,
  first-level subfolders, nested packages, dominant languages, tests, public
  entrypoints, generated, vendor, build, and cache exclusions, user-facing
  product surfaces, package-consumer or service-author surfaces,
  operator-facing surfaces, docs, examples, command help, and likely product
  extension points.
- Prefer slices based on repository-owned feature surface and user value:
  public commands/APIs, library or service behavior, package-consumer and
  service-author workflows, documented product examples, product onboarding
  paths, integrations, extension points, changed or recently touched product
  areas, and nearby tests. Use depth only as a discovery aid, not as the review
  boundary.
- For delegated review, each assigned agent owns recursive review only within
  its bounded slice. Each agent must perform feature-gap discovery for that
  slice, pairing with
  `$project-workflow`, `$doc-standards`, `$naming-standards`, relevant language
  standards, `$change-safety`, `$testing-standards`, and `$change-validation`
  as the proposed feature surface requires. Agents must use `$testing-standards`
  and `$project-workflow` to route test-harness, build, CI, Makefile, release,
  validation, command-discovery, or repository-workflow candidates away from
  `FEATURES.md` before returning feature proposals.
- Confirm each candidate feature against the acceptance gate, code, generated
  surfaces, framework wrappers, shared helpers, vendored dependency behavior
  when delegated, docs, tests, examples, command behavior, current
  architecture, and available comparable-tool evidence before recording it. Try
  to disprove the candidate by asking whether the workflow is already
  supported, whether the repository owns the behavior, whether the likely
  audience exists, whether existing product surfaces already cover enough of the
  workflow, whether the residual gap is still meaningful after that coverage,
  whether the operation is common enough for the audience, and whether the
  feature can be added incrementally using local patterns.
- When sub-agents are authorized and candidate volume justifies delegation,
  assign at least one disprover slice when practical. The disprover should look
  for existing APIs, commands, endpoints, health/metrics, generated contracts,
  docs, examples, tests, shared helpers, framework behavior, or workflow routing
  that already covers each proposed feature, and should try to route weak leads
  to another gap workflow or optional follow-up.
- Record feature gaps only when the proposal names the audience, current
  product workflow limitation, existing coverage, residual gap, practical
  audience benefit, common-operation evidence, repository-owned product surface,
  evidence of user, operator, service-author, package-consumer, CLI, API, or
  library value, fit with existing patterns, smallest plausible implementation
  path, compatibility risk, and validation path.
- Do not record confirmed bugs, security issues, compatibility breaks,
  reliability gaps, missing tests, test-harness quality issues, stale docs,
  project workflow gaps, or unclear naming as feature gaps. Route them to
  `$code-issues`, `$security-audit`, `$reliability-gaps`, `$test-gaps`,
  `$doc-gaps`, `$project-gaps`, or `$naming-standards` as appropriate.
- Do not record feature ideas whose evidence is only novelty, personal
  preference, a competitor checklist, a trend, an undocumented future roadmap,
  an uncommon operation, a broad rewrite, a new framework preference, or
  optional polish with no concrete workflow improvement.
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

## `FEATURES.md` Format

Use this structure:

````markdown
# Features

## FEATURE-1: Short concrete title

| Field | Value |
| --- | --- |
| Type | Feature Gap |
| Priority | High \| Medium \| Low |
| Confidence | 93% |
| Scope | path/to/file-or-folder |
| Audience | User \| Developer \| Maintainer \| Operator \| Package consumer \| Service author |
| Product surface | Public command \| API \| library behavior \| service/operator behavior \| package-consumer workflow \| integration \| template \| extension point. |

### Workflow Map

```text
current limitation: The workflow limitation, missing capability, or friction.
existing coverage: Current product surfaces that already address part or all of
the need, and why they are insufficient for the named audience.
residual gap: Even with the existing coverage, the audience still cannot
complete this specific supported workflow or outcome.
benefit: Why this matters to the named audience and how their workflow becomes better.
common operation: Evidence that this is a normal or recurring workflow for the
named audience, not only comparable-tool parity.
```

### Evidence

```text
Evidence: Concrete file and line references, command behavior, docs, examples,
comparable-tool evidence, or user/developer workflow evidence.
Reproduction: Smallest supported user, developer, service-author, operator, or
package-consumer workflow trace that demonstrates the current limitation or
missing capability.
```

### Decision Trace

```text
named audience
  -> supported workflow
  -> existing coverage
  -> residual gap
  -> smallest useful feature
  -> validation that proves the feature
```

### Proposed Change

```yaml
repository_fit: Why this belongs in the current repository and matches existing patterns.
proposed_feature: Smallest useful capability to add.
compatibility_and_maintenance: Public behavior, dependency, migration, support, or maintenance tradeoffs.
validation:
  - Suggested checks for the feature change.
```
````

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

Do not assign 90% or higher confidence to a missing-feature proposal when the
current behavior may be provided by an included framework, shared helper,
generated surface, vendored dependency, or default configuration that has not
been inspected. Keep the candidate below threshold, gather that evidence, or
discard it.

Do not assign 90% or higher confidence to a reusable-library or shared-tooling
proposal whose support is limited to package-local possibility, synthetic
fakes, manual construction, or unsupported downstream usage. Inspect supported
usage evidence first.

Do not add a separate percentage for idea quality, strength, value, impact, or
priority. Use `Priority` to express the strength of the audience benefit and
use `Confidence` only for evidence-backed actionability.

Assign priority by user value and fit, not implementation ease:

- `High`: Improves a primary workflow, unlocks a documented use case, removes
  recurring maintainer/developer friction, or aligns strongly with comparable
  mature tools while fitting the repository's existing direction.
- `Medium`: Improves a real secondary workflow or extension point with clear
  fit and manageable maintenance cost.
- `Low`: Useful but narrow improvement with limited audience, limited urgency,
  or meaningful tradeoffs that still fit the repository.

Do not use `Low` for vague ideas. Reject vague-benefit candidates instead.
Low-priority proposals still need concrete benefit, evidence, audience, fit,
and a plausible implementation path.

## Implement Mode

Follow `references/plan.md#implement-mode-plan` and the implementation rules in
`../references/gap-workflow.md`.

These feature implementation rules remain mandatory:

- Before proposing an implementation for each feature, re-check the current
  code, generated surfaces, framework wrappers, shared helpers, vendored
  dependency behavior when delegated, docs, tests, examples, command behavior,
  and comparable-tool evidence. Treat the ledger as something that can go
  stale: dismiss or revise proposals that are already supported, duplicate
  another feature, no longer fit the repository, or belong in another workflow.
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
  `Validation` entries. Use `Refactor: none (<reason>)` when no cleanup was
  needed after green. Then ask the human to verify and explicitly say
  `FEATURE-N is done`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Read `../references/gap-workflow.md` for shared scoped-ledger, delegation, coverage, confidence, and approval gates.
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
