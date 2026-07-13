# Check Selection

Use this reference when choosing which checks to run.

## Validation Principles

- Before wrapping up code changes, run the applicable lint checks.
- Run the narrowest check that gives credible confidence for the change and
  report when broader CI coverage is intentionally left to CI.
- Prefer repository-defined commands because they encode project conventions.
- Use direct commands only when they are an established repository or harness
  selector that is clearly narrower or better aligned with the task than a
  broader repo wrapper.
- Before running, retrying, replacing, or recommending commands, establish the repository root, documented entrypoint, CI analogue, initialized user shell, and any macOS/Homebrew tool-path assumptions.
- Before selecting tests, identify the dominant relevant test harness and repository-defined entry point for the affected behavior.
- Do not add or select an ad hoc language-native test command when the repository's established harness owns the behavior, unless the user explicitly asked for that layer or the behavior cannot be covered through the established harness.
- If bypassing the dominant harness is necessary, stop before editing or validating and state why the established harness cannot cover the behavior.
- For code or test changes, prefer fast feedback from supported package, file,
  scenario, example, focus, or test-name selectors in the dominant harness
  before running a broad suite. Do not use a selector that changes the test
  layer or skips required setup.
- Use CI configuration as a strong signal for which checks matter most.
- Run the repository's setup target, such as `make dep`, when checks depend on installed dependencies, generated files, or vendored state.
- Identify checks that require SSH credentials, GitHub auth, registry auth,
  cloning, pushing, publishing, opening PRs, or updating remote state. Rely on
  the active agent configuration for command approval behavior; do not add a
  separate model-level permission request.
- Expand from targeted checks to broader checks only when the task or risk justifies it.
- Never imply a check ran if the wrapper no-op'd because a dependency was missing.
- Report network, credential, shell environment, `PATH`, or tool-version failures as environment or validation gaps rather than code failures.
- Keep the repository-defined command as the intended validation command when the agent environment differs from the user's normal shell.
- After a repository-defined command, Make target, dominant test harness, or skill-required workflow fails, do not switch to an ad hoc command, different validation layer, or alternate workflow merely to make progress. First classify the failure using the repository's validation categories; then retry only through the initialized-shell or approved escalation path, or report the blocker.

## Command Execution Environment

- Treat the repository Makefile and CI configuration as the source of truth for setup, lint, test, security, benchmark, and review commands.
- On developer machines, especially macOS, assume required tools may come from Homebrew or another user-shell setup rather than the OS defaults.
- Prefer `make` targets and documented repository entry points over direct tool invocations, even when a direct command appears equivalent.
- Run commands from the repository root unless the Makefile, script, or task explicitly requires another working directory.
- Use the user's configured shell environment for command execution. If a command fails because a tool is missing, an old version is found, or `PATH` differs from the user's normal terminal, treat that as an environment mismatch or validation gap, not as evidence that the repository command is wrong.
- Run repository commands through the user's initialized shell when tool resolution matters, for example `zsh -lic 'make lint'`.
- Do not invent direct commands, replace a Makefile target, install alternate tools, or keep retrying variants merely to get something to run in the agent environment.
- When diagnosing command-environment mismatches, check the command surface first, then inspect `command -v <tool>`, `<tool> --version`, `SHELL`, and `PATH` as diagnostics only.
- In this shared `bin` repo and downstream repos that vendor it as `./bin`, `make` targets are the preferred validation interface. If `make` reports an unexpected tool or version problem in the agent environment but works in the user's shell, report the mismatch and keep the Makefile target as the intended command.

## Typical Validation Order

1. Run setup or dependency installation when the required tools or generated/vendor state may be missing.
2. Run the fastest supported selector that exercises the changed area, such as a
   package, file, scenario, example, focus tag, or test name exposed by the
   repository's dominant harness.
3. Run the nearest repository entry point, often a `make` target, when that is the project's standard workflow.
4. Run applicable lint for changed code, tests, scripts, docs, skills, or policy.
5. Run any additional repo-defined checks that are clearly relevant to the risk of the change.
6. Run broader lint or test suites only when the change touches shared infrastructure, multiple packages, or release-sensitive behavior.

## Output Format

For standalone validation reports, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Validation

- command: `make lint`
  result: passed
  coverage: Ruby linting for changed files.
  local-pattern: Repo lint target; no new validation layer.

## Gaps

- None.
```

- Use only these results: `passed`, `failed`, `not run`, `no-op`.
- Use `no-op` when a wrapper ran but skipped meaningful validation because an optional tool was missing.
- Use `not run` when a relevant command was intentionally skipped or could not be run.
- If no commands ran, write one `Validation` entry with `command: none` and `result: not run`.
- In `coverage`, state what the command actually validated or why it did not validate anything.
- In `local-pattern`, state the repository-defined validation path or dominant harness used, and state when no new validation layer was introduced.
- If there are no validation gaps, write exactly `- None.`
- When embedding validation in another skill's output format, preserve command, result, coverage, and gap details without adding standalone sections.

## Helpful Heuristics

- For docs, policy, skills, configuration, metadata, formatting-only changes,
  generated artifacts, shell scripts, Dockerfiles, and Makefile glue, prefer the
  repo's lint, schema, dry-run, or closest validation target when no established
  executable test harness owns the behavior.
- For shell scripts, Dockerfiles, and Makefile glue, prefer the repo's lint targets when available.
- For changes in any implementation language, first identify the majority relevant repository-defined test harness for the affected behavior; prefer the matching test entry point before inventing ad hoc commands.
- For changes isolated to one package, file, command, scenario, or documented
  example, prefer the matching supported selector first. If the repository only
  exposes a broad `make` target, use that target and report the lack of a
  narrower supported selector as validation scope, not as a failure.
- If a service behavior is primarily covered by Cucumber, Gherkin, RSpec-style features, acceptance tests, or another cross-language harness, validate through that harness unless the user explicitly asks for lower-level tests.
- Run language-specific lint or formatting commands for changed code when the repository exposes them, regardless of which harness owns the behavior tests.
- For Go changes whose majority relevant tests are Go-based, prefer the repo's Go test entry points.
- For Ruby changes whose majority relevant tests are Ruby-based, prefer the repo's Ruby feature, spec, or benchmark entry points.
- For CI or build changes, validate the closest local command that mirrors the affected pipeline step.
- If the repository exposes `lint`, use it after relevant edits unless a narrower lint target is clearly better.
- If the repository exposes named test entry points, use the one that matches the affected behavior instead of inventing a different test vocabulary.
- If the repository exposes benchmark or coverage targets that are relevant to the change, prefer those entry points over ad hoc commands.
- If a repo exposes `dep`, `lint`, `specs`, `features`, `benchmarks`, `coverage`, or `sec`, prefer those names over ad hoc tool invocations.
- For this shared `bin` repo itself, CI currently runs `make dep`, `make clean-dep`, `make scripts-lint`, `make skills-lint`, `make docker-lint`, `make lint`, and `make sec`.
- Dependency setup, scanners, Docker commands, Buf commands, and Go module commands may require network access; identify that before relying on them.
- Push, publish, release, Docker manifest push, Buf push, and PR open/update
  flows update remote state. Run them only when the current request authorizes
  that workflow, and rely on the active agent configuration for command
  approval behavior.

## `./bin`-Specific Caution

- If a repo vendors this shared `bin` project, run validation from the consuming repo when targets depend on downstream include wiring or test/build layout.
- Do not assume a helper script proves anything unless the downstream wiring matches the way the repo actually executes it.
- If a wrapper depends on optional tools such as `golangci-lint`, `shellcheck`, `hadolint`, or `govulncheck`, report clearly when the command could not provide full coverage.
