---
name: change-safety
description: Use when changes may affect compatibility, documented interfaces, migrations, generated files, dependencies, or user-facing behavior. Protect APIs, commands, flags, environment variables, file formats, Make targets, docs, auth, and shell execution; use code-review for general bug finding.
---

# Change Safety

## Steps

1. Identify whether the requested change touches a user-facing or documented interface.
2. Read `references/safety-checks.md` before editing compatibility-sensitive, security-sensitive, generated, vendored, or documented behavior.
3. Preserve existing behavior unless the user explicitly requests a breaking change or the fix requires one.
4. Update documentation and examples in the repository's existing style when behavior, usage, or migration expectations change; if no docs update is needed for a user-facing change, state why.
5. For security-specific risk analysis, pair with `$security-audit` instead of expanding this skill into a full audit.
6. When safety notes are the final response, use the exact structure in `references/safety-checks.md`; do not add, remove, rename, or reorder sections.
7. When another skill embeds safety notes, preserve compatibility, migration, security, and generated/external-file facts in the caller's output format.

## References

- Read `references/safety-checks.md` for compatibility, migration, security, generated-file, vendored-file, dependency, and documentation-scope decisions.
