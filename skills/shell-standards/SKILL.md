---
name: shell-standards
description: Applies this repository ecosystem's Bash scripting, ShellCheck, text-processing, directory-scope, naming idiom, and function documentation conventions. Use when writing, reviewing, refactoring, linting, or documenting shell scripts in repos that use this shared ./bin tooling; pair with $naming-standards when names or renames are part of the change.
---

# Shell Standards

## Steps

1. Confirm the task touches shell scripts, shell linting, shell documentation, or script behavior.
2. Read `references/conventions.md` before editing script structure, ShellCheck directives, text processing, directory handling, or functions.
3. Preserve the repository's existing shell style, argument handling, command wrappers, and test harness choices. Do not assume shell changes require shell-native tests; use `$testing-standards` to identify the majority relevant existing harness first.
4. Use Bash for scripts with `#!/usr/bin/env bash` and catch failures early with `set -eo pipefail`.
5. Pair this skill with `$naming-standards` when creating, reviewing, or renaming scripts, functions, flags, environment variables, files, tests, fixtures, or documentation terms.
6. Pair this skill with `$security-audit` for `eval`, shell-command construction, broad file deletion/writes, downloads, temp files, env/secrets, or other trust-boundary changes.
7. Pair this skill with `$testing-standards` when designing, reviewing, or refactoring script behavior tests.
8. Pair this skill with `$change-validation` when selecting ShellCheck or script lint commands.

## References

- Read `references/conventions.md` for Bash, ShellCheck, text-processing, directory-scope, and function documentation conventions.
