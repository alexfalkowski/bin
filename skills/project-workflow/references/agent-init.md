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
invocation is allowed outside the sandbox without prompting, except `make
pr`, `make draft`, `make merge`, `make ready`, and `make review`, which
remain approval-gated because they create, merge, or force-push a pull
request; cleanup inside writable roots is prompt-free, direct remote and
external-service commands remain approval-gated, and catastrophic commands
remain forbidden. Root `.env`
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
through the sandbox network proxy. It also allows binding to local ports (for
local dev servers and tests) and all Unix domain socket connections (for
Docker, ssh-agent, and local database sockets); the latter can grant effective
host access through sockets like `/var/run/docker.sock`, so keep using these
profiles only in trusted repositories. Every `make` invocation is excluded from the
sandbox and allowed without prompting, except `make pr`, `make draft`, `make
merge`, `make ready`, and `make review`, which require approval because they
create, merge, or force-push a pull request. Built-in file reads and edits are scoped
to the workspace plus the standard system temporary directories (`/tmp`,
`/private/tmp`, `/var/tmp`, `/var/folders`), which are readable and writable
without prompting. Per-repo or per-machine permission tweaks belong in the
gitignored `.claude/settings.local.json`, which Claude Code merges over the
baseline.

## Background process lifecycle and signal handling

Manually backgrounding a long-lived process (a bare `&`/`nohup`, for example
to debug a dev or test server) that outlives the tool call that started it
behaves differently under each assistant's sandbox; do not assume one
generalizes to the other.

### Claude Code

The sandbox denies real signal delivery from a bare Bash command against any
process that outlived the tool call that spawned it, even one owned by the
same user — `kill`, `kill -0`, `kill -9`, and `kill -1` all fail with
"operation not permitted"; there is no cross-call existence check either.
Signals only work within the same tool call, against the current shell or a
child it just spawned. A process backgrounded with a bare `&`/`nohup`
therefore cannot be inspected or stopped once the tool call that started it
returns: it leaks, holds its port, and blocks subsequent runs until a human
kills it from outside the sandbox. Use the Bash tool's `run_in_background`
option instead, and stop the resulting task with the matching background-task
stop tool keyed by that task's ID; this does not hit the signal restriction.
One test spawning a parent process with a grandchild TCP listener observed
the stop call killing both, but that is a single observation, not a confirmed
guarantee across sandbox versions or configurations.

### Codex

Repeated probes in this runtime observed a tool-call-boundary difference:
`kill`/`kill -0` against a self-backgrounded process succeeds in the same
tool call that spawned it, while a later, separate tool call received
"operation not permitted" for both the recorded PID and its process group.
This is observed runtime behavior, not a confirmed general Codex property; it
may vary by version, sandbox configuration, or runtime, so treat cross-call
signal delivery as unreliable. A pidfile plus process group is not a safe
substitute: `setsid` may be unavailable, and a nonzero `kill -0` result alone
cannot establish cleanup in a later call, since it can mean "operation not
permitted" rather than "no such process." Same-call cleanup can remove a
parent and ordinary forked children that remain in an explicitly managed
process group when the cleanup mechanism is verified to signal that group,
but does not guarantee cleanup of a descendant that creates its own session
or process group (for example via `setsid`). The
`exec_command`/`unified_exec` tool has no documented parameter to background a
command and later terminate it. The CLI-level `/ps` and `/stop` commands are
documented, but are not confirmed working or descendant-tree-safe by testing
in this runtime. Do not manually start a process that needs to survive beyond
the current tool call; for bounded helpers, keep startup, use, and cleanup
within one call where possible.
