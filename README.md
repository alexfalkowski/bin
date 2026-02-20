[![CircleCI](https://circleci.com/gh/alexfalkowski/bin.svg?style=shield)](https://circleci.com/gh/alexfalkowski/bin)
[![Stability: Active](https://masterminds.github.io/stability/active.svg)](https://masterminds.github.io/stability/active.html)

# bin

A collection of shared **executables** and **Makefile includes** intended to be reused across projects (typically as a Git submodule checked out at `./bin`).

This repo contains:

- reusable `build/make/*.mak` fragments (Go/Ruby/proto helpers)
- small Bash/Ruby scripts under `build/` and `quality/`
- a Dockerfile template for building Go services (`build/docker/go/Dockerfile`)

## Rationale

After repeating the same build/lint/test/CI glue across projects, it’s useful to standardize it once and reuse it.

## Repository layout

| Path            | What it contains                                                                  |
|-----------------|------------------------------------------------------------------------------------|
| `build/make/`   | Makefile include fragments (Go, Ruby, git workflow, buf/proto, project templates). |
| `build/go/`     | Go-related helper scripts (`lint`, `clean`, `fa`).                                 |
| `build/docker/` | Docker helpers and `build/docker/go/Dockerfile`.                                   |
| `build/sec/`    | Security scanning helpers (Trivy).                                                 |
| `quality/`      | Quality/test helpers (Go coverage processing, cucumber wrappers).                  |

## Using this repo (recommended: Git submodule)

Most make fragments invoke scripts via `$(PWD)/bin/...`, so the intended usage is:

- your project has this repo checked out at `./bin`
- your project `Makefile` includes one or more fragments from `./bin/build/make/*.mak`

Example:

```bash
git submodule add git@github.com:alexfalkowski/bin.git bin
git submodule update --init
```

## Makefile includes (examples)

### Ruby-only project

```make
include bin/build/make/help.mak
include bin/build/make/ruby.mak
```

This gives you targets like:

- `make dep` (bundler install into `vendor/bundle`)
- `make lint` / `make fix-lint` / `make format` (rubocop)
- `make features` / `make benchmarks` (cucumber wrappers)

### Go project

```make
include bin/build/make/help.mak
include bin/build/make/go.mak
```

This gives you targets like:

- `make dep` (download/tidy/vendor)
- `make lint` / `make fix-lint` / `make format`
- `make specs` (gotestsum + race + coverage written under `test/reports/`)
- `make coverage` (HTML + func coverage from `test/reports/final.cov`)
- `make sec` (govulncheck)

### Git workflow helpers

```make
include bin/build/make/git.mak
```

This adds convenience targets such as `make new-feature name=<something>`, `make sync`, and `make optimise`.

## Executables and helpers (examples)

### Go coverage helpers

- `quality/go/covfilter` filters `test/reports/profile.cov` into `test/reports/final.cov` using an exclude regex.
  - Default exclude is `test` unless `.gocov` exists.
- `quality/go/covmerge` filters each `test/reports/*.cov` into `test/reports/filter/` and merges them into `test/reports/final.cov`.
  - Default exclude is `test|.pb|main.go` unless `.gocov` exists.

### Cucumber wrappers

- `quality/ruby/feature` runs cucumber with the `report` profile and excludes `@benchmark`.
- `quality/ruby/benchmark` runs only `@benchmark` scenarios.

These are used by `build/make/ruby.mak` targets `features` and `benchmarks`.

### Docker helpers

- `build/docker/go/Dockerfile` is a multi-stage Dockerfile to build a Go binary and copy it into a distroless image.
- `build/docker/build` builds a **test** image tagged `alexfalkowski/<name>:test.<platform>`.
- `build/docker/push` and `build/docker/manifest` are gated: they only run if the last commit subject starts with `chore`.

### Local environment helper

`build/docker/env` is a convenience wrapper for a sibling checkout of `../docker`:

- if `../docker` exists, it updates it via `git pull --rebase` and updates submodules
- otherwise, it tries to `git clone git@github.com:alexfalkowski/docker.git` (SSH)

It then runs `(cd ../docker && make kind=deps <command>)`.

## Working on this repo

List available targets:

```bash
make
```

Common checks used in CI (`.circleci/config.yml`):

```bash
make dep
make clean-dep
make scripts-lint
make docker-lint
make lint
```

## CircleCI note

CircleCI jobs in this repo explicitly run `git submodule sync` / `git submodule update --init` because submodules require extra handling in CI (see `.circleci/config.yml`).
