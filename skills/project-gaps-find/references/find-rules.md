# Project-Gap Find Rules

These rules remain mandatory:

- Read `../../project-gaps-implement/ledger.yaml` and use its resolved scoped path as the proposal ledger.
- Classify every candidate's implementation home before recording it. Use:
  `current repo` when the requested scope owns the fix; `shared bin` when
  reusable `bin` tooling owns the fix; `external repo` when another repository,
  image, third-party dependency, tool, or project-owned upstream library owns
  the invoked command, script, CI job, release behavior, or underlying defect;
  and `mixed` only when a small local adapter plus an owning upstream change are
  both necessary.
- Treat third-party library, framework, tool, and image defects as project
  workflow candidates only for the repository-owned response. The upstream
  defect itself is not a normal scoped ledger entry for the current scope.
- Before assigning review agents or starting local review, build a recursive
  scope inventory for the requested package or folder: relevant file count,
  first-level subfolders, nested packages, dominant languages, Makefiles, CI
  config, scripts, validation entrypoints, release/deploy/versioning surfaces,
  setup flows, command discovery surfaces, generated/vendor/build/cache
  exclusions, tests, docs, examples, and likely project workflow extension
  points.
- Prefer slices based on repository-owned project workflow value: Make targets
  and fragments, CI jobs, setup and dependency installation, validation and
  local preflight, release/versioning/publishing paths, reusable scripts,
  command discovery/help entrypoints, downstream `./bin` wiring, and changed or
  recently touched project tooling.
- For delegated review, each assigned agent owns recursive review only within
  its bounded slice. Each agent must perform project-gap discovery for that
  slice, pairing with
  `$project-workflow`, `$change-safety`, `$change-validation`, relevant
  language standards, and `$testing-standards` only when needed to route
  test-surface concerns correctly.
- Confirm each candidate project gap against the acceptance gate, repository
  commands, CI config, Makefiles, scripts, docs, tests, examples, and current
  architecture before recording it. Try to disprove the candidate by asking
  whether the workflow is already supported, whether the repository owns the
  surface, whether the likely audience exists, and whether the project change
  can be added incrementally using local patterns.
- Do not record confirmed bugs, security issues, compatibility breaks,
  reliability gaps, missing tests, stale docs, unclear naming, or main product
  feature ideas as project gaps. Route them to `$code-issues-find`,
  `$security-audit`, `$reliability-gaps-find`, `$test-gaps-find`,
  `$doc-gaps-audit`/`$doc-gaps-fix`, `$naming-standards`, or
  `$feature-gaps-find` as appropriate.
- If a candidate mostly improves test correctness, test coverage, test-harness
  maintainability, fixture design, test determinism, or wrong-layer tests, route
  it to `$test-gaps-find` even when the changed file is Ruby, shell, or another
  language used only by the test harness.
- If a candidate mostly adds or improves product-owned capabilities for users,
  package consumers, service authors, or operators, route it to
  `$feature-gaps-find`.
- If a candidate mostly documents existing behavior, route it to
  `$doc-gaps-audit` or `$doc-gaps-fix`.
- If a candidate's implementation home is outside the requested scope, do not
  record it as a normal scoped ledger entry for that scope. Record it under
  `Routed Project Follow-Ups` with the owning home and local evidence, or route
  it to a separate project-gaps-find run in the owning repository or shared
  tooling scope.
