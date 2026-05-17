# Bin Submodule Workflow

Use this reference when you need to establish context quickly and discover how a repository is wired.

## Discover The Interface

1. Read `AGENTS.md` if present.
2. Read `README.md` and the root `Makefile`.
3. Inspect CI configuration to learn what the repository expects to pass.
4. Inspect which `bin/build/make/*.mak` fragments are included by the root `Makefile`, when relevant.
5. Inspect only the files and scripts relevant to the requested task.

## Prefer Repository Entry Points

- Prefer repository entry points such as `make` targets over calling tools directly.
- Use direct tool invocations only when the repository does not provide a stable entry point or when a narrower check is clearly better for the task.
- Confirm that a target or script is actually wired into the repo before relying on it.
- Identify whether a command fetches, clones, pushes, publishes, opens PRs, updates remote state, or requires SSH/GitHub/registry credentials before running it.
- When `help.mak` is included, use `make` or `make help` as the quickest way to discover the command surface.
- When planning work, note whether the repository exposes setup targets such as `dep` so you can use them later when the task moves from discovery to edits or validation.

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
- Use `Bin Wiring` for included `bin/build/make/*.mak` fragments or `$(PWD)/bin/...` path behavior.
- Use `Constraints` for missing tools, downstream-only paths, CI-only behavior, SSH/network/auth requirements, remote-write targets, or other workflow limits.
- When another skill embeds workflow discovery, keep the same command, CI, bin-wiring, and constraint facts but use the caller's required output sections.

## When The Repo Uses `./bin`

- Treat the consuming repository as the primary execution context.
- Inspect the root `Makefile` to see which `bin/build/make/*.mak` fragments are included.
- Validate path-sensitive behavior from the consuming repository root, not from inside the `bin` submodule.
- Be careful with targets that resolve helper paths through `$(PWD)/bin/...`; they may work in a downstream repo and fail inside the `bin` repo itself.
- Be careful with `start` and `stop` helpers because they may depend on a sibling `../docker` checkout or SSH access.
