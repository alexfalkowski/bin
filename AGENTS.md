# AGENTS.md

## Repository purpose

This repository is a collection of shared **executables** and **Makefile
includes** reused across projects as a Git submodule mounted at `./bin`. See
`README.md`.

Most of the code here is small Bash/Ruby utilities plus reusable make fragments under `build/make/`.

## Non-negotiable agent rules

The instructions in this file and the selected `skills/**/SKILL.md` files are
mandatory operating rules, not advisory guidance. Agents MUST follow them
before applying personal judgment.

Agents MUST:

- Read and follow the smallest matching skill before taking task action.
- Treat sub-agents as usable only when the active runtime provides them and the
  current user request explicitly asks for sub-agents, delegation, or parallel
  agent work. When sub-agents are authorized, use them for delegation, parallel
  review, forward-testing, independent validation, read-only exploration, or
  disjoint implementation work whenever they can materially improve coverage,
  confidence, throughput, or implementation safety. When the selected skill
  requires delegation, parallel review, or forward-testing, do not treat that
  required use as optional based on scope size, convenience, or local
  confidence.
- At the delegation gate, continue locally only when the selected skill does not
  require delegation and the required confidence threshold can still be met.
  Otherwise stop: if the current request does not authorize sub-agents, ask for
  explicit current-request sub-agent authorization; if authorized sub-agents are
  unavailable, forbidden, or denied by the runtime, state the blocked delegation
  requirement plus the runtime limitation. Do not offer a local-only pass as
  equivalent, as the default next step, or as acceptable merely because the
  repository looks small.
- Report an explicit confidence percentage before treating any result, finding,
  validation conclusion, or task as accepted or complete. Default minimum is
  90%; require 95% for high-risk acceptance: security findings, destructive
  actions, public-interface or compatibility conclusions, release or PR
  readiness, CI/deployment root-cause conclusions, broad no-findings claims, and
  claims that a problem is definitely fixed. Back every number with concrete
  evidence — source inspection, tests, logs, scanner output, official
  documentation, runtime behavior, or repository history. Below the required
  threshold, gather more evidence or state the blocker instead of accepting
  completion.
- For ledger findings and validation conclusions, prefer reproducible local
  evidence from the smallest supported command, test, scenario, trace, lookup,
  or negative search that demonstrates the claim. CI running later is not
  reproduction evidence unless a current CI result or equivalent
  repository-defined command has been observed and classified.
- Before accepting confidence at or above the required threshold, perform a
  challenge pass. Material unresolved questions, alternate owners, unsupported
  paths, or counterexamples must lower confidence; questions already answered by
  inspected evidence must not.
- Calibrate durable findings against supported usage evidence. In reusable
  libraries, helpers, or shared tooling, package-local synthetic tests, fakes,
  manual construction, and unsupported downstream patterns are leads, not enough
  evidence for a >=90% finding by themselves. Before recording a high-confidence
  issue, inspect a supported consumer, executable example, integration test,
  module wiring path, documented contract, CI workflow, or comparable real usage
  path that can trigger the candidate. If supported usage evidence cannot be
  found, lower confidence below the recording threshold, route the concern to
  the correct workflow, or state the evidence gap instead of recording it.
- Route findings about third-party libraries, frameworks, tools, or project-owned
  upstream libraries to the owner of the fix. Use `project-gaps` only for the
  repository-owned dependency/tooling response; route project-owned upstream
  library bugs to that library's agent or ledger unless local adapter behavior is
  independently wrong.
- Treat unowned working-tree changes as human changes by default. Do not undo,
  overwrite, reformat, relocate, or "clean up" changes the agent did not make;
  if they affect the current task, explain the conflict and ask before editing
  them.
- When reviewing, auditing, or incidentally noticing an issue outside the
  current explicitly approved implementation scope, validate the candidate
  against repository evidence and present the proposed fix before editing. When
  more than one credible fix exists, compare the practical options and evidence
  instead of implementing a self-selected design.
- Follow existing repository patterns over personal judgment.
- Treat skill workflow steps using "must", "do not", or "stop" language as
  blocking requirements.
- Stop and ask before deviating from a selected skill, repository instruction,
  dominant test harness, local style, or documented workflow, and state the
  exact instruction being deviated from before proposing any deviation.
- Treat a checklist item the agent itself declared (for example "TDD decision:
  scenario-first") as a binding commitment. If it cannot be honored, STOP at that
  item and flag the deviation before continuing; silence is a violation.
- Re-read the selected skill and identify the governing instruction when the
  human challenges process, asks what the skill says, or points out a suspected
  instruction violation.

Agents MUST NOT:

- Add tests in a different layer after the selected skill says to inspect and
  follow the dominant relevant harness.
- Add cryptic tests that only prove internal call order, implementation timing,
  provider wiring, or third-party behavior when no observable repository-owned
  contract changes.
- Introduce import aliases, abstractions, helpers, files, or validation paths
  for personal clarity when local patterns already exist.
- Start edits for review findings, audit findings, incidental discoveries, or
  adjacent issues before the human approves what will change. When multiple
  credible approaches exist, present the options and evidence first. This gate
  is waived only when the current request explicitly says not to use it or
  grants free-form implementation authority for that scope.
- Treat `AGENTS.md` or `SKILL.md` instructions as optional.
- Continue after discovering they violated an instruction; they must correct
  course immediately and remove their own noncompliant change.
- Report `Red`, `Green`, `Refactor`, or any TDD cycle without pasting the actual
  command and its output; never narrate end-of-run debugging of already-written
  code as a red-then-green cycle.
- Present work as test-driven when the failing test was never observed before
  implementation; label such work "test-after (not TDD)" with the reason.

If there is a conflict, precedence is:

1. System/developer instructions.
2. The consuming repository's `AGENTS.md`.
3. This shared `bin/AGENTS.md`.
4. The selected `skills/**/SKILL.md`.
5. Existing local code, test, docs, and workflow patterns.
6. Agent judgment.

## Local pattern binding

Before editing, agents MUST inspect nearby files and the relevant test,
configuration, documentation, and validation surfaces. Agents MUST preserve
local import, naming, file layout, configuration key, test-layer, and validation
patterns unless the task explicitly requires changing them.

Do not introduce import aliases, new helper layers, new test layers, or new
validation paths merely to avoid ambiguity. Use the existing local style. If the
existing style appears unsafe or insufficient, stop and ask before changing it.

## Shared skills

Use the smallest matching skill in `skills/`; do not use a broad default when a
focused skill applies.

- `project-workflow`: project discovery, command surfaces, CI, and `./bin`
  wiring.
- `change-safety`: compatibility, documented interfaces, migrations, generated
  files, dependencies, and security-sensitive edits.
- `change-validation`: test, lint, CI, security, benchmark, and validation
  selection.
- `testing-standards`: test design, coverage, fixtures, determinism, and
  test-layer guidance.
- `doc-standards`: README, docs, examples, command/config docs, public API
  comments, docstrings, and stale-doc review.
- `api-standards`: gRPC, Protocol Buffer, REST, HTTP/JSON, generated client,
  public schema, resource, method, versioning, and API compatibility guidance.
- `naming-standards`: domain clarity, public terminology, abstraction level,
  consistency, and rename safety.
- `code-review`: bug, regression, risk, and missing-coverage findings.
- `style-review`: optional non-blocking readability, consistency, idiom, and
  polish suggestions.
- `security-audit`: vulnerability checks plus unsafe shell, filesystem,
  network, auth, Go, Ruby, and shell inspection.
- `code-issues`: confirmed code issues in `ISSUES.md`; fix one agreed issue at a
  time.
- `test-gaps`: confirmed test gaps in `TESTS.md`; fix one agreed gap at a time.
- `doc-gaps`: one-pass documentation gap finding and fixing; use `DOCS.md` only
  for audit-only requests or unresolved gaps.
- `feature-gaps`: concrete product-facing opportunities in `FEATURES.md`; fix
  one agreed feature at a time.
- `project-gaps`: build, CI, Makefile, release, setup, validation, command
  discovery, and workflow opportunities in `PROJECTS.md`; fix one agreed gap at
  a time.
- `reliability-standards`: SRE, NALSD, production readiness, SLOs, overload,
  observability, release safety, recovery, and operability.
- `reliability-gaps`: confirmed reliability gaps in `RELIABILITY.md`; fix one
  agreed gap at a time.
- `repo-health`: delivery, CI quality, release/deploy, and service reliability
  summaries from GitHub, CircleCI, Kubernetes/DigitalOcean, and UptimeRobot.
- `diagnose-issue`: read-only diagnosis of selected CI, deploy, rollout,
  runtime, monitor, or latest-version failures.
- `review-pr`: commit, force-push, and open a draft PR with a generated summary.
- `shell-standards`: Bash scripting, ShellCheck, text processing, directory
  scope, and function documentation.
- `go-standards`: Go API, documentation, import, naming, and testing
  conventions for repos using this tooling.
- `ruby-standards`: Ruby API, documentation, naming, style, and validation
  conventions for repos using this tooling.

Treat this `AGENTS.md` as the repo-specific companion to those skills.

## Remembered workflow commands

Treat these short commands as binding workflow shorthands, not casual prose.
They select the matching skill and its gates before any edits. Supported gap
IDs include `FEATURE-*`, `ISSUE-*`, `TEST-*`, `DOC-*`, `PROJECT-*`, and
`RELIABILITY-*`; route each ID to the matching gap skill and ledger.

Three verbs carry the workflow, and each takes the same optional tail. `Start`
begins the workflow, `Approved` accepts the presented solution, and `Done`
confirms an entry is verified. After any verb, name the ID, add
`in path/LEDGER.md` when the ID is ambiguous, then add `with agents`,
`with a goal`, or `with agents and a goal` to authorize sub-agents, a runtime
goal, or both. On `Done`, the tail carries that authorization to the next entry.

- `Start FEATURE-3 in path/FEATURES.md`: select the matching gap skill from the
  ID prefix, refresh evidence, present the solution, and stop at the agreement
  gate before editing. Apply the same shape to other ledgers, such as
  `Start ISSUE-3 in path/ISSUES.md` or `Start TEST-3 in path/TESTS.md`.
- `Start FEATURE-3 with agents`: same as `Start`, plus explicit current-request
  authorization to use sub-agents when they materially improve coverage,
  throughput, implementation safety, or fresh review. Apply the same shape to
  other ledger IDs.
- `Start FEATURE-3 with a goal`: same as `Start`, plus explicit current-request
  authorization to use a runtime goal when goals are available and useful.
  Apply the same shape to other ledger IDs.
- `Start FEATURE-3 with agents and a goal`: explicit authorization for both
  sub-agents and a runtime goal. Ranges also work, such as
  `Start FEATURE-3/4/5 with agents and a goal`.
- `Approved FEATURE-3`: approve the presented solution for that entry and allow
  the selected skill to implement it through its validation and review gates.
- `Approved FEATURE-3 with agents`: same as `Approved FEATURE-3`, plus explicit
  current-request authorization to use sub-agents during implementation and
  fresh review when they can work on disjoint slices, validation support, or
  independent review without bypassing the selected skill's gates. The
  `with a goal` and `with agents and a goal` tails apply here too.
- `Done FEATURE-3`: confirm the presented entry is verified and complete; the
  selected skill drops or revises that entry and continues with the next. The
  tail carries forward — `Done FEATURE-3 with agents` authorizes sub-agents for
  the next entry, and `with a goal` / `with agents and a goal` apply too.

These commands are shorthand only. They do not bypass solution agreement,
scoped ledger rules, validation freshness, confidence thresholds, remote-write
permission, or the selected skill's output format.

## Skill workflow mechanics

Stateful gap and review workflows may include `references/plan.md`; those files
are templates for runtime execution state, not durable project artifacts.
Shared workflow mechanics live in `skills/references/gap-workflow.md`. For
substantial, ambiguous, or multi-iteration work, use
`skills/references/long-running-work.md` as a compact runtime-state pattern for
research, blocking questions, thin slices, validation, and fresh review.

Use runtime goals only when the human explicitly requests them or
higher-priority runtime instructions allow goal creation for the selected
workflow. Otherwise maintain stateful workflow progress in the conversation or
tool plan. Goals do not bypass skill steps, stop gates, permission gates,
scoped ledgers, human confirmation requirements, or validation freshness rules.

When a skill owns the final response, use that skill's required output format.
When a skill is embedded by another skill, preserve its concrete facts and use
the caller's output format.

Use `testing-standards` before adding, reviewing, refactoring, or planning
tests. Inspect the dominant relevant harness, test observable
repository-owned behavior through public or documented surfaces, keep tests
readable and deterministic, and avoid coverage theater.

Before running commands that require SSH credentials, GitHub auth, registry
auth, cloning, fetching large dependencies, pushing, publishing, opening PRs, or
updating remote state, make the requirement explicit and get permission. Treat
network, credential, shell, `PATH`, and missing-tool failures as environment or
validation gaps unless repository evidence proves otherwise.

When a downstream repo reads this repository as `./bin`, treat `bin/` as
vendored shared tooling:

- Read `bin/AGENTS.md` and the relevant `bin/skills/**` files when shared
  guidance is needed.
- Do not search, read, edit, or review other files under `bin/**` unless the
  task is explicitly about shared `bin` tooling, Makefile includes, skills, or
  submodule wiring.
- Search consuming repositories with unrelated submodule content excluded, for
  example `rg --glob '!bin/**' ...`.
- Reason about shared Make behavior from the consuming repository root.
- Remember that make fragments derive helper paths from their include location
  through `BIN_ROOT`.

## Downstream repository defaults

Apply these defaults only when a consuming repository has matching local
evidence such as `.gitmodules`, a root `Makefile`, `.circleci/config.yml`,
`test/`, or `test/nonnative.yml`. The consuming repository's own `AGENTS.md`
remains higher precedence when it gives more specific guidance.

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

### Shared service health defaults

- Services using the shared health wiring can intentionally connect `healthz`
  to an `online` check that verifies external connectivity. Do not flag that as
  a reliability gap unless the task concerns changing the health contract,
  environments that must run without public egress, or a documented operator
  workflow where `healthz` must mean local-process-only health.

## Skill composition

- `review-pr`: compose `project-workflow`, `change-validation`, relevant
  language standards, `doc-standards`, `code-review`, summary drafting,
  optional explicit `style-review`, and the review target.
- `code-issues`: aggregate confirmed `project-workflow`, `code-review`, and
  `security-audit` findings into `ISSUES.md`; fix one agreed code issue at a
  time.
- `test-gaps`: aggregate confirmed `project-workflow` context and missing or
  weak coverage into `TESTS.md`; fix one agreed test gap at a time.
- `doc-gaps`: combine `project-workflow` context with `doc-standards`; fix
  confirmed doc gaps in one pass, and use `DOCS.md` only for audit-only
  requests or unresolved gaps.
- `feature-gaps`: aggregate product-facing opportunities into `FEATURES.md`;
  route standalone test, CI, build, Makefile, release, validation, command
  discovery, and workflow concerns to `test-gaps` or `project-gaps`.
- `project-gaps`: aggregate build, CI, Makefile, release, setup, validation,
  command discovery, and workflow opportunities into `PROJECTS.md`; fix one
  agreed project gap at a time.
- `reliability-gaps`: aggregate SRE, NALSD, operability, overload,
  observability, release-safety, recovery, or data-integrity gaps into
  `RELIABILITY.md`; fix one agreed reliability gap at a time.
- `repo-health`: pair with `project-workflow`; add `change-validation` only when
  the summary process changes files or validation commands need selection.
- `diagnose-issue`: keep diagnosis read-only; pair with `change-validation`
  only when implementing a suggested fix.
- `code-review`: consult `security-audit` for security-sensitive scope while
  keeping the review findings format.
- `style-review`: run only when explicitly requested; do not use it instead of
  bug, security, compatibility, test-gap, or doc-gap review.
- `security-audit`: pair with `change-safety` for code changes and
  `change-validation` for scanner, lint, or CI command selection.
- `testing-standards`: pair with language standards for test idioms and
  `change-validation` for command selection; own test-harness/support-code
  improvements that primarily affect test correctness, maintainability,
  determinism, configurability, or layering.
- `doc-standards`: pair with language standards for API comments and docstrings,
  `naming-standards` for terminology, `change-safety` for documented contract
  changes, and `change-validation` for docs-related validation.
- `api-standards`: pair with `go-standards` or `ruby-standards` for API
  implementation code, `naming-standards` for resource/method/field names,
  `doc-standards` for API docs and comments, `testing-standards` for API
  coverage, `change-safety` for versioning and compatibility, and
  `change-validation` for generated-contract and repository checks.
- `reliability-standards`: pair with `change-safety`, `security-audit`,
  `testing-standards`, and `change-validation` for production-readiness, SLO,
  overload, observability, release-safety, recovery, or operability changes.
- `naming-standards`: pair with language standards when creating, reviewing, or
  renaming identifiers, commands, flags, files, tests, fixtures, or
  documentation terms.
- `project-workflow`: own command discovery, CI expectations, downstream
  `./bin` wiring, and shared Makefile fragment behavior.
- `project-gaps`: own build, CI, Makefile, release, setup, validation, command
  discovery, and repository workflow gaps.
- `change-validation`: use `project-workflow` context before selecting
  validation commands for orchestrated workflows.

## Test harness selection

- Do not infer the test language from the implementation language. Before
  recommending, adding, or reviewing tests, inspect the relevant Makefile
  targets, CI jobs, existing tests, fixtures, and harness directories (`test/`,
  `features/`, `spec/`, `*_test.go`, etc.).
- Follow the majority pattern of the relevant existing tests for the behavior,
  even when that means testing one implementation language from another
  language or harness. For example, a Go service can be tested mostly through
  Ruby features, and Ruby code can be tested mostly through another harness.
- Add language-native tests only when that is the majority relevant local
  pattern, the changed surface is a language-level package/API contract, or the
  user explicitly asks for that level of coverage. If there is no clear
  majority relevant pattern, use the repository-defined Make/CI entrypoint that
  owns the behavior and state the uncertainty.

## Command execution policy

- Treat this repository's Makefile, reusable make fragments, and CircleCI config
  as the source of truth for setup, lint, test, security, benchmark, and review
  commands.
- Run commands from the repository root unless the Makefile, script, or task
  explicitly requires another working directory.
- Prefer `make` targets and documented entrypoints over direct tool
  invocations, even when a direct command appears equivalent.
- For code and test changes, run the narrowest supported fast-feedback selector
  in the dominant harness first, such as a package, file, scenario, example,
  focus tag, test name, command, or documented entrypoint. Do not use speed as
  a reason to bypass the repository-defined harness, skip required setup, or
  test a private surface.
- Show command discovery with `make` or `make help`.
- Use `make dep` for Ruby dependency setup before checks that need installed
  gems or vendor state.
- Use CI-equivalent validation from `.circleci/config.yml`: `make dep`, `make
  clean-dep`, `make scripts-lint`, `make skills-lint`, `make docker-lint`,
  `make lint`, and `make sec`.
- Use `make scripts-lint` for shell script changes, `make skills-lint` for
  skill or agent-policy changes, `make docker-lint` for Dockerfile changes,
  `make lint` for Ruby linting, and `make sec` for security-sensitive changes.
- Use `make fix-lint` or `make format` only when applying supported local
  formatting or lint fixes.
- Only rely on external CLIs when the relevant `.mak` file or script invokes
  them.
- Before any selected skill runs, retries, replaces, or recommends a command,
  establish the repository command surface and execution environment.

### Tool shell environment

- Before reporting repository command failure, establish the command surface and
  execution environment: repository root, documented entrypoint, CI analogue,
  initialized user shell, and macOS/Homebrew tool-path assumptions.
- Use the user's configured shell environment. If a command fails because a tool
  is missing, an old version is found, or `PATH` differs from the user's normal
  terminal, report an environment mismatch or validation gap, not a repository
  failure.
- In Codex/tool shells, compare `ruby` and `make` resolution with
  `zsh -lic 'command -v ruby; command -v make'` before reporting repository
  command failures.
- If resolution differs, rerun Make targets through the initialized shell before
  treating the failure as real.
- After a repository-defined command, Make target, dominant test harness, or
  skill-required workflow fails, do not switch to an ad hoc command, different
  validation layer, or alternate workflow merely to make progress. Classify the
  failure first using the repository's validation categories, then retry only
  through the initialized-shell or approved escalation path, or report the
  blocker.
- Do not invent direct commands, bypass Make targets, install alternate tools,
  replace a Makefile target, or keep retrying variants merely to get something
  to run in the agent environment.
- When diagnosing environment mismatches, check the command surface first, then
  inspect `command -v <tool>`, `<tool> --version`, `SHELL`, and `PATH`.
- In this repository and downstream repos that vendor it as `./bin`, keep
  `make` targets as the intended validation interface when the agent
  environment differs from the user's normal shell.

## Local contracts

- Public shared surfaces live in `build/make/`, `build/docker/`, `build/go/`,
  `build/git/`, `build/sec/`, `build/claude/`, `quality/`, and `skills/`;
  inspect the relevant files before editing.
- Preserve formatting from `.editorconfig`, Ruby settings from `.rubocop.yml`,
  and nearby Bash/Ruby style. Do not duplicate those config files here.
- Make fragments derive `BIN_ROOT` from their include location. For path-related
  changes, validate direct use in this repository and downstream `./bin`
  include behavior when feasible.
- `build/docker/env` clones or updates `git@github.com:alexfalkowski/docker.git`
  in sibling `../docker`; `make start` and `make stop` paths can require SSH and
  network access.
- `quality/go/*` helpers read and write under `test/reports/`; preserve that
  downstream test-report contract.
- `build/go/lint` is a no-op unless `golangci-lint` exists in `PATH`; do not
  report full lint coverage unless the binary ran.
- `master` is the canonical branch in this repo and shared fragments. Hardcoded
  `master` references in `build/go/clean`, `build/make/git.mak`,
  `build/make/buf.mak`, and `.circleci/config.yml` are intentional.
- `build/make/git.mak` intentionally adds a random suffix to `USER` for branch
  creation to reduce local branch-name collisions.
- Treat Ruby/tooling version skew as intentional, including differences between
  the CI image, local Ruby configuration, and RuboCop target settings, unless
  the task explicitly modernizes CI or Ruby tooling.
- Do not flag the intentional contracts above as bugs unless the task is
  specifically about changing that contract.

## When changing this repo

- Prefer the smallest compatible change; these scripts are reused across
  projects.
- Update existing docs and examples when public commands, APIs, Make targets,
  environment variables, file formats, output shapes, or operator-facing
  behavior change.
- Update `skills/<name>/agents/openai.yaml` when a skill's trigger, scope,
  workflow, display name, short description, default prompt, or user-facing
  behavior changes.
- Keep skills tool-agnostic. `skills/<name>/SKILL.md` is shared by Codex and
  Claude Code, so do not hardcode a single assistant; where attribution or
  invocation differs, cover both. `build/codex/init` (via `make codex-init`)
  wires Codex by symlinking `.agents/skills` to `skills/`, `.codex/config.toml`
  to the shared permission profile, and `.codex/rules/bin.rules` to the shared
  host-execution guardrails; repo-owned real config and rule files are left
  untouched. The project must be trusted before Codex loads project config and
  rules, and permission profiles require Codex 0.138.0 or later. The shared
  profile makes workspace `.git` metadata writable for routine staging and
  commits, grants write access to the standard Go, RuboCop, and Trivy caches plus
  the macOS golangci-lint cache, grants read-only access to common host credential
  locations, and allows outbound internet access. The shared rules allow `make
  specs`, `make features`, `make coverage`, `make fuzzes`, and `make benchmarks`
  to run outside the sandbox without prompting. Use the profile only in trusted
  repositories
  because sandboxed commands can transmit readable credentials and host-allowed
  Make targets inherit the user's access. Remote and destructive Git operations
  remain governed by the shared rules and explicit workflow permission gates.
  Per-machine additions belong in `~/.codex/config.toml` and `~/.codex/rules/`.
  `build/claude/init` (via `make claude-init`)
  wires Claude Code by symlinking `.claude/skills` to `skills/`, symlinking
  `.claude/settings.json` to the shared `build/claude/settings.json`
  permissions baseline (unless the repo owns a real, non-symlink
  `settings.json`), and importing `AGENTS.md` from `CLAUDE.md`; the symlinks
  target shared paths, so updating skills or the permissions baseline needs no
  downstream re-wiring, only a `git submodule update`. Per-repo or per-machine
  permission tweaks belong in the gitignored `.claude/settings.local.json`,
  which Claude Code merges over the baseline.
- Treat skills as maintained artifacts and review them when project workflow,
  tooling, model behavior, or team conventions change.
- Treat external skills like third-party dependencies. Use `security-audit` with
  `skills/references/skills.md` for skill-specific security review.
- After edits, run the narrowest repository-defined checks that cover the
  changed files, then expand to CI-equivalent targets when risk justifies it.
