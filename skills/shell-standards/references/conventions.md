# Shell Conventions

Use this reference when working with shell scripts.

## Script Baseline

- Use Bash for scripts with `#!/usr/bin/env bash`.
- Catch failures early with `set -eo pipefail`.
- Preserve existing argument handling, command wrappers, and pass-through semantics.

## Text Processing

- Prefer `sed` or `awk` for text manipulation when shell tooling is the right fit.
- Keep transformations readable and scoped to the command that needs them.

## Directory Scope

- When a command needs to run from another directory, use a subshell such as `(cd path && command)`.
- Avoid changing the caller's working directory as a side effect.

## Functions

- Add comments for public functions.
- Functions starting with `_` are private and do not require comments.
- Keep function names and call patterns aligned with the surrounding script.

## ShellCheck

- Use ShellCheck for linting.
- Disable ShellCheck rules only at the narrowest useful scope and only when the script actually violates an intentional pattern.
- Commonly disabled rules in this repository are `SC1010`, `SC1091`, `SC2034`, `SC2086`, `SC2154`, and `SC2155`.
