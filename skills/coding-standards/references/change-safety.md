# Change Safety Reference

Use this reference when deciding how to handle compatibility, documentation, security, and other safety-sensitive edges of a change.

## Backward Compatibility

- Avoid silently breaking user-facing or documented APIs, exported symbols, commands, flags, env vars, config keys, file formats, and Make targets.
- Preserve existing behavior for downstream consumers when feasible.
- If a breaking change is necessary, call it out explicitly and document the migration impact.

## Migration And Deprecation

- If a change needs consumer action, document the migration path as part of the work.
- When downstream users are affected, prefer compatibility-preserving transitions over abrupt removal.
- Document replacement guidance and cleanup expectations for temporary compatibility paths.

## Security Defaults

- Do not commit secrets or sample credentials that look real.
- Be careful with shell execution, filesystem writes, path handling, auth flows, and untrusted input.
- Prefer safe defaults and call out security-sensitive tradeoffs.

## Generated And External Files

- Do not hand-edit generated code unless the repository clearly expects that.
- Do not modify vendored code unless the task explicitly requires it.
- Update lockfiles only when dependency changes actually require it.
- When regeneration is needed, prefer the repository's documented generation command.

## Documentation Scope

- When behavior or operator-facing usage changes, update the corresponding docs in the repository's established locations.
- Prefer updating existing documentation files over creating new ones unless the repository clearly expects a new document.
- Place examples where the repository already expects them, such as inline docs, example tests, or README snippets.
- If user-facing behavior changes, update README snippets, examples, changelog entries, or operator docs when the repository uses them.
- Keep documentation aligned with the shipped behavior, not the intended behavior.
