# README Standard

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
  help, or package docs are the authoritative documentation owner. Include one
  representative example and link to the owner.
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
