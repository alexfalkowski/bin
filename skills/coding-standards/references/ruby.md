# Ruby Reference

Use this reference when working in Ruby repositories.

## User-Facing APIs

- Keep user-facing or documented modules, classes, and methods consistent with the repository's existing Ruby style and API shape.
- Prefer straightforward Ruby over clever metaprogramming unless the repository already uses that pattern or the task clearly requires it.
- Avoid monkey patches unless the repository explicitly relies on them.

## Documentation

- User-facing or documented Ruby APIs need accurate RDoc for modules, classes, methods, and other supported entrypoints.
- When a user-facing or documented API is non-trivial, include examples if the repository's documentation style supports them.
- Keep examples aligned with the real public interface and expected calling style.

## Conventions

- Keep method signatures, return shapes, exceptions, and side effects aligned with the repository's existing Ruby conventions.
- Prefer explicit objects and methods over clever DSLs or implicit behavior unless the repository already uses that style.
- When changing a documented command or task interface, update the corresponding docs and examples in the repo's established locations.
- Match the repository's established naming, error-handling, and test idioms instead of imposing a global Ruby style.
