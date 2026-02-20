# AGENTS.md

## Repository purpose

This repository is a collection of shared **executables** and **Makefile includes** intended to be reused across projects (typically as a Git submodule mounted at `./bin`). See `README.md`.

Most of the code here is small Bash/Ruby utilities plus reusable make fragments under `build/make/`.

## Quick commands (this repo)

From this repository root:

- Show available Make targets:
  - `make` (defaults to `help`, via `build/make/help.mak`)
  - `make help`
- Install Ruby dev deps (Bundler):
  - `make dep`
- Ruby linting:
  - `make lint`
  - `make fix-lint`
  - `make format`
- Script / Dockerfile linting:
  - `make scripts-lint` (runs `shellcheck` over various scripts)
  - `make docker-lint` (runs `hadolint` on `build/docker/go/Dockerfile`)

CI runs (CircleCI): `make dep`, `make clean-dep`, `make scripts-lint`, `make docker-lint`, `make lint` (see `.circleci/config.yml`).

## Tooling dependencies (observed)

Ruby tooling (declared in `Gemfile`):

- Ruby (Rubocop targets Ruby **3.4**, see `.rubocop.yml`)
- Bundler (`bundler` gem)
- RuboCop (`rubocop` gem)

External CLIs referenced by Make targets / scripts in this repo:

- `shellcheck` (used by `make scripts-lint`)
- `hadolint` (used by `make docker-lint`)

Other CLIs referenced in reusable scripts/make fragments (used by downstream repos that include these files):

- Go toolchain (`go`), `gotestsum`, `golangci-lint`, `govulncheck`, `fieldalignment`
- `buf`
- `docker` (including `docker buildx`/manifest)
- `trivy`
- `mkcert`, `goda`, `dot`, `scc`, `codecovcli`, `gsa`, `air`

Only rely on a command if you can find it being invoked in the relevant `.mak`/script you’re touching.

## Layout

- `build/make/*.mak`
  - Reusable Makefile fragments for other repositories to `include`.
  - Examples:
    - `build/make/ruby.mak`: bundler/rubocop tasks + cucumber wrappers.
    - `build/make/git.mak`: branch/workflow helpers and conventional-ish commit prefixing.
    - `build/make/go.mak`: go deps, lint, tests, coverage, security.
    - `build/make/{http,grpc,client}.mak`: project templates combining Go + Ruby test harness.
    - `build/make/buf.mak`: buf lint/generate/push/breaking.
- `build/docker/`
  - `go/Dockerfile`: multi-stage Go build into distroless runtime.
  - `env`: helper that clones/updates a sibling `../docker` repo and runs `make …` there.
  - `push`, `manifest`: docker publishing helpers gated by last commit subject.
- `build/go/`
  - `lint`: wrapper that only runs `golangci-lint` if it exists in `$PATH`.
  - `clean`: helper that may trigger dependency cleanup if `go.sum` differs from `master`.
  - `fa`: wrapper around `fieldalignment` with optional `.gofa` package filtering.
- `build/sec/`
  - `trivy-repo`, `trivy-image`: Trivy scanning helpers.
- `quality/`
  - `quality/go/covfilter`: removes excluded packages from `test/reports/profile.cov` into `final.cov`.
  - `quality/go/covmerge`: filters and merges multiple coverage files into `test/reports/final.cov`.
  - `quality/ruby/feature`, `quality/ruby/benchmark`: cucumber wrappers.

## Conventions & patterns (observed)

### Shell scripts

- Scripts generally use:
  - `#!/usr/bin/env bash`
  - `set -eo pipefail`
- Some scripts intentionally disable specific ShellCheck rules (e.g. `SC2086`) when passing through user-provided args.

### Ruby scripts

- Ruby scripts use `# frozen_string_literal: true`.
- Simple file-system / process helpers; no framework.

### Formatting

- `.editorconfig` enforces:
  - default: 2-space indentation, LF line endings
  - `Makefile`/`*.mak`: tabs
  - `*.go`: tabs

### RuboCop

- `.rubocop.yml` sets `TargetRubyVersion: 3.4`.
- Excludes `vendor/**/*` and also `bin/**/*` (important in downstream repos that vendor this as `./bin`).

## Gotchas

- **Submodule path expectations**: many make fragments invoke tools via `$(PWD)/bin/...` (e.g. `build/make/ruby.mak`, `build/make/go.mak`).
  - That’s intended when *this repo is checked out as `./bin` inside another repo*.
  - When running from this repo root, any target that references `$(PWD)/bin/...` will resolve to `<repo>/bin/...` (which usually does **not** exist here) and will fail.
  - For changes that affect these targets, validate the path logic against the intended usage model.

- **`build/docker/env` clones via SSH**: it uses `git clone git@github.com:alexfalkowski/docker.git` into `../docker` if missing (`build/docker/env:14`). Agents without SSH keys/permissions won’t be able to run `make start/stop` paths that depend on it.

- **Coverage helpers assume downstream test layout**:
  - `quality/go/*` reads/writes under `test/reports/`.

- **`build/go/lint` is a no-op if `golangci-lint` isn’t installed** (`build/go/lint:5-7`). Don’t assume lint ran unless the binary exists.

- **`build/go/clean` assumes a `master` branch exists** when diffing `go.sum` (`build/go/clean:6-10`).

## CI signals

`.circleci/config.yml` is the authoritative “what must pass” for this repo:

- Bundler deps are cached under `vendor/`.
- The required checks in CI are:
  - `make scripts-lint`
  - `make docker-lint`
  - `make lint`

## When changing this repo

- Prefer the smallest change; these scripts are reused across projects.
- After edits, re-run at least:
  - `make dep`
  - `make lint`
  - `make scripts-lint` (if `shellcheck` is available)
  - `make docker-lint` (if `hadolint` is available)
