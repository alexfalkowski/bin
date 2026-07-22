# Gap Lead Generation

Use this reference during scoped gap, issue, documentation, test, reliability,
feature, project, and broad security audits. It improves recall before the
selected skill applies its evidence gate.

## How To Use

1. Classify the requested scope by repository archetype and public surface.
2. Use `comparable-lead-generation.md` when sibling repositories, GitHub owner
   inventory, local checkouts, or external framework checklists would improve
   recall for the requested scope.
3. Build a lead inventory from the matching archetype prompts below and any
   applicable comparable leads.
4. For each lead, choose the owning workflow before investigating deeply.
5. Try to disprove each lead using current code, docs, tests, command behavior,
   CI, generated contracts, and supported usage evidence.
6. Record only leads that satisfy the selected skill's confidence and
   reproduction rules. Report rejected, routed, deferred, and blocked leads in
   closeout so a quiet audit still shows what was checked.

Lead generation finds candidates; it does not lower confidence, ownership,
  reproduction, validation, or implementation gates.
Comparable systems are recall evidence only: do not record a finding merely
because a sibling repository, GitHub inventory item, or external framework has a
pattern the target lacks.

## Repository Archetypes

Use the first matching local evidence: root `Makefile` includes, `AGENTS.md`,
`.circleci/config.yml`, `api/`, `test/features`, `go.mod`, `Gemfile`, Docker or
Pulumi folders, and shipped commands.

### Shared Go Library Or Tool

Common evidence: `include bin/build/make/go.mak`, Go packages at repo root or
under small folders, `make specs`, `make benchmarks`, public exported APIs.

- Code leads: exported compatibility, nil/error behavior, context and
  cancellation, concurrency safety, resource cleanup, boundary/default values,
  parser or encoder behavior, aliases or wrappers that promise more than
  pass-through, examples that imply contracts.
- Test leads: missing edge/error/concurrency coverage for public behavior,
  weak table coverage, benchmarks or fuzz targets that do not protect stated
  behavior, wrong-layer tests around dependency pass-through.
- Reliability leads: unbounded goroutines, timers, workers, retries, queues,
  waits, locks, resource lifetime, repeated start/stop, cleanup after failure.
- Security leads: filesystem paths, process execution, network clients,
  sensitive logs, dependency scanner no-ops, unsafe defaults copied into
  consumers.
- Feature leads: package-consumer ergonomics, supported extension points,
  observable diagnostics, compatibility helpers, safer public options.
- Project leads: Make target coverage, local/CI parity, generated or coverage
  reports, benchmark/fuzz discoverability, optional tool no-op reporting.

### gRPC Or HTTP Service

Common evidence: `include bin/build/make/grpc.mak` or `http.mak`, `api/`,
generated stubs, `internal/api`, `test/features`, service config, Docker
release jobs.

- Code leads: proto and transport drift, generated constants, HTTP-to-gRPC
  route mapping, status/error mapping, request metadata, config decoding,
  validation limits, response defaults, versioned API behavior, DI wiring that
  is observable through a service command or feature.
- Test leads: Ruby feature coverage for public API behavior, stale generated
  test stubs, missing HTTP/gRPC parity checks, weak error-path assertions,
  benchmark scenarios that no longer reflect primary workflows.
- Reliability leads: health/readiness semantics, shutdown/drain, startup with
  dependencies, request deadlines, slow dependency behavior, migration or
  release rollback, Docker image validation, config drift, operator diagnostics.
- Security leads: request size limits, auth or metadata propagation, secret and
  file config handling, database/source URLs, unsafe diagnostics, Docker and
  dependency scans, CI contexts and release credentials.
- Feature leads: user/service-author API capabilities, safer config knobs,
  public diagnostics, documented integration workflows, template capabilities.
- Project leads: proto generation and stale checks, service build/test targets,
  feature harness setup, Docker multi-arch publish path, CircleCI fan-in.

### Infrastructure Or Docker Repository

Common evidence: Pulumi areas, Kubernetes manifests, image directories,
`make/docker.mk`, path-filtered CircleCI, release or manifest jobs.

- Code leads: config-to-resource mapping, generated schema drift, default
  values, naming and selector consistency, release tag construction, build
  context paths, script argument handling.
- Test leads: Pulumi mocks, rendered resource assertions, path-filter coverage,
  build/test image parity, missing negative config cases.
- Reliability leads: rollout ordering, rollback, partial publish, image tag and
  manifest consistency, resource limits, probes, config admission, recovery
  paths, operational diagnostics.
- Security leads: secrets in build contexts or config, broad privileges,
  network policy ownership, Dockerfile hardening, build secrets, release
  credentials, scanner coverage for published artifacts.
- Feature leads: operator or service-author capabilities already aligned with
  the repository's infrastructure model.
- Project leads: path filters, build matrices, image scan gates, local dry-runs,
  command discovery, generated schema checks.

### Ruby Tooling, Gem, Or Static Site

Common evidence: `include bin/build/make/ruby.mak`, root `Gemfile`, Cucumber
features, Ruby scripts, static build commands.

- Code leads: CLI args, process orchestration, filesystem paths, YAML/JSON
  parsing, proxy or server lifecycle, cleanup on failure, public gem API
  behavior.
- Test leads: Cucumber coverage, flaky service/process orchestration, weak
  assertions around proxying or command output, fixture determinism.
- Reliability leads: process start/stop ordering, timeouts, port conflicts,
  cleanup, external service assumptions, generated report preservation.
- Security leads: shell execution, file writes/deletes, temp files, YAML
  loading, credentials in fixtures, dependency scans.
- Feature leads: user-facing command/gem ergonomics, first-use workflows,
  service orchestration capabilities, useful diagnostics.
- Project leads: Bundler setup, lint/security target parity, static build
  validation, artifact/report handling.

### Shared `bin` Tooling

Common evidence: work in this repository or downstream include behavior through
`bin/build/make/*.mak`, `build/`, `quality/`, `skills/`, or reusable scripts.

- Code leads: path derivation through `BIN_ROOT`, downstream include behavior,
  shell quoting, optional tool no-ops, report paths, generated or vendored
  exclusions, command help comments.
- Test leads: missing downstream-style validation, scripts not covered by
  ShellCheck, skill lint gaps, wrong harness for Make/shell behavior.
- Reliability leads: start/stop cloning behavior, cache/report cleanup,
  network/SSH assumptions, release helper ordering, tool availability
  classification.
- Security leads: shared script inputs reaching shell, filesystem, network,
  Docker, secrets, auth contexts, remote writes, or skill metadata.
- Feature leads: downstream shared-tooling capability, safer defaults,
  reusable extension points, discoverability that improves package consumers.
- Project leads: common Make targets, CI-equivalent preflight, lint/security
  wrappers, local/CI parity, command discovery, submodule bootstrap.

## Lead Accounting

Before no-finding or incomplete closeout, include compact accounting:

- `Confirmed`: leads recorded in the selected ledger or audit output.
- `Rejected`: leads checked and dismissed, with the authoritative surface or
  evidence that disproved them.
- `Routed`: leads belonging to another skill or repository, with the owner.
- `Deferred`: exact follow-up scopes that were not reviewed deeply.
- `Blocked`: leads blocked by missing tools, credentials, services, sandbox,
  or ambiguous setup.

When comparable lead generation was used or skipped, include the GitHub owner,
matched local checkouts, comparable repositories, external frameworks, and any
blocked inventory or checkout-mapping steps in the accounting.

Rejected and routed leads should be brief, but they must be specific enough for
a later reviewer to understand why the audit did not record them.
