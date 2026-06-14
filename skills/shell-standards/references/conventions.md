# Shell Conventions

Use this reference when working with shell scripts.

## Script Baseline

- Use Bash for scripts with `#!/usr/bin/env bash`.
- Catch failures early with `set -eo pipefail`.
- In standalone executable scripts, include a descriptive and accurate comment near the top that explains the script's purpose.
- Script and function comments must follow `$doc-standards`: do not narrate obvious commands, assignments, flag parsing, or control flow. Explain purpose, non-obvious environment assumptions, compatibility constraints, external command quirks, security-sensitive behavior, or cleanup requirements.
- Preserve existing argument handling, command wrappers, and pass-through semantics.

## External Style References

- When this repository does not state a more specific convention, use the Google Shell Style Guide and Wooledge BashGuide Practices as advisory references.
- Repository-local conventions take precedence over external style guides.

## Text Processing

- Prefer `sed` or `awk` for text manipulation when shell tooling is the right fit.
- Keep transformations readable and scoped to the command that needs them.

## Directory Scope

- When a command needs to run from another directory, use a subshell such as `(cd path && command)`.
- Avoid changing the caller's working directory as a side effect.

## Testing

- Follow `$testing-standards` for cross-language test design, coverage, fixtures, determinism, and test-layer decisions.
- Prefer validating shell changes through public or documented commands, scripts, Make targets, and argument flows.
- Do not create shell-native tests solely because the production code is shell. If the majority relevant coverage uses another language or harness, update that harness unless the changed surface is specifically a shell library or script contract tested at that layer.
- Cover relevant failure paths such as invalid arguments, missing files/tools, non-zero commands, path errors, permissions, and argument pass-through.

## Functions

- Use `$naming-standards` for concept clarity, vocabulary consistency, abstraction level, public terminology, and rename safety. Use this reference for shell-specific script, function, flag, environment variable, and file idioms.
- In included or sourced shell library files, typically files ending in `.sh`, add comments for public functions.
- In included or sourced shell library files, functions starting with `_` are private and do not require comments.
- In standalone executable scripts, functions do not need a leading `_` just to avoid public API treatment.
- In standalone executable scripts, add descriptive and accurate comments for helper functions only when the function purpose or constraint is not already obvious from its name and local call pattern.
- Keep function names and call patterns aligned with the surrounding script.

## ShellCheck

- Use ShellCheck for linting.
- Disable ShellCheck rules only at the narrowest useful scope and only when the script actually violates an intentional pattern.
- Commonly disabled rules in this repository are `SC1010`, `SC1091`, `SC2034`, `SC2086`, `SC2154`, and `SC2155`.
