---
name: shell-standards
description: Applies this repository ecosystem's Bash scripting, ShellCheck, text-processing, directory-scope, and function documentation conventions. Use when writing, reviewing, refactoring, linting, or documenting shell scripts in repos that use this shared ./bin tooling.
---

# Shell Standards

## Steps

1. Confirm the task touches shell scripts, shell linting, shell documentation, or script behavior.
2. Read `references/conventions.md` before editing script structure, ShellCheck directives, text processing, directory handling, or functions.
3. Preserve the repository's existing shell style, argument handling, and command wrappers.
4. Use Bash for scripts with `#!/usr/bin/env bash` and catch failures early with `set -eo pipefail`.
5. Pair this skill with `$security-audit` for `eval`, shell-command construction, broad file deletion/writes, downloads, temp files, env/secrets, or other trust-boundary changes.
6. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring script behavior tests.
7. Pair this skill with `change-validation` when selecting ShellCheck or script lint commands.

## References

- Read `references/conventions.md` for Bash, ShellCheck, text-processing, directory-scope, and function documentation conventions.
