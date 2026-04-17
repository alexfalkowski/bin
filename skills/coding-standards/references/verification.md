# Verification Reference

Use this reference when choosing which checks to run and how to describe verification in the final response.

## Verification Principles

- Treat linting as part of the edit loop, not just a final pass.
- Run the narrowest check that gives credible confidence for the change.
- Prefer repository-defined commands because they encode project conventions.
- Use CI configuration as the strongest signal for which checks are truly required.
- Verify that public-facing code changes include matching documentation updates, not just code and tests.
- Verify that behavior changes include tests or a clearly stated reason they were not added.
- Verify that migration or deprecation needs are addressed when consumers are affected.
- Verify that performance-sensitive or operationally significant changes considered benchmark and observability impact.
- Expand from targeted checks to broader checks only when the task or risk justifies it.
- Never imply a check ran if the wrapper no-op'd because a dependency was missing.

## Typical Validation Order

1. After each edit, run the most targeted lint command that covers the changed files when the repo provides one.
2. Run the most targeted test or lint command that exercises the changed behavior.
3. Run the nearest repository entry point, often a `make` target, when that is the project's standard workflow.
4. Run broader lint or test suites only when the change touches shared infrastructure, multiple packages, or release-sensitive behavior.

## Helpful Heuristics

- For shell scripts, Dockerfiles, and Makefile glue, prefer the repo's lint targets when available.
- For Markdown files, prefer `markdownlint-cli2` when it is available or when the repository already uses it.
- For Go changes, prefer the repo's test and lint entry points before inventing ad hoc commands.
- For Ruby changes, prefer the repo's lint and feature/benchmark entry points when they exist.
- For CI or build changes, validate the closest local command that mirrors the affected pipeline step.
- If the repository exposes `lint`, use it after relevant edits unless a narrower lint target is clearly better.
- If a public interface changes, include a compatibility check in your validation thinking, even if that check is partly manual.
- If a change affects hot paths or throughput-sensitive code, include benchmark or performance reasoning when the repo supports it.
- If a change adds runtime behavior that may need diagnosis in production, check whether logging, metrics, tracing, or error context should also be updated.
- For exported or public Go code, verify package docs and doc comments remain accurate and complete.
- For public Ruby APIs, classes, modules, and methods, verify the corresponding RDoc remains accurate and complete.
- If a repo exposes `dep`, `lint`, `specs`, `features`, `benchmarks`, `coverage`, or `sec`, prefer those names over ad hoc tool invocations.
- For this shared `bin` repo itself, CI currently treats `make scripts-lint`, `make docker-lint`, `make lint`, and `make sec-lint` as the authoritative checks.

## `./bin`-Specific Caution

- If a repo vendors this shared `bin` project, run validation from the consuming repo when targets depend on `$(PWD)/bin/...`.
- Do not assume a helper script proves anything unless the downstream wiring matches the way the repo actually executes it.
- If a wrapper depends on optional tools such as `golangci-lint`, `shellcheck`, `hadolint`, or `govulncheck`, report clearly when the command could not provide full coverage.

## Reporting Rules

- State exactly what you ran.
- State what passed, failed, or could not run.
- State which lint checks were run after the changes.
- State the exact test commands run when tests were executed.
- If a PR summary includes committed work, make sure the summary reflects the
  inspected committed changes and not only the uncommitted diff.
- State whether public-facing documentation was updated or intentionally left unchanged.
- State whether compatibility, migration, dependency, performance, observability, or security-sensitive concerns were relevant to the change.
- Call out missing tools, sandbox limits, or environment constraints.
- If validation was intentionally scoped, say so plainly.
- Do not describe the work as complete if relevant tests or lint checks failed.
