# API And Identity Security

Use this reference for API handlers, middleware, RPC interceptors, sessions,
credential issuance/verification, tenant isolation, or business-flow abuse.
Read `shared.md` for the evidence, confidence, execution, and reporting rules.

## Inspect

- Inventory the actual route/RPC registrations, authentication mechanisms,
  protected resources, and authorization owners. Compare HTTP and gRPC entry
  paths, older versions, admin routes, and batch/import/export operations when
  they reach the same behavior; do not assume one transport's middleware
  protects another.
- Trace subject, tenant, resource, and operation through authorization and
  data access. Check object ownership, field reads/writes, list filters, batch
  membership, and cache keys. Authentication alone does not authorize access to
  another principal's resource.
- For tokens, verify signature and configured algorithm/key selection, issuer,
  audience, lifetime, scope, and principal/resource binding as applicable to
  the token's role. Trace caller-controlled key selectors and decoded claims
  through the verifier before trusting them.
- For sessions and OAuth/OIDC flows, establish the component's role before
  assigning controls. Review callback and initiating-session binding, redirect
  handling, applicable PKCE/nonce checks, session rotation, revocation, account
  linking, recovery, and fallback paths. Inspect CSRF protection where browsers
  attach credentials to state-changing requests.
- Follow user-controlled fetch destinations through URL parsing, redirects,
  DNS resolution, and the HTTP client. Check actual destination restrictions
  and upstream-response handling rather than treating an internal service or
  third-party API response as inherently trusted.
- Review expensive operations, pagination, batch size, concurrency, and quota
  accounting against shared resource/cost boundaries. Look for replay, repeated
  approval, state-transition bypass, and check/use races that permit a concrete
  unauthorized result. A missing rate limit alone is not proof of abuse.

## Evidence And Validation

- Show the caller's starting authority and exact resource or operation reached.
  When reproducing isolation claims, compare the same operation for an allowed
  principal and a principal outside that owner/tenant scope using dummy data.
- Follow framework and upstream controls before reporting a missing local
  check. Separate source-visible failures from unknown ingress, identity
  provider, deployment, or downstream-consumer policy; use `Gaps` or the
  caller's equivalent section for a decisive unresolved fact.
- Prefer the repository's existing caller-facing validation path. Report which
  entry path and boundary it exercises; dependency scanners do not establish
  authorization or business-flow correctness.

## Verification Sources

- [OWASP API Security Top 10:2023](https://owasp.org/API-Security/editions/2023/en/0x11-t10/)
  for API risk categories; use them to generate leads, not automatic findings.
- [JWT Best Current Practices, RFC 8725](https://www.rfc-editor.org/rfc/rfc8725.html)
  for token verification and claim binding.
- [OAuth 2.0 Security Best Current Practice, RFC 9700](https://www.rfc-editor.org/rfc/rfc9700.html)
  for role-appropriate flow and token protections.
