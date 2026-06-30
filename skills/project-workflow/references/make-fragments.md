# Make Fragments

Use this reference after you have identified which shared `bin/build/make/*.mak` fragments a repository includes, or when editing reusable `build/make/*.mak` files in this repo.

## Scope

- Treat the root `Makefile` as the actual interface and included fragments as supporting context.
- Use this reference to interpret likely fragment behavior, not to replace checking which targets the repository really exposes.
- Validate path-sensitive behavior from this repository root and from the consuming repository root when helper paths or downstream layouts matter.
- Preserve downstream `./bin` include behavior unless the user explicitly asks to change it.

## Target Metadata

- Treat comments immediately before targets as the external command catalog. A target that is called by humans, CI, downstream repositories, scripts, or any other external system must have a concise `# ...` comment that says what it does.
- Treat uncommented targets as internal implementation details. Do not present or recommend them as discoverable commands unless the task explicitly targets internal Make wiring.
- Do not add `.PHONY` entries mechanically for every target. Keep `.PHONY` selective, and add it only when there is a concrete file or directory collision risk and the target must always run.
- Do not broaden a Makefile's `.PHONY` policy as cleanup while making unrelated target, comment, or validation changes.

## Common Fragment Map

### `help.mak`

- Usually makes `help` the default target.
- Use it to discover repo-defined commands before guessing.

### `ruby.mak`

- Especially relevant targets: `dep`, `lint`, `format`, `features`, `benchmarks`, `sec`, `start`, `stop`.
- `features` and `benchmarks` call wrappers under `BIN_ROOT/quality/ruby/...`; downstream test layout still controls whether they can run successfully.
- `start` and `stop` delegate to `bin/build/docker/env`, which may require access to a sibling `../docker` checkout and SSH-based cloning if that repo is missing.
- `dep`, `update-dep`, `update-all-dep`, `sec`, `start`, and `stop` may require network access or external credentials depending on the consuming repo.

### `go.mak`

- Especially relevant targets: `dep`, `lint`, `format`, `specs`, `benchmark`, `coverage`, `sec`, `start`, `stop`.
- `specs` expects a downstream `test/reports/` layout.
- `coverage` depends on coverage files under `test/reports/`.
- `lint` runs field alignment checks and `golangci-lint`; the wrapper may no-op if `golangci-lint` is not installed.
- `clean` may assume a `master` branch exists when refreshing dependencies.
- `dep`, `get`, `get-all`, `update-dep`, `update-all-dep`, `sec`, `start`, and `stop` may require network access or external credentials depending on the consuming repo.

### `buf.mak`

- Especially relevant targets: `lint`, `fix-lint`, `format`, `generate`, `stale`, `breaking`, `push`, `update-all-dep`.
- `breaking` compares against `https://github.com/alexfalkowski/$(NAME).git#branch=master`, so branch and remote assumptions matter.
- `generate`, `stale`, and `push` depend on the consuming repository's Buf configuration.
- `stale` runs `buf generate` from the Buf module directory that included the fragment, then runs `git diff --exit-code`; Git checks the whole worktree, so generated outputs outside that child directory are still detected.
- `push` updates remote state and requires explicit user permission.

### `http.mak`, `grpc.mak`, And `client.mak`

- These are project-template fragments that combine Go, Ruby test harness, Docker, security, coverage, and helper targets.
- `grpc.mak` also includes proto lint, format, generate, stale, breaking, and push targets.
- `features` and `benchmarks` depend on downstream test/build layout and wrappers under `BIN_ROOT/quality/ruby/...`.
- `specs`, coverage, and report cleanup assume downstream `test/reports/` paths.
- Docker and certificate helper targets depend on external CLIs such as Docker, `mkcert`, `dot`, and `air` depending on the target.
- Docker push, manifest, release, and registry-publishing targets update remote state and require explicit user permission.

### `git.mak`

- Common helpers cover branch creation, sync, commit/PR flows, destructive cleanup, and submodule commands.
- Treat these as convenience wrappers, not default actions.
- Do not use targets that rewrite history, delete branches, discard changes, or push remotely unless the user explicitly asks.
- `push`, `force`, `draft`, `pr`, `merge`, `review`, and `ready` update remote GitHub state and require explicit current-request permission.

## Practical Inference Rules

- If the root `Makefile` includes `ruby.mak`, expect Ruby lint and cucumber-style feature flows.
- If it includes `go.mak`, expect Go lint, test, coverage, and security flows.
- If it includes `buf.mak`, expect Buf lint, format, generate, stale-output, push, and breaking-change flows.
- If it includes `http.mak`, `grpc.mak`, or `client.mak`, expect combined Go/Ruby validation and downstream test harness assumptions.
- If the repo exposes both `features` and `specs`, choose the target that best matches the area under change.
- If the repo overrides a target after including a fragment, trust the root `Makefile` behavior over the fragment default.
