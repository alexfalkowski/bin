# Workflow Reference

Use this reference when you need to establish context quickly and discover how a repository is wired.

## Discover The Interface

1. Read `AGENTS.md` if present.
2. Read `README.md` and the root `Makefile`.
3. Inspect CI configuration to learn what the repository expects to pass.
4. Inspect which `bin/build/make/*.mak` fragments are included by the root `Makefile`, when relevant.
5. Inspect only the files and scripts relevant to the requested task.

## Prefer Repository Entry Points

- Prefer repository entry points such as `make` targets over calling tools directly.
- Use direct tool invocations only when the repository does not provide a stable entry point or when a narrower check is clearly better for the task.
- Confirm that a target or script is actually wired into the repo before relying on it.
- When `help.mak` is included, use `make` or `make help` as the quickest way to discover the command surface.
- When planning work, note whether the repository exposes setup targets such as `dep` so you can use them later when the task moves from discovery to edits or validation.

## When The Repo Uses `./bin`

- Treat the consuming repository as the primary execution context.
- Inspect the root `Makefile` to see which `bin/build/make/*.mak` fragments are included.
- Validate path-sensitive behavior from the consuming repository root, not from inside the `bin` submodule.
- Be careful with targets that resolve helper paths through `$(PWD)/bin/...`; they may work in a downstream repo and fail inside the `bin` repo itself.
- Be careful with `start` and `stop` helpers because they may depend on a sibling `../docker` checkout or SSH access.
