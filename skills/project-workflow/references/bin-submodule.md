# Bin Submodule Workflow

Use this reference when you need to establish context quickly and discover how a repository is wired.

## Discover The Interface

1. Read `AGENTS.md` if present.
2. Read `README.md` and the root `Makefile`.
3. Inspect CI configuration to learn what the repository expects to pass.
4. Inspect which `bin/build/make/*.mak` fragments are included by the root `Makefile`, when relevant.
5. Inspect only the files and scripts relevant to the requested task.
6. Read `make-fragments.md` when you need to interpret likely behavior of included shared Makefile fragments or edit reusable `build/make/*.mak` files.
7. Before editing, identify the local pattern for the changed surface, including import style, naming, file layout, dominant test harness, documented config keys, and repository validation target.
8. Treat the consuming repository's `AGENTS.md`, this shared `bin/AGENTS.md`, and the selected skills as mandatory rules. If a needed edit would deviate from them or from the discovered local pattern, stop and ask before editing.

## Prefer Repository Entry Points

- Prefer repository entry points such as `make` targets over calling tools directly.
- Use direct tool invocations only when the repository does not provide a stable entry point or when a narrower check is clearly better for the task.
- Confirm that a target or script is actually wired into the repo before relying on it.
- Preserve the repository's established validation path instead of inventing a new direct command for convenience.
- Identify whether a command fetches, clones, pushes, publishes, opens PRs, updates remote state, or requires SSH/GitHub/registry credentials before running it.
- When `help.mak` is included, use `make` or `make help` as the quickest way to discover the command surface.
- When planning work, note whether the repository exposes setup targets such as `dep` so you can use them later when the task moves from discovery to edits or validation.

## Command Execution Environment

- Treat the repository Makefile and CI configuration as the source of truth for setup, lint, test, security, benchmark, and review commands.
- Account for platform-specific tool-path setup rather than assuming OS defaults.
- Prefer `make` targets and documented repository entry points over direct tool invocations, even when a direct command appears equivalent.
- Run commands from the repository root unless the Makefile, script, or task explicitly requires another working directory.
- Use the configured command environment for command execution. If a command fails because a tool is missing, an old version is found, or `PATH` differs from the configured environment, treat that as an environment mismatch or validation gap, not as evidence that the repository command is wrong.
- Run repository commands in the configured command environment when tool resolution matters.
- Do not invent direct commands, replace a Makefile target, install alternate tools, or keep retrying variants merely to get something to run in the agent environment.
- When diagnosing command-environment mismatches, check the command surface first, then inspect `command -v <tool>`, `<tool> --version`, `SHELL`, and `PATH` as diagnostics only.

## Output Format

When workflow discovery is the final response, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Command Surface

- `make lint` - defined by root `Makefile`.

## CI Expectations

- `make lint` - required by CI.

## Bin Wiring

- Uses `./bin` shared make fragments.

## Constraints

- None.
```

- If a section has no entries, write exactly `- None.`
- Use `Command Surface` for local commands, Make targets, scripts, or package-manager entrypoints.
- Use `CI Expectations` for checks required by CI configuration.
- Use `Bin Wiring` for included `bin/build/make/*.mak` fragments or shared `BIN_ROOT` helper path behavior.
- Use `Constraints` for missing tools, downstream-only paths, CI-only behavior, SSH/network/auth requirements, remote-write targets, or other workflow limits.
- When another skill embeds workflow discovery, keep the same command, CI, bin-wiring, and constraint facts but use the caller's required output sections.

## When The Repo Uses `./bin`

- Treat the consuming repository as the primary execution context.
- Treat the consuming repository's `AGENTS.md` as binding local policy before applying shared `./bin` defaults.
- Inspect the root `Makefile` to see which `bin/build/make/*.mak` fragments are included.
- Use `make-fragments.md` to interpret included shared fragments after checking the root `Makefile`; do not let the fragment map replace the repository's actual command surface.
- After confirming downstream scope, read `downstream-defaults.md` for conditional
  shared-bin defaults; do not load it for work confined to this repository.
- Validate path-sensitive behavior from the consuming repository root when downstream layout affects target behavior.
- Preserve downstream local code, test, documentation, configuration, and validation patterns unless the user explicitly asks to change them.
- Be careful with targets that resolve helper paths through `BIN_ROOT`; they should work in downstream repos and inside the `bin` repo itself, but downstream test/build layouts may still differ.
- If a Make target reports an unexpected tool or version problem in the agent environment but works in the configured command environment, report the mismatch and keep the Makefile target as the intended command.
- Be careful with `start` and `stop` helpers because they may depend on a sibling `../docker` checkout or SSH access.
