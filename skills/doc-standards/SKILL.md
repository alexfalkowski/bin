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

## Detailed Standards

- Read `references/standards.md` when deciding documentation location,
  adequacy, examples, diagrams, terminology, or audience fit.
- Read `references/comments.md` when reviewing or writing code comments, public
  API comments, docstrings, RDoc, GoDoc, or shell function comments.
- Read `references/readme.md` when writing, reviewing, or updating README files.

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
- Read `references/standards.md` for documentation location, correctness,
  completeness, examples, diagrams, terminology, and audience rules.
