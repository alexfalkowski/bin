---
name: doc-standards
description: Use when writing, reviewing, or updating documentation; when changed code affects documented behavior; when $code-review or $review-pr needs documentation judgment; or when $doc-gaps needs criteria for scoped documentation triage. Apply strict documentation adequacy standards for README files, user-facing docs, examples, command/config docs, public API comments, docstrings, and stale-doc review.
---

# Doc Standards

## Operating Stance

Operate as a documentation reviewer: protect users, operators, and
maintainers from concrete misunderstanding while rejecting wording preferences,
exhaustive private-code commentary, and optional polish that does not reduce
real use or maintenance risk. Do not pass documentation because it exists, is
long, has many headings, follows an established local shape, or satisfies a
linter. Pass documentation only after verifying that it is accurate, adequate,
and in the authoritative location for the audience and action at risk.

When documentation contradicts implementation, do not assume documentation is
the source of truth. Treat code, tests, schemas, generated contracts, runtime
behavior, and external standards as the evidence for current behavior. Route the
mismatch to `$code-issues` only when non-prose evidence proves the
implementation is wrong; otherwise fix the documentation to describe the
behavior the repository actually implements.

## Steps

1. Identify the documentation surface in scope: README files, docs, examples,
   command help, setup instructions, configuration docs, public API comments,
   code comments, docstrings, changelogs, migration notes, or generated docs.
2. Identify the public surface, intended user, authoritative documentation
   owner, minimum successful example or command, and non-obvious contract that
   users need before they can use or maintain the surface safely.
3. Compare documentation against the changed behavior, requested scope, tests,
   examples, command output, configuration schema, and public interfaces.
4. If docs and implementation disagree, verify whether non-prose evidence proves
   the code is wrong. If not, treat the prose as stale and fix the authoritative
   documentation owner.
5. Route each concern to the correct documentation owner before deciding whether
   existing documentation is adequate.
6. For `$code-review` and `$review-pr`, inspect changed documentation and nearby
   documentation directly affected by the current change. Do not perform a
   package-wide documentation audit unless the user explicitly asks for
   `$doc-gaps` or a broader docs pass.
7. For `$doc-gaps`, use these standards as the quality bar for fixing or
   recording confirmed missing, weak, stale, misleading, or wrong-location
   documentation.
8. Pair with relevant language standards for language-specific public API
   comments and docstrings. Pair with `$naming-standards` when terminology,
   command/API names, examples, or public vocabulary are unclear or
   inconsistent.
9. Pair with `$change-safety` when documentation changes public contracts,
   compatibility expectations, migrations, security guidance, operational
   behavior, or documented support boundaries.
10. Pair with `$change-validation` when selecting validation for documentation
   changes, such as docs lint, generated-doc checks, example tests, command
   snapshots, or the repository's normal review target.

## Adequacy Gate

Documentation is adequate only when it answers the applicable contract questions
at the right documentation layer. Before passing, fixing, dismissing, or
recording a documentation concern, explicitly verify:

- **Surface**: the public command, API, package, service, configuration,
  example, file format, or operator behavior being documented.
- **Audience**: the service author, package consumer, operator, contributor, or
  maintainer who must act on the documentation.
- **Action**: the concrete use, setup step, maintenance decision, migration,
  debugging step, integration, or operational task at risk.
- **Owner**: the authoritative documentation surface where the information
  belongs.
- **Example**: the smallest successful command, API call, request, config
  snippet, or executable example needed for first correct use.
- **Contract**: the non-obvious behavior, errors, nil or empty behavior,
  lifecycle, concurrency, retry, timeout, configuration default, security,
  compatibility, data-loss, or ownership boundary that users cannot safely infer
  from names, signatures, generated output, or obvious code.

If these answers cannot be identified from the current docs and repository
surface, treat the issue as a candidate documentation gap. If the only support
for adequacy is that the README is long, a heading exists, every exported symbol
has a comment, or a comment satisfies lint shape, do not pass the documentation.

## Documentation Location

Route documentation to the surface that owns the reader's next action:

- **README**: project identity, boundary, first-use bootstrap, one minimal usage
  path, essential configuration, applicable operations notes, and links to
  deeper owners.
- **User docs**: workflows, setup paths, operational procedures, migrations,
  troubleshooting, and multi-step behavior that does not fit command help or API
  comments.
- **Command help**: command syntax, flags, environment variables, defaults,
  error cases, and command-specific examples.
- **Public API comments, GoDoc, RDoc, and docstrings**: callable API contracts,
  behavior, parameters when non-obvious, return or nil semantics, exceptions or
  errors, lifecycle, side effects, compatibility, and ownership boundaries.
- **Executable examples**: reusable API usage, representative command flows, or
  integration examples that can be validated by the repository's established
  test or example harness.
- **Schemas, `.proto` files, generated docs, and sample config**: exhaustive
  field, wire, and generated reference material. Link to these owners instead of
  duplicating them in README prose.

## Documentation Standards

- **Correctness**: Documentation must describe the current repository-owned
  behavior, command syntax, configuration shape, examples, defaults, limits,
  errors, compatibility expectations, and operational constraints accurately.
  If documentation conflicts with code and tests, prove the implementation is
  wrong with non-prose evidence before changing code; otherwise update the
  documentation.
- **Completeness**: Public entrypoints, exported APIs, commands, configuration
  keys, setup paths, migrations, and examples need enough documentation for the
  intended user to use or maintain them without reading private implementation
  code first.
- **Location**: Put documentation where the target audience will look: public
  API comments near exported identifiers, command behavior in help or README
  docs, setup and operator guidance in project docs, and executable examples
  near the documented entrypoint. Do not accept correct information in the wrong
  place when the intended user would not discover it before making the risky
  decision.
- **Examples**: Examples and commands should be copy-paste-ready when practical,
  aligned with real entrypoints, and kept current with flags, config keys,
  package names, imports, outputs, and validation constraints. Prefer
  executable examples over README-only examples when the language or repository
  already has an executable example convention for that public surface.
- **Diagrams**: Use ASCII diagrams when they make control flow, data flow,
  ownership, protocol boundaries, dependency direction, state transitions, or
  lifecycle ordering easier to understand than prose. Keep diagrams small,
  aligned with the documented behavior, and close to the relevant explanation.
  Do not add decorative diagrams, file-tree art, or diagrams that duplicate an
  authoritative generated diagram, schema, `.proto`, config, or command output.
- **Public API comments and docstrings**: Explain exported behavior, contracts,
  nil or error behavior, compatibility constraints, side effects, deprecations,
  alias or wrapper relationships, and security or operational requirements when
  those are not obvious from the signature. Follow the relevant language's
  documentation requirements, but do not demand or write comments that merely
  restate the identifier, signature, return type, or obvious implementation.
- **Code comments**: Explain non-obvious intent, invariants, tradeoffs,
  bug-workaround context, copied-code sources, external standards, incomplete
  implementation state, or surprising behavior. Comments must explain why the
  code exists or what contract it protects, not narrate what each line does. If
  a clear comment cannot be written because the code itself is confused,
  recommend `$code-issues`.
- **Terminology**: Use the same names for concepts, commands, config keys, API
  fields, and roles across docs, code, examples, and tests. Use
  `$naming-standards` when unclear terminology creates misuse or maintenance
  risk.
- **Audience**: Keep startup docs concise, current, and structured with headings
  and links to deeper docs. Do not bury critical setup, security, migration, or
  operational instructions in unrelated comments or long prose.

## Code Comment Standard

Read `references/comments.md` when reviewing or writing code comments, public
API comments, docstrings, RDoc, GoDoc, or shell function comments.

## README Standard

Read `references/readme.md` when writing, reviewing, or updating README files.

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
  one-pass, audit-only, and delegation rules.
- Direct user request: the scope the user named. If no scope is clear and the
  decision affects edit size or review cost, ask for the intended documentation
  surface before auditing broadly.

## References

- Read `references/comments.md` for code comments, public API comments,
  docstrings, RDoc, GoDoc, and shell function comments.
- Read `references/readme.md` for README responsibilities, project-type
  expectations, alerts, duplication rules, and README anti-patterns.
