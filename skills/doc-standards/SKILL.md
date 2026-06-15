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

## Steps

1. Identify the documentation surface in scope: README files, docs, examples,
   command help, setup instructions, configuration docs, public API comments,
   code comments, docstrings, changelogs, migration notes, or generated docs.
2. Identify the public surface, intended user, authoritative documentation
   owner, minimum successful example or command, and non-obvious contract that
   users need before they can use or maintain the surface safely.
3. Compare documentation against the changed behavior, requested scope, tests,
   examples, command output, configuration schema, and public interfaces.
4. Route each concern to the correct documentation owner before deciding whether
   existing documentation is adequate.
5. For `$code-review` and `$review-pr`, inspect changed documentation and nearby
   documentation directly affected by the current change. Do not perform a
   package-wide documentation audit unless the user explicitly asks for
   `$doc-gaps` or a broader docs pass.
6. For `$doc-gaps`, use these standards as the quality bar for fixing or
   recording confirmed missing, weak, stale, misleading, or wrong-location
   documentation.
7. Pair with relevant language standards for language-specific public API
   comments and docstrings. Pair with `$naming-standards` when terminology,
   command/API names, examples, or public vocabulary are unclear or
   inconsistent.
8. Pair with `$change-safety` when documentation changes public contracts,
   compatibility expectations, migrations, security guidance, operational
   behavior, or documented support boundaries.
9. Pair with `$change-validation` when selecting validation for documentation
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

Apply these rules strictly for code comments, public API comments, docstrings,
RDoc, GoDoc, shell function comments, and any language-specific documentation
near code.

Comment presence is not comment adequacy. A comment that exists only because a
language linter expects a sentence is still weak documentation when it fails to
document the non-obvious repository-owned contract.

For package docs and exported API comments, do not only check whether a comment
exists or starts with the identifier. Audit whether it documents the
repository-owned contract that a caller cannot safely infer from the signature.
For each exported package, type, function, method, variable, or constant in
scope, check whether the comment needs to cover:

- behavior and purpose;
- error, panic, nil, empty, or zero-value behavior;
- side effects, lifecycle, cleanup, global registration, or process behavior;
- concurrency, caching, retry, timeout, cancellation, or idempotency behavior;
- configuration defaults, limits, validation, and fallback behavior;
- security, operational, compatibility, or data-loss risks; and
- alias, wrapper, re-export, or dependency ownership boundaries.

Do not require every comment to mention every category. Require the relevant
non-obvious contract to be documented. If none of these categories apply and the
comment only restates the name or signature, remove or keep it minimal according
to the language lint requirement.

These rules follow the rule set from Stack Overflow's "Best practices for
writing code comments":
https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/

- Do not duplicate the code. Remove or rewrite comments that only translate syntax,
  restate a name, describe a visible assignment, list obvious parameters, or say
  what a nearby line already says.
- Do not use comments to compensate for unclear code. Prefer clearer names,
  smaller structure, or a documented `$code-issues` finding when the code cannot
  be made understandable with the local pattern.
- If a clear comment cannot be written, treat that as evidence that the code,
  naming, or abstraction may be wrong; use `$code-issues` rather than adding
  vague explanation.
- Comments must reduce confusion. Remove or rewrite comments that are stale,
  cute, ambiguous, speculative, or more confusing than the code.
- Explain unidiomatic, surprising, redundant-looking, compatibility-driven,
  generated, or workaround code when a maintainer might otherwise simplify it
  incorrectly.
- Link to the original source for copied or adapted code, copied formulas,
  external algorithms, standards, protocol rules, compatibility references, or
  tutorials that are necessary to understand why the code is shaped that way.
- Add bug-fix or workaround comments only when the code would otherwise look
  unnecessary or wrong. Reference the issue, upstream bug, version constraint,
  or observable failure when available.
- Mark incomplete implementations with the repository's established TODO/FIXME
  format and include the missing behavior, owner or issue reference when local
  style expects it, and the condition for removing the comment.
- For aliases, re-exports, thin wrappers, or compatibility shims, do not copy
  the upstream package, type, function, constant, method, or command
  documentation. State that this API aliases, re-exports, or wraps the original
  to keep call sites on the project-owned surface, reduce repeated imports, or
  preserve compatibility only when that is the real reason, then link to the
  authoritative upstream or canonical local documentation when practical.

## README Standard

READMEs should be a stable orientation and first-use guide, not a generated
inventory of the repository. Prefer content that helps a new user, service
owner, operator, or contributor decide what the project is, when to use it, and
how to exercise its public surface.

README responsibilities are strict; README templates are not. A README may use
different heading names, order, or grouping only when the applicable
responsibilities remain easy to find: project identity, why or boundary,
install or bootstrap, usage, configuration, operations when applicable, and
references. Do not force a README into a fixed heading template when the current
structure already makes those responsibilities clear.

README headings should use a short, relevant emoji prefix to make the document
easier to scan and add visual colour unless the consuming repository has a
conflicting established README convention. Use one emoji per heading, keep the
heading text clear without relying on the emoji for meaning, and preserve local
heading names and order when they keep the README responsibilities easy to find.

Use this default README shape only as a reference audit shape, not as a required
template. It demonstrates common responsibilities and a discoverable order, but
the project-type responsibility checklist below is the governing rule.

Do not dismiss README structure gaps merely because the current README is large,
locally consistent, matches this example shape, or has an established heading
style. Treat missing, hard-to-find, stale, or wrong-location coverage for
applicable responsibilities as a documentation gap.

Do not rename or reorder headings only for cosmetic template conformity when the
equivalent responsibility is already clear. Remove empty template sections, and
omit irrelevant sections rather than keeping placeholders to satisfy the
example shape.

```markdown
# Project Name

One or two sentences explaining what this project does and who should use it.

## 🎯 Why This Exists

The problem it solves, the boundary it owns, and the tradeoff or design choice
that helps users decide whether it fits.

## 🚀 Install Or Bootstrap

Only the commands required before the first useful command can run, such as
package installation, submodule initialization, dependency setup, or required
runtime assets.

## 💻 Usage

<A minimal, copy-paste-ready example through the main public API, CLI, service
endpoint, package import, or configuration path.>

## 🔧 Configuration

<Only the configuration users must understand to run or integrate the project.
Link to schema, examples, generated docs, or sample config when exhaustive
field documentation belongs there.>

## 🛠️ Operations

<Security, deployment, compatibility, data freshness, health, migration,
shutdown, or observability notes that affect real use. Omit this section when
the project has no operator-facing behavior.>

## 🔗 References

<Links to generated API docs, protobuf contracts, examples, changelog, package
docs, or deeper design notes.>
```

When reviewing a README, explicitly check whether it covers:

- Identity: project name, module/package/service purpose, and intended
  audience.
- Boundary: what the project owns, what it does not own, and when to use it.
- Bootstrap: first commands or setup required before useful work.
- Usage: minimal copy-paste-ready example through the main public surface.
- Configuration: required config shape, examples, defaults, and links to
  schemas or authoritative config docs.
- Operations: security, deployment, health, compatibility, migration,
  observability, data-loss, or lifecycle notes when applicable.
- References: generated docs, API contracts, examples, changelog, templates, or
  deeper design docs.

A README may group or rename sections, but missing or hard-to-find coverage for
an applicable responsibility is a documentation gap.

Keep, add, remove, or rename sections based on the project type. Treat missing
applicable responsibilities as documentation gaps, even when the README has a
different established shape:

- **Library**: install/import guidance, a minimal public API example,
  compatibility or version notes, and links to generated package docs, RDoc,
  GoDoc, executable examples, or API reference material.
- **Client**: target service or API boundary, authentication and required
  configuration, a minimal request, error, retry, timeout, pagination, or rate
  limit behavior when applicable, and links to service contracts or generated
  client docs.
- **Server**: service boundary, supported transports, local bootstrap,
  representative configuration, request examples, health or operational
  endpoints, deployment constraints, migration or compatibility notes, and API
  contract links.
- **Shared tooling**: supported integration path, minimal bootstrap, public
  commands or include surfaces, extension points, compatibility boundaries, and
  links to command help or included templates.

Use GitHub Markdown alerts to draw attention to critical README information
when plain prose would be easy to miss:

```markdown
> [!NOTE]
> Useful context readers should notice while skimming.

> [!TIP]
> Optional guidance that helps users succeed.

> [!IMPORTANT]
> Information users need to succeed.

> [!WARNING]
> Risk that needs immediate attention.

> [!CAUTION]
> Negative consequence of an action.
```

Keep alerts rare and specific. Do not use alerts as decoration, to create a
second heading system, or to compensate for unclear section structure.

Do not use a README to duplicate information that already has an authoritative,
discoverable owner:

- Do not list every Make target when `make` or `make help` is the command
  catalog. Mention only first-use commands or non-obvious workflows that a user
  must run in order.
- Do not restate CI job order, required checks, or branch filters when the CI
  configuration owns that truth. Mention CI only when users need a local parity
  command or a non-obvious environment prerequisite.
- Do not maintain exhaustive repository-layout tables that just mirror the file
  tree. Describe layout only when it teaches users where public contracts,
  configuration examples, generated files, or extension points live.
- Do not repeat full config schemas, generated API references, or package
  documentation when generated docs, sample config, `.proto` files, command
  help, or package docs are the source of truth. Include one representative
  example and link to the owner.
- Do not add "development workflow" sections that only name standard lint,
  test, format, security, or benchmark targets. Use the project workflow docs
  or `make help` for command discovery unless a command sequence is required
  before the project can be used.

Do not pass documentation based on these anti-patterns:

- Do not pass a README because it is long, has many headings, or follows an
  established local template while missing an applicable README responsibility.
- Do not fail or rewrite a README solely because its headings, order, or grouping
  differ from the reference audit shape while the applicable responsibilities
  are easy to find.
- Do not pass public API documentation because every exported symbol has a
  comment; verify that the comments document the contract users cannot infer
  from signatures or names.
- Do not pass examples that are stale, non-executable when the repository has an
  executable example convention, or not aligned with real imports, commands,
  configuration, request shapes, outputs, or errors.
- Do not pass README coverage that duplicates generated docs, package docs,
  command help, config schemas, `.proto` files, or sample config instead of
  linking to the authoritative owner.
- Do not treat local inconsistency as precedent when it hides identity,
  boundary, bootstrap, usage, configuration, operations, references, API
  contract, or example responsibilities.

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
