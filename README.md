[![CircleCI](https://circleci.com/gh/alexfalkowski/bin.svg?style=shield)](https://circleci.com/gh/alexfalkowski/bin)
[![Stability: Active](https://masterminds.github.io/stability/active.svg)](https://masterminds.github.io/stability/active.html)

# 🧰 bin

Shared executables, Makefile includes, and agent skills for projects that use
this repository as a Git submodule at `./bin`.

## 🎯 Why This Exists

The projects that use this repository share the same build, lint, test,
security, Docker, release, and agent-workflow glue. Keeping that glue here makes
the consuming repositories smaller while giving them one supported integration
path.

## 🚀 Install Or Bootstrap

Add this repository as the downstream project's `bin` submodule:

```bash
git submodule add git@github.com:alexfalkowski/bin.git bin
git submodule update --init
```

> [!IMPORTANT]
> In a fresh checkout of a project that already has the submodule, initialize it
> before using targets supplied by `bin`.

```bash
git submodule update --init
```

## 💻 Usage

Include only the Make fragments your project needs. The fragments derive helper
paths from their own location, so downstream includes work when this repository
is mounted at `./bin`. Inside this repository, the root `Makefile` includes the
same fragments from `build/make/`.

For command discovery, include `help.mak` and run `make` or `make help` in the
consuming repository.

```make
include bin/build/make/help.mak
include bin/build/make/go.mak
```

Ruby projects typically include the Ruby fragment instead:

```make
include bin/build/make/help.mak
include bin/build/make/ruby.mak
```

Projects that use the shared git workflow can include it separately:

```make
include bin/build/make/git.mak
```

Consuming repositories choose which fragments to include and remain responsible
for project-specific configuration such as service code, image names, release
version files, and environment-specific settings.

## 🤖 Agent Skills

This repository also ships shared agent guidance in `skills/`. Each skill is a
`skills/<name>/SKILL.md` file that works with both OpenAI Codex and Claude Code;
`skills/<name>/agents/openai.yaml` carries the Codex-specific interface.

### Codex

Codex discovers repository skills from `.agents/skills`, so wire a downstream
repository once with the shared bootstrap, then commit the result:

```make
include bin/build/make/codex.mak
```

```bash
make codex-init
```

This creates a `.agents/skills` symlink to `bin/skills`, a `.codex/config.toml`
symlink to the shared permission profile in `bin/build/codex/config.toml`, and a
`.codex/rules/bin.rules` symlink to the shared execution guardrails. A
repository-owned real config or rule file is left untouched. Every later clone
can invoke shared skills with `$`, for example `$code-review`, and receives the
shared permissions after the one-time project trust prompt. Repositories with
an existing real config can merge the shared settings explicitly.

The permission profile requires Codex 0.138.0 or later. It confines routine
commands to the workspace while making workspace Git metadata and the standard
Go, RuboCop, golangci-lint, and Trivy caches writable. It grants read access to
common host credential locations, permits outbound network access, and allows
writes to standard system temporary directories. Every `make` invocation runs
outside the sandbox without prompting. Direct cleanup inside writable sandbox
roots is allowed, direct recognized remote and external-system changes require
approval, and catastrophic commands are forbidden. Root `.env` and `.env.*`
files remain protected, while nested dependency environment files and `.envrc`
files are allowed for native dependency workflows. Explicit workflow permission
gates in `AGENTS.md` remain in force.

> [!WARNING]
> The shared profile is only for trusted repositories. Make targets run outside
> the sandbox and inherit the user's host access, while sandboxed commands can
> read configured credentials and send data over the internet. Review executable
> repository content, Makefiles, and dependency scripts before using it.

Legacy `sandbox_mode` settings and the `--sandbox` CLI flag take precedence over
permission profiles. Remove those overrides when the shared profile should be
active.

Codex loads project config and rules only for trusted repositories. Put
per-machine additions in `~/.codex/config.toml` and
`~/.codex/rules/default.rules`; Codex also records accepted persistent command
prefixes in that user rules file. Re-run `make codex-init` only when the shared
paths move. Updates to the shared profile or rules propagate with the next
`bin` submodule update; start a new Codex session afterward so it uses the
updated permissions.

Codex reads `AGENTS.md` separately for repository instructions. Downstream
repositories should still point agents at the shared instructions instead of
copying the skill list:

```markdown
## Shared guidance

Use `bin/AGENTS.md` for shared skills and cross-repository defaults.
```

### Claude Code

Claude Code does not scan submodules; it only loads skills from `.claude/skills/`
and instructions from `CLAUDE.md`. Wire a repository once with the shared
bootstrap, then commit the results:

```make
include bin/build/make/claude.mak
```

```bash
make claude-init
```

This creates a `.claude/skills` symlink to `bin/skills`, a `.claude/settings.json`
symlink to the shared permissions baseline in `bin/build/claude/settings.json`
(unless the repository owns a real, non-symlink `settings.json`), and a managed
block in `CLAUDE.md` that imports the local and shared `AGENTS.md`. All are
committed, so every later clone works with no per-machine setup beyond the
one-time workspace trust prompt. Invoke a skill as a slash command, for example
`/code-review`. Re-run `make claude-init` only when the shared skills directory
moves; adding a new skill or updating the permissions baseline needs no
downstream change because the symlinks target shared paths that follow `bin`.

The baseline starts in Claude Code's default permission mode, enables the Bash
sandbox, and routes direct Bash commands through the `permissions` allow, ask,
and deny guardrails. Direct Bash is broadly allowed without prompting while it
remains sandboxed; project-local operations stay autonomous, recognized remote
and external-system changes require approval, and catastrophic commands are
forbidden. The unsandboxed escape hatch is disabled. The sandbox grants the
standard Go, RuboCop, golangci-lint, and Trivy cache writes used by project
commands, plus standard system temporary directories. Every `make` invocation
is excluded from the sandbox and allowed without prompting. Built-in file edits
stay scoped to the workspace, and explicit workflow permission gates in
`AGENTS.md` remain in force.

> [!WARNING]
> The shared baseline is only for trusted repositories. Make targets run outside
> the sandbox and inherit the user's host access. The Bash sandbox permits broad
> reads and configured cache writes, and it does not impose blanket secret-read
> restrictions. Review executable repository content, Makefiles, and dependency
> scripts before using it.

Put per-repository or per-machine permission tweaks in the gitignored
`.claude/settings.local.json`, which Claude Code merges over the baseline.
Wiring the `*-template` repositories once pre-wires every repository generated
from them.

Update `AGENTS.md` when the shared skill set, composition rules, or repository
workflow guidance changes.

## 🛠️ Operations

This repository is shared tooling. Changes can affect every downstream project
that vendors it, so prefer small compatible changes and validate through the
repository Make targets.

Some helpers intentionally depend on tools or services outside this repository:
Docker helpers assume the consuming project supplies image names and release
version files; the shared Go Dockerfile uses `Dockerfile.dockerignore` next to
the Dockerfile, which takes precedence over a consuming repository's root
`.dockerignore`; security helpers assume Trivy is available; shell and
Dockerfile lint targets depend on `shellcheck` and `hadolint`;
`build/docker/env` pulls, rebases, and updates submodules in an existing sibling
`../docker` checkout, or uses SSH to clone
`git@github.com:alexfalkowski/docker.git` there when missing.

## 🔗 References

- `make` or `make help`: current command catalog for this repository.
- `build/make/*.mak`: reusable Makefile fragments for downstream projects.
- `build/codex/init`: one-time Codex wiring for a consuming repository (run via
  `make codex-init`).
- `build/codex/config.toml` and `build/codex/rules/default.rules`: shared Codex
  permission profile and execution guardrails.
- `build/claude/init`: one-time Claude Code wiring for a consuming repository
  (run via `make claude-init`).
- `build/docker/go/Dockerfile`: shared Go service Dockerfile template.
- `build/docker/go/Dockerfile.dockerignore`: shared Docker build-context
  exclusions for the Go service Dockerfile.
- `quality/`: shared lint, feature, benchmark, and coverage helpers.
- `AGENTS.md`: repository instructions, shared skills, and agent operating
  rules.
