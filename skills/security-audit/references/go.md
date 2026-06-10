# Go Security Audit

Use this reference for Go code, tests, module metadata, or Go-related Make targets.

## Inspect

- `os/exec`: avoid shell interpretation; validate command names and args; set working directory and environment deliberately.
- Filesystem paths: clean and constrain user-provided paths; avoid path traversal, unsafe symlink following, broad `os.RemoveAll`, and weak file modes.
- HTTP clients/servers: timeouts, request body limits, TLS verification, redirect behavior, header trust, CORS, proxy behavior, and log exposure.
- Crypto and randomness: use `crypto/rand`; avoid custom crypto, weak hashes for security decisions, hardcoded keys, and nonce reuse.
- Serialization: treat YAML/JSON/protobuf input as untrusted; enforce limits for large payloads and recursive structures.
- Database/query code: use parameterized queries; avoid string-built SQL or unsafe query fragments.
- Concurrency around security state: avoid races in caches, token stores, and auth decisions.
- Errors/logs: do not leak secrets, tokens, credentials, private keys, or sensitive request bodies.

## Validation

- Prefer repo-defined Go targets first.
- If `build/make/go.mak` is included, use `make sec` for `govulncheck` plus Trivy.
- Use `govulncheck -show verbose -test ./...` when a narrower direct vulnerability check is appropriate.
- For behavioral security fixes, use the majority relevant test harness for the risky behavior, especially path constraints, input validation, auth decisions, and error handling. Do not default to Go tests unless Go is the relevant established coverage layer or the changed surface is a Go package/API contract.
- If `golangci-lint` is wrapped by `build/go/lint`, remember it may no-op when `golangci-lint` is missing.

## Findings

- Prioritize exploitable data flow from untrusted input to dangerous sinks.
- For dependency findings, include the vulnerable module, vulnerable path when available, and upgrade/remediation path.
- For API changes, pair with `go-standards`, `change-safety`, and `change-validation`.
