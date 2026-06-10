# AGENTS.md

## Repository purpose

This repository is a collection of shared **executables** and **Makefile includes** intended to be reused across projects (typically as a Git submodule mounted at `./bin`). See `README.md`.

Most of the code here is small Bash/Ruby utilities plus reusable make fragments under `build/make/`.

## Shared skills

This repository ships focused skills under `skills/`. Use the smallest matching
skill instead of one broad default:

- `project-workflow`: project discovery, command surfaces, CI, and `./bin`
  submodule wiring.
- `change-safety`: compatibility, documented interfaces, migrations, generated
  files, and security-sensitive edits.
- `change-validation`: test, lint, CI, security, benchmark, and validation selection.
- `testing-standards`: language-agnostic test design, coverage, fixtures,
  determinism, and test-layer guidance.
- `naming-standards`: cross-language naming judgment for domain clarity,
  consistency, abstraction level, public terminology, and rename safety.
- `code-review`: review findings, risk assessment, and missing coverage.
- `style-review`: non-blocking readability, consistency, idiom, and polish
  suggestions that should not be reported as code-review findings.
- `security-audit`: security reviews, vulnerability checks, unsafe shell/filesystem/network/auth inspection, and Go/Ruby/shell audit guidance.
- `code-issues`: find confirmed code issues into `ISSUES.md`, then implement agreed fixes one code issue at a time.
- `test-gaps`: find confirmed missing or weak tests into `ISSUES.md`, then implement agreed test fixes gap by gap.
- `doc-gaps`: find confirmed missing, stale, or misleading docs/comments into `ISSUES.md`, then implement agreed doc fixes gap by gap.
- `reliability-standards`: SRE, NALSD, production-readiness, SLO, overload,
  observability, release-safety, recovery, and operability guidance.
- `reliability-gaps`: find confirmed reliability gaps into `ISSUES.md`, then
  implement agreed reliability fixes gap by gap.
- `review-pr`: create a commit, force-push, and open a draft PR with a generated summary.
- `shell-standards`: Bash scripting, ShellCheck, text processing, directory
  scope, and function documentation conventions.
- `go-standards`: Go API, documentation, import, naming idiom, and testing
  conventions for repos using this tooling.
- `ruby-standards`: Ruby API, documentation, naming idiom, style, and validation
  conventions for repos using this tooling.

Treat this `AGENTS.md` as the repo-specific companion to those skills.

When this repository is read from a downstream repo as `./bin`, treat `bin/`
as vendored shared tooling:

- Read `bin/AGENTS.md` and the relevant `bin/skills/**` files when shared
  guidance is needed.
- Do not search, read, edit, or review other files under `bin/**` unless the
  task is explicitly about shared `bin` tooling, Makefile includes, skills, or
  submodule wiring.
- Prefer searches from the consuming repo that exclude unrelated submodule
  contents, for example `rg --glob '!bin/**' ...`.
- Make fragments derive shared helper paths from their own include location
  through `BIN_ROOT`; reason about target behavior from the consuming
  repository root without exploring unrelated files inside `bin/`.

When changing a skill's trigger, scope, workflow, or user-facing behavior,
check the matching `skills/<name>/agents/openai.yaml` and update it if the
display name, short description, or default prompt became stale.

Common composition:

- `review-pr` orchestrates PR preparation with `project-workflow`,
  `change-validation`, relevant language standards, `code-review`, summary
  drafting, optional explicit `style-review`, and the review target.
- `code-issues` orchestrates a two-phase code-issue workflow: aggregate confirmed
  `project-workflow`, `code-review`, and `security-audit` findings into
  `ISSUES.md`, then implement agreed fixes one code issue at a time.
- `test-gaps` orchestrates a two-phase test-gap workflow: aggregate confirmed
  `project-workflow` context and missing or weak test coverage into
  `ISSUES.md`, then implement agreed test fixes gap by gap.
- `doc-gaps` orchestrates a two-phase doc-gap workflow: aggregate
  confirmed `project-workflow` context and missing, stale, or misleading
  README, docs, examples, comments, and docstrings into `ISSUES.md`, then
  implement agreed doc fixes gap by gap.
- `reliability-gaps` orchestrates a two-phase reliability-gap workflow:
  aggregate confirmed `project-workflow` context and SRE, NALSD, operability,
  overload, observability, release-safety, recovery, or data-integrity gaps into
  `ISSUES.md`, then implement agreed reliability fixes gap by gap.
- `code-review` conditionally consults `security-audit` for security-sensitive
  review scope while keeping the review findings format.
- `style-review` performs an optional non-blocking polish pass when explicitly
  requested, after or separate from `code-review`; it must not replace bug,
  security, compatibility, test-gap, or doc-gap review.
- `security-audit` pairs with `change-safety` for code changes and
  `change-validation` for scanner, lint, or CI command selection.
- `testing-standards` pairs with language standards for test idioms and
  `change-validation` for command selection.
- `reliability-standards` pairs with `change-safety`, `security-audit`,
  `testing-standards`, and `change-validation` when changes affect production
  readiness, SLOs, overload, observability, release safety, recovery, or
  operability.
- `naming-standards` pairs with language standards when a change creates,
  reviews, or renames identifiers, commands, flags, files, tests, fixtures, or
  documentation terms.
- `project-workflow` covers command discovery, CI expectations, downstream
  `./bin` wiring, and shared Makefile fragment behavior.
- `change-validation` should use `project-workflow` context before selecting
  validation commands for orchestrated workflows.

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
- Security scanning:
  - `make sec` (runs Trivy over the repository)

CI runs (CircleCI): `make dep`, `make clean-dep`, `make scripts-lint`, `make docker-lint`, `make lint`, `make sec` (see `.circleci/config.yml`).

## Command execution policy

- Treat this repository's Makefile, reusable make fragments, and CI
  configuration as the source of truth for setup, lint, test, security,
  benchmark, and review commands.
- Prefer `make` targets and documented repository entry points over direct tool
  invocations, even when a direct command appears equivalent.
- Run commands from the repository root unless the Makefile, script, or task
  explicitly requires another working directory.
- Use the user's configured shell environment for command execution. If a
  command fails because a tool is missing, an old version is found, or `PATH`
  differs from the user's normal terminal, treat that as an environment
  mismatch or validation gap, not as evidence that the repository command is
  wrong.
- Do not replace a Makefile target with guessed direct commands just because the
  agent environment cannot find the same tools as the user's shell.
- When diagnosing command-environment mismatches, check the command surface
  first, then inspect `command -v <tool>`, `<tool> --version`, `SHELL`, and
  `PATH` as diagnostics only.
- In this repository and downstream repos that vendor it as `./bin`, `make`
  targets are the preferred validation interface. If `make` reports an
  unexpected tool or version problem in the agent environment but works in the
  user's shell, report the mismatch and keep the Makefile target as the intended
  command.

## Tooling dependencies (observed)

Ruby tooling (declared in `Gemfile`):

- Ruby
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
- `build/git/`
  - `commit`: helper used by `build/make/git.mak` to build the conventional-ish
    commit message from `PREFIX`, `msg`, `desc`, or `desc_file`.
  - `optimise`: helper used by `build/make/git.mak` to enable git performance
    settings and run `git gc`.
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

- `.rubocop.yml` defines the Ruby parser/target settings.
- Excludes `vendor/**/*` and also `bin/**/*` (important in downstream repos that vendor this as `./bin`).

## Gotchas

- **Shared helper path expectations**: make fragments derive `BIN_ROOT` from the
  included make fragment's location, then invoke tools through that root.
  - This supports the usual downstream `./bin` checkout and this repository
    root, where the root `Makefile` includes `build/make/ruby.mak` directly.
  - For changes that affect these targets, validate the path logic against both
    direct repository usage and the downstream include model when feasible.

- **`build/docker/env` clones via SSH**: it uses `git clone git@github.com:alexfalkowski/docker.git` into `../docker` if missing (`build/docker/env:14`). Agents without SSH keys/permissions won’t be able to run `make start/stop` paths that depend on it.

- **Coverage helpers assume downstream test layout**:
  - `quality/go/*` reads/writes under `test/reports/`.

- **`build/go/lint` is a no-op if `golangci-lint` isn’t installed** (`build/go/lint:5-7`). Don’t assume lint ran unless the binary exists.

## Intentional design choices

- **`master` is the canonical branch in this repo and its shared fragments**.
  - Hardcoded `master` references in `build/go/clean`, `build/make/git.mak`, `build/make/buf.mak`, and `.circleci/config.yml` are intentional.
  - Do not flag them as bugs unless the task is specifically about making the shared tooling branch-name configurable.

- **`build/make/git.mak` intentionally adds a random suffix to `USER` for branch creation**.
  - This is deliberate to reduce local branch-name collisions.
  - Do not flag it as a bug unless the task is specifically about changing branch naming semantics.

- **Ruby/tooling version skew may be intentional here**.
  - Treat differences between the CI image, local Ruby configuration, and RuboCop target settings as deliberate unless the task is specifically about modernizing CI or Ruby tooling.

## CI signals

`.circleci/config.yml` is the authoritative “what must pass” for this repo:

- Bundler deps are cached under `vendor/`.
- The required checks in CI are:
  - `make scripts-lint`
  - `make docker-lint`
  - `make lint`
  - `make sec`

## When changing this repo

- Prefer the smallest change; these scripts are reused across projects.
- After edits, re-run at least:
  - `make dep`
  - `make lint`
  - `make sec`
  - `make scripts-lint` (if `shellcheck` is available)
  - `make docker-lint` (if `hadolint` is available)
