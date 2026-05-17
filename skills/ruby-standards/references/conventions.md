# Ruby Conventions

Use this reference when working in Ruby repositories.

## User-Facing APIs

- Keep user-facing or documented Ruby modules, classes, and methods consistent with the repository's existing Ruby style and API shape.
- Prefer straightforward Ruby over clever metaprogramming unless the repository already uses that pattern or the task clearly requires it.
- Avoid monkey patches unless the repository explicitly relies on them.

## Documentation

- User-facing or documented Ruby APIs need clear, accurate, and detailed RDoc for modules, classes, methods, and other supported entrypoints.
- When a user-facing or documented API is non-trivial, include examples if the repository's documentation style supports them.
- Keep examples aligned with the real public interface and expected calling style.

## Testing

- Reuse the repository's existing test, feature, fixture, helper, assertion, and naming patterns before adding new structure.
- Infer the project type from existing tests and CI: Ruby libraries commonly use unit and integration tests such as RSpec, while services in this ecosystem commonly use Cucumber feature flows.
- Prefer testing through the repository's established public or documented Ruby APIs, commands, tasks, or feature flows so coverage reflects real consumer behavior.
- Do not introduce a new Ruby test framework, fixture layout, or test layer unless the task explicitly changes testing infrastructure.
- Keep tests deterministic and cover relevant failure paths for changed behavior.
- Use internal seams only when the repository already tests that way, the behavior cannot be exercised credibly through the established public surface, or the change has no stable public surface.
- When internal tests are necessary, keep them focused and still run public-path validation when practical.

## External Style References

- When this repository does not state a more specific convention, use the RuboCop Ruby Style Guide and the Shopify Ruby Style Guide as advisory references.
- Repository-local conventions take precedence over external style guides.

## Conventions

- Keep method signatures, return shapes, exceptions, and side effects aligned with the repository's existing Ruby conventions.
- Prefer explicit objects and methods over clever DSLs or implicit behavior unless the repository already uses that style.
- When changing a documented command or task interface, update the corresponding docs and examples in the repo's established locations.
- Match the repository's established naming, error-handling, and test idioms instead of imposing a global Ruby style.
