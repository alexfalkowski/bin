# Check Selection

Use this reference when choosing which checks to run.

## Validation Principles

- Before wrapping up code changes, run the applicable lint checks.
- Run the narrowest check that gives credible confidence for the change.
- Prefer repository-defined commands because they encode project conventions.
- Use direct commands when they are clearly narrower or better aligned with the task than a broader repo wrapper.
- Use CI configuration as a strong signal for which checks matter most.
- Run the repository's setup target, such as `make dep`, when checks depend on installed dependencies, generated files, or vendored state.
- Ask for permission before running checks that require SSH credentials, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state.
- Expand from targeted checks to broader checks only when the task or risk justifies it.
- Never imply a check ran if the wrapper no-op'd because a dependency was missing.
- Report network, credential, shell environment, `PATH`, or tool-version failures as environment or validation gaps rather than code failures.
- Keep the repository-defined command as the intended validation command when the agent environment differs from the user's normal shell.

## Command Execution Environment

- Treat the repository Makefile and CI configuration as the source of truth for setup, lint, test, security, benchmark, and review commands.
- Prefer `make` targets and documented repository entry points over direct tool invocations, even when a direct command appears equivalent.
- Run commands from the repository root unless the Makefile, script, or task explicitly requires another working directory.
- Use the user's configured shell environment for command execution. If a command fails because a tool is missing, an old version is found, or `PATH` differs from the user's normal terminal, treat that as an environment mismatch or validation gap, not as evidence that the repository command is wrong.
- Do not replace a Makefile target with guessed direct commands just because the agent environment cannot find the same tools as the user's shell.
- When diagnosing command-environment mismatches, check the command surface first, then inspect `command -v <tool>`, `<tool> --version`, `SHELL`, and `PATH` as diagnostics only.
- In this shared `bin` repo and downstream repos that vendor it as `./bin`, `make` targets are the preferred validation interface. If `make` reports an unexpected tool or version problem in the agent environment but works in the user's shell, report the mismatch and keep the Makefile target as the intended command.

## Typical Validation Order

1. Run setup or dependency installation when the required tools or generated/vendor state may be missing.
2. Run the most targeted lint or test command that exercises the changed behavior.
3. Run the nearest repository entry point, often a `make` target, when that is the project's standard workflow.
4. Run any additional repo-defined checks that are clearly relevant to the risk of the change.
5. Run broader lint or test suites only when the change touches shared infrastructure, multiple packages, or release-sensitive behavior.

## Output Format

For standalone validation reports, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Validation

- command: `make lint`
  result: passed
  coverage: Ruby linting for changed files.

## Gaps

- None.
```

- Use only these results: `passed`, `failed`, `not run`, `no-op`.
- Use `no-op` when a wrapper ran but skipped meaningful validation because an optional tool was missing.
- Use `not run` when a relevant command was intentionally skipped or could not be run.
- If no commands ran, write one `Validation` entry with `command: none` and `result: not run`.
- In `coverage`, state what the command actually validated or why it did not validate anything.
- If there are no validation gaps, write exactly `- None.`
- When embedding validation in another skill's output format, preserve command, result, coverage, and gap details without adding standalone sections.

## Helpful Heuristics

- For shell scripts, Dockerfiles, and Makefile glue, prefer the repo's lint targets when available.
- For Go changes, prefer the repo's test and lint entry points before inventing ad hoc commands.
- For Ruby changes, prefer the repo's lint and feature/benchmark entry points when they exist.
- For CI or build changes, validate the closest local command that mirrors the affected pipeline step.
- If the repository exposes `lint`, use it after relevant edits unless a narrower lint target is clearly better.
- If the repository exposes named test entry points, use the one that matches the affected behavior instead of inventing a different test vocabulary.
- If the repository exposes benchmark or coverage targets that are relevant to the change, prefer those entry points over ad hoc commands.
- If a repo exposes `dep`, `lint`, `specs`, `features`, `benchmarks`, `coverage`, or `sec`, prefer those names over ad hoc tool invocations.
- For this shared `bin` repo itself, CI currently runs `make dep`, `make clean-dep`, `make scripts-lint`, `make docker-lint`, `make lint`, and `make sec-lint`.
- Dependency setup, scanners, Docker commands, Buf commands, and Go module commands may require network access; identify that before relying on them.
- Push, publish, release, Docker manifest push, Buf push, and PR open/update flows require explicit user permission.

## `./bin`-Specific Caution

- If a repo vendors this shared `bin` project, run validation from the consuming repo when targets depend on `$(PWD)/bin/...`.
- Do not assume a helper script proves anything unless the downstream wiring matches the way the repo actually executes it.
- If a wrapper depends on optional tools such as `golangci-lint`, `shellcheck`, `hadolint`, or `govulncheck`, report clearly when the command could not provide full coverage.
