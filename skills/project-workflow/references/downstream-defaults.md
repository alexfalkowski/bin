# Downstream Repository Defaults

Apply these defaults only when a consuming repository has matching local
evidence such as `.gitmodules`, a root `Makefile`, `.circleci/config.yml`,
`test/`, or `test/nonnative.yml`. The consuming repository's own
`AGENTS.md` remains higher precedence when it gives more specific guidance.

### Shared skill discovery

- Repositories mounted at `./bin` use shared skills from `bin/skills/`.
- Read `bin/AGENTS.md` for the canonical shared skill list.
- Use the smallest matching skill for the task.
- A consuming root `AGENTS.md` only needs to make this shared file
  discoverable; keep the canonical skill list and shared defaults here.
- Do not flag absent, thin, or pointer-only consuming `AGENTS.md` files as
  project workflow gaps unless the gap rule below applies.
- Raise an agent-guidance gap only when repository-specific workflow policy is
  missing and cannot be inferred from `Makefile`, CI, README, and this file, or
  when the task explicitly concerns repository agent onboarding.

### Bin submodule bootstrap

- Treat `path = bin` with URL `git@github.com:alexfalkowski/bin.git` as the
  intentional default.
- Use this raw bootstrap command before Makefile-provided targets can load:

  ```sh
  git submodule sync && git submodule update --init
  ```

- Use `make submodule` only after the shared `bin/` checkout is present; it is
  provided by `bin/build/make/git.mak`.
- Treat root `Makefile`s that directly include `bin/build/make/*.mak` as
  intentional thin wrappers.
- Do not flag missing root-owned bootstrap shims, no-submodule `make submodule`
  fallbacks, or the SSH submodule URL unless the repository has explicitly
  decided to own those contracts differently.

### Shared Make ownership

- Use root `make` targets as the preferred command surface.
- Document Makefile targets in consuming `AGENTS.md` files; do not recommend
  repeatable standalone language, tool, or helper commands that bypass Make.
- Use direct commands only for narrow diagnosis, local inspection, or a one-off
  gap unless the consuming repository explicitly owns them outside Make.
- Treat a useful repeated command missing from the Makefile surface as a shared
  tooling gap; add or improve the relevant `bin` Make target before copying the
  command into multiple consuming repositories.
- Add one-command local CI preflight targets to shared `bin` Make fragments, not
  service-local Makefiles.
- Do not flag the absence of a root `verify` or `ci-checks` target unless the
  consuming repository explicitly owns one or current workflow evidence shows
  the missing target breaks users.
- Treat shared Make fragments as GNU Make 4+; use `gmake` on macOS when
  `/usr/bin/make` cannot parse them.
- Do not flag GNU Make 3.81 parsing failures unless the task is explicitly
  about legacy make compatibility in shared `bin` tooling.
- Treat `make start` and `make stop` as potentially network/SSH-affecting:
  shared helpers can call `bin/build/docker/env`, which clones or updates
  sibling `../docker` over SSH and delegates there.

### Common downstream targets

Always inspect the consuming root `Makefile`; included fragments determine
which targets exist. Common names are:

- Discovery/bootstrap: `make`, `make help`, `make submodule`.
- Dependencies and quality: `make dep`, `make lint`, `make fix-lint`,
  `make format`, `make sec`.
- Tests and reports: `make specs`, `make features`, `make benchmarks`,
  `make coverage`.
- Service/tool workflow: `make build`, `make build-test`, `make dev`,
  `make start`, `make stop`.
- Protobuf/Buf workflow: `make proto-lint`, `make proto-format`,
  `make proto-generate`, `make proto-stale`, `make proto-breaking`,
  `make proto-push`.

Do not assume a common target exists until the consuming Makefile exposes it.
Prefer exposed root targets over direct harness commands unless the consuming
repository says otherwise.

Target-specific rules:

- The shared Go lint wrapper runs `golangci-lint` only when the binary is in
  `PATH`; do not flag the local no-op unless CI lacks the tool, the task is
  about strict local lint parity, or the repository decided missing local
  `golangci-lint` must fail.
- `proto-push` updates remote state and requires explicit current-request
  permission.
- `proto-breaking` derives the GitHub repository name from the checkout
  directory basename. Do not require a local `NAME := <repo>` override for
  canonical checkouts.
- `proto-breaking` compares against remote GitHub `master`, and Buf generation
  can require remote plugins or a warm plugin cache. Do not flag the network
  requirement or lack of offline protobuf validation unless offline validation
  is documented as supported or current CI/developer workflows are broken.
- Shared `git.mak` targets expose branch, commit, PR, push, reset, purge, and
  stash helpers for maintainers. Do not flag their presence, discoverability,
  destructive potential, or remote-write capability unless there is concrete
  accidental-use evidence, broken guarded push behavior, or an explicit request
  to change the shared git workflow.

### Release and deployment workflow

- Treat CircleCI `version` jobs that run external `package` from
  `alexfalkowski/release` or `alexfalkowski/docker/release` as owning
  GoReleaser config validation. Do not require a separate local GoReleaser
  validation job without evidence that the release image stopped validating
  `.goreleaser.yml` or an explicit repository decision to own pre-release
  checks locally.
- Treat non-`master` Docker image validation as sufficient before the master
  `version` or `package` release step. Do not require master-branch
  `test-docker-*` gating without current release breakage or an explicit local
  gate decision.
- When `manifest-docker` is serialized to prevent overlapping `latest` updates,
  treat versioned image tags as the deployment contract. Raise ordering risk
  only for `latest` consumers, unpinned image deployment, versioned tag
  overwrite, partial versioned artifact publication, or release/deploy contract
  changes.
- For services deployed through `alexfalkowski/infraops/area/apps`, treat
  deployment ordering and desired state as owned there. Do not require a
  CircleCI deploy-job `serial-group` unless the task concerns deployment
  ordering, current deploy races exist, or the repository chose local deploy
  serialization.
- Do not require an extra repository-local pre-publish container startup smoke
  test when the service already runs repository-owned Docker image validation
  and deploys through the external release/deployment path. Raise that gap only
  with concrete release breakage, a missing deployment startup/readiness gate,
  or an explicit local smoke-check decision.

### CircleCI workflow conventions

- Treat CircleCI as the primary CI source of truth unless the consuming
  `AGENTS.md` or task states otherwise.
- Do not require equivalent GitHub Actions validation when `.circleci/` defines
  the build, test, security, release, or deploy path.
- Do not flag `wait-all` fan-in jobs that list branch-filtered jobs such as
  non-`master` `sync` or master-only `version`; CircleCI ignores filtered-out
  required jobs.
- Do not propose split branch-specific wait jobs without evidence that required
  checks are missing or blocked.
- Treat non-`master` `make sync push` jobs as intentional CI-managed branch
  synchronization after validation. Do not flag missing `serial-group` on
  `sync` or guarded force-push behavior without branch update races, workflow
  design lease failures, or a repository decision to stop CI-managed sync.
- Treat `.source-key` as a generated, ignored cache input from `make
  source-key`; do not commit it. Do not require `.source-key` in dependency
  cache keys when dependency lockfiles and language/tool versions key the cache.
- Treat `make codecov-upload` as CI upload behavior, not read-only local
  validation. Do not require local dry-run wrappers unless the task concerns
  coverage publication or concrete upload failures.
- Treat repeated `make clean` around dependency restore/install, lint, specs,
  and coverage as intentional shared Go cache hygiene unless measured CI cost or
  concrete cache corruption proves otherwise.
- When Dependabot has a `gitsubmodule` update for dependency `bin`, treat shared
  submodule update discovery as owned. Do not require another scheduler,
  workflow, or Make wrapper without evidence that Dependabot is not opening
  expected updates.
- For path-filtered repositories such as `docker` and `infraops`, treat the
  CircleCI setup workflow plus `.circleci/continue_config.yml` as owning
  area-specific validation. Do not require one all-repository build job when
  path filtering maps changes to the relevant image, area, or Pulumi workflow.

### Ruby feature and benchmark harnesses

- Treat Ruby code under `test/` as a local feature or benchmark harness unless
  repository evidence says it is production code.
- Treat Ruby runtime selection for that harness as owned by the shared CI image
  and shared Ruby Make wiring. Do not require repository-local `.ruby-version`,
  `.tool-versions`, `mise.toml`, or Gemfile `ruby` directives without workflow
  breakage or an explicit local runtime-ownership decision.
- Treat fixed localhost endpoints in `test/lib/**`, `test/nonnative.yml`,
  `test/.config/**`, and related feature helpers as intentional local harness
  assumptions unless current workflow breakage proves otherwise.
- Use root `make features` and `make benchmarks` as supported integration and
  benchmark entrypoints when they exist; they can build the correct binary
  before delegating into `test/`.
- Do not treat direct `make -C test ...` targets as default workflow unless the
  consuming repository says so.
- Cucumber feature and benchmark runs set `COVERAGE_NAME` to `features` and
  `benchmarks`. Use that in `test/.config/cucumber.yml` only when Cucumber HTML
  is a durable CI artifact.
- Do not flag a single shared HTML report path when JUnit XML reports and
  coverage files are the durable CI artifacts.
- Treat CircleCI `store_artifacts` and `store_test_results` as special steps
  that already run after prior step failure. Do not require `when: always`
  around them or move them merely because they follow validation commands.
- Raise report/artifact upload gaps only with evidence that configured upload
  steps, paths, job timeouts, cancellations, or documented CI artifact contracts
  fail to preserve required diagnostics.
- Do not flag generated files under `test/reports` merely because validation
  targets do not automatically run `make clean-reports`; CI uses fresh
  workspaces and local users have an explicit cleanup target.

### Containerized Go-service defaults

- For containerized `go-service` applications, standalone `validate-config`,
  `check-config`, `server --check-config`, Make, or CI configuration validators
  are not desired by default. Runtime configuration is validated during normal
  server startup.
- Schema-only checks provide little value because they cannot validate
  referenced secrets, certificates, policies, migration sources, database URLs,
  dependencies, or deployment readiness.
- Do not report the absence of a standalone configuration validator as a gap
  without a supported non-container consumer, observed failure, or explicit
  project decision.

### Shared service health defaults

- Services using the shared health wiring can intentionally connect `healthz`
  to an `online` check that verifies external connectivity. Do not flag that as
  a reliability gap unless the task concerns changing the health contract,
  environments that must run without public egress, or a documented operator
  workflow where `healthz` must mean local-process-only health.
