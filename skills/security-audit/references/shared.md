# Shared Security Audit

Use this reference for any security audit, then load language-specific references only as needed.

## Scope

- Determine whether the user wants a diff audit, full repository audit, dependency scan, or one command/script path.
- Identify trust boundaries: CLI args, env vars, config files, network input, filesystem paths, generated files, dependency metadata, and CI secrets.
- For shared `./bin` tooling, consider both this repository root and downstream usage where helpers are invoked through `BIN_ROOT`.
- For broad audits, use `../../references/gap-lead-generation.md` to classify
  the repository archetype and build a security lead inventory before filtering
  findings.

## Source-To-Sink Review

For each security-sensitive slice, trace concrete sources to concrete sinks:

- Sources: CLI args, environment variables, config files, request bodies,
  headers, metadata, generated input, fixtures, dependency metadata, CI
  variables, and file paths.
- Sinks: shell or process execution, filesystem writes/deletes, archive or
  template expansion, YAML/JSON parsing, SQL or query construction, network
  calls, TLS/auth configuration, logs, Docker build context, CI release steps,
  and secret stores.
- Controls: validation, allowlists, size limits, escaping, argv separation,
  permissions, timeout/deadline behavior, scanner coverage, CI context scoping,
  and repository-owned wrappers.
- Outcomes: confirmed findings, rejected leads with the control that blocks
  exploitation, routed dependency/tool findings, and validation gaps such as
  missing or no-op scanners.

## Common Risks

- Secrets or realistic credentials committed in code, tests, docs, configs, fixtures, or generated files.
- Untrusted input reaching shell execution, filesystem writes/deletes, archive extraction, templates, SQL/queries, YAML deserialization, HTTP requests, or logs.
- Unsafe defaults: disabled TLS verification, broad filesystem permissions, world-writable files, unauthenticated endpoints, permissive CORS, weak crypto, or silent fallback to insecure behavior.
- Dependency or container vulnerabilities not covered by the repository's validation commands.
- CI or Make targets that expose secrets, run remote code, or differ materially from local validation.
- Docker and release paths where the scanned artifact can differ from the
  published artifact.
- Skill metadata, bundled scripts, or imported references that expand routing,
  permissions, network access, or executable behavior beyond the skill's scope.

## Validation

- Prefer repository-defined targets before ad hoc scanners.
- Ask for permission before running scanners or dependency checks that need network, SSH, GitHub auth, registry auth, or remote writes.
- In this repository, relevant checks include:
  - `make sec` for Trivy repository scanning.
  - `make scripts-lint` for ShellCheck coverage of shared scripts.
  - `make docker-lint` for Hadolint coverage of the Go Dockerfile.
  - `make lint` for RuboCop coverage of Ruby code.
- In downstream Go repositories that include `build/make/go.mak`, `make sec` runs `govulncheck` and Trivy repo scanning.
- In downstream Ruby repositories that include `build/make/ruby.mak`, `make sec` runs Trivy repo scanning.
- Report wrappers as partial or no-op when tools such as `trivy`, `govulncheck`, `shellcheck`, `hadolint`, or `golangci-lint` are missing.
- Report network or credential failures as validation gaps unless the audited code caused the failure.

## Freshness

- Treat this reference as stable audit heuristics, not an exhaustive current vulnerability database.
- Prefer repository-defined commands, local configuration, lockfiles, and scanner output over this reference when they differ.
- For dependency vulnerabilities, scanner behavior, language or tool security guidance, and newly disclosed issues, verify against current tool output or official documentation.
- Do not cite CVEs, current scanner capabilities, or current best-practice claims from memory.
- Keep updates focused on durable risk classes, dangerous sinks, and repository entry points instead of volatile vulnerability lists.

## Verification Sources

- Use current verification sources when a finding depends on vulnerability status, affected versions, scanner behavior, exploit activity, or official hardening guidance.
- Ruby language and standard library advisories: `https://www.ruby-lang.org/en/security/`.
- Ruby gems: RubySec and Bundler Audit, especially `https://rubysec.com/` and the local `Gemfile.lock` when present.
- RubyGems supply-chain guidance: `https://guides.rubygems.org/security/`.
- Go modules, standard library, and toolchain advisories: `https://pkg.go.dev/vuln/`, `https://go.dev/doc/security/vuln/database`, and `govulncheck` output.
- Cross-ecosystem open-source dependencies: OSV.dev data/API at `https://osv.dev/`, especially for ecosystems such as Go, RubyGems, Debian, Alpine, Ubuntu, npm, PyPI, and Maven.
- Docker images and container vulnerability status: Docker Scout and its advisory-source documentation under `https://docs.docker.com/scout/`.
- Dockerfile and container hardening: Docker security, build secrets, Dockerfile reference, and build best-practices documentation under `https://docs.docker.com/security/`, `https://docs.docker.com/build/`, and `https://docs.docker.com/reference/dockerfile/`.
- Bash itself: GNU Bash project pages, GNU Bash bug/mailing-list channels, NVD/CVE records, and the relevant operating-system distribution security tracker. Bash does not have a single canonical vulnerability database equivalent to Ruby's security page or the Go vulnerability database.
- Shell script findings: ShellCheck output and rule documentation, especially `https://www.shellcheck.net/wiki/`, plus local code-flow evidence.
- Exploit prioritization: CISA Known Exploited Vulnerabilities catalog at `https://www.cisa.gov/known-exploited-vulnerabilities-catalog`.
- If sources disagree, prefer vendor or ecosystem advisories for affected versions and remediation, scanner output for what the local project currently exposes, and CISA KEV for known exploitation status.

## Severity

Use these security-specific examples after filtering out low-confidence or
unsupported candidates. They align with `../../references/finding-severity.md`.
Recorded security findings must include the agent's actual confidence
percentage, for example `confidence: 96%`. Use an explicit confidence target
from the current request when provided; otherwise use the 95% default for
security findings. If the audited evidence cannot support the active threshold,
gather more evidence or discard the candidate. A lower explicit target does not
waive the security evidence, authorization, or validation requirements; state
the reduced assurance and residual risks.

- Critical: near-certain remote code execution, credential exposure, auth bypass, data loss or corruption, or exploitable critical dependency issue with broad severe impact.
- High: likely exploitable command injection, arbitrary file write/delete, path traversal to sensitive files, sensitive information disclosure, or other serious security issue with narrower impact.
- Medium: constrained injection, sensitive information disclosure, unsafe TLS/auth defaults, dangerous local-only behavior likely to be copied into production, or scanner coverage gaps on security-sensitive changes.
- Low: hardening issue, defense-in-depth improvement, unclear validation gap, or risky pattern without a demonstrated exploit path.

## Reporting

- When security-audit is the final response, use exactly this Markdown structure and do not add, remove, rename, or reorder sections:

```markdown
## Findings

- severity: Critical
  confidence: 96%
  file: `path/to/file:42`
  risk: Untrusted input reaches shell execution.
  trigger: User-controlled CLI arguments are interpolated into a shell command.
  impact: An attacker can execute arbitrary commands.
  remediation: Pass arguments as argv entries without shell interpretation.

## Validation

- command: `make sec`
  result: passed
  coverage: Trivy repository scan for critical vulnerabilities.

## Gaps

- None.
```

- Use only these severity values for findings: `Critical`, `High`, `Medium`, `Low`. Use `None` only for the required no-findings entry.
- Use an actual percentage at or above the active confidence threshold for
  finding confidence; when no explicit target is provided, that threshold is
  95%. Use `n/a` only for the required no-findings entry.
- Use only these validation results: `passed`, `failed`, `not run`, `no-op`.
- Use `file: n/a` only for repository-wide dependency, configuration, or validation findings that do not have a precise source line.
- If there are no findings, write exactly one finding entry with `severity: None`, `confidence: n/a`, `file: n/a`, `risk: No findings.`, `trigger: n/a`, `impact: n/a`, and `remediation: n/a`.
- If no validation ran, write one `Validation` entry with `command: none`, `result: not run`, and a concise coverage explanation.
- If there are no gaps, write exactly `- None.`
- Findings must be ordered by severity, with exploitable risks before hardening items.
- Each finding should state: risk, trigger condition, impact, and remediation.
- Do not report generic checklist items as findings unless they apply to the audited code.
- Do not report findings based only on comments, GoDoc, README text, examples,
  or other prose contradicting implementation. Prose can be stale; prove the
  actual code or configuration is insecure or wrong with non-prose evidence
  such as data/control flow, runtime behavior, scanner output, external security
  standards, generated contracts, tests, or history. If current behavior is
  supported and the prose is stale, report a documentation gap instead.
- If no findings are found, say that clearly and list meaningful gaps, such as scanners not installed or dynamic behavior not exercised.
- When another skill embeds the audit, keep the same factual content, confidence, and severity meaning but use the caller's required output sections.
