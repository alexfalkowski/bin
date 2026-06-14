---
name: doc-gaps
description: Finds concrete missing, weak, stale, or misleading documentation in a package or folder, including README files, user-facing docs, examples, and code comments/docstrings required by $doc-standards and relevant language standards, records confirmed gaps in that scope's ISSUES.md, and later proposes and implements explicitly agreed doc fixes gap by gap. Use when the user asks to find $doc-gaps in a package or folder, find doc gaps in a package or folder, implement $doc-gaps in a package or folder, or implement doc gaps in a package or folder.
---

# Doc Gaps

Use this skill in two distinct modes:

- **Find mode**: `Find $doc-gaps in <package/folder>` or `Find doc gaps in <package/folder>`.
- **Implement mode**: `Implement $doc-gaps in <package/folder>` or `Implement doc gaps in <package/folder>`.

Do not combine the two modes in one pass.

Before starting Find mode or Implement mode, read `references/plan.md` and use
it to maintain the active execution plan. The active plan is runtime state; do
not write it into the repository unless the human explicitly asks for a durable
plan file.
When the runtime supports goals, bind the selected mode and requested scope to
one active goal and update that goal as ledger, proposal, approval, validation,
or human-confirmation state changes.

## Operating Stance

Operate as a scoped documentation ledger manager: use `$doc-standards` for
documentation quality judgment, and use this skill for scope control,
delegation, `ISSUES.md` recording, and gap-by-gap implementation.

## Find Mode

Follow `references/plan.md#find-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Use `ISSUES.md` in the requested package or folder as the review ledger, for example `<package/folder>/ISSUES.md`.
- If `ISSUES.md` already exists in the requested package or folder, stop. Tell the user the existing scoped ledger must be resolved first, or the human must delete that scoped `ISSUES.md` before a new find pass there.
- Treat `Find $doc-gaps in <package/folder>` or `Find doc gaps in <package/folder>` as the user's explicit request to delegate documentation review for that scope. Do not require the user to separately say "use sub-agents", "spawn agents", or "delegate".
- Use sub-agents for Find mode whenever the active runtime provides them and the runtime permits delegation for the request. Do not treat sub-agents as optional based on scope size, and do not perform the doc-gap review locally first.
- Do not claim that extra delegation wording is needed before launching review agents. The Find mode invocation is the explicit delegation request.
- If delegation is denied, stop instead of falling back to a local review. If sub-agents are unavailable, say so briefly and perform the review locally for the requested scope.
- Ask for human permission before agents run commands that require approval, such as network, SSH, GitHub auth, registry auth, remote writes, or other non-read-only validation.
- Exclude generated files and folders, vendored dependencies, caches, build output, generated API docs, and generated lockfile churn unless the requested scope is explicitly about them.
- Each subpackage/subfolder agent owns recursive review of the rest of that subtree. Each agent must perform a thorough documentation review for its assigned scope, pairing with `$doc-standards`, relevant language standards, `$naming-standards` when terminology is unclear or inconsistent, and `$change-validation` for likely validation commands.
- Require each agent to return findings in the same shape as the `ISSUES.md` format, without final IDs unless useful locally.
- Use `../references/finding-severity.md` to discard low-confidence candidates before assigning severity.
- Confirm each candidate gap against the code, current docs, examples, and documented interfaces before recording it, using `$doc-standards` as the finding threshold.
- Do not record candidates that `$doc-standards` routes to `$code-review`, `$code-issues`, `$security-audit`, `$testing-standards`, or `$test-gaps`.
- List optional documentation polish only as optional follow-up notes when relevant.
- If no confirmed doc gaps are found, report that no doc gaps were found and do not create `ISSUES.md`.
- If confirmed doc gaps are found, write all findings to the scoped `ISSUES.md` before making any fixes.
- Assign every finding a unique ID for the session in the form `DOC-<number>`.
- Stop after presenting the ledger and plan. Do not fix findings in the same pass.

## Documentation Review Standards

Use `$doc-standards` to decide whether a documentation concern is concrete
enough to record. Use the relevant language standards for code comments,
docstrings, public API docs, and language-specific examples before recording
findings. Keep GoDoc details in `$go-standards`, RDoc details in
`$ruby-standards`, and shell script/function comment rules in
`$shell-standards`.

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

Follow `references/plan.md#implement-mode-plan`.

These rules remain mandatory:

- If no scope is provided, stop and ask for the package or folder.
- Read `ISSUES.md` in the requested package or folder first and treat it as the working doc-gap ledger.
- If scoped `ISSUES.md` does not exist, stop and ask whether to run Find mode first for that scope.
- Work through findings sequentially by ID unless the human explicitly names a different finding.
- Stop after proposing the solution. Do not edit files, update `ISSUES.md`, or start validation until the human explicitly agrees to that finding's solution.
- Ask questions when behavior, audience, documentation location, public-contract wording, examples, validation, or user intent is ambiguous. Treat silence or a broad "implement doc gaps" request as permission to start the proposal workflow, not as permission to edit.
- After the human agrees and before editing, state the selected local documentation pattern, dominant relevant validation path, planned validation command, and any deviation from `AGENTS.md` or selected skills. If a deviation is needed, stop and ask before editing.
- Implement only the agreed finding with the smallest clear documentation change.
- Use `$doc-standards` and relevant language standards for code comments and API docs. Use `$change-safety` when documentation changes public API, command, migration, or compatibility expectations.
- Do not move to the next finding until the human says `DOC-<number> is done`.
- After the human confirms a finding is done, remove that finding from scoped `ISSUES.md`. If a finding is deemed invalid or not actually a doc gap, remove it only after explaining why and getting human agreement.
- Once all findings are resolved and confirmed done by the human, delete the scoped `ISSUES.md`.

## References

- Read `references/plan.md` before starting Find mode or Implement mode.
- Use `$doc-standards` as the documentation quality bar and routing threshold.
- Use `../references/finding-severity.md` for confidence filtering and severity.
- Use `$project-workflow` for repository command discovery, documented entrypoints, CI expectations, examples, and `./bin` wiring before review planning or validation.
- Use the paired language, naming, safety, and validation skills through `$doc-standards`.
