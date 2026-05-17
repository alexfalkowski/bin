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

- Before adding new test structure, look for existing tests in the package or adjacent packages and reuse their helpers, fixtures, table shapes, assertions, and naming patterns when they fit.
- When new coverage is needed, base it on the testing style already present in the repository rather than introducing a new pattern.
- Infer the project type from existing tests and CI: Go libraries commonly use unit and integration tests, while services in this ecosystem may rely on Cucumber feature flows around the service.
- Prefer testing through the repository's established public or documented Go APIs, commands, or service entrypoints so coverage reflects real consumer behavior.
- Do not introduce a new Go test framework, fixture layout, or test layer unless the task explicitly changes testing infrastructure.
- Keep tests deterministic and cover relevant failure paths for changed behavior.
- In this repository ecosystem, prefer `github.com/stretchr/testify/require` when adding assertion-based tests unless the package already uses a different local pattern.
- Prefer external test packages named `<package>_test` when the behavior can be exercised through the public interface.
- Use internal package tests only when the repository already tests that way, the behavior cannot be exercised credibly through the established public surface, or the change has no stable public surface.
- When internal tests are necessary, keep them focused and still run public-path validation when practical.
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
