# Go Reference

Use this reference when working in Go repositories.

## User-Facing APIs

- Keep exported or documented Go APIs aligned with the repository's existing package shape and naming style.
- Prefer straightforward package and type names over clever aliases or indirection.

## Documentation

- Keep package-level GoDoc in `doc.go` files.
- Do not leave package documentation comments on unrelated source files such as `main.go`, `client.go`, or `types.go`.
- When package documentation needs to change, update `doc.go` rather than scattering package comments across implementation files.

## Imports And Naming

- Do not alias a Go import unless there is a real collision or required disambiguation.
- If a project package has the same name as a Go standard-library package, prefer the project package as the natural import in local code.
- Keep the project package unaliased when possible so the code reads in the repository's domain language.
- Alias only the standard-library import instead of forcing an awkward alias onto the project package.
- If the collision is at identifier level rather than import level, alias or rename only the referenced stdlib type, function, or variable needed to keep the code correct and readable.
- Keep aliases short, obvious, and specific to the standard-library package they disambiguate.
- If there is no collision, import the package without an alias.
- When there is a collision, alias only what is needed on the stdlib side so the project's own package remains the default name in local code and the import block stays minimal.
