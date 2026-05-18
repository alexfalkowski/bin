---
name: project-workflow
description: Discovers project-local workflow, command surfaces, CI expectations, and shared ./bin submodule wiring before work begins. Use when starting in a project, inspecting how to run tasks, or deciding trusted entrypoints; use makefile-includes when editing or debugging reusable make fragments.
---

# Project Workflow

## Steps

1. Read project-local instructions first, such as `AGENTS.md`, `README.md`, the root `Makefile`, and CI configuration.
2. Identify the project's real command surface before choosing tools. Prefer exposed entrypoints over guessed direct invocations.
3. If the repository uses this shared project as `./bin`, read `references/bin-submodule.md` before reasoning about path-sensitive behavior.
4. Inspect only the files, scripts, and make fragments relevant to the user's task.
5. Identify commands that require network, SSH, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state before running or recommending them.
6. When workflow discovery is the final response, use the exact structure in `references/bin-submodule.md`; do not add, remove, rename, or reorder sections.
7. When another skill embeds this discovery, preserve the discovered commands, CI expectations, bin wiring, and constraints in the caller's output format.

## References

- Read `references/bin-submodule.md` when a repository includes `bin/build/make/*.mak`, vendors this project as `./bin`, or has targets that call `$(PWD)/bin/...`.
