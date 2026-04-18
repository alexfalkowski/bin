# Workflow Reference

Use this reference when you need to establish context quickly and consistently in these repositories.

## Build Context In This Order

1. Read `AGENTS.md` if present.
2. Read `README.md` and the root `Makefile`.
3. Run `make dep` if the repository exposes it so local dependencies and tool wrappers are up to date before deeper investigation.
4. Inspect which `bin/build/make/*.mak` fragments are included by the root `Makefile`.
5. Inspect CI configuration to learn what must pass.
6. Inspect only the files and scripts relevant to the requested change.

## Prefer Repository Entry Points

- Prefer repository entry points such as `make` targets over calling tools directly.
- Use direct tool invocations only when the repository does not provide a stable entry point or when a narrower check is clearly better for the task.
- Confirm that a target or script is actually wired into the repo before relying on it.
- If the repo exposes `make dep`, run it before deeper investigation or analysis unless the user asked you not to or the environment prevents it.
- When `help.mak` is included, use `make` or `make help` as the quickest way to discover the command surface.
- When a repo includes `ruby.mak` or `go.mak`, use those fragments to infer likely workflows, but still trust the root `Makefile` as the final interface.
- Do not assume `features` and `specs` identify mutually exclusive project types. A repository may intentionally expose either one or both.
- When planning tests, follow the workflow the repository actually exposes. If only one of `features` or `specs` exists, use that one and do not invent the other.

## When The Repo Uses `./bin`

- Treat the consuming repository as the primary execution context.
- Inspect the root `Makefile` to see which `bin/build/make/*.mak` fragments are included.
- Validate path-sensitive behavior from the consuming repository root, not from inside the `bin` submodule.
- Be careful with targets that resolve helper paths through `$(PWD)/bin/...`; they may work in a downstream repo and fail inside the `bin` repo itself.
- Be careful with `start` and `stop` helpers because they may depend on a sibling `../docker` checkout or SSH access.

## Change Discipline

- Prefer the smallest safe change.
- Match existing naming, layout, formatting, and test style.
- Avoid introducing new tools, abstractions, or dependencies unless the repository already points in that direction or the task requires it.
- If behavior changes, plan the corresponding test update as part of the same change.
- Prefer compatibility-preserving changes for public interfaces and shared build targets.
- If a change affects consumers, plan the migration or deprecation path as part of the implementation.
- If a change touches hot paths or operational behavior, decide early whether benchmarks or observability updates are needed.
- If a decision has non-obvious consequences, pause and verify the direction with a short plan before committing to it.
- Use the plan to surface the main options, the intended path, the relevant risks, and how the choice will be verified.
- Treat destructive git helper targets as opt-in actions that require explicit user intent.

## PR Requests

- When the user asks for a PR, treat the output format as part of the task.
- Provide the commit message first, on its own, as a single line of
  all-lowercase plain text.
- Check both the relevant committed changes and the current working-tree
  changes before writing the summary when both may matter.
- Provide a PR summary in markdown with these exact headings:

```md
## What

## Why

## Testing
```

- Do not wrap the commit message in bullets, code fences, labels, or extra
  formatting.
- Do not assume the PR only reflects the current uncommitted diff if recent
  committed work is also part of the requested change.
- Keep the `Testing` section honest about what ran, what passed, and what was not run.
- Include the exact commands run in the `Testing` section when commands were executed.
