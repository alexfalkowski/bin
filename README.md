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

This repository also ships shared agent guidance in `skills/`. Downstream
repositories should point agents at the shared instructions instead of copying
the skill list:

```markdown
## Shared skills

This repository uses the shared skills from `bin/skills/`. Read
`bin/AGENTS.md` for the canonical shared skill list and use the smallest
matching skill for the task.
```

Update `AGENTS.md` when the shared skill set, composition rules, or repository
workflow guidance changes.

## 🛠️ Operations

This repository is shared tooling. Changes can affect every downstream project
that vendors it, so prefer small compatible changes and validate through the
repository Make targets.

Some helpers intentionally depend on tools or services outside this repository:
Docker helpers assume the consuming project supplies image names and release
version files; security helpers assume Trivy is available; shell and Dockerfile
lint targets depend on `shellcheck` and `hadolint`; `build/docker/env` pulls,
rebases, and updates submodules in an existing sibling `../docker` checkout, or
uses SSH to clone `git@github.com:alexfalkowski/docker.git` there when missing.

## 🔗 References

- `make` or `make help`: current command catalog for this repository.
- `build/make/*.mak`: reusable Makefile fragments for downstream projects.
- `build/docker/go/Dockerfile`: shared Go service Dockerfile template.
- `quality/`: shared lint, feature, benchmark, and coverage helpers.
- `skills/README.md`: shared skill composition and lifecycle guidance.
- `AGENTS.md`: repository instructions and shared agent operating rules.
