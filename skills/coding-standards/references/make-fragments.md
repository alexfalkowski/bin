# Make Fragments Reference

Use this reference when a repository includes `bin/build/make/*.mak` and you need to infer likely commands or workflow expectations from the selected fragments.

## Read The Root Makefile First

- Treat the root `Makefile` as the actual interface.
- Use included fragments to infer what targets probably exist, then confirm the repo exposes them.
- Prefer `make` or `make help` when the repo includes `help.mak`.

## Common Fragment Map

### `help.mak`

- Usually makes `help` the default target.
- Use it to discover repo-defined commands before guessing.

### `ruby.mak`

- Common targets cover deps, lint/format, features/benchmarks, reports, security, cost, and local environment helpers.
- Especially relevant targets: `dep`, `lint`, `format`, `features`, `benchmarks`, `sec`, `start`, `stop`.
- `features` and `benchmarks` call wrappers under `$(PWD)/bin/quality/ruby/...`, so they should be run from the consuming repo root.
- `start` and `stop` delegate to `bin/build/docker/env`, which may require access to a sibling `../docker` checkout and SSH-based cloning if that repo is missing.

### `go.mak`

- Common targets cover deps, cleanup, lint/format, tests, benchmarks, coverage, security, cost, and local environment helpers.
- Especially relevant targets: `dep`, `lint`, `format`, `specs`, `benchmark`, `coverage`, `sec`, `start`, `stop`.
- `specs` expects a downstream `test/reports/` layout.
- `coverage` depends on coverage files under `test/reports/`.
- `lint` runs field alignment checks and `golangci-lint`; the wrapper may no-op if `golangci-lint` is not installed.
- `clean` may assume a `master` branch exists when refreshing dependencies.

### `git.mak`

- Common helpers cover branch creation, sync, commit/PR flows, reset/purge, and submodule commands.
- Treat these as convenience wrappers, not default actions.
- Do not use targets that rewrite history, delete branches, discard changes, or push remotely unless the user explicitly asks.

## Practical Inference Rules

- If the root `Makefile` includes `ruby.mak`, expect Ruby lint and cucumber-style feature flows.
- If it includes `go.mak`, expect Go lint, test, coverage, and security flows.
- If it exposes only one of `features` or `specs`, treat that as the repo's intended test entry point for new or updated tests in that area.
- If it includes both, treat that as an intentional mixed workflow. A repo can validly expose `features`, `specs`, or both.
- If it includes both, prefer the target that best matches the files you changed and widen validation only when the change crosses boundaries.
- If the repo overrides a target after including a fragment, trust the root `Makefile` behavior over the fragment default.
