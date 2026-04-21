---
name: coding-standards
description: Apply shared cross-repository engineering expectations for repo inspection, safe changes, validation, and review output.
---

# Coding Standards

## Overview

Follow repository-local instructions first, then use this skill to keep behavior consistent across repositories that share this reusable `./bin` make-and-script workflow.
Use the core workflow for general execution. Prefer the smallest safe change, validate with the narrowest relevant checks, and report clearly what was verified and what remains uncertain.

## Core Workflow

### Understand The Repo

- Read the relevant repository-local guidance that exists before editing, such as `AGENTS.md`, `README.md`, the root `Makefile`, and CI configuration.
- In repositories that expose `make dep`, run it before validation, tests, lint, or code changes unless the task is purely read-only. In this ecosystem, dependency drift is common enough that skipping this step often produces misleading failures or stale tool behavior. If `make dep` cannot be run, say so plainly and continue with that constraint in mind.
- Treat repository-local instructions as higher priority than this skill. Use this skill to fill gaps and standardize behavior across repos.
- For read-only tasks such as review or analysis, do not force edits, documentation changes, or validation steps that the task does not require.
- For read-only tasks, gather the needed context, prioritize findings and notable coverage or validation gaps over summaries or implementation advice, and keep the output grounded in the inspected code and repository behavior.
- Treat CI configuration as a strong signal for what the repository expects to pass, then confirm whether repository-local instructions or the task context imply additional checks.

### Make The Change

- Prefer the smallest change that solves the task end-to-end.
- Preserve existing project patterns unless a deviation is necessary for correctness, safety, or maintainability.
- If a decision has non-obvious consequences, pause and verify the direction with a short plan before committing to it.
- Keep diffs tight. Avoid incidental refactors, large renames, or formatting churn unless they are required by the task.
- If behavior changes, add or update tests unless the repository truly cannot support it. When tests are not added, state the reason explicitly.
- Use the repo's actual test workflow and entrypoints. If the repository exposes named targets such as `specs` or `features`, use the one that matches the behavior under change instead of forcing a different test vocabulary.
- Prefer the standard library and existing project dependencies before adding a new dependency. If a new dependency is required, keep it narrowly scoped and explain why it is necessary.

### Protect Users And Interfaces

- Treat documentation for user-facing or documented interfaces as required work, not optional polish.
- When a change alters the behavior, usage, or contract of a documented interface, update the relevant documentation in the repository's native style and include examples when the interface is non-trivial and the doc style supports them.
- Prefer updating existing documentation over creating new documentation files unless the repository clearly expects a new document.
- Do not silently break user-facing or documented APIs, flags, env vars, config, file formats, or Make targets that downstream users may depend on. Preserve backward compatibility when feasible, and call out intentional breaking changes explicitly.
- If a change to existing behavior or interfaces needs migration or deprecation work, include that work when it is relevant instead of leaving it implicit.
- If a change introduces or materially reshapes runtime-critical or hard-to-diagnose behavior, such as hot paths, background jobs, retries, polling, or concurrency, consider benchmark impact, runtime cost, and the observability needed to understand the feature in production.
- Avoid committing secrets, weakening security controls, or introducing unsafe handling of shell commands, file paths, auth, or untrusted input.
- Do not hand-edit generated code, vendored code, or lockfiles unless the task specifically requires it or regeneration is part of the intended workflow.
- Do not leave temporary code behind without calling it out. Remove debug prints, temporary instrumentation, dead code, throwaway TODOs, and short-term compatibility shims unless they are intentionally part of the change with a clear rationale.

### Validate And Report

- Do not assume tools exist. Discover likely commands from the repository's Makefiles, scripts, CI, documentation, and any shared make fragments the repository actually uses.
- Prefer the narrowest verified entrypoint for the task, whether that is a repo-exposed `make` target or a direct command the repository's workflow expects.
- Before wrapping up code changes, run the applicable lint checks. Prefer the narrowest repo-defined lint command that covers the files you changed, and report clearly when linting could not be run.

## Use The References

- Consult only the specific reference you need for the current task.
- Each reference focuses on a single concern, so open the one that matches the decision you are making.
