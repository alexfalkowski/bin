# Documentation Standards

## Location

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
  behavior, non-obvious parameters, nil or return semantics, exceptions or
  errors, lifecycle, side effects, compatibility, and ownership boundaries.
- **Executable examples**: reusable API usage, representative command flows, or
  integration examples validated by the established test or example harness.
- **Schemas, `.proto` files, generated docs, and sample config**: exhaustive
  field, wire, and generated reference material. Link to these owners instead of
  duplicating them in README prose.

## Quality Bar

- **Correctness**: Describe current repository-owned behavior accurately. If
  docs conflict with code and tests, prove the implementation is wrong with
  non-prose evidence before changing code; otherwise update docs.
- **Completeness**: Document public entrypoints, exported APIs, commands,
  configuration keys, setup paths, migrations, and examples enough for the
  intended user to use or maintain them without reading private code first.
- **Location**: Put documentation where the target audience will look. Do not
  accept correct information in the wrong place when the intended user would not
  discover it before a risky decision.
- **Examples**: Keep examples and commands copy-paste-ready when practical,
  aligned with real entrypoints, and current with flags, config keys, package
  names, imports, outputs, and validation constraints. Prefer executable
  examples when the repository already has that convention.
- **Diagrams**: Use small ASCII diagrams only when they clarify control flow,
  data flow, ownership, protocol boundaries, dependency direction, state
  transitions, or lifecycle ordering better than prose. Do not add decorative
  diagrams or duplicate generated diagrams, schemas, `.proto`, config, or
  command output.
- **Public API comments and docstrings**: Explain exported behavior, contracts,
  nil or error behavior, compatibility constraints, side effects, deprecations,
  alias or wrapper relationships, and security or operational requirements when
  not obvious from the signature. Do not demand comments that merely restate the
  identifier, signature, return type, or obvious implementation.
- **Code comments**: Explain non-obvious intent, invariants, tradeoffs,
  bug-workaround context, copied-code sources, external standards, incomplete
  implementation state, or surprising behavior. Comments explain why the code
  exists or what contract it protects, not what each line does. If a clear
  comment cannot be written because the code is confused, recommend
  `$code-issues`.
- **Terminology**: Use consistent names for concepts, commands, config keys, API
  fields, and roles across docs, code, examples, and tests. Use
  `$naming-standards` when unclear terminology creates misuse or maintenance
  risk.
- **Audience**: Keep startup docs concise, current, and structured with headings
  and links to deeper docs. Do not bury critical setup, security, migration, or
  operational instructions in unrelated comments or long prose.
