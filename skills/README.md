# Skills

Use the smallest skill that matches the task. Compose skills by letting the
outer workflow own the final response format and embedded skills provide facts,
checks, and findings.

## Mandatory Rule

Skills are mandatory operating rules, not advisory notes. When a selected skill
or repository `AGENTS.md` says to read, inspect, preserve, stop, ask, or avoid a
pattern, agents must do that before applying personal judgment. If an agent
believes a rule cannot work for the task, it must stop before editing, quote the
specific rule or local pattern, and ask for approval to deviate.

All skills may use sub-agents when the active runtime provides them. Use
sub-agents for delegation, parallel review, forward-testing, independent
validation, read-only exploration, or disjoint implementation work whenever they
can materially improve coverage or throughput.

When a selected skill requires delegation, parallel review, or forward-testing,
agents must use sub-agents. Do not treat required sub-agent use as optional
based on scope size, convenience, or local confidence, and do not claim extra
delegation wording is needed when the selected skill says the user's invocation
already grants permission.

## Common Composition

- `review-pr` orchestrates PR preparation with `project-workflow`,
  `change-validation`, relevant language standards, `doc-standards`,
  `code-review`, summary drafting, optional explicit `style-review`, and the
  review target.
- `code-issues` orchestrates a two-phase code-issue workflow: first aggregate confirmed
  `project-workflow`, `code-review`, and `security-audit` findings into
  `ISSUES.md`, then implement agreed fixes one code issue at a time.
- `test-gaps` orchestrates a two-phase test-gap workflow: first aggregate
  `project-workflow` context and confirmed missing or weak test coverage into
  `ISSUES.md`, then implement agreed test fixes one gap at a time.
- `doc-gaps` orchestrates a one-pass doc-gap workflow: aggregate
  `project-workflow` context and confirmed `$doc-standards` findings for
  README, docs, examples, comments, and docstring gaps, implement confirmed
  documentation fixes, validate them, and use `ISSUES.md` only for audit-only
  requests or unresolved gaps.
- `reliability-gaps` orchestrates a two-phase reliability-gap workflow: first
  aggregate `project-workflow` context and verified SRE, NALSD, operability,
  overload, observability, release-safety, recovery, or data-integrity gaps into
  `ISSUES.md`, then implement agreed reliability fixes one gap at a time.
- `repo-health` orchestrates daily or weekly repository health
  reporting across delivery flow, CI quality, release/deploy activity, and
  service reliability. It should use `project-workflow` for repository
  discovery and source boundaries, and keep missing GitHub, CircleCI,
  Kubernetes/DigitalOcean, or UptimeRobot data explicit.
- `diagnose-issue` orchestrates read-only CI and deployment failure diagnosis
  for a selected latest pipeline, explicit pipeline ID, latest deployment
  version, or explicit version. It should use `project-workflow` for repository
  context and the bundled Ruby collector before suggesting fixes.
- `code-review` performs the review pass and conditionally consults
  `security-audit` for security-sensitive scope.
- `style-review` performs an optional non-blocking polish pass when explicitly
  requested, after or separate from `code-review`; it must not replace bug,
  security, compatibility, test-gap, or doc-gap review.
- `security-audit` pairs with `change-safety` for code changes and
  `change-validation` for scanner, lint, or CI command selection.
- `testing-standards` covers language-agnostic test design and coverage
  decisions; pair it with language standards for idioms and
  `change-validation` for command selection.
- `doc-standards` covers README, docs, examples, command/config docs, public
  API comments, docstrings, and stale-doc review; pair it with language
  standards for API comments and docstrings, `naming-standards` for terminology,
  `change-safety` for documented contract changes, and `change-validation` for
  docs-related validation.
- `reliability-standards` covers SRE, NALSD, production-readiness, SLO,
  overload, observability, release-safety, recovery, and operability judgment;
  pair it with `change-safety`, `security-audit`, `testing-standards`, and
  `change-validation` as the scope requires.
- `naming-standards` covers cross-language naming judgment for domain clarity,
  vocabulary consistency, abstraction level, ambiguity, public terminology, and
  rename safety; pair it with language standards for language-specific idioms.
- `project-workflow` covers command discovery, CI expectations, downstream
  `./bin` wiring, and shared Makefile fragment behavior.
- `change-validation` should use `project-workflow` context before selecting
  validation commands for orchestrated workflows.
- Language standards pair with `change-validation` for check selection and
  `change-safety` when public APIs, commands, or documented behavior change.
  They pair with `naming-standards` when a change creates, reviews, or renames
  identifiers, commands, flags, files, tests, fixtures, or documentation terms.

## Workflow Plan Templates

Stateful workflow skills may include `references/plan.md`. These files are
canonical plan templates for active runtime execution state, not durable task
artifacts. Invoke the skill, for example `Find $test-gaps in <folder>`; the
skill loads its plan template and instantiates it against the current repository
root. In downstream repositories that vendor this project as `./bin`, the
consuming repository remains the execution context and `bin/skills/**` remains
shared guidance.

## Goal Binding

When the runtime supports goals, stateful workflow skills should bind one active
goal to the selected skill mode and requested scope. The goal states the
user-visible outcome, current waiting or blocked reason, and completion
condition. Goals are per-session runtime state, like active plans; do not write
them into the repository unless the human explicitly asks for a durable goal
artifact.

Goals do not bypass skill steps, stop gates, permission gates, scoped
`ISSUES.md` ledgers, human confirmation requirements, or validation freshness
rules. The selected skill still owns the workflow plan; the goal only makes the
intended outcome and current state explicit.
When the runtime has stricter status-transition rules, follow those runtime
rules and use the skill's goal rules to explain the waiting, blocked, or done
reason.

## Format Rule

When a skill is used as the final answer, use that skill's required output
format. When a skill is embedded by another skill, preserve its concrete facts
and use the caller's output format.

## Testing Principle

Use `testing-standards` when adding, reviewing, refactoring, or planning tests.
In brief: inspect the repository's existing tests, fixtures, helpers,
entrypoints, CI targets, and majority relevant test harness before adding new
structure.
Do not infer the test language from the implementation language; recommend or
update the majority relevant existing harness, even when it tests code written
in another language. Add language-native tests only when that is the majority
relevant pattern, the changed surface is a language-level package/API contract,
or the user explicitly asks for that level of coverage.
If the dominant relevant harness is Cucumber, Gherkin, RSpec-style features,
acceptance tests, or another cross-language repository-defined layer, agents
must not add language-native tests for convenience or private access. They must
stop and ask before using a different layer.
Prefer the narrowest established test layer that credibly covers changed
behavior through a public or documented surface; private-surface tests need
explicit human approval. Treat tests as executable specifications for observable
repository behavior, and for behavior-changing code prefer a small test-first
loop: add or update the focused test first in TDD-style projects, or the focused
scenario, feature, or spec first in BDD-style projects. Run it red when
practical, make the smallest implementation change to go green, then refactor
while keeping tests green. Report that trace in the final update so the workflow
is auditable. Preserve meaningful coverage where practical, verify coverage
claims when useful, scan for mutation-style gaps, and avoid coverage theater.
Keep tests readable, edge-aware, deterministic, and descriptive when they fail.

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
