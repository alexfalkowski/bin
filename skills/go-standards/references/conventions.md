# Go Conventions

Use this reference when working in Go repositories.

## User-Facing APIs

- Keep user-facing or documented Go packages, types, functions, and methods consistent with the repository's existing Go style and API shape.
- Prefer straightforward package and type names over clever aliases or indirection.

## Documentation

- User-facing or documented Go APIs need clear, accurate, and detailed GoDoc for packages, exported types, functions, methods, and other supported entrypoints.
- Keep package-level GoDoc in `doc.go` files.
- Do not leave package documentation comments on unrelated source files such as `main.go`, `client.go`, or `types.go`.
- Keep examples aligned with the real public interface and expected calling style when the repository's documentation style supports them.
- When package documentation needs to change, update `doc.go` rather than scattering package comments across implementation files.

## Testing

- Follow `$testing-standards` for cross-language test design, coverage, fixtures, determinism, and test-layer decisions.
- Infer the project type from existing tests and CI: Go libraries commonly use unit and integration tests, while services in this ecosystem may rely on Cucumber feature flows around the service.
- In this repository ecosystem, prefer `github.com/stretchr/testify/require` when adding assertion-based tests unless the package already uses a different local pattern.
- When changing Go tests, scan changed `require.True`, `require.False`, `require.Equal`, `require.EqualValues`, `require.Less`, and `require.LessOrEqual` calls. Repeated or scenario-sensitive boolean and numeric assertions should include a message unless the test or subtest name already makes the behavior obvious.
- Prefer external test packages named `<package>_test` when the behavior can be exercised through the public interface.
- Keep test cases and test functions first in the file. Place fakes, stubs, spies, mock implementations, and helper types after the tests at the bottom of the file.

## Method Layout

- For types with both exported and unexported methods, keep exported methods near the top of the type's method group and unexported methods below them.

## External Style References

- When this repository does not state a more specific convention, use Effective Go, the Google Go Style Guide, and the Uber Go Style Guide as advisory references.
- Repository-local conventions take precedence over external style guides.

## Imports And Naming

- Do not alias a Go import unless there is a real collision or required disambiguation.
- If a project package has the same name as a standard-library package, keep the project package unaliased and alias only the standard-library import.
- If the collision is at identifier level rather than import level, alias or rename only the referenced standard-library type, function, or variable.
- Keep aliases short, obvious, and specific to the standard-library package they disambiguate.
