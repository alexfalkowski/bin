---
name: code-issues
description: Use when the user asks to find $code-issues in a package or folder, find code issues in a package or folder, implement $code-issues in a package or folder, implement code issues in a package or folder, asks about issue IDs such as ISSUE-1, asks what the fix is for ISSUE-1, asks to fix or verify ISSUE-1, or says ISSUE-1 is done. Find concrete bugs, security issues, compatibility breaks, and public contract violations, record them in scoped ISSUES.md, and later propose and implement agreed fixes one code issue at a time.
---

# Code Issues

Use this skill in two distinct modes:

- **Find mode**: `Find $code-issues in PACKAGE_OR_FOLDER` or `Find code issues in PACKAGE_OR_FOLDER`.
- **Implement mode**: `Implement $code-issues in PACKAGE_OR_FOLDER` or `Implement code issues in PACKAGE_OR_FOLDER`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as ledger, proposal, approval, validation,
or human-confirmation state changes.

## Operating Stance

Operate as a strict issue triager and ledger owner: separate confirmed code
defects from test gaps, doc gaps, polish, and speculation; keep the scoped
`ISSUES.md` actionable, deduplicated, and tied to user-visible or contract risk.

Code is the default source of behavioral truth. Comments, GoDoc, README prose,
examples, and other documentation can be stale. Do not record or implement a
code issue merely because prose and implementation disagree. First prove the
implementation is wrong using non-prose evidence such as executable behavior,
tests, schemas, wire/API contracts, external standards, runtime failures, or
history showing an unintended code regression. If implementation and tests agree
while prose disagrees, treat it as a documentation gap and update the docs.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Before checking, reading, creating, or updating the scoped `ISSUES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `ISSUES.md` as a standalone pattern. If the pattern is missing, add it.
- Use `ISSUES.md` in the requested package or folder as the review ledger, for example `PACKAGE_OR_FOLDER/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
- Treat `Find $code-issues in PACKAGE_OR_FOLDER` or `Find code issues in PACKAGE_OR_FOLDER` as the user's explicit request to delegate review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and runtime policy/tooling permits delegation. Do not treat sub-agents as optional based on scope size, and do not perform the find review locally first.
- Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
- In downstream repositories that vendor this project as `./bin`, treat
  `bin/**` as vendored shared tooling unless the requested scope is explicitly
  about shared `bin` tooling, Makefile includes, skills, or submodule wiring.
  Exclude `bin/**` from recursive review and inventory by default; inspect only
  included `bin/build/make/*.mak` fragments or selected `bin/skills/**`
  guidance needed as evidence. Route upstream-only shared-tooling findings to a
  separate `bin`-scoped run instead of writing them into the consuming
  repository's `ISSUES.md`.
- Before assigning review agents, build a recursive scope inventory for the requested package or folder: relevant file count, first-level subfolders, nested packages, dominant languages, tests, public entrypoints, generated/vendor/build/cache exclusions, and security-sensitive surfaces.
- Do not assign broad recursive subtrees merely because they are first-level subfolders. When a subtree contains many independent nested packages, mixed responsibilities, or too many relevant files for a credible single pass, split it into smaller behavior-owned slices before delegation.
- Prefer slices based on repository-owned behavior and risk: public commands/APIs, changed or recently touched areas, auth/network/filesystem/process boundaries, config/CI/release paths, documented workflows, and nearby tests. Use depth only as a discovery aid, not as the review boundary.
- If the requested scope is too broad to review credibly in one pass, review the highest-risk slices first and record explicit coverage: reviewed deeply, skimmed, excluded, and deferred.
- Do not present a broad requested scope as fully reviewed when any relevant slice was only skimmed or deferred. Name those slices in the final coverage notes and provide runnable follow-up scopes for deferred review.
- Each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for that slice, using `$testing-standards` for concrete missing-coverage or weak-test analysis and `$change-validation` for likely validation commands.
- Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity and confidence.
- Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
- For candidates based on documentation or comments contradicting code, require non-prose proof that the implementation is wrong before recording a code issue. Existing tests, helper names, runtime behavior, or commit history that support the implementation mean the candidate is a doc gap, not a code issue.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as code issues unless they are tied to a confirmed bug, security issue, compatibility break, or violated public contract. Use `$test-gaps` for standalone missing or weak test coverage passes.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as code issues unless they reveal a confirmed bug, security issue, compatibility break, or violated public contract. Use `$doc-gaps` for standalone documentation review passes.
- Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps, doc gaps, or optional follow-up notes when relevant.
- If no confirmed code issues are found, report that no code issues were found and do not create `ISSUES.md`.
- If confirmed code issues are found, write all findings to the scoped `ISSUES.md` before making any fixes.
- Assign every finding a unique ID for the session in the form `ISSUE-N`.
- Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## ISSUE-1: Short concrete title

- Severity: Critical|High|Medium|Low
- Confidence: 93%
- Scope: path/to/file-or-folder
- Impact: User-visible impact or violated contract.
- Evidence: Concrete file and line references, command output, or code path.
- Proposed fix: Brief implementation direction.
- Validation: Suggested checks for the fix.
```

Keep optional follow-up notes separate from findings:

```markdown
## Testing Gaps And Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Before checking, reading, creating, or updating the scoped `ISSUES.md`
  ledger, ensure the consuming repository root `.gitignore` exists and contains
  `ISSUES.md` as a standalone pattern. If the pattern is missing, add it.
- Read `ISSUES.md` in the requested package or folder first and treat it as the working review ledger.
- If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
- Work through code issues sequentially by ID unless the human explicitly names a different issue.
- Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that issue's solution.
- Ask questions when behavior, compatibility, security, validation, or user intent is ambiguous. Treat silence or a broad "implement code issues" request as permission to start the proposal workflow, not as permission to code.
- When re-checking an issue whose evidence depends on documentation or comments contradicting implementation, prove the code is wrong before proposing a code change. If non-prose evidence supports the implementation, explain that the ledger item is invalid as a code issue and propose reclassifying or fixing the documentation instead.
- After the human agrees and before editing, state the selected local code pattern, dominant relevant test harness, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed issue with the smallest safe change.
- Use `$testing-standards` when deciding whether to add or update regression tests for the fix, and prefer its test-first or scenario-first loop when a behavior-changing fix has a credible test or BDD layer.
- Do not move to the next issue until the human says `ISSUE-N is done`.
- After the human confirms an issue is done, remove that issue from scoped `ISSUES.md`. If an issue is deemed invalid or not actually a code issue, remove it only after explaining why and getting human agreement.
- Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Use `../references/finding-severity.md` for confidence filtering, confidence labels, and severity.
- Use `$code-review` for review rigor and finding quality.
- Use `$security-audit` for security-sensitive review scope.
- Use `$testing-standards` when deciding or reviewing regression coverage.
- Use `$test-gaps` instead when the user asks for a standalone missing or weak test coverage pass.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented fixes.
