---
name: docs-standards
description: Applies documentation quality standards for README files, user-facing docs, examples, command/config docs, public API comments, docstrings, and behavior changes that may make existing documentation stale. Use when writing, reviewing, or updating documentation; when changed code affects documented behavior; when $code-review or $review-pr needs documentation judgment; and when $doc-gaps needs criteria for scoped documentation triage.
---

# Docs Standards

## Operating Stance

Operate as a documentation reviewer: protect users, operators, and
maintainers from concrete misunderstanding while rejecting wording preferences,
exhaustive private-code commentary, and optional polish that does not reduce
real use or maintenance risk.

## Steps

1. Identify the documentation surface in scope: README files, docs, examples,
   command help, setup instructions, configuration docs, public API comments,
   code comments, docstrings, changelogs, migration notes, or generated docs.
2. Compare documentation against the changed behavior, requested scope, tests,
   examples, command output, configuration schema, and public interfaces.
3. For `$code-review` and `$review-pr`, inspect changed documentation and nearby
   documentation directly affected by the current change. Do not perform a
   package-wide documentation audit unless the user explicitly asks for
   `$doc-gaps` or a broader docs pass.
4. For `$doc-gaps`, use these standards as the quality bar for recording
   confirmed missing, weak, stale, misleading, or wrong-location documentation
   in the scoped `ISSUES.md` ledger.
5. Pair with relevant language standards for language-specific public API
   comments and docstrings. Pair with `$naming-standards` when terminology,
   command/API names, examples, or public vocabulary are unclear or
   inconsistent.
6. Pair with `$change-safety` when documentation changes public contracts,
   compatibility expectations, migrations, security guidance, operational
   behavior, or documented support boundaries.
7. Pair with `$change-validation` when selecting validation for documentation
   changes, such as docs lint, generated-doc checks, example tests, command
   snapshots, or the repository's normal review target.

## Documentation Standards

- **Correctness**: Documentation must describe the current repository-owned
  behavior, command syntax, configuration shape, examples, defaults, limits,
  errors, compatibility expectations, and operational constraints accurately.
- **Completeness**: Public entrypoints, exported APIs, commands, configuration
  keys, setup paths, migrations, and examples need enough documentation for the
  intended user to use or maintain them without reading private implementation
  code first.
- **Location**: Put documentation where the target audience will look: public
  API comments near exported identifiers, command behavior in help or README
  docs, setup and operator guidance in project docs, and examples near the
  documented entrypoint.
- **Examples**: Examples and commands should be copy-paste-ready when practical,
  aligned with real entrypoints, and kept current with flags, config keys,
  package names, imports, outputs, and validation constraints.
- **Public API comments and docstrings**: Explain exported behavior, contracts,
  nil or error behavior, compatibility constraints, side effects, deprecations,
  and security or operational requirements when those are not obvious from the
  signature. Do not demand comments that merely restate obvious code.
- **Code comments**: Explain non-obvious intent, invariants, tradeoffs,
  bug-workaround context, copied-code sources, or surprising behavior. If a
  clear comment cannot be written because the code itself is confused, recommend
  `$code-issues`.
- **Terminology**: Use the same names for concepts, commands, config keys, API
  fields, and roles across docs, code, examples, and tests. Use
  `$naming-standards` when unclear terminology creates misuse or maintenance
  risk.
- **Audience**: Keep startup docs concise, current, and structured with headings
  and links to deeper docs. Do not bury critical setup, security, migration, or
  operational instructions in unrelated comments or long prose.

## Finding Threshold

Treat a documentation concern as a finding only when it creates credible risk
to users, operators, maintainers, public API consumers, documented command
behavior, onboarding, setup, contribution workflows, security expectations, or
compatibility. Do not report arbitrary wording preferences, style nits,
exhaustive private implementation comments, or optional documentation polish as
findings.

When the confirmed problem is broken behavior, a security issue, a compatibility
break, or a violated public contract, report it through `$code-review`,
`$code-issues`, or `$security-audit` instead of treating it as a documentation
gap. When the confirmed problem is missing or weak test coverage, use
`$testing-standards` or `$test-gaps`.

## Review Scope

- `$code-review` and `$review-pr`: changed docs plus directly affected nearby
  docs.
- `$doc-gaps`: the requested package or folder, recursively, using that skill's
  ledger and delegation rules.
- Direct user request: the scope the user named. If no scope is clear and the
  decision affects edit size or review cost, ask for the intended documentation
  surface before auditing broadly.
