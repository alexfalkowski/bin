# API Conventions

Use this reference to identify which of this ecosystem's three real
`go-service` HTTP transports a route or service surface uses, and to apply
that transport's local contract instead of generic REST/AIP/CRUD rules.

## Transport Identification

Identify the transport per route or service surface, not per repository. A
repository can mix transports, and a `net/http/rest` route can either serve
the request directly or front a generated gRPC client — check the handler
body, not just the repository.

- `net/http/rpc` — POST-only, gRPC-first services (`standort`, `bezeichner`,
  `migrieren`) exposing their proto-defined gRPC services over HTTP with
  routes keyed on the full gRPC method name.
- `net/http/rest` — verb-qualified `<METHOD> <pattern>` routing with Go 1.22
  path templates. Two supported patterns exist: standalone HTTP-only
  (`status`, a diagnostic endpoint mapping all five HTTP verbs to one handler)
  and a gateway in front of a generated gRPC client (`go-monolith`, e.g.
  `rest.Get("/greeter/v1/hello/{name}", ...)` calling a generated
  `client.Hello`).
- `net/http/mvc` — server-rendered HTML (`web`), `GET` full view / `PUT`
  partial view for the same resource path. Not an API; out of this skill's
  contract scope.

## `net/http/rpc` Contract

- Every route is `POST <full gRPC method name>`; there is no resource-oriented
  URL design.
- Responses use a `meta map<string, string>` envelope field (e.g.
  `standort/api/standort/v2/service.proto`).
- Batch/generation RPCs use a config-driven per-request item-count limit
  instead of AIP `page_token`/`page_size` pagination — e.g.
  `GenerateIdentifiersRequest.count` and `MapIdentifiersRequest.ids` in
  `bezeichner/api/bezeichner/v1/service.proto`, with the effective limits
  reported back via a `RequestLimits` field on `ListApplicationsResponse`.
- Partial-failure batches use `oneof outcome` with a `google.rpc.Status`
  branch per item (e.g. `standort/api/standort/v2/service.proto`).
- Long-running operations document gRPC diagnostic trailers directly in the
  `.proto` comments (e.g. `migrieren/api/migrieren/v1/service.proto`).
- Guard compatibility with the repository's `make proto-breaking` target
  (provided by `build/make/grpc.mak`); do not apply AIP HTTP-transcoding
  annotations
  (`google.api.http`) — this ecosystem's `rpc` services do not use them.

## `net/http/rest` Contract

- Routes are verb-qualified: `<METHOD> <pattern>` with Go 1.22 path
  templating.
- Content negotiation reads `Accept`/`Content-Type` and falls back to JSON.
- Error responses use `status.SafeError`, not ad hoc error bodies.
- `Retry-After` is set only on 3xx/429/503 responses: 3xx and 503 usage
  matches RFC 9110 §10.2.3, and 429 usage matches RFC 6585 §4. `status`'s
  diagnostic endpoint additionally
  restricts its query-driven `Location` header to 3xx codes as a local
  validation choice, not a general RFC rule: RFC 9110 §10.2.2 also permits
  `Location` on a 201 Created response, so a resource-creating
  `net/http/rest` route may still set it there.
- Before proposing resource-oriented REST design, confirm whether the route
  serves the request directly (no resource model, e.g. `status`) or fronts a
  generated gRPC client (apply the `net/http/rpc` contract above to the
  backing service, e.g. `go-monolith`).

## `net/http/mvc` Contract

- `GET` renders the full view; `PUT` renders the partial view for the same
  resource path (e.g. `web`).
- Treat these as HTML view routes, not API contracts — do not apply
  REST/AIP/CRUD or JSON schema rules to them.

## When To Use The External Guides

- Use the Google Cloud API Design Guide and Google AIPs for proto3/gRPC design
  on `net/http/rpc` surfaces, and for resource-oriented design questions not
  answered by a local contract above.
- Do not apply generic REST-best-practices guidance to `net/http/rest` routes;
  use the local contract above instead.
