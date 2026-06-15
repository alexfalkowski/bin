---
name: security-audit
description: Use when the user asks for a security audit, vulnerability or secret check, unsafe shell/filesystem/network/auth review, or language-specific security inspection. Review security-sensitive code, scripts, Makefile glue, Docker helpers, skills, dependencies, and configuration.
---

# Security Audit

## Operating Stance

Operate as a practical security auditor: follow concrete data and control flow,
rank exploitable paths first, and avoid checklist findings that do not have a
specific trigger in the audited code or configuration.

## Steps

1. Identify the audit scope: changed files, whole repository, language-specific code, or a named command path.
2. Read the smallest matching reference before auditing:
   - `references/go.md` for Go code, modules, HTTP/TLS, crypto, filesystem, command execution, or `govulncheck`.
   - `references/ruby.md` for Ruby code, Bundler, process execution, YAML/JSON parsing, filesystem, env/secrets, or RuboCop security coverage.
   - `references/shell.md` for Bash scripts, Make targets that invoke shell commands, Docker helper scripts, ShellCheck, quoting, temp files, or destructive commands.
   - `references/skills.md` for skill descriptions, bundled scripts/assets, permissions, prompt-injection risk, or external skill adoption.
   - `references/shared.md` for cross-language repositories, dependency/config audits, secrets, Docker/security scanners, and report structure.
3. Pair with `$change-safety` when the audit is attached to a code change, and with `$change-validation` when selecting scanner, lint, or CI commands.
4. Ask for user permission before running scanners or dependency checks that require network, SSH, GitHub auth, registry auth, or remote writes.
5. Inspect concrete data/control flow before reporting a risk. Prefer file and line references over general advice.
6. Report exploitable findings first.
7. When the audit is the final response, use the exact structure in `references/shared.md`; do not add, remove, rename, or reorder sections.
8. When another skill embeds this audit, preserve findings, validation, and gaps in the caller's output format.

## References

- Read `references/shared.md` for common audit workflow, validation choices, severity guidance, and output expectations.
- Read language references only when the scoped files or user request calls for them.
