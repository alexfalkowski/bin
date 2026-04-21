# Verification Reference

Use this reference when choosing which checks to run.

## Verification Principles

- Before wrapping up code changes, run the applicable lint checks.
- Run the narrowest check that gives credible confidence for the change.
- Prefer repository-defined commands because they encode project conventions.
- Use direct commands when they are clearly narrower or better aligned with the task than a broader repo wrapper.
- Use CI configuration as a strong signal for which checks matter most.
- Expand from targeted checks to broader checks only when the task or risk justifies it.
- Never imply a check ran if the wrapper no-op'd because a dependency was missing.

## Typical Validation Order

1. Run the most targeted lint or test command that exercises the changed behavior.
2. Run the nearest repository entry point, often a `make` target, when that is the project's standard workflow.
3. Run any additional repo-defined checks that are clearly relevant to the risk of the change.
4. Run broader lint or test suites only when the change touches shared infrastructure, multiple packages, or release-sensitive behavior.

## Helpful Heuristics

- For shell scripts, Dockerfiles, and Makefile glue, prefer the repo's lint targets when available.
- For Go changes, prefer the repo's test and lint entry points before inventing ad hoc commands.
- For Ruby changes, prefer the repo's lint and feature/benchmark entry points when they exist.
- For CI or build changes, validate the closest local command that mirrors the affected pipeline step.
- If the repository exposes `lint`, use it after relevant edits unless a narrower lint target is clearly better.
- If the repository exposes named test entry points, use the one that matches the affected behavior instead of inventing a different test vocabulary.
- If the repository exposes benchmark or coverage targets that are relevant to the change, prefer those entry points over ad hoc commands.
- If a repo exposes `dep`, `lint`, `specs`, `features`, `benchmarks`, `coverage`, or `sec`, prefer those names over ad hoc tool invocations.
- For this shared `bin` repo itself, CI currently treats `make scripts-lint`, `make docker-lint`, `make lint`, and `make sec-lint` as the authoritative checks.

## `./bin`-Specific Caution

- If a repo vendors this shared `bin` project, run validation from the consuming repo when targets depend on `$(PWD)/bin/...`.
- Do not assume a helper script proves anything unless the downstream wiring matches the way the repo actually executes it.
- If a wrapper depends on optional tools such as `golangci-lint`, `shellcheck`, `hadolint`, or `govulncheck`, report clearly when the command could not provide full coverage.
