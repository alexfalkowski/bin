---
name: project-workflow
description: Discovers project-local workflow, command surfaces, Makefile includes, CI expectations, and shared ./bin submodule wiring. Use when starting work in a project, inspecting how to run tasks, or deciding which project entrypoints to trust before edits or validation.
---

# Project Workflow

## Steps

1. Read project-local instructions first, such as `AGENTS.md`, `README.md`, the root `Makefile`, and CI configuration.
2. Identify the project's real command surface before choosing tools. Prefer exposed entrypoints over guessed direct invocations.
3. If the repository uses this shared project as `./bin`, read `references/bin-submodule.md` before reasoning about path-sensitive behavior.
4. Inspect only the files, scripts, and make fragments relevant to the user's task.
5. Report any workflow constraint that affects the work, such as missing tools, downstream-only paths, or CI-only behavior.

## References

- Read `references/bin-submodule.md` when a repository includes `bin/build/make/*.mak`, vendors this project as `./bin`, or has targets that call `$(PWD)/bin/...`.
