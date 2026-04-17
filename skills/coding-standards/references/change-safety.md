# Change Safety Reference

Use this reference when deciding how far a change should go and what must accompany it.

## Tests

- If behavior changes, add or update tests unless the repository truly cannot support it.
- Prefer the narrowest tests that prove the new or changed behavior.
- If tests are not added, state why plainly in the final response.

## Dependencies

- Prefer the standard library and dependencies that are already in the repository before adding a new one.
- Add or update dependencies only when they clearly reduce risk, complexity, or maintenance cost.
- Keep dependency changes narrowly scoped and explain why they are needed.

## Backward Compatibility

- Avoid silently breaking public APIs, exported symbols, commands, flags, env vars, config keys, file formats, and Make targets.
- Preserve existing behavior for downstream consumers when feasible.
- If a breaking change is necessary, call it out explicitly and document the migration impact.

## Migration And Deprecation

- If a change needs consumer action, include a migration path as part of the work.
- Prefer deprecation and staged rollout over abrupt removal when downstream users may be affected.
- Document replacement guidance and cleanup expectations for temporary compatibility paths.

## Performance And Observability

- For hot paths, high-volume flows, or potentially expensive operations, consider performance impact before shipping.
- Add or update benchmarks when performance is material and the repository supports them.
- Keep new runtime behavior observable through the repo's existing logging, metrics, tracing, or error-reporting patterns.
- Prefer observability that helps explain production behavior over silent internal complexity.

## Security Defaults

- Do not commit secrets or sample credentials that look real.
- Be careful with shell execution, filesystem writes, path handling, auth flows, and untrusted input.
- Prefer safe defaults and call out security-sensitive tradeoffs.

## Generated And External Files

- Do not hand-edit generated code unless the repository clearly expects that.
- Do not modify vendored code unless the task explicitly requires it.
- Update lockfiles only when dependency changes actually require it.
- When regeneration is needed, prefer the repository's documented generation command.

## Temporary Code Hygiene

- Remove debug prints, temporary instrumentation, dead code, and throwaway TODOs before finishing the change.
- Keep temporary compatibility shims only when they are part of the intended rollout and call out their cleanup expectations.
- Do not leave behind scaffolding that obscures the steady-state design unless it is clearly intentional.

## Documentation Scope

- Public code needs accurate GoDoc, RDoc, or the repository's native API docs.
- Non-trivial public APIs should include examples when the repository's documentation style supports them.
- Prefer updating existing documentation files over creating new ones unless the repository clearly expects a new document.
- Place examples in the repository's established locations, such as inline docs, example tests, or README snippets.
- If user-facing behavior changes, update README snippets, examples, changelog entries, or operator docs when the repository uses them.
- Keep documentation aligned with the shipped behavior, not the intended behavior.
