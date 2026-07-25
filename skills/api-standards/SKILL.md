---
name: api-standards
description: Use when designing, reviewing, documenting, or changing an API contract in a repository using this shared tooling, including adding an endpoint or RPC, changing a request/response schema or client interface, or preserving API compatibility. Apply Google Cloud API Design Guide and Google AIP guidance by default; identify the route's real `net/http/rpc`, `net/http/rest`, or `net/http/mvc` transport contract before applying REST rules.
---

# API Standards

## Operating Stance

Treat API shape as a long-lived public contract. Prefer resource-oriented,
consistent, boring APIs over implementation-shaped methods, transport-specific
shortcuts, or one-off naming.

Use this skill for API design judgment. Pair it with `$go-standards` or
`$ruby-standards` when changing Go or Ruby implementation code, with
`$testing-standards` when adding API behavior coverage, with `$doc-standards`
when API docs or comments change, with `$change-safety` for compatibility or
versioning risk, and with `$change-validation` for command selection.

## Authoritative Guides

1. Use the Google Cloud API Design Guide as the default standard:
   `https://docs.cloud.google.com/apis/design`.
2. For gRPC and Protocol Buffer APIs, follow the linked Google AIPs for
   resource-oriented design, resource names, standard methods, custom methods,
   errors, inline documentation, proto3, versioning, backward compatibility,
   file layout, and naming.
3. When local repository contracts, generated protobuf contracts, OpenAPI specs,
   or existing API docs are stricter than the external guides, preserve the
   local contract unless the task explicitly approves a migration.

## Steps

1. Identify the API surface in scope: `.proto`, service method, resource name,
   HTTP mapping, request or response message, REST route, generated client,
   public Go or Ruby API wrapper, documentation, or compatibility policy.
2. Read `references/conventions.md` and identify which of this ecosystem's
   three real `go-service` HTTP transports the specific route or service
   surface uses: `net/http/rpc`, `net/http/rest`, or `net/http/mvc`.
   Identify per route or service surface, not per repository — a `net/http/rest`
   route may serve the request directly or front a generated gRPC client, so
   check the handler body, not just the repository. Treat `net/http/mvc` view
   routes as outside this skill's API-contract scope; do not apply REST/AIP/CRUD
   rules to them.
3. Inspect nearby APIs, generated files, docs, tests, and consumers before
   proposing names, routes, fields, methods, or compatibility changes.
4. Prefer resource-oriented design: stable resources, clear parent-child
   relationships, canonical resource names, collection-oriented `List`, and
   standard `Get`, `Create`, `Update`, and `Delete` behavior before custom
   methods.
5. Use custom methods only when the operation is not a standard resource
   lifecycle action. Name custom methods after the domain action and document
   why a standard method does not fit.
6. Preserve backward compatibility. Treat field removals, field type changes,
   enum value changes, route changes, method renames, response shape changes,
   required-field additions, changed error semantics, and changed pagination or
   filtering behavior as compatibility-sensitive until proven otherwise.
7. Keep request and response schemas explicit. Avoid leaking storage models,
   framework types, transport-only names, private implementation details, or
   language-specific naming into public API contracts.
8. Use consistent errors, pagination, filtering, sorting, idempotency, retry,
   timeout, authentication, authorization, rate-limit, and observability
   semantics across the API family.
9. For `net/http/rest` routes, follow the local contract in
   `references/conventions.md`: verb-qualified routing with Go 1.22 path
   templates, Accept/Content-Type negotiation falling back to JSON,
   `status.SafeError` for error responses, and `Retry-After` only on
   3xx/429/503 responses (RFC 9110 §10.2.3 for 3xx/503, RFC 6585 §4 for 429).
   Treat any endpoint-specific `Location` restriction as a local contract, not
   a general REST rule.
10. Validate API changes through repository-defined Make targets and generated
    contract checks. Do not bypass existing protobuf, feature, lint, or
    compatibility workflows with ad hoc commands.

## References

- Read `references/conventions.md` for this ecosystem's three real
  `net/http/rpc`, `net/http/rest`, and `net/http/mvc` transport contracts.

## Review Gate

Before accepting an API design, implementation, or review conclusion, verify:

- **Surface**: the exact method, route, message, field, client API, or doc being
  changed.
- **Audience**: generated clients, Go callers, Ruby callers, external
  integrators, service owners, operators, or maintainers.
- **Resource model**: resources, parents, names, collection boundaries,
  lifecycle, and standard methods.
- **Compatibility**: old clients, generated artifacts, persisted identifiers,
  error handling, pagination tokens, enum values, versioning, and documented
  behavior.
- **Transport**: gRPC, REST, HTTP transcoding, or mixed behavior and where each
  contract is authoritative.
- **Evidence**: existing APIs, `.proto` comments, generated docs, tests,
  consumers, CI configuration, or official guide sections that support the
  conclusion.

If evidence is missing, lower confidence and gather more repository evidence
instead of accepting a design because it seems idiomatic.

## Go And Ruby Boundaries

Use language standards for implementation details, but keep API standards in
charge of public contract shape:

- In Go, generated protobuf packages, service interfaces, handlers, client
  wrappers, and exported request/response helpers must preserve the API
  contract rather than optimize for package-local convenience.
- In Ruby, API clients, feature harnesses, request builders, and documented
  command/task interfaces must preserve the wire contract rather than hide
  incompatible behavior behind Ruby convenience methods.
- Do not introduce Go- or Ruby-specific names into `.proto`, HTTP routes, JSON
  fields, or documentation unless the API is explicitly language-local.
