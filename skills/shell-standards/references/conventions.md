# Shell Conventions

Use this reference when working with shell scripts.

## Script Baseline

- Use Bash for scripts with `#!/usr/bin/env bash`.
- Catch failures early with `set -eo pipefail`.
- In standalone executable scripts, include a descriptive and accurate comment near the top that explains the script's purpose.
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

- Prefer validating shell changes through public or documented commands, scripts, Make targets, and argument flows.
- Reuse the repository's existing script tests, feature flows, lint targets, and validation entrypoints before adding ad hoc checks.
- Cover relevant failure paths such as invalid arguments, missing files/tools, non-zero commands, path errors, permissions, and argument pass-through.
- Keep checks deterministic and avoid relying on the caller's real home directory, global config, network, wall-clock time, or shared mutable state.
- Use internal helper seams only when the repository already tests that way, the behavior cannot be exercised credibly through the established command path, or the change has no stable public surface.
- When internal checks are necessary, keep them focused and still run public-path validation when practical.

## Functions

- In included or sourced shell library files, typically files ending in `.sh`, add comments for public functions.
- In included or sourced shell library files, functions starting with `_` are private and do not require comments.
- In standalone executable scripts, functions do not need a leading `_` just to avoid public API treatment.
- In standalone executable scripts, add descriptive and accurate comments for helper functions.
- Keep function names and call patterns aligned with the surrounding script.

## ShellCheck

- Use ShellCheck for linting.
- Disable ShellCheck rules only at the narrowest useful scope and only when the script actually violates an intentional pattern.
- Commonly disabled rules in this repository are `SC1010`, `SC1091`, `SC2034`, `SC2086`, `SC2154`, and `SC2155`.
