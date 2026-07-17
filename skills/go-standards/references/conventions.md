# Go Conventions

Use this reference when working in Go repositories.

## User-Facing APIs

- Before adding or changing exported Go packages, types, interfaces,
  constructors, functions, methods, or documented examples, sketch the intended
  Go caller first. Use that call site to decide package home, public noun,
  ownership, lifecycle symmetry, and whether callers should construct the value
  or receive it from an owner.
- Keep user-facing or documented Go packages, types, functions, and methods consistent with the repository's existing Go style and API shape.
- Prefer straightforward package and type names over clever aliases or indirection.
- Keep implementation contracts as simple as the supported path allows. Do not
  add defensive state, nil guards, idempotency guards, synchronization, recovery
  paths, or fallback behavior only because a caller could misuse an API or an
  impossible state is imaginable. Add that defensiveness only when a supported
  wiring path, documented public contract, observed bug, concurrency boundary,
  security boundary, or realistic external input can trigger it. Otherwise make
  the narrower contract explicit in code or GoDoc and let misuse fail plainly.
- When adding configuration, classify each field before choosing its home:
  shared mechanics, domain-specific behavior, or test/setup convenience. Keep
  shared config limited to behavior that is truly transport-, backend-, or
  domain-agnostic. Put domain-specific classification near the package that owns
  the native concept.
- Do not overload policy callbacks with unrelated decisions. A policy should
  answer one domain question, such as operation eligibility; separate failure
  classification, routing, formatting, or transport-specific matching into
  owned config or helpers.
- Prefer native domain types over wrapper types unless the wrapper adds
  validation, behavior, compatibility, or a repository-owned abstraction.

## Abstractions And Helpers

- Keep code direct until an abstraction earns its name. Do not extract a
  function, method, interface, wrapper, or package only because a statement can
  be moved behind a name.
- A one-line helper is useful only when it explains a real domain concept,
  centralizes a supported boundary, preserves compatibility, hides non-obvious
  error/lifecycle semantics, removes repeated tricky logic, or matches an
  established local pattern. Otherwise keep the call inline.
- Do not add interfaces, callback seams, option objects, or wrapper functions
  for speculative flexibility. Add them when a current caller, test harness,
  external boundary, or repository pattern needs the extra shape.
- During refactor passes, inline helpers that merely restate their only call,
  especially when the helper name is no clearer than the wrapped expression.
- When a helper grows a long parameter list, separate stable configuration from
  per-call data before adding a new abstraction. Prefer an existing receiver
  type when it already owns the state; use closure capture for small local
  behavior; add a private struct only when it clarifies ownership or removes a
  real data clump.

## Documentation

- User-facing or documented Go APIs need clear, accurate, and detailed GoDoc for packages, exported types, functions, methods, constants, variables, and other supported entrypoints.
- Go doc comments should directly precede the declaration they document with no intervening blank line.
- Go doc comments for exported identifiers should start with the documented identifier where appropriate so generated documentation and summaries read clearly.
- GoDoc must still follow `$doc-standards`: do not write comments that only restate the declaration, obvious type shape, or implementation. Prefer contract, behavior, error semantics, compatibility, side effects, constraints, or examples that generated docs cannot infer from the signature.
- For Go aliases, re-exports, and thin wrappers, keep GoDoc minimal: say that the identifier aliases, re-exports, or wraps the canonical identifier to keep call sites on the project-owned surface or reduce repeated imports, and link to the canonical package documentation when practical. Mention compatibility only when that is the real reason. Do not copy the upstream GoDoc into the alias.
- Keep package-level GoDoc in `doc.go` files.
- Do not leave package documentation comments on unrelated source files such as `main.go`, `client.go`, or `types.go`.
- For reusable Go libraries, prefer executable examples in `*_test.go` using
  Go's `Example`, `ExampleType`, `ExampleType_Method`, or equivalent example
  forms when an example teaches public API usage. README examples should stay
  minimal and link to GoDoc, package docs, or executable examples.
- Keep examples aligned with the real public interface and expected calling
  style. Do not accept README-only examples as sufficient when a non-trivial
  reusable API should be documented by an executable Go example and the
  repository's harness supports it.
- When package documentation needs to change, update `doc.go` rather than scattering package comments across implementation files.
- Preserve `Deprecated:` paragraphs in doc comments when documenting compatibility guidance for identifiers that remain available but should not be used.

## Testing

- Follow `$testing-standards` for cross-language test design, coverage, fixtures, determinism, and test-layer decisions.
- Infer the project type from the majority relevant existing tests and CI before recommending or adding tests. Go libraries commonly use unit and integration tests, while services in this ecosystem may be exercised primarily through another language or harness.
- Do not create Go `*_test.go` files solely because the production code is Go. If the majority relevant coverage uses another language or harness, update that harness unless the changed surface is specifically a Go package/API contract that cannot be covered there or the user explicitly asks for Go-level coverage. Stop and ask before taking either exception.
- In this repository ecosystem, prefer `github.com/stretchr/testify/require` when adding assertion-based tests unless the package already uses a different local pattern.
- When changing Go tests, scan changed `require.True`, `require.False`, `require.Equal`, `require.EqualValues`, `require.Less`, and `require.LessOrEqual` calls. Repeated or scenario-sensitive boolean and numeric assertions should include a message unless the test or subtest name already makes the behavior obvious.
- Use this decision gate before creating or changing a Go test file: default to an external test package named `<package>_test`; use the production package only after explaining why the public or documented entrypoint cannot cover the behavior.
- Keep Go benchmark functions in `benchmark_test.go` and fuzz functions in
  `fuzz_test.go`. When reviewing Go tests, flag benchmark or fuzz entrypoints
  placed in other `*_test.go` files.
- Before adding or approving Go benchmarks or fuzz tests, require a concrete
  repository-owned reason: a performance contract or performance question for
  benchmarks, or an input/state space risk, parser/decoder surface,
  concurrency/state-machine invariant, or regression history for fuzz tests.
- Do not benchmark or fuzz aliases, re-exports, or thin wrappers that only
  delegate to a canonical implementation unless the test states an explicit
  rationale, such as compatibility/parity with the canonical surface or wrapper
  overhead for a supported public contract. Otherwise prefer ordinary behavior
  tests, executable examples, repository validation, or no new coverage.
- Do not write internal Go tests in the production package just to reach unexported functions, methods, fields, or collaborators.
- Keep test cases and test functions first in the file. Place fakes, stubs, spies, mock implementations, and helper types after the tests at the bottom of the file.

## Audit And Validation

- When a code, reliability, security, test-gap, or review workflow audits Go
  behavior, pair the selected skill's shared inventory and confidence rules with
  Go-specific coverage accounting when the repository exposes the relevant
  commands.
- Use `go list ./...` or the repository-defined equivalent to record Go package
  count when the requested scope is broad enough for package inventory to affect
  confidence. Name excluded paths such as `bin/**`, `vendor/**`, generated
  folders, caches, build output, and intentionally skipped packages.
- For broad Go audits, consider major reviewed groups such as config/CLI,
  DI/module/lifecycle, HTTP/gRPC transport, token/access/limiter, SQL/cache,
  encoding/compress, telemetry/feature/events, crypto, and
  health/debug/time/id/helpers when those groups exist in the repository.
- Preflight Go tool availability only when repository Make targets, CI,
  scripts, or tests require it. Common tools in this ecosystem include the Go
  toolchain, `betteralign`, `golangci-lint`, `buf`, `govulncheck`, Trivy,
  sidecars, and service dependencies.
- Preserve Go tooling nuance in audit notes: `betteralign` may report
  `./... matched no packages` in a restricted sandbox or stale tool context;
  `go test`, `make specs`, and `httptest` may need localhost listener
  permissions; and `govulncheck`, Trivy, and Buf may need cache writes under
  the user home directory. A sandbox failure is not automatically a repository
  finding.

## Method Layout

- For types with both exported and unexported methods, keep exported methods near the top of the type's method group and unexported methods below them.

## External Style References

- When this repository does not state a more specific convention, use Effective Go, the Google Go Style Guide, and the Uber Go Style Guide as advisory references.
- Repository-local conventions take precedence over external style guides.

## Imports And Naming

- Use `$naming-standards` for concept clarity, vocabulary consistency, abstraction level, public terminology, and rename safety. Use this section for Go-specific package, import, alias, wrapper, and identifier idioms.
- Apply these import rules while writing or reviewing code, before adding, approving, or keeping a direct import or alias.
- Before writing code that adds or changes imports, inspect nearby files in the same package and adjacent packages for existing import names and package patterns. Match the existing unaliased package name unless a real collision requires otherwise.
- Resolve wrapper ownership before deciding import aliases: first decide whether code should use or expand a project wrapper, then decide whether any remaining import needs an alias. Do this before accepting aliases such as `stdtime`, `upstreamjwt`, or `externalbcrypt`.
- Do not alias a Go import unless there is a real collision, the file would not compile without it, or an established local pattern requires it. Do not preemptively alias imports for readability, brevity, style, caution, personal clarity, or guesswork.
- Being cautious is not a valid import-alias reason. If nearby code imports a package unaliased, use the same unaliased form unless a real compile-time collision exists.
- Treat existing aliases as potentially intentional. If an alias is already present and no collision is obvious, or if the alias merely feels awkward, do not remove or rename it during cleanup. In style-review, flag the alias as a non-blocking note and let the human decide whether to change it.
- Being inside a package with the same package name as an imported dependency is not, by itself, a collision. For example, `package jwt` may import `github.com/golang-jwt/jwt/v4` unaliased as `jwt`; do not invent aliases such as `webtoken` or `upstreamjwt` solely to distinguish "ours" from "upstream" inside the wrapper package.
- If a project package has the same name as a standard-library package, keep the project package unaliased. Prefer existing project package functionality over importing the standard-library package directly. If the project package is a wrapper around the standard-library package, do not default to aliasing the standard-library package as `std<name>` at call sites; first use the project wrapper or add the missing thin wrapper surface when the wrapper already owns that concept.
- If a project package wraps or centralizes another project, standard-library, or external package, prefer the existing project wrapper package when that matches the repository's API shape. A project wrapper exists to prevent call sites from repeatedly reaching through to the wrapped dependency.
- Do not expand a project wrapper solely to avoid importing the standard library, to avoid an import alias, or to satisfy an ambiguous "use our own package" request. Add wrapper surface only when the package already owns that exact concept, the API is clearly useful beyond one call site, and the user has agreed to the public API expansion.
- When a project package wraps or centralizes another package, consider expanding the project wrapper with a narrow missing constant, type alias, helper, constructor, or contract-checking function before importing the wrapped package directly from nearby code or tests. Keep the added wrapper surface within the package's documented responsibility. Import the wrapped package directly when the needed API is outside that responsibility, too broad to wrap honestly, only useful at one call site, or would make the project wrapper misleading.
  For example, in any Go repository using this skill, if a project package named `time` wraps the standard library `time`, and a call site needs `time.Now`, `time.Since`, `time.Until`, `time.Sleep`, `time.NewTimer`, or `time.NewTicker`, use the project wrapper's `time.Now`, `time.Since`, `time.Until`, `time.Sleep`, `time.NewTimer`, or `time.NewTicker` instead of importing the standard library as `stdtime`. If a narrow standard-library time concept is missing and belongs to the wrapper's contract, add it to the wrapper rather than making each call site bypass the wrapper.
  For example, if `crypto/bcrypt` wraps `golang.org/x/crypto/bcrypt` and a test needs `Cost` or `DefaultCost` to verify the wrapper's hashing contract, add `crypto/bcrypt.Cost` or `crypto/bcrypt.DefaultCost` instead of importing `golang.org/x/crypto/bcrypt` in the test.
  Apply the same decision to any project package that wraps a standard-library, external, or lower-level project package; these package names are examples, not special cases.
- If two project packages have the same package name or would collide in one file, inspect their dependency direction and domain ownership before choosing aliases. Keep the base or depended-on package unaliased, and alias the more-specific dependent package with its qualifier, such as `transportmeta` for `transport/meta` when it depends on `meta`.
- If a project and external package overlap conceptually, prefer the project-owned domain package. For example, telemetry wrappers should own imports from OpenTelemetry or external metrics packages when that is the repository pattern.
- Treat named packages in these rules as examples, not a fixed list. Apply the same ownership, wrapper, and dependency-direction checks to any package pair.
- If there is no collision, use the package's declared name and do not alias it.
- If the collision is at identifier level rather than import level, alias or rename only the referenced non-project type, function, or variable when possible.
- Keep required aliases short, obvious, and specific to the package or domain they disambiguate.
- If ownership, dependency direction, or wrapper intent is unclear, ask before choosing an import alias or bypassing a project package.
