# Skills

Use the smallest skill that matches the task. Skills are maintained operating
rules for agents that work in this repository and in downstream repositories
that vendor it as `./bin`.

This README is an orientation guide. The authoritative rules live in
`AGENTS.md`, each `skills/<name>/SKILL.md`, and shared references under
`skills/references/`.

## Mandatory Rule

Skills are mandatory operating rules, not advisory notes. Agents must follow the
selected skill before applying personal judgment. If a rule or local pattern
cannot work for the task, stop before editing, quote the governing instruction,
and ask for approval to deviate.

Use sub-agents only when the human explicitly authorizes delegation,
sub-agents, or parallel agent work, or when the active runtime or
higher-priority policy permits implicit delegation for the selected workflow.
If sub-agents are unavailable or not permitted, perform the work locally unless
the selected skill explicitly requires delegation and the request cannot be
completed safely without it.

Agents must report confidence before accepting findings, validation conclusions,
or completion. They must use 90% as the default minimum threshold. They must
use 95% for high-risk acceptance such as security findings, destructive actions,
public-interface or compatibility conclusions, release or PR readiness, broad
no-findings claims, and claims that a problem is definitely fixed. Confidence must be backed by concrete evidence; use
`skills/references/finding-severity.md` for calibration.

## Command Environment Prerequisite

Before any skill runs, retries, replaces, or recommends a command, establish the
repository command surface and execution environment. Prefer repository Make
targets, documented entrypoints, and CI analogues.

On developer machines, especially macOS, required tools may come from Homebrew
or the user's initialized shell. Compare important tool resolution such as
`make` or `ruby` against that environment before treating a failure as real. Do
not report shell resolution as a repository failure until that check is done. Do
not bypass Make targets. Do not invent direct commands, install alternate tools,
or retry variants merely to get something to run in the agent environment.

## Composition

- `review-pr`: orchestrates PR preparation with workflow discovery,
  validation, relevant standards, review, and summary drafting.
- `code-issues`: records confirmed code defects in `ISSUES.md`; fixes one
  agreed issue at a time.
- `test-gaps`: records confirmed missing or weak coverage in `TESTS.md`; fixes
  one agreed gap at a time.
- `doc-gaps`: performs a documentation gap pass and fixes confirmed doc gaps;
  uses `DOCS.md` only for audit-only or unresolved gaps.
- `feature-gaps`: records product-facing opportunities in `FEATURES.md`; route
  standalone test or project workflow concerns elsewhere.
- `project-gaps`: records build, CI, Makefile, release, setup, validation,
  command discovery, and workflow gaps in `PROJECTS.md`.
- `reliability-gaps`: records SRE, operability, overload, observability,
  release-safety, recovery, or data-integrity gaps in `RELIABILITY.md`.
- `repo-health`: summarizes delivery, CI, release/deploy, and reliability
  health from supported sources.
- `diagnose-issue`: performs read-only diagnosis of selected CI, deployment,
  rollout, runtime, monitor, or latest-version failures.
- `code-review`: reviews for bugs, regressions, compatibility, missing
  coverage, and documentation risk.
- `style-review`: optional non-blocking polish only when explicitly requested.
- `security-audit`: reviews security-sensitive code, tooling, dependencies, and
  configuration.
- `testing-standards`: owns test design, harness choice, coverage, fixtures,
  determinism, and test-layer judgment.
- `doc-standards`: owns README, docs, examples, command/config docs, comments,
  docstrings, and stale-doc judgment.
- `reliability-standards`: owns production readiness, SLO, overload,
  observability, release-safety, recovery, and operability judgment.
- `naming-standards`: owns domain clarity, vocabulary consistency, abstraction
  level, ambiguity, public terminology, and rename safety.
- `project-workflow`: owns command discovery, CI expectations, downstream
  `./bin` wiring, and shared Makefile fragment behavior.
- `change-validation`: owns repository-defined check selection and validation
  reporting.
- `change-safety`: owns compatibility, documented interfaces, migrations,
  generated files, dependencies, and security-sensitive edits.
- Language standards pair with validation, safety, naming, docs, and testing
  skills as the touched surface requires.

## Workflow State

Stateful gap and review workflows may include `references/plan.md`; those files
are templates for runtime execution state, not durable project artifacts. Shared
workflow mechanics live in `skills/references/gap-workflow.md`.

Use runtime goals only when the human explicitly requests them or
higher-priority runtime instructions allow goal creation for the selected
workflow. Otherwise maintain stateful workflow progress in the conversation or
tool plan. Goals do not bypass skill steps, stop gates, permission gates,
scoped ledgers, human confirmation requirements, or validation freshness rules.

## Output And Validation

When a skill is the final response, use that skill's required output format.
When a skill is embedded by another skill, preserve its concrete facts and use
the caller's output format.

Use `testing-standards` before adding, reviewing, refactoring, or planning tests.
In brief: inspect the dominant relevant harness, test observable
repository-owned behavior through public or documented surfaces, keep tests
readable and deterministic, and avoid coverage theater.

Before running commands that require SSH credentials, GitHub auth, registry
auth, cloning, fetching large dependencies, pushing, publishing, opening PRs, or
updating remote state, make the requirement explicit and get permission. Treat
network, credential, shell, `PATH`, and missing-tool failures as environment or
validation gaps unless repository evidence proves otherwise.

## Maintenance

- Update existing docs and examples when public commands, APIs, Make targets,
  environment variables, file formats, output shapes, or operator-facing
  behavior change.
- When a skill's trigger, scope, workflow, or user-facing behavior changes,
  check `agents/openai.yaml` and keep it concise.
- Treat skills as maintained artifacts and review them when project workflow,
  tooling, model behavior, or team conventions change.
- Treat external skills like third-party dependencies. Use `security-audit` with
  `references/skills.md` for skill-specific security review.
