# Naming Conventions

## Core Principle

A good name says what concept the thing represents, what promise it makes, or
what role it plays in the surrounding system. Prefer boring precision over
cleverness.

## Decision Order

1. Name the domain concept.
2. Match existing project vocabulary.
3. Match the abstraction level of the surrounding code.
4. Apply language-specific spelling and idiom.
5. Check compatibility and migration cost.

## Good Names

- Use the domain's nouns and verbs where they already exist.
- Distinguish concepts that change independently.
- Make booleans read as true or false claims.
- Make collections plural when the language and local style support it.
- Make errors, statuses, modes, and states specific enough to guide callers.
- Name tests and scenarios after behavior, not implementation mechanics.
- Name helpers after the transformation or responsibility they own.
- Use symmetry when APIs expose paired operations, for example encode/decode,
  start/stop, load/save, or open/close.

## Names To Question

- Generic nouns: `data`, `info`, `item`, `object`, `thing`, `value`, `result`,
  `manager`, `handler`, `helper`, `util`, `common`, or `misc`.
- Names that describe implementation instead of meaning: `map`, `list`, `json`,
  `string`, or `wrapper`, unless that detail is the contract.
- Names that hide side effects, persistence, network calls, mutation, or process
  execution.
- Names that reuse one term for multiple concepts in the same scope.
- Names that introduce a synonym when the project already has a clear term.
- Names that are only clear after reading the implementation.
- Abbreviations that are not established in the language, project, or domain.

## Boolean Names

- Prefer names that read naturally in conditionals.
- Avoid negative booleans when possible, especially double negatives.
- Use positive capability or state names when they make call sites clearer.
- Let language standards decide exact idioms, such as Ruby `?` methods or Go
  exported boolean names.

## Public Names

- Public API, command, flag, environment variable, metric, event, file format,
  and documentation terms are compatibility surfaces.
- Rename public names only when the old name is materially misleading, unsafe,
  inconsistent with the documented contract, or worth a migration.
- For public renames, consider aliases, deprecation notes, migration docs,
  changelog entries, and tests that protect backward compatibility.

## Review Bar

Do not report naming preferences as findings by themselves. A naming finding
must explain the concrete risk: ambiguity, wrong domain meaning, public contract
confusion, likely misuse, inconsistent vocabulary, or maintenance cost.
