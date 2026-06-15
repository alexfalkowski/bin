# Ruby Conventions

Use this reference when working in Ruby repositories.

## User-Facing APIs

- Before adding or changing documented Ruby modules, classes, methods,
  commands, tasks, DSL entrypoints, or examples, sketch the intended Ruby call
  site or command invocation first. Use that caller shape to decide public names,
  ownership, lifecycle, and documentation before writing tests or implementation.
- Keep user-facing or documented Ruby modules, classes, and methods consistent with the repository's existing Ruby style and API shape.
- Prefer straightforward Ruby over clever metaprogramming unless the repository already uses that pattern or the task clearly requires it.
- Avoid monkey patches unless the repository explicitly relies on them.

## Documentation

- User-facing or documented Ruby APIs need clear, accurate, and detailed RDoc for modules, classes, methods, and other supported entrypoints.
- Class and module RDoc should explain the purpose of the API and common uses.
- Method RDoc should cover the synopsis, important examples, arguments when needed, corner cases, exceptions, and related methods when useful.
- RDoc must still follow `$doc-standards`: do not write comments that only restate the class, module, method name, argument names, return type, or obvious implementation. Prefer purpose, contract, examples, exceptions, compatibility, side effects, and constraints that readers cannot infer from the method signature.
- For Ruby aliases, delegated APIs, compatibility shims, or thin wrappers, keep RDoc minimal: say that the API aliases, delegates to, or wraps the canonical API to keep call sites on the project-owned surface or reduce repeated requires/imports, and link to the canonical documentation when practical. Mention compatibility only when that is the real reason. Do not copy the original documentation into the alias.
- When a user-facing or documented API is non-trivial, include examples if the repository's documentation style supports them.
- Keep examples aligned with the real public interface and expected calling style.

## Testing

- Follow `$testing-standards` for cross-language test design, coverage, fixtures, determinism, and test-layer decisions.
- Infer the project type from the majority relevant existing tests and CI before recommending or adding tests. Ruby libraries commonly use unit and integration tests such as RSpec, while services in this ecosystem commonly use Cucumber feature flows, but repository-local patterns take precedence.
- Do not create Ruby tests solely because the production code is Ruby. If the majority relevant coverage uses another language or harness, update that harness unless the changed surface is specifically a Ruby API contract.
- Match the repository's established Ruby test, feature, helper, assertion, and naming idioms.
- When changing RSpec tests, scan changed boolean and numeric expectations such as `be(true)`, `be(false)`, `eq(...)`, comparison matchers, and count/status expectations. Repeated or scenario-sensitive expectations should have descriptive example names, contexts, or failure messages unless the surrounding example already makes the behavior obvious.

## External Style References

- When this repository does not state a more specific convention, use the RuboCop Ruby Style Guide and the Shopify Ruby Style Guide as advisory references.
- Repository-local conventions take precedence over external style guides.

## Conventions

- Keep method signatures, return shapes, exceptions, and side effects aligned with the repository's existing Ruby conventions.
- Prefer explicit objects and methods over clever DSLs or implicit behavior unless the repository already uses that style.
- When changing a documented command or task interface, update the corresponding docs and examples in the repo's established locations.
- Use `$naming-standards` for concept clarity, vocabulary consistency, abstraction level, public terminology, and rename safety. Use this reference for Ruby-specific module, class, method, predicate, bang-method, constant, and test idioms.
- Match the repository's established naming, error-handling, and test idioms instead of imposing a global Ruby style.
