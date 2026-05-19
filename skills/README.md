# Skills

Use the smallest skill that matches the task. Compose skills by letting the
outer workflow own the final response format and embedded skills provide facts,
checks, and findings.

## Common Composition

- `review-pr` orchestrates PR preparation with `change-validation`, relevant
  language standards, `code-review`, and `pr-summary`.
- `code-review` performs the review pass and conditionally consults
  `security-audit` for security-sensitive scope.
- `security-audit` pairs with `change-safety` for code changes and
  `change-validation` for scanner, lint, or CI command selection.
- `makefile-includes` should follow `project-workflow` when the command surface
  or downstream `./bin` wiring is not yet known.
- Language standards pair with `change-validation` for check selection and
  `change-safety` when public APIs, commands, or documented behavior change.

## Format Rule

When a skill is used as the final answer, use that skill's required output
format. When a skill is embedded by another skill, preserve its concrete facts
and use the caller's output format.

## Testing Principle

Before adding tests, inspect the repository's existing test suites, fixtures,
helpers, entrypoints, and CI targets, then follow that standard. Prefer tests
and validation through the existing public or documented entry points for the
project type: libraries often use unit/integration tests, while services in
this ecosystem often use Cucumber features. Use internal seams only when the
repo already tests that way, the behavior cannot be exercised credibly through
the established surface, or the change has no stable public surface.

- Do not introduce a new test framework, fixture layout, or test layer unless
  the task explicitly changes testing infrastructure.
- Choose the narrowest established test layer that credibly covers the changed
  behavior; use broader suites for shared infrastructure or release-sensitive
  changes.
- Assert changed behavior and contracts, not incidental implementation details.
- Keep tests deterministic: avoid uncontrolled network, wall-clock time, random
  data, ordering assumptions, real home directories, and shared mutable state.
- Cover relevant failure paths, especially invalid input, missing files/tools,
  non-zero commands, path errors, permissions, and argument pass-through.
- Do not add behavioral tests for docs-only or formatting-only changes; run the
  relevant lint, docs, or formatting validation when available.
- For shared `./bin` scripts and make fragments, validate from the consuming
  repository root when behavior depends on downstream `$(PWD)/bin/...` wiring.
- Report validation gaps honestly, including lint-only coverage, missing tools,
  skipped checks, and wrappers that no-op.

## Network And Remote Commands

- Networked commands are acceptable when needed for setup, validation,
  dependency resolution, scanning, or workflow execution.
- Before running commands that require SSH credentials, GitHub auth, registry
  auth, cloning, fetching large dependencies, pushing, publishing, opening PRs,
  or updating remote state, make the network/auth requirement explicit and get
  user permission.
- Treat remote-write commands such as push, publish, release, Docker manifest
  push, Buf push, and PR update/open flows as permission-gated even when a local
  Make target wraps them.
- If a needed command fails because network or credentials are unavailable,
  report it as an environment or validation gap rather than a code failure.

## Documentation And Examples

- When a public command, API, Make target, environment variable, file format,
  output shape, or operator-facing behavior changes, update the repository's
  existing docs and examples in the same change.
- Prefer updating existing README snippets, inline docs, examples, feature
  files, or operator docs over creating new documentation locations.
- If docs or examples are not updated for a user-facing change, state why they
  are not needed.

## Skill Metadata

- When a skill's trigger, scope, workflow, or user-facing behavior changes,
  check the matching `agents/openai.yaml` and update its display name, short
  description, or default prompt if they became stale.
- Keep `agents/openai.yaml` concise; it should describe when to use the skill,
  not repeat the full `SKILL.md` workflow.

## Skill Lifecycle

- Treat skills as maintained artifacts: review them when project workflow,
  tooling, model behavior, or team conventions change.
- Skills generated or drafted by a model need human review before adoption.
- Periodically compare representative tasks with and without a skill; retire a
  skill when it no longer improves outcomes or consistently overrides better
  native behavior.

## Skill Security

- Treat external skills like third-party dependencies and review the full folder
  before use.
- Check descriptions for prompt injection or overbroad routing, and check bundled
  scripts/assets for data exfiltration, broad filesystem access, remote code
  execution, and unnecessary permissions.
- Use `security-audit` with `references/skills.md` for skill-specific security
  review.
