# Agent init wiring and sandbox posture

How `make codex-init` and `make claude-init` wire this shared tooling into a
consuming repository, and the permission posture each installs. This is
maintainer-facing detail for changes to the init scripts or permission
baselines; the root `AGENTS.md` links here rather than carrying it inline.

Use these profiles only in trusted repositories: Make targets inherit the
user's host access, sandboxed commands can read credentials and use the
network, outbound network access is unrestricted, enabling `trustd` widens the
exfiltration surface, and the sandbox does not impose blanket secret-read
restrictions.

## Codex (`build/codex/init`, via `make codex-init`)

Wires Codex by symlinking `.agents/skills` to `skills/`, `.codex/config.toml`
to the shared permission profile, and `.codex/rules/bin.rules` to the shared
execution guardrails; repo-owned real config and rule files are left untouched.
The project must be trusted before Codex loads project config and rules, and
permission profiles require Codex 0.138.0 or later.

The shared profile extends `:workspace`, makes workspace Git metadata and
standard Go, RuboCop, golangci-lint, and Trivy caches writable, grants read
access to common host credential locations, allows writes to standard system
temporary directories, and allows outbound network access. Every `make`
invocation is allowed outside the sandbox without prompting; cleanup inside
writable roots is prompt-free, direct remote and external-service commands
remain approval-gated, and catastrophic commands remain forbidden. Root `.env`
and `.env.*` files remain protected, while nested dependency environment files
and `.envrc` files are allowed for native dependency workflows. The shared
rules provide runtime approval guardrails, while `AGENTS.md` defines task scope
and workflow authorization. Per-machine additions belong in
`~/.codex/config.toml` and `~/.codex/rules/`.

## Claude Code (`build/claude/init`, via `make claude-init`)

Wires Claude Code by symlinking `.claude/skills` to `skills/`, symlinking
`.claude/settings.json` to the shared `build/claude/settings.json` permissions
baseline (unless the repo owns a real, non-symlink `settings.json`), and
importing `AGENTS.md` from `CLAUDE.md`; the symlinks target shared paths, so
updating skills or the permissions baseline needs no downstream re-wiring, only
a `git submodule update`.

The baseline starts in Claude Code's default permission mode, enables the Bash
sandbox, and routes direct Bash through the `permissions` allow/ask/deny
guardrails. Direct Bash is broadly allowed without prompting while sandboxed;
project-local operations stay autonomous, recognized remote and
external-service changes require approval, and catastrophic commands remain
forbidden. The unsandboxed escape hatch is disabled. The sandbox grants the
standard Go, RuboCop, golangci-lint, and Trivy cache writes needed by project
commands plus standard system temporary directories, and allows unrestricted
outbound network access to match the Codex profile, with macOS `trustd` access
enabled so Go-based CLI tools (`gh`, `gcloud`, `terraform`) can verify TLS
through the sandbox network proxy. Every `make` invocation is excluded from the
sandbox and allowed without prompting. Built-in file reads and edits are scoped
to the workspace plus the standard system temporary directories (`/tmp`,
`/private/tmp`, `/var/tmp`, `/var/folders`), which are readable and writable
without prompting. Per-repo or per-machine permission tweaks belong in the
gitignored `.claude/settings.local.json`, which Claude Code merges over the
baseline.
