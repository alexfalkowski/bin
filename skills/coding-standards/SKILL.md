---
name: coding-standards
description: Apply shared cross-repository engineering expectations when working in repositories that may use the shared ./bin submodule and Makefile fragments. Use when implementing features, fixing bugs, reviewing code, updating CI, changing tests, or making maintenance edits that need consistent repo inspection, minimal safe changes, validation strategy, and review format.
---

# Coding Standards

## Overview

Follow repository-local instructions first, then use this skill to keep behavior consistent across related codebases. Build context before editing, infer available workflows from the repo's included make fragments and CI configuration, prefer the smallest safe change, validate with the narrowest relevant checks, and report clearly what was verified and what remains uncertain.

## Core Workflow

- Read repository-local guidance before editing: `AGENTS.md`, `README.md`, root `Makefile`, and CI configuration.
- Treat repository-local instructions as higher priority than this skill. Use this skill to fill gaps and standardize behavior across repos.
- Treat CI configuration as the best source of truth for what must pass in the current repository.
- Inspect the relevant codepaths and entrypoints before proposing or making changes.
- Prefer the smallest change that solves the task end-to-end.
- Preserve existing project patterns unless a deviation is necessary for correctness, safety, or maintainability.
- If a decision has non-obvious consequences, pause and verify the direction with a short plan before committing to it.
- Keep diffs tight. Avoid incidental refactors, large renames, or formatting churn unless they are required by the task.
- Keep agent-facing Markdown compressed. Prefer concise rules, references, and examples over repeated prose in Markdown files that Codex may load.
- After every change, check the applicable linting issues before moving on. Prefer the narrowest repo-defined lint command that covers the files you changed, and report clearly when linting could not be run.
- If behavior changes, add or update tests unless the repository truly cannot support it. When tests are not added, state the reason explicitly.
- Prefer the standard library and existing project dependencies before adding a new dependency. If a new dependency is required, keep it narrowly scoped and explain why it is necessary.
- In Go code, do not alias imports unless there is a real collision or required disambiguation. If the project defines a package whose name overlaps with a standard-library package, prefer the project package as the natural unaliased import and alias only the standard-library import or referenced stdlib identifiers needed to make the code work cleanly and keep imports minimal.
- Treat documentation for public code as required work, not optional polish. When public packages, modules, types, functions, methods, classes, or commands change, add or update accurate documentation in the repository's native style, such as GoDoc comments or RDoc, and include examples when the public API is non-trivial and the repository's doc style supports them.
- Prefer updating existing documentation over creating new documentation files unless the repository clearly expects a new document.
- Do not silently break public APIs, flags, env vars, config, file formats, or Make targets that downstream users may depend on. Preserve backward compatibility when feasible, and call out intentional breaking changes explicitly.
- If a breaking or behavior-changing rollout needs migration steps, deprecation handling, or staged adoption, include that work as part of the change instead of leaving it implicit.
- For performance-sensitive paths or new operational behavior, consider benchmark impact, runtime cost, and the observability needed to understand the feature in production.
- Avoid committing secrets, weakening security controls, or introducing unsafe handling of shell commands, file paths, auth, or untrusted input.
- Do not hand-edit generated code, vendored code, or lockfiles unless the task specifically requires it or regeneration is part of the intended workflow.
- Do not leave temporary code behind without calling it out. Remove debug prints, temporary instrumentation, dead code, throwaway TODOs, and short-term compatibility shims unless they are intentionally part of the change with a clear rationale.
- Do not assume tools exist. Confirm commands from the repository's Makefiles, scripts, CI, or documentation.
- Infer likely commands from included `bin/build/make/*.mak` fragments, then verify which targets are exposed by the repo's root `Makefile`.
- If the repository includes `./bin`, inspect which shared make fragments and targets are actually used by the consuming repo before relying on them.
- Do not force a repository into a single workflow type. A project may intentionally expose `features`, `specs`, or both, and that combination is by design.
- When adding or updating tests, use the repo's actual test workflow. If a project exposes only `specs`, write and run `specs`; if it exposes only `features`, write and run `features`; if it exposes both, choose the one that matches the behavior under change.
- Prefer `make` targets such as `help`, `dep`, `lint`, `specs`, `features`, `benchmarks`, `coverage`, or `sec` when the repo exposes them.
- When the user asks for a PR, always prepare:
  - a single-line commit message written entirely in lowercase plain text
  - the commit message first, by itself
  - a PR summary based on both relevant committed changes and current working-tree changes when both exist
  - a markdown PR summary after the commit message with exactly these section titles: `What`, `Why`, and `Testing`
- Do not run destructive or remote-effect git helpers such as reset, purge, branch deletion, force-push, merge, or amend flows unless the user explicitly asks for that action.
- Do not revert or overwrite unrelated user changes.

## Use The References

- Read `references/workflow.md` when you need help interpreting repo structure, `./bin` usage, target discovery, or the right investigation sequence.
- Read `references/verification.md` when deciding what to run, how to scope validation, or how to report checks honestly.
- Read `references/make-fragments.md` when the repository includes the shared `./bin` make fragments and you need to infer which commands, wrappers, or gotchas likely apply.
- Read `references/change-safety.md` when deciding how to handle tests, dependencies, compatibility, generated files, security-sensitive changes, or broader documentation updates.
- Read `references/go.md` when working in Go repositories and making import, naming, or package-collision decisions.
- Read `references/ruby.md` when working in Ruby repositories and making public API, documentation, or style decisions.
- Read `references/review.md` when the user asks for a review or wants risk-focused feedback on a change.

## Done Criteria

- The requested change or analysis is complete.
- Public-facing code introduced or changed by the work has detailed and accurate documentation in the project's native style.
- Non-trivial public APIs include examples when the repository's documentation style supports them.
- Behavior changes are covered by tests, or the reason tests were not added is stated explicitly.
- Applicable linting was checked after changes and passed, or the reason it could not be checked is stated explicitly.
- Relevant validation was run and passed, or the reason it could not be run is stated explicitly.
- Migration, deprecation, performance, and observability impacts are addressed when they are relevant to the change.
- Temporary code and debug scaffolding are removed or intentionally called out.
- Important assumptions, tradeoffs, and residual risks are called out.
- The final response is concise and points to the most important files, checks, or findings.
