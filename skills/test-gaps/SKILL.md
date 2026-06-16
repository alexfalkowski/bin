---
name: test-gaps
description: Use when the user asks to find $test-gaps in a package or folder, find test gaps in a package or folder, find flaky tests in a package or folder, find wrong-layer tests in a package or folder, implement $test-gaps in a package or folder, implement test gaps in a package or folder, asks about test gap IDs such as TEST-1, asks what the fix is for TEST-1, asks to fix or verify TEST-1, or says TEST-1 is done. Find concrete missing, weak, misleading, flaky, or wrong-layer test coverage, record confirmed gaps in scoped ISSUES.md, and later propose and implement agreed test fixes gap by gap.
---

# Test Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $test-gaps in PACKAGE_OR_FOLDER` or `Find test gaps in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $test-gaps in PACKAGE_OR_FOLDER` or `Implement test gaps in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as ledger, proposal, approval, validation,
or human-confirmation state changes.

## Operating Stance

Operate as a coverage triager: protect repository-owned behavior through the
narrowest credible established test layer, and reject gaps that only test
dependency semantics, private implementation detail, or coverage vanity.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Use `ISSUES.md` in the requested package or folder as the review ledger, for example `PACKAGE_OR_FOLDER/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
- Treat `Find $test-gaps in PACKAGE_OR_FOLDER` or `Find test gaps in PACKAGE_OR_FOLDER` as the user's explicit request to delegate test-gap review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and runtime policy/tooling permits delegation. Do not treat sub-agents as optional based on scope size, and do not perform the test-gap review locally first.
- Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
- Before assigning review agents, build a recursive scope inventory for the requested package or folder: relevant file count, first-level subfolders, nested packages, dominant languages, tests, public entrypoints, generated/vendor/build/cache exclusions, and existing test harnesses.
- Do not assign broad recursive subtrees merely because they are first-level subfolders. When a subtree contains many independent nested packages, mixed responsibilities, or too many relevant files for a credible single pass, split it into smaller behavior-owned slices before delegation.
- Prefer slices based on repository-owned behavior and test risk: public commands/APIs, changed or recently touched areas, documented workflows, compatibility-sensitive behavior, release paths, and nearby existing tests. Use depth only as a discovery aid, not as the review boundary.
- If the requested scope is too broad to review credibly in one pass, review the highest-risk slices first and record explicit coverage: reviewed deeply, skimmed, excluded, and deferred.
- Each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$testing-standards` review for that slice, pairing with relevant language standards and `$change-validation` for likely validation commands.
- Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally. Each finding must name the repository-owned behavior being protected; reject findings that only test dependency semantics, aliases, or pass-through wrappers.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity.
- Confirm each candidate gap against the code and existing tests before recording it. Gaps must be concrete missing, weak, misleading, flaky, or wrong-layer coverage with credible risk to changed behavior, public contracts, compatibility, release-sensitive workflows, or documented command/API behavior.
- For each candidate, explicitly identify the nearby existing test shape and why extending existing tests, fixtures, tables, helpers, or assertions does not already cover the behavior. Do not record a gap when the proposed fix would duplicate coverage already provided by that local shape.
- Do not record gaps whose only meaningful test would assert pass-through behavior to an upstream library, standard library, or framework. This includes aliases, type aliases, thin wrappers, direct option forwarding, direct global setter/getter calls, dependency injection container behavior, validator tag behavior, encoder/parser behavior, and constructors where the repository adds no branching, validation, transformation, error handling, lifecycle behavior, compatibility policy, or composition contract of its own.
- Only record a gap around third-party integration when the untested behavior is repository-owned. Examples include local validation/normalization before calling the dependency, local input/output mapping, local error wrapping/classification/recovery, lifecycle ordering or cleanup owned by the repository, documented compatibility behavior promised across dependency versions, or end-to-end behavior through a supported public repo entrypoint where multiple repo-owned pieces are composed.
- When a candidate gap touches a wrapper around a dependency, explicitly ask: "Would the proposed test fail because repository code changed, or only because the dependency's behavior/shape changed?" Record it only when repository code owns the failing behavior.
- Do not record gaps that require build tags, architecture-specific execution, optional services, integration environments, or other validation modes the repository does not normally run, unless the finding is explicitly that CI or the documented validation path must add that mode.
- Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as test gaps. If such broken behavior is discovered during review, report it as out of scope for the test-gap ledger and recommend `$code-issues`; use this skill when the unprotected or poorly protected behavior is the finding.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as test gaps. Use `$doc-gaps` when documentation itself is the finding.
- Do not report optional nice-to-have tests, private implementation coverage, arbitrary coverage percentage improvements, style preferences, or docs-only validation as findings by themselves. List them only as doc gaps or optional follow-up notes when relevant.
- If no confirmed test gaps are found, report that no test gaps were found and do not create `ISSUES.md`.
- If confirmed test gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
- Assign every finding a unique ID for the session in the form `TEST-N`.
- Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## TEST-1: Short concrete title

- Type: Test Gap
- Severity: Critical|High|Medium|Low
- Scope: path/to/file-or-folder
- Impact: Risk created by the missing, weak, misleading, flaky, or wrong-layer coverage.
- Evidence: Concrete file and line references, existing test behavior, command output, or untested code path.
- Proposed fix: Brief test direction using the narrowest credible established test layer.
- Validation: Suggested checks for the test change.
```

Keep optional follow-up notes separate from findings:

```markdown
## Optional Test Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Read `ISSUES.md` in the requested package or folder first and treat it as the working test-gap ledger.
- If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
- Work through findings sequentially by ID unless the human explicitly names a different finding.
- Before proposing a fix for each finding, re-check the current code and nearby tests. Treat the ledger as something that can go stale: dismiss or revise findings that are already covered, would duplicate the local test shape, test only underlying libraries/frameworks, or require validation modes the repository does not run.
- Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
- Ask questions when behavior, compatibility, test layer, fixture strategy, validation, or user intent is ambiguous. Treat silence or a broad "implement test gaps" request as permission to start the proposal workflow, not as permission to code.
- After the human agrees and before editing, state the selected local test pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed finding with the smallest clear test change, preferring the existing local test shape over new standalone structure.
- Use `$testing-standards` for test design and pair with the relevant language standard for local idioms. If implementing the test gap requires production behavior to change, prefer the test-first or scenario-first loop from `$testing-standards`.
- Do not move to the next finding until the human says `TEST-N is done`.
- After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a test gap, remove it only after explaining why and getting human agreement.
- Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Use `../references/finding-severity.md` for confidence filtering and severity.
- Use `$testing-standards` for cross-language test quality, coverage, fixtures, determinism, and test-layer decisions.
- Use relevant language standards for local test idioms.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented test fixes.
