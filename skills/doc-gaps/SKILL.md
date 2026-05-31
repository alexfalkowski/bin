---
name: doc-gaps
description: Finds concrete missing, weak, stale, or misleading documentation in a package or folder, including README files, user-facing docs, examples, and code comments/docstrings required by relevant language standards, records confirmed gaps in that scope's ISSUES.md, and later proposes and implements explicitly agreed doc fixes gap by gap. Use when the user asks to find $doc-gaps in a package or folder, find doc gaps in a package or folder, implement $doc-gaps in a package or folder, or implement doc gaps in a package or folder.
---

# Doc Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $doc-gaps in <package/folder>` or `Find doc gaps in <package/folder>`.
- **Implement mode**: `Implement $doc-gaps in <package/folder>` or `Implement doc gaps in <package/folder>`.

Do not combine the two modes in one pass.

## Find Mode

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
3. If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
4. Use `$project-workflow` to discover repository entrypoints, CI expectations, documented commands, public APIs, examples, and `./bin` wiring before planning documentation review agents or validation.
5. Treat `Find $doc-gaps in <package/folder>` or `Find doc gaps in <package/folder>` as the user's explicit request to delegate documentation review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
6. Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the doc-gap review locally first.
7. Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
8. If the runtime still requires an approval step before launching sub-agents, ask once with the concrete read-only agent plan. If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
9. Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation. Without that permission, agents should inspect code and docs only and suggest validation.
10. Exclude generated files and folders, vendored dependencies, caches, build output, generated API docs, and generated lockfile churn unless the requested scope is explicitly about them.
11. Launch at least one sub-agent covering the requested root package/folder. Split agent assignments across:
   - documentation files directly under the requested root package/folder.
   - source files directly under the requested root package/folder whose comments or docstrings are in scope.
   - each first-level subpackage/subfolder under the requested root.
12. Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough documentation review for its assigned scope, pairing with:
   - relevant language standards (`$go-standards`, `$ruby-standards`, `$shell-standards`) before recording language-specific comment, docstring, or API documentation findings.
   - `$naming-standards` when documentation terminology, command/API names, examples, comments, or public vocabulary are unclear or inconsistent.
   - `$change-validation` for likely validation commands.
13. Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
14. Wait for all agents to finish before aggregating results.
15. Deduplicate overlapping findings and resolve conflicting agent conclusions by re-checking the code and docs directly.
16. Confirm each candidate gap against the code, current docs, examples, and documented interfaces before recording it. Gaps must be concrete missing, weak, stale, misleading, or wrong-location documentation with credible risk to users, operators, maintainers, public APIs, documented command behavior, onboarding, setup, or contribution workflows.
17. Do not record confirmed production bugs, security issues, compatibility breaks, or violated public contracts as doc gaps. If broken behavior is discovered during review, report it as out of scope for the doc-gap ledger and recommend `$code-issues`; use this skill when unclear, missing, stale, or misleading documentation is the finding.
18. Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as doc gaps. Recommend `$test-gaps` when the unprotected behavior is the finding.
19. Do not report arbitrary wording preferences, style nits, exhaustive private implementation comments, or optional documentation polish as findings by themselves. List them only as optional follow-up notes when relevant.
20. If no confirmed doc gaps are found, report that no doc gaps were found and do not create `ISSUES.md`.
21. If confirmed doc gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
22. Assign every finding a unique ID for the session in the form `DOC-<number>`.
23. Present the scoped `ISSUES.md` and a proposed doc-fix plan to the user.
24. Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## Documentation Review Standards

Use these standards to decide whether a documentation concern is concrete enough to record:

- **README and project docs**: README files should quickly explain what the project does, why it is useful, how users get started, where to get help, and who maintains or contributes to it. Prefer root, `.github/`, or `docs/` README placement when GitHub rendering matters. Keep startup docs concise, current, structured with headings, and linked to deeper docs instead of burying long manuals in the README.
- **Examples and commands**: Installation, setup, usage, Make targets, CLI examples, environment variables, and API examples should be copy-paste-ready when practical and aligned with real entrypoints.
- **Code comments**: Comments should explain non-obvious intent, tradeoffs, invariants, unidiomatic choices, bug-workaround context, copied-code sources, and helpful external references. Do not demand comments that merely restate obvious code. If a clear comment cannot be written because the code itself is confused, recommend `$code-issues`.
- **Naming and terminology**: Use `$naming-standards` when documentation terminology, command/API names, examples, comments, or public vocabulary are unclear, inconsistent with code, or misleading.
- **Language-specific docs**: Use the relevant standards skill for code comments, docstrings, public API docs, and language-specific examples before recording findings. Keep GoDoc details in `$go-standards`, RDoc details in `$ruby-standards`, and shell script/function comment rules in `$shell-standards`.

## `ISSUES.md` Format

Use this structure:

```markdown
# Issues

## DOC-1: Short concrete title

- Type: Doc Gap
- Severity: Critical|High|Medium|Low
- Scope: path/to/file-or-folder
- Impact: Risk created by the missing, weak, stale, misleading, or wrong-location documentation.
- Evidence: Concrete file and line references, command/API behavior, existing docs, examples, or comment/docstring gap.
- Proposed fix: Brief documentation direction using the established documentation location and style.
- Validation: Suggested checks for the documentation change.
```

Keep optional follow-up notes separate from findings:

```markdown
## Optional Doc Follow-Ups

- Optional or non-blocking note.
```

## Implement Mode

1. Identify the requested package or folder scope. If no scope is provided, stop and ask for the package or folder.
2. Read `ISSUES.md` in the requested package or folder first and treat it as the working doc-gap ledger.
   If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
3. Use `$project-workflow` before proposing or running validation so repository entrypoints, CI expectations, documented commands, public APIs, examples, and `./bin` wiring are current.
4. Work through findings sequentially by ID unless the human explicitly names a different finding.
5. For each finding, first present:
   - the issue ID and current evidence.
   - the proposed documentation solution.
   - documentation-location, public-contract, example accuracy, compatibility, or maintenance tradeoffs.
   - the intended validation.
6. Stop after proposing the solution. Do not edit files, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
7. Ask questions when behavior, audience, documentation location, public-contract wording, examples, validation, or user intent is ambiguous. Treat silence or a broad "implement doc gaps" request as permission to start the proposal workflow, not as permission to edit.
8. Once the solution for the current finding is agreed, implement only that finding with the smallest clear documentation change.
9. Use relevant language standards for code comments and API docs. Use `$change-safety` when documentation changes public API, command, migration, or compatibility expectations.
10. Validate the documentation change using checks appropriate to the changed files, such as markdown linting if present, generated documentation checks if present, relevant language linting, examples, or documented command smoke checks.
11. Report the result for that finding and ask the human to verify and explicitly say `DOC-<number> is done`.
12. Do not move to the next finding until the human says `DOC-<number> is done`.
13. After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a doc gap, remove it only after explaining why and getting human agreement.
14. Then propose the solution for the next remaining finding and repeat the same agreement gate.
15. Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.
16. Summarize what changed, which doc gaps were resolved or dismissed, and which validation steps were run or still need to be carried out by the human.

## References

- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use relevant language standards for code comments, public API docs, and examples.
- Use `$naming-standards` when documentation terminology, command/API names, examples, comments, or public vocabulary are unclear, inconsistent, or misleading.
- Use `$change-safety` when documentation affects public contracts, compatibility, migrations, security expectations, or documented operational behavior.
- Use `$change-validation` when selecting validation commands for implemented doc fixes.
- Use `$code-issues` when the confirmed problem is broken behavior, a security issue, a compatibility break, or a violated public contract.
- Use `$test-gaps` when the confirmed problem is missing or weak test coverage rather than documentation.
