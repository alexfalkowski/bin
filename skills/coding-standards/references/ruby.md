# Ruby Reference

Use this reference when working in Ruby repositories.

## Public APIs

- Keep public modules, classes, and methods consistent with the repository's existing Ruby style and API shape.
- Prefer straightforward Ruby over clever metaprogramming unless the repository already uses that pattern or the task clearly requires it.
- Avoid monkey patches unless the repository explicitly relies on them.

## Documentation

- Public Ruby APIs need accurate RDoc for modules, classes, and public methods.
- When a public API is non-trivial, include examples if the repository's documentation style supports them.
- Keep examples aligned with the real public interface and expected calling style.

## Dependencies And Style

- Prefer the standard library and existing project dependencies before adding new gems.
- Match the repository's established naming, error-handling, and test idioms instead of imposing a global Ruby style.
