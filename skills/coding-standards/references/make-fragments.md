# Make Fragments Reference

Use this reference after you have already identified which shared `bin/build/make/*.mak` fragments a repository includes and you need quick help interpreting their likely targets or gotchas.

## Scope

- Treat the root `Makefile` as the actual interface and the included fragments as supporting context.
- Use this reference to interpret fragment behavior, not to replace checking which targets the repository really exposes.
- Use `references/workflow.md` first when you still need to discover the command surface.

## Common Fragment Map

### `help.mak`

- Usually makes `help` the default target.
- Use it to discover repo-defined commands before guessing.

### `ruby.mak`

- Especially relevant targets: `dep`, `lint`, `format`, `features`, `benchmarks`, `sec`, `start`, `stop`.
- `features` and `benchmarks` call wrappers under `$(PWD)/bin/quality/ruby/...`, so they should be run from the consuming repo root.
- `start` and `stop` delegate to `bin/build/docker/env`, which may require access to a sibling `../docker` checkout and SSH-based cloning if that repo is missing.

### `go.mak`

- Especially relevant targets: `dep`, `lint`, `format`, `specs`, `benchmark`, `coverage`, `sec`, `start`, `stop`.
- `specs` expects a downstream `test/reports/` layout.
- `coverage` depends on coverage files under `test/reports/`.
- `lint` runs field alignment checks and `golangci-lint`; the wrapper may no-op if `golangci-lint` is not installed.
- `clean` may assume a `master` branch exists when refreshing dependencies.

### `git.mak`

- Common helpers cover branch creation, sync, commit/PR flows, destructive cleanup, and submodule commands.
- Treat these as convenience wrappers, not default actions.
- Do not use targets that rewrite history, delete branches, discard changes, or push remotely unless the user explicitly asks.

## Practical Inference Rules

- If the root `Makefile` includes `ruby.mak`, expect Ruby lint and cucumber-style feature flows.
- If it includes `go.mak`, expect Go lint, test, coverage, and security flows.
- If the repo exposes both `features` and `specs`, choose the target that best matches the area under change.
- If the repo overrides a target after including a fragment, trust the root `Makefile` behavior over the fragment default.
