---
name: test-gaps
description: Finds concrete missing, weak, or misleading test coverage in a package or folder, records confirmed gaps in that scope's ISSUES.md, and later proposes and implements explicitly agreed test fixes gap by gap. Use when the user asks to find $test-gaps in a package or folder, find test gaps in a package or folder, implement $test-gaps in a package or folder, or implement test gaps in a package or folder.
---

# Test Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $test-gaps in <package/folder>` or `Find test gaps in <package/folder>`.
- **Implement mode**: `Implement $test-gaps in <package/folder>` or `Implement test gaps in <package/folder>`.

Do not combine the two modes in one pass.

## Find Mode

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
3. If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
4. Use `$project-workflow` to discover repository entrypoints, CI expectations, and `./bin` wiring before planning review agents or validation.
5. Treat `Find $test-gaps in <package/folder>` or `Find test gaps in <package/folder>` as the user's explicit request to delegate test-gap review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
6. Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the test-gap review locally first.
7. Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
8. If the runtime still requires an approval step before launching sub-agents, ask once with the concrete read-only agent plan. If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
9. Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation. Without that permission, agents should inspect code and tests only and suggest validation.
10. Exclude generated files and folders, vendored dependencies, caches, build output, and generated lockfile churn unless the requested scope is explicitly about them.
11. Launch at least one sub-agent covering the requested root package/folder. Split agent assignments across:
   - files directly under the requested root package/folder.
   - each first-level subpackage/subfolder under the requested root.
12. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough and accurate `$testing-standards` review for its assigned scope, pairing with relevant language standards and `$change-validation` for likely validation commands.
13. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally. Each finding must name the repository-owned behavior being protected; reject findings that only test dependency semantics, aliases, or pass-through wrappers.
14. Wait for all agents to finish before aggregating results.
15. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code and tests directly.
16. Confirm each candidate gap against the code and existing tests before recording it. Gaps must be concrete missing, weak, misleading, flaky, or wrong-layer coverage with credible risk to changed behavior, public contracts, compatibility, release-sensitive workflows, or documented command/API behavior.
17. Do not record gaps whose only meaningful test would assert pass-through behavior to an upstream library, standard library, or framework. This includes aliases, type aliases, thin wrappers, direct option forwarding, direct global setter/getter calls, and constructors where the repository adds no branching, validation, transformation, error handling, lifecycle behavior, compatibility policy, or composition contract of its own.
18. Only record a gap around third-party integration when the untested behavior is repository-owned. Examples include local validation/normalization before calling the dependency, local input/output mapping, local error wrapping/classification/recovery, lifecycle ordering or cleanup owned by the repository, documented compatibility behavior promised across dependency versions, or end-to-end behavior through a supported public repo entrypoint where multiple repo-owned pieces are composed.
19. When a candidate gap touches a wrapper around a dependency, explicitly ask: "Would the proposed test fail because repository code changed, or only because the dependency's behavior/shape changed?" Record it only when repository code owns the failing behavior.
20. Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as test gaps. If such broken behavior is discovered during review, report it as out of scope for the test-gap ledger and recommend `$code-issues`; use this skill when the unprotected or poorly protected behavior is the finding.
21. Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as test gaps. Use `$doc-gaps` when documentation itself is the finding.
22. Do not report optional nice-to-have tests, private implementation coverage, arbitrary coverage percentage improvements, style preferences, or docs-only validation as findings by themselves. List them only as doc gaps or optional follow-up notes when relevant.
23. If no confirmed test gaps are found, report that no test gaps were found and do not create `ISSUES.md`.
24. If confirmed test gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
25. Assign every finding a unique ID for the session in the form `TEST-<number>`.
26. Present the scoped `ISSUES.md` and a proposed test-fix plan to the user.
27. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

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

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Read `ISSUES.md` in the requested package or folder first and treat it as the working test-gap ledger.
   If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
3. Use `$project-workflow` before proposing or running validation so repository entrypoints, CI expectations, and `./bin` wiring are current.
4. Work through findings sequentially by ID unless the human explicitly names a different finding.
5. For each finding, first present:
   - the issue ID and current evidence.
   - the proposed test solution.
   - test-layer, fixture, determinism, compatibility, or maintenance tradeoffs.
   - the intended validation.
6. Stop after proposing the solution. Do not edit code, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
7. Ask questions when behavior, compatibility, test layer, fixture strategy, validation, or user intent is ambiguous. Treat silence or a broad "implement test gaps" request as permission to start the proposal workflow, not as permission to code.
8. Once the solution for the current finding is agreed, implement only that finding with the smallest clear test change.
9. Use `$testing-standards` for test design and pair with the relevant language standard for local idioms.
10. Validate the test change using checks appropriate to the changed tests.
11. Report the result for that finding and ask the human to verify and explicitly say `TEST-<number> is done`.
12. Do not move to the next finding until the human says `TEST-<number> is done`.
13. After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a test gap, remove it only after explaining why and getting human agreement.
14. Then propose the solution for the next remaining finding and repeat the same agreement gate.
15. Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.
16. Summarize what changed, which test gaps were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `$testing-standards` for cross-language test quality, coverage, fixtures, determinism, and test-layer decisions.
- Use relevant language standards for local test idioms.
- Use `$doc-gaps` instead when the user asks for a standalone missing, stale, misleading, or weak documentation, README, example, comment, or docstring pass.
- Use `$project-workflow` for repository command discovery, CI expectations, and `./bin` wiring before review planning or validation.
- Use `$change-validation` when selecting validation commands for implemented test fixes.
