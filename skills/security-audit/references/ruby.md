# Ruby Security Audit

Use this reference for Ruby scripts, libraries, tests, Bundler metadata, or Ruby Make targets.

## Inspect

- Shell execution: avoid interpolated strings in `system`, backticks, `%x`, `Open3`, and process helpers; pass argv arrays where possible.
- Filesystem paths: constrain user-provided paths; avoid traversal, unsafe symlink handling, broad deletes, and insecure file permissions.
- YAML and serialization: avoid unsafe deserialization of untrusted data; prefer safe loaders and explicit classes when loading YAML.
- Environment and secrets: avoid logging env secrets, tokens, credentials, private keys, and realistic sample credentials.
- Network calls: verify TLS, set timeouts, avoid SSRF-prone fetches, and constrain redirects/proxies when input controls URLs.
- Regular expressions: check user-controlled patterns or catastrophic backtracking in request/CLI paths.
- Metaprogramming: scrutinize `eval`, `instance_eval`, `class_eval`, dynamic constants, and monkey patches.

## Validation

- Prefer repo-defined Ruby targets first.
- In this repository, `make lint` runs RuboCop and `make sec` runs Trivy repo scanning.
- If `build/make/ruby.mak` is included downstream, use `make sec` for Trivy repository scanning.
- If Bundler audit tooling is present in a consuming repo, use the repo's configured entry point rather than inventing one.
- Report when security coverage is limited to static linting or dependency scanning and no behavior tests exercise the risky path.

## Findings

- Show the exact data path from untrusted input to the Ruby sink.
- Include a safe replacement pattern, such as argv-array process execution, safe YAML loading, constrained path joins, or redacted logging.
- Pair with `ruby-standards`, `change-safety`, and `change-validation` for code changes.
