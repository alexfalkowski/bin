---
name: doc-standards
description: Applies documentation quality standards for README files, user-facing docs, examples, command/config docs, public API comments, docstrings, and behavior changes that may make existing documentation stale. Use when writing, reviewing, or updating documentation; when changed code affects documented behavior; when $code-review or $review-pr needs documentation judgment; and when $doc-gaps needs criteria for scoped documentation triage.
---

# Doc Standards

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

These rules follow the rule set from Stack Overflow's "Best practices for
writing code comments":
https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/

- Do not duplicate the code. Remove comments that only translate syntax,
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

Use this default README shape unless the repository already has a stronger
local convention:

```markdown
# <Project Name>

<One or two sentences explaining what this project does and who should use it.>

## Why This Exists

<The problem it solves, the boundary it owns, and the tradeoff or design choice
that helps users decide whether it fits.>

## Install Or Bootstrap

<Only the commands required before the first useful command can run, such as
package installation, submodule initialization, dependency setup, or required
runtime assets.>

## Usage

<A minimal, copy-paste-ready example through the main public API, CLI, service
endpoint, package import, or configuration path.>

## Configuration

<Only the configuration users must understand to run or integrate the project.
Link to schema, examples, generated docs, or sample config when exhaustive
field documentation belongs there.>

## Operations

<Security, deployment, compatibility, data freshness, health, migration,
shutdown, or observability notes that affect real use. Omit this section when
the project has no operator-facing behavior.>

## References

<Links to generated API docs, protobuf contracts, examples, changelog, package
docs, or deeper design notes.>
```

Keep, add, remove, or rename sections based on the project type:

- Libraries usually need install/import guidance, a minimal API example,
  version or compatibility notes, and links to generated package docs or
  executable examples.
- Services usually need the service boundary, supported transports, local
  bootstrap, representative configuration, request examples, health or
  operational endpoints, deployment constraints, and API contract links.
- Shared tooling repositories usually need the supported integration path,
  minimal bootstrap, extension points, compatibility boundaries, and links to
  command help or included templates.

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
