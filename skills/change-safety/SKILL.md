---
name: change-safety
description: Protects documented interfaces, compatibility, security, generated files, dependencies, and migration paths during code or configuration changes. Use before edits that may affect APIs, commands, flags, environment variables, file formats, Make targets, docs, auth, shell execution, or user-facing behavior.
---

# Change Safety

## Steps

1. Identify whether the requested change touches a user-facing or documented interface.
2. Read `references/safety-checks.md` before editing compatibility-sensitive, security-sensitive, generated, vendored, or documented behavior.
3. Preserve existing behavior unless the user explicitly requests a breaking change or the fix requires one.
4. Update documentation in the repository's existing style when behavior, usage, or migration expectations change.
5. Report safety-relevant notes using the exact structure in `references/safety-checks.md`; do not add, remove, rename, or reorder sections.

## References

- Read `references/safety-checks.md` for compatibility, migration, security, generated-file, vendored-file, dependency, and documentation-scope decisions.
