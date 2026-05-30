# Skills

Use the smallest skill that matches the task. Compose skills by letting the
outer workflow own the final response format and embedded skills provide facts,
checks, and findings.

## Common Composition

- `review-pr` orchestrates PR preparation with `project-workflow`,
  `change-validation`, relevant language standards, `code-review`, summary
  drafting, and the review target.
- `code-issues` orchestrates a two-phase code-issue workflow: first aggregate confirmed
  `project-workflow`, `code-review`, and `security-audit` findings into
  `ISSUES.md`, then implement agreed fixes one code issue at a time.
- `test-gaps` orchestrates a two-phase test-gap workflow: first aggregate
  `project-workflow` context and confirmed missing or weak test coverage into
  `ISSUES.md`, then implement agreed test fixes one gap at a time.
- `doc-gaps` orchestrates a two-phase doc-gap workflow: first
  aggregate `project-workflow` context and confirmed README, docs, examples,
  comments, and docstring gaps into `ISSUES.md`, then implement agreed
  doc fixes one gap at a time.
- `code-review` performs the review pass and conditionally consults
  `security-audit` for security-sensitive scope.
- `security-audit` pairs with `change-safety` for code changes and
  `change-validation` for scanner, lint, or CI command selection.
- `testing-standards` covers language-agnostic test design and coverage
  decisions; pair it with language standards for idioms and
  `change-validation` for command selection.
- `project-workflow` covers command discovery, CI expectations, downstream
  `./bin` wiring, and shared Makefile fragment behavior.
- `change-validation` should use `project-workflow` context before selecting
  validation commands for orchestrated workflows.
- Language standards pair with `change-validation` for check selection and
  `change-safety` when public APIs, commands, or documented behavior change.

## Format Rule

When a skill is used as the final answer, use that skill's required output
format. When a skill is embedded by another skill, preserve its concrete facts
and use the caller's output format.

## Testing Principle

Use `testing-standards` when adding, reviewing, refactoring, or planning tests.
In brief: inspect the repository's existing tests, fixtures, helpers,
entrypoints, CI targets, and dominant test harness before adding new structure.
Prefer the narrowest established test layer that credibly covers changed
behavior through a public or documented surface; private-surface tests need
explicit human approval. For behavior-changing code, prefer a test-first loop:
add or update the focused test first in TDD-style projects, or the focused
scenario, feature, or spec first in BDD-style projects. Run it red when
practical, make the smallest implementation change to go green, then refactor
while keeping tests green. Report that trace in the final update so the workflow
is auditable. Preserve meaningful coverage where practical, check whether new or
risky behavior needs better coverage, and explain unavoidable gaps. Keep tests
readable, edge-aware, deterministic, and descriptive when they fail.

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
