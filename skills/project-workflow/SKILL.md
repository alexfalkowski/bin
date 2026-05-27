---
name: project-workflow
description: Discovers project-local workflow, command surfaces, CI expectations, shared ./bin submodule wiring, and reusable build/make/*.mak fragment behavior before work begins. Use when starting in a project, inspecting how to run tasks, deciding trusted entrypoints, or editing/debugging shared Makefile fragments.
---

# Project Workflow

## Steps

1. Read project-local instructions first, such as `AGENTS.md`, `README.md`, the root `Makefile`, and CI configuration.
2. Identify the project's real command surface before choosing tools. Prefer exposed entrypoints over guessed direct invocations.
3. If the repository uses this shared project as `./bin`, read `references/bin-submodule.md` before reasoning about path-sensitive behavior.
4. Inspect only the files, scripts, and make fragments relevant to the user's task.
5. Read `references/make-fragments.md` when you need to interpret included `bin/build/make/*.mak` fragments, edit reusable make fragments, or reason about likely target behavior.
6. Identify commands that require network, SSH, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state before running or recommending them.
7. When workflow discovery is the final response, use the exact structure in `references/bin-submodule.md`; do not add, remove, rename, or reorder sections.
8. When another skill embeds this discovery, preserve the discovered commands, CI expectations, bin wiring, and constraints in the caller's output format.

## References

- Read `references/bin-submodule.md` when a repository includes `bin/build/make/*.mak`, vendors this project as `./bin`, or has targets that call `$(PWD)/bin/...`.
- Read `references/make-fragments.md` after discovering which shared Makefile fragments are included and before editing or debugging reusable `build/make/*.mak` behavior.
