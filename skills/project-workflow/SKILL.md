---
name: project-workflow
description: Use when you need to discover how a repository is built, tested, linted, released, or configured; when choosing a supported command; or before changing shared Makefile tooling. Identify project commands, CI expectations, local patterns, and downstream ./bin behavior.
---

# Project Workflow

## Steps

1. Read project-local instructions first, such as `AGENTS.md`, `README.md`, the root `Makefile`, and CI configuration.
2. Identify the project's real command surface before choosing tools. Prefer exposed entrypoints over guessed direct invocations.
3. Before running, retrying, replacing, or recommending commands, establish the execution environment: repository root, documented entrypoint, CI analogue, configured command environment, and any platform-specific tool-path setup. Do not invent direct commands or bypass Make targets just because the agent shell cannot find the right tool.
4. After a repository-defined command, Make target, dominant test harness, or skill-required workflow fails, do not switch to an ad hoc command, different validation layer, or alternate workflow merely to make progress. First classify the failure using the repository's validation categories; then retry only through the configured command environment or approved escalation path, or report the blocker.
5. If the repository uses this shared project as `./bin`, read `references/bin-submodule.md` before reasoning about path-sensitive behavior.
6. When downstream-specific defaults apply after confirming shared `./bin` wiring, read `references/downstream-defaults.md`; do not preload it for work confined to this repository.
7. Inspect only the files, scripts, and make fragments relevant to the user's task.
8. Read `references/make-fragments.md` when you need to interpret included `bin/build/make/*.mak` fragments, edit reusable make fragments, or reason about likely target behavior.
9. Identify commands that require network, SSH, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state before running or recommending them.
10. Before editing code, tests, docs, config, scripts, or validation paths, identify the local pattern for the changed surface: import style, naming style, file layout, dominant test harness, documented config keys, and repository validation target. Agents MUST preserve those patterns unless the user explicitly asks to change them.
11. If an edit would deviate from the discovered local pattern, stop and ask before editing. State the exact pattern, why it cannot work, and the proposed deviation.
12. When workflow discovery is the final response, use the exact structure in `references/bin-submodule.md`; do not add, remove, rename, or reorder sections.
13. When another skill embeds this discovery, preserve the discovered commands, CI expectations, bin wiring, constraints, and local-pattern facts in the caller's output format.

## References

- Read `references/bin-submodule.md` when a repository includes `bin/build/make/*.mak`, vendors this project as `./bin`, or uses shared helper paths through `BIN_ROOT`.
- Read `references/make-fragments.md` after discovering which shared Makefile fragments are included and before editing or debugging reusable `build/make/*.mak` behavior.
- Read `references/downstream-defaults.md` only when downstream-specific defaults apply after confirming shared `./bin` wiring.
