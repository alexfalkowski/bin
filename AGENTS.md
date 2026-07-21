# AGENTS.md

## Repository purpose

This repository is a collection of shared **executables** and **Makefile
includes** reused across projects as a Git submodule mounted at `./bin`. See
`README.md`.

Most of the code here is small Bash/Ruby utilities plus reusable make fragments under `build/make/`.

## Non-negotiable agent rules

The instructions in this file and the selected `skills/**/SKILL.md` files are
mandatory operating rules, not advisory guidance. Agents MUST follow them
before applying personal judgment.

Agents MUST:

- Read and follow the smallest matching skill before taking task action.
- Treat sub-agents as usable only when the active runtime provides them and the
  current user request explicitly asks for sub-agents, delegation, or parallel
  agent work. When sub-agents are authorized, use them for delegation, parallel
  review, forward-testing, independent validation, read-only exploration, or
  disjoint implementation work whenever they can materially improve coverage,
  confidence, throughput, or implementation safety. When the selected skill
  requires delegation, parallel review, or forward-testing, do not treat that
  required use as optional based on scope size, convenience, or local
  confidence.
- At the delegation gate, continue locally only when the selected skill does not
  require delegation and the required confidence threshold can still be met.
  Otherwise stop: if the current request does not authorize sub-agents, ask for
  explicit current-request sub-agent authorization; if authorized sub-agents are
  unavailable, forbidden, or denied by the runtime, state the blocked delegation
  requirement plus the runtime limitation. Do not offer a local-only pass as
  equivalent, as the default next step, or as acceptable merely because the
  repository looks small.
- Report an explicit confidence percentage before treating any result, finding,
  validation conclusion, or task as accepted or complete. Use an explicit
  confidence target from the current request when one is provided; otherwise,
  use a 90% default minimum and a 95% default for high-risk acceptance:
  security findings, destructive actions, public-interface or compatibility
  conclusions, release or PR readiness, CI/deployment root-cause conclusions,
  broad no-findings claims, and claims that a problem is definitely fixed. An
  explicit target may be lower or higher than those defaults, but it does not
  waive evidence, challenge-pass, approval, validation, security, or
  compatibility requirements. Back every number with concrete evidence — source
  inspection, tests, logs, scanner output, official documentation, runtime
  behavior, or repository history. Below the active threshold, gather more
  evidence or state the blocker instead of accepting completion, and state the
  reduced assurance and residual risks when an explicit target lowers a default.
  Do not claim 100% certainty for any repository result; if requested, continue
  gathering evidence where useful but report residual uncertainty instead of
  stating that the result is certain.
- For ledger findings and validation conclusions, prefer reproducible local
  evidence from the smallest supported command, test, scenario, trace, lookup,
  or negative search that demonstrates the claim. CI running later is not
  reproduction evidence unless a current CI result or equivalent
  repository-defined command has been observed and classified.
- Before accepting confidence at or above the required threshold, perform a
  challenge pass. Material unresolved questions, alternate owners, unsupported
  paths, or counterexamples must lower confidence; questions already answered by
  inspected evidence must not.
- Calibrate durable findings against supported usage evidence. In reusable
  libraries, helpers, or shared tooling, package-local synthetic tests, fakes,
  manual construction, and unsupported downstream patterns are leads, not enough
  evidence for a durable finding by themselves. Before recording a high-
  confidence issue, inspect a supported consumer, executable example,
  integration test, module wiring path, documented contract, CI workflow, or
  comparable real usage path that can trigger the candidate. If supported usage
  evidence cannot be found, lower confidence below the active recording
  threshold, route the concern to the correct workflow, or state the evidence
  gap instead of recording it.
- Route findings about third-party libraries, frameworks, tools, or project-owned
  upstream libraries to the owner of the fix. Use `project-gaps` only for the
  repository-owned dependency/tooling response; route project-owned upstream
  library bugs to that library's agent or ledger unless local adapter behavior is
  independently wrong.
- Treat unowned working-tree changes as human changes by default. Do not undo,
  overwrite, reformat, relocate, or "clean up" changes the agent did not make;
  if they affect the current task, explain the conflict and ask before editing
  them.
- When reviewing, auditing, or incidentally noticing an issue outside the
  current explicitly approved implementation scope, validate the candidate
  against repository evidence and present the proposed fix before editing. When
  more than one credible fix exists, compare the practical options and evidence
  instead of implementing a self-selected design.
- Follow existing repository patterns over personal judgment.
- Treat skill workflow steps using "must", "do not", or "stop" language as
  blocking requirements.
- Stop and ask before deviating from a selected skill, repository instruction,
  dominant test harness, local style, or documented workflow, and state the
  exact instruction being deviated from before proposing any deviation.
- Treat a checklist item the agent itself declared (for example "TDD decision:
  scenario-first") as a binding commitment. If it cannot be honored, STOP at that
  item and flag the deviation before continuing; silence is a violation.
- Re-read the selected skill and identify the governing instruction when the
  human challenges process, asks what the skill says, or points out a suspected
  instruction violation.

Agents MUST NOT:

- Add cryptic tests that only prove internal call order, implementation timing,
  provider wiring, or third-party behavior when no observable repository-owned
  contract changes.
- Introduce import aliases, abstractions, helpers, files, or validation paths
  for personal clarity when local patterns already exist.
- Start edits for review findings, audit findings, incidental discoveries, or
  adjacent issues before the human approves what will change. When multiple
  credible approaches exist, present the options and evidence first. This gate
  is waived only when the current request explicitly says not to use it or
  grants free-form implementation authority for that scope.
- Treat `AGENTS.md` or `SKILL.md` instructions as optional.
- Continue after discovering they violated an instruction; they must correct
  course immediately and remove their own noncompliant change.
- Report `Red`, `Green`, `Refactor`, or any TDD cycle without pasting the actual
  command and its output; never narrate end-of-run debugging of already-written
  code as a red-then-green cycle.
- Present work as test-driven when the failing test was never observed before
  implementation; label such work "test-after (not TDD)" with the reason.

## Inherited credential handling

Credentials exported by an operator shell and inherited by trusted-repository
Make targets are intentional. This policy preserves that workflow while
preventing accidental disclosure in agent-visible output.

Agents MUST:

- Treat inherited environment values and credential material as secrets. Redact
  any such value encountered accidentally and do not repeat it in a response.
- Keep approved credential-dependent Make targets usable in trusted
  repositories; this policy does not prohibit those targets from inheriting
  credentials.

Agents MUST NOT:

- Print, enumerate, serialize, copy, commit, or include inherited environment
  values or credential material in command output, logs, patches, or responses.
- Run generic environment dumps (`env`, `printenv`, `set`, `export -p`,
  `declare -x`, or `typeset -x`), shell tracing (`set -x`, `zsh -x`, or
  `bash -x`), or Make database/debug modes that can expose inherited values.
- Source shell startup files solely to obtain credentials for an agent command.

## Instruction precedence

If there is a conflict, precedence is:

1. System/developer instructions.
2. The consuming repository's `AGENTS.md`.
3. This shared `bin/AGENTS.md`.
4. The selected `skills/**/SKILL.md`.
5. Existing local code, test, docs, and workflow patterns.
6. Agent judgment.

## Local pattern binding

Before editing, agents MUST inspect nearby files and the relevant test,
configuration, documentation, and validation surfaces. Agents MUST preserve
local import, naming, file layout, configuration key, test-layer, and validation
patterns unless the task explicitly requires changing them.

Do not introduce import aliases, new helper layers, new test layers, or new
validation paths merely to avoid ambiguity. Use the existing local style. If the
existing style appears unsafe or insufficient, stop and ask before changing it.

## Shared skills

Use the smallest matching skill in `skills/`; its frontmatter and
`agents/openai.yaml` own discovery details. The root policy only routes the
main cross-cutting concerns:

- `project-workflow` for repository commands, CI, `./bin` wiring, and Make
  fragments.
- `change-safety` for compatibility, documented interfaces, migrations,
  generated files, dependencies, and security-sensitive edits.
- `change-validation` for repository-defined checks.
- `doc-standards` for documentation; use the language standards and
  `naming-standards` when their scopes apply.
- `code-review`, `security-audit`, and `style-review` for their named review
  scopes.
- `testing-standards` before adding, reviewing, refactoring, or planning tests.
- Use API, reliability, Go, Ruby, and shell standards when those scopes apply.
- `Start`, `Approved`, and `Done` IDs route to the matching gap skill by
  prefix.

Treat this `AGENTS.md` as the repo-specific companion to those skills.

## Remembered workflow commands

Treat these short commands as binding workflow shorthands, not casual prose.
They select the matching skill and its gates before any edits. Each ledger
skill's `ledger.yaml` declares its accepted ID prefix and canonical ledger
path; route each ID through that contract.

`Start` begins the workflow, `Approved` accepts the presented solution, and
`Done` confirms an entry is verified. After any verb, name the ID and add
`in path/LEDGER.md` when the ID is ambiguous. The optional `with agents`,
`with a goal`, and `with agents and a goal` tails carry current-request
authorization.

These authorization tails also apply after a generic skill invocation, such as
`$skill-name in SCOPE`, `Find $skill-name in SCOPE`, or
`Implement $skill-name in SCOPE`. They carry the same current-request
authorization without changing the skill's mode, default behavior, or approval
gates. `SCOPE` is interpreted by the selected skill: normally a package or
folder, but it may be a CI/deployment target, repository and reporting period,
or another skill-defined target. Skills that do not accept a generic scope
remain explicit-request exceptions. `review-pr` is one such exception: its
bare current-request invocation targets the current repository and means the
full review, validation, commit, force-push, and draft-PR workflow; it does not
use a path scope.

- `Start ID in SCOPE`: select the matching gap skill, resolve the exact scoped
  ledger path from its `ledger.yaml`, refresh evidence, present the solution,
  and stop at the agreement gate before editing. Use `in LEDGER_PATH` only when
  the skill or scope is ambiguous.
- `Approved ID with agents`: approve the presented solution and
  authorize sub-agents for implementation or fresh review when useful.
- `Start ID with a goal`: authorize a runtime goal when goals are
  available and useful.
- `Start ID with agents and a goal`: authorize both sub-agents and a
  runtime goal.
- `Done ID`: confirm the entry is verified and complete; the selected
  skill continues with the next entry. The `with a goal` and `with agents and
  a goal` tails apply here too.

These commands are shorthand only. They do not bypass solution agreement,
scoped ledger rules, validation freshness, confidence thresholds, remote-write
permission, or the selected skill's output format.

## Skill workflow mechanics

Stateful gap and review workflows use their `references/plan.md` and
`skills/references/gap-workflow.md`; read them only when that workflow is
selected. Use `skills/references/long-running-work.md` for substantial or
ambiguous multi-iteration work.

When a skill owns the final response, use its required output format. When a
skill is embedded by another skill, preserve its concrete facts and use the
caller output format.

Runtime goals and sub-agents require current-request authorization and never
bypass approval, validation, or confidence gates. Use `testing-standards`
before adding, reviewing, refactoring, or planning tests.

Before direct commands that may use SSH, GitHub or registry credentials,
cloning, publishing, or remote state, make the external effect explicit and
rely on the active agent configuration for command approval behavior. A
repository Make target may perform those actions without a separate command
prompt, but it does not expand the current request's scope. For consuming
repositories, read local instructions first, then the relevant `bin/skills/**`
references; exclude unrelated `bin/**` content from searches and reason about
shared Make behavior from the consumer root.

## Downstream repository defaults

When working from a repository that vendors this project as `./bin`, first
inspect its local `AGENTS.md`, `README.md`, root `Makefile`, and CI
configuration. After confirming the shared wiring, read
`skills/project-workflow/references/downstream-defaults.md` when downstream
specific defaults apply. The consuming repository's own `AGENTS.md` has
precedence.

## Skill composition

The selected skill owns its scope and output. Read only the paired skills it
names and use their facts in the selected skill's format. The common routing is:

- Gap workflows pair with `project-workflow` and their domain standards.
- `review-pr` pairs with workflow, validation, documentation, and review
  skills.
- Security-sensitive work uses `security-audit`; reliability work uses
  `reliability-standards`.
- API, language, naming, documentation, testing, and validation skills apply
  only when their scopes match.

The selected skill's `References` section is authoritative; do not duplicate
the full pairing matrix here.

## Test harness selection

Before recommending, adding, reviewing, or changing tests, use
`testing-standards` to identify the caller-facing boundary, dominant existing
harness, narrowest supported selector, and repository-defined validation path.
Do not infer the test language from the implementation language alone.

## Command execution policy

- Treat the repository's Makefile, shared make fragments, and CI configuration
  as the source of truth for setup, lint, tests, security, benchmarks, and
  review commands.
- Run from the repository root and prefer exposed `make` targets over direct
  tools. Show command discovery with `make` or `make help`.
- Treat repository Make targets as the trusted prompt-free execution interface,
  including targets that are destructive, access external services, or update
  remote state. Run them only when their outcome is authorized by the current
  request and the selected workflow.
- When a recurring supported action has no Make target, mention the smallest
  useful `*.mak` addition at handoff; do not add unrelated Make targets during
  the current task without approval.
- For code or test changes, use the narrowest supported selector first; use
  `make dep` when Ruby, generated, or vendored state requires setup.
- Use `make scripts-lint` for shell changes, `make skills-lint` for skills or
  agent-policy changes, `make docker-lint` for Dockerfiles, `make lint` for
  Ruby, and `make sec` for security-sensitive changes.
- Before any selected skill runs, retries, replaces, or recommends a command,
  establish the command surface, initialized shell, CI analogue, and
  credential/network requirements.
- Compare tool resolution with `zsh -lic` when PATH or Homebrew differences
  matter. If resolution differs, rerun Make targets through the initialized
  shell before treating the failure as real.
- After a repository-defined command fails, classify the failure before retrying.
  Do not replace a failed target with an ad hoc command, alternate layer, or
  alternate tool just to make progress.
- Do not manually background a long-lived process with a bare `&`/`nohup`
  expecting to stop it from a later command; each assistant's sandbox handles
  signal delivery differently, and a mishandled one can leak or interfere
  with subsequent runs. If the active assistant exposes a documented,
  verified tracked background-task mechanism, use it; otherwise keep process
  startup, use, and cleanup within one tool call — see
  `skills/project-workflow/references/agent-init.md` for the exact per-assistant
  behavior.

## Local contracts

- Public shared surfaces live in `build/make/`, `build/docker/`, `build/go/`,
  `build/git/`, `build/sec/`, `build/claude/`, `quality/`, and `skills/`;
  inspect the relevant files before editing.
- Preserve formatting from `.editorconfig`, Ruby settings from `.rubocop.yml`,
  and nearby Bash/Ruby style. Do not duplicate those config files here.
- Make fragments derive `BIN_ROOT` from their include location. For path-related
  changes, validate direct use in this repository and downstream `./bin`
  include behavior when feasible.
- `build/docker/env` clones or updates `git@github.com:alexfalkowski/docker.git`
  in sibling `../docker`; `make start` and `make stop` paths can require SSH and
  network access.
- `quality/go/*` helpers read and write under `test/reports/`; preserve that
  downstream test-report contract.
- `build/go/lint` is a no-op unless `golangci-lint` exists in `PATH`; do not
  report full lint coverage unless the binary ran.
- `master` is the canonical branch in this repo and shared fragments. Hardcoded
  `master` references in `build/go/clean`, `build/make/git.mak`,
  `build/make/buf.mak`, and `.circleci/config.yml` are intentional.
- `build/make/git.mak` intentionally adds a random suffix to `USER` for branch
  creation to reduce local branch-name collisions.
- Treat Ruby/tooling version skew as intentional, including differences between
  the CI image, local Ruby configuration, and RuboCop target settings, unless
  the task explicitly modernizes CI or Ruby tooling.
- Do not flag the intentional contracts above as bugs unless the task is
  specifically about changing that contract.

## When changing this repo

- Prefer the smallest compatible change; these scripts are reused across
  projects.
- Update existing docs and examples when public commands, APIs, Make targets,
  environment variables, file formats, output shapes, or operator-facing
  behavior change.
- Update `skills/<name>/agents/openai.yaml` when a skill's trigger, scope,
  workflow, display name, short description, default prompt, or user-facing
  behavior changes.
- Keep skills tool-agnostic. `skills/<name>/SKILL.md` is shared by Codex and
  Claude Code, so do not hardcode a single assistant; where attribution or
  invocation differs, cover both. `make codex-init` (`build/codex/init`) and
  `make claude-init` (`build/claude/init`) wire the two assistants by symlinking
  `skills/` and the shared permission profiles into place; see
  `skills/project-workflow/references/agent-init.md` for the exact symlinks,
  sandbox posture, runtime approval guardrails, and trusted-repository caveats. Use those
  profiles only in trusted repositories, because Make targets inherit the user's
  host access and sandboxed commands can read credentials and use the network.
- Treat skills as maintained artifacts and review them when project workflow,
  tooling, model behavior, or team conventions change.
- Treat external skills like third-party dependencies. Use `security-audit` with
  `skills/references/skills.md` for skill-specific security review.
- After edits, run the narrowest repository-defined checks that cover the
  changed files, then expand to CI-equivalent targets when risk justifies it.
