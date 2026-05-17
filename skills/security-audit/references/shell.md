# Shell Security Audit

Use this reference for Bash scripts, Make recipes that execute shell code, Docker helper scripts, and command wrappers.

## Inspect

- Quoting: quote variable expansions unless intentional word splitting is documented and safe.
- Shell interpretation: avoid `eval`, `bash -c`, `sh -c`, and interpolated command strings with untrusted input.
- Argument pass-through: preserve argv boundaries with arrays or `"$@"`; document intentional pass-through and ShellCheck disables.
- Filesystem operations: constrain delete/write paths; scrutinize `rm -rf`, `mv`, `cp`, globbing, symlink handling, and relative paths.
- Temp files: use `mktemp`; avoid predictable names and races.
- Downloads and remote execution: avoid `curl | sh`; verify sources and fail closed.
- Environment and secrets: avoid printing secrets with `set -x`, logs, or error messages.
- Error handling: use `set -eo pipefail` where consistent with the repo; handle expected non-zero statuses explicitly.

## Validation

- Prefer repo-defined targets first.
- In this repository, use `make scripts-lint` for ShellCheck coverage of shared scripts.
- For Docker-related script changes, consider `make docker-lint` and `make sec-lint` when relevant.
- ShellCheck is necessary but not sufficient: still inspect trust boundaries, path constraints, and command construction manually.
- Report `make scripts-lint` as not run or no-op if `shellcheck` is unavailable.

## Findings

- Treat untrusted input reaching shell parsing or broad filesystem mutation as high severity unless strongly constrained.
- Include a concrete safer rewrite: arrays, `--` separators, anchored working directories, constrained path checks, or explicit allowlists.
- Pair with `shell-standards`, `change-safety`, and `change-validation` for script changes.
