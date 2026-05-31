# Go Conventions

Use this reference when working in Go repositories.

## User-Facing APIs

- Keep user-facing or documented Go packages, types, functions, and methods consistent with the repository's existing Go style and API shape.
- Prefer straightforward package and type names over clever aliases or indirection.

## Documentation

- User-facing or documented Go APIs need clear, accurate, and detailed GoDoc for packages, exported types, functions, methods, constants, variables, and other supported entrypoints.
- Go doc comments should directly precede the declaration they document with no intervening blank line.
- Go doc comments for exported identifiers should start with the documented identifier where appropriate so generated documentation and summaries read clearly.
- Keep package-level GoDoc in `doc.go` files.
- Do not leave package documentation comments on unrelated source files such as `main.go`, `client.go`, or `types.go`.
- Keep examples aligned with the real public interface and expected calling style when the repository's documentation style supports them.
- When package documentation needs to change, update `doc.go` rather than scattering package comments across implementation files.
- Preserve `Deprecated:` paragraphs in doc comments when documenting compatibility guidance for identifiers that remain available but should not be used.

## Testing

- Follow `$testing-standards` for cross-language test design, coverage, fixtures, determinism, and test-layer decisions.
- Infer the project type from existing tests and CI: Go libraries commonly use unit and integration tests, while services in this ecosystem may rely on Cucumber feature flows around the service.
- In this repository ecosystem, prefer `github.com/stretchr/testify/require` when adding assertion-based tests unless the package already uses a different local pattern.
- When changing Go tests, scan changed `require.True`, `require.False`, `require.Equal`, `require.EqualValues`, `require.Less`, and `require.LessOrEqual` calls. Repeated or scenario-sensitive boolean and numeric assertions should include a message unless the test or subtest name already makes the behavior obvious.
- Use this decision gate before creating or changing a Go test file: default to an external test package named `<package>_test`; use the production package only after explaining why the public or documented entrypoint cannot cover the behavior.
- Do not write internal Go tests in the production package just to reach unexported functions, methods, fields, or collaborators.
- Keep test cases and test functions first in the file. Place fakes, stubs, spies, mock implementations, and helper types after the tests at the bottom of the file.

## Method Layout

- For types with both exported and unexported methods, keep exported methods near the top of the type's method group and unexported methods below them.

## External Style References

- When this repository does not state a more specific convention, use Effective Go, the Google Go Style Guide, and the Uber Go Style Guide as advisory references.
- Repository-local conventions take precedence over external style guides.

## Imports And Naming

- Use `$naming-standards` for concept clarity, vocabulary consistency, abstraction level, public terminology, and rename safety. Use this section for Go-specific package, import, alias, wrapper, and identifier idioms.
- Apply these import rules while writing or reviewing code, before adding, approving, or keeping a direct import or alias.
- Before writing code that adds or changes imports, inspect nearby files in the same package and adjacent packages for existing import names and package patterns. Match the existing unaliased package name unless a real collision requires otherwise.
- Resolve wrapper ownership before deciding import aliases: first decide whether code should use or expand a project wrapper, then decide whether any remaining import needs an alias.
- Do not alias a Go import unless there is a real collision or required disambiguation. Do not preemptively alias imports for readability, brevity, style, or guesswork.
- If a project package has the same name as a standard-library package, keep the project package unaliased. Prefer adding missing wrapper functionality to the project package over importing the standard-library package directly. If the standard-library import is still needed, alias only that import.
- If a project package wraps or centralizes another project, standard-library, or external package, prefer the project wrapper package and add missing surface there when that matches the repository's API shape.
- When a project package wraps or centralizes an external package, prefer expanding the project wrapper with a narrow missing constant, helper, constructor, or contract-checking function before importing the external package directly from nearby code or tests. Keep the added wrapper surface within the package's documented responsibility. Import the external package directly only when the needed API is outside that responsibility, too broad to wrap honestly, or would make the project wrapper misleading.
  For example, if `crypto/bcrypt` wraps `golang.org/x/crypto/bcrypt` and a test needs `Cost` or `DefaultCost` to verify the wrapper's hashing contract, add `crypto/bcrypt.Cost` or `crypto/bcrypt.DefaultCost` instead of importing `golang.org/x/crypto/bcrypt` in the test.
- If two project packages have the same package name or would collide in one file, inspect their dependency direction and domain ownership before choosing aliases. Keep the base or depended-on package unaliased, and alias the more-specific dependent package with its qualifier, such as `transportmeta` for `transport/meta` when it depends on `meta`.
- If a project and external package overlap conceptually, prefer the project-owned domain package. For example, telemetry wrappers should own imports from OpenTelemetry or external metrics packages when that is the repository pattern.
- Treat named packages in these rules as examples, not a fixed list. Apply the same ownership, wrapper, and dependency-direction checks to any package pair.
- If there is no collision, use the package's declared name and do not alias it.
- If the collision is at identifier level rather than import level, alias or rename only the referenced non-project type, function, or variable when possible.
- Keep required aliases short, obvious, and specific to the package or domain they disambiguate.
- If ownership, dependency direction, or wrapper intent is unclear, ask before choosing an import alias or bypassing a project package.
