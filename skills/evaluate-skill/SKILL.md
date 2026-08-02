---
name: evaluate-skill
description: Evaluate an existing agent skill for unnecessary, duplicated, misplaced, or over-specific text without editing it. Use when users ask whether skill instructions are still needed, want to prune or simplify a skill, compare a lean candidate with the current version, or reassess skill value after model changes. Default to read-only inspection; use isolated comparison runs only with explicit current-request sub-agent authorization.
---

# Evaluate Skill

## Operating Stance

Treat each instruction as a hypothesis about observable skill behavior. Prefer
the smallest skill that preserves its supported contracts, safety boundaries,
and useful outcomes.

Keep the target skill read-only. Create candidate revisions only in temporary
storage and report proposed changes; do not implement them under this skill.
Treat conclusions as model- and runtime-specific, and record that context when
it is available.

Use the active repository confidence threshold. Default to 90%, or 95% for
security, destructive behavior, compatibility, public interfaces, broad
no-regression claims, or other high-risk conclusions. Never claim 100%.

## Modes

- `inspect` is the default. Use no sub-agents and make no behavioral claim.
- `quick` evaluates one coherent candidate with one case and exactly two
  top-level task runs: current skill and candidate skill.
- `standard` evaluates one coherent candidate with two or three cases and two
  task runs per case.
- `thorough` is explicit-only. Add edge cases, repetitions when variance
  matters, a no-skill baseline when measuring the entire skill's value, and an
  independent comparator or human review when the decision warrants them.

Invoke comparison modes with current-request authorization, for example:
`$evaluate-skill quick in skills/style-review with agents`. If the mode is
omitted, use `inspect`.

## Common Setup

1. Resolve the target skill and read its complete `SKILL.md`, agent metadata,
   and only the directly relevant references needed to understand the candidate.
2. Identify the skill's user-visible purpose, supported callers or examples,
   repository instructions, and requirements it uniquely owns.
3. Do not treat a model's current default behavior as permission to remove a
   normative rule, private fact, safety boundary, compatibility requirement, or
   repository-specific workflow.
4. Select one coherent section or repeated idea at a time. Do not combine
   unrelated removals in one candidate.
5. Classify the candidate as `keep`, `move`, `consolidate`, or
   `evaluate removal`.
6. Before accepting a conclusion, challenge it with rare but supported uses,
   alternate instruction owners, downstream portability, and counterexamples.

For shared skills, require a documented contract, supported consumer, realistic
example, integration path, or comparable usage before making a durable claim.
Synthetic prompts alone are leads rather than proof of supported behavior.

## Inspect Mode

Identify at most three high-value candidates and explain:

- the exact section or repeated idea;
- its current purpose and owner;
- why it may be generic, duplicated, conditional, or misplaced;
- the proposed action and risk if the judgment is wrong.

Label behavioral comparison as `not run` and removal as unproven. Inspection
may recommend a comparison mode, but it must not claim that output quality is
preserved.

## Comparison Gate

Before `quick`, `standard`, or `thorough`:

1. Require the current request to explicitly authorize sub-agents, delegation,
   parallel agents, or `with agents`.
2. If authorization is absent, stop after inspection and request it. Do not
   present a same-context run as equivalent independent evidence.
3. If authorized sub-agents are unavailable, state the runtime limitation and
   stop the comparison.
4. Use only non-mutating tasks, snapshots, fixtures, or temporary workspaces.
   Never let evaluation runs change the source repository, production systems,
   remote state, or external services.
5. State the top-level run count and any nested agents required by the target
   skill before starting. If the selected mode cannot honor the target's
   mandatory workflow within the disclosed cost, stop instead of disabling that
   workflow or understating the evaluation cost.

## Run Comparisons

1. Snapshot the current skill in temporary storage and create a candidate that
   changes only the selected section or idea.
2. Choose realistic tasks from supported usage evidence. Include the boundary
   the candidate instruction is intended to protect.
3. Define two to four observable assertions before starting the runs. Assert
   user-visible outcomes and contracts, not exact wording, internal reasoning,
   tool call order, or implementation timing.
4. Start each current-and-candidate pair together when runtime capacity allows.
   Give both task agents the same raw request and fixtures.
5. Give task agents only the assigned skill path, task, inputs, output location,
   and expected artifact type. Do not leak assertions, pruning rationale,
   suspected failures, the intended winner, or prior conclusions.
6. Compare both outputs against the assertions and record concrete evidence for
   every pass or failure. Use deterministic checks for mechanical properties
   when available.
7. Record runtime tokens and duration only when the runtime provides them. Do
   not estimate missing usage data; report exact skill size differences instead.
8. Clean up only temporary artifacts created by the evaluation after preserving
   the evidence needed for the report.

## Decision Rules

- Keep or revise the instruction when the candidate regresses.
- Propose consolidation, relocation, or removal only when the candidate is
  equal or better on the tested behavior and the challenge pass finds no
  unresolved owner, supported path, or material counterexample.
- Do not accept high-risk removal from `quick`; use at least `standard` and the
  95% confidence threshold.
- Treat an equal no-skill baseline as evidence only for the tested cases, not a
  broad claim that the skill has no value.
- Lower confidence when results vary, supported usage is missing, assertions
  are subjective, runtime data is unavailable, or the candidate affects more
  behavior than the cases exercise.
- Never edit the evaluated skill from this workflow. Present the proposed patch
  or exact change and wait for explicit implementation approval.

## Output

Use this structure:

```markdown
## Evaluation

- Target: path
- Mode: inspect | quick | standard | thorough
- Candidate: exact section or idea
- Supported use: evidence source
- Comparison: not run | current versus candidate | current versus candidate versus no skill
- Cost: task runs performed and available usage data

## Evidence

- Assertions and concrete results, or source-only inspection evidence.
- Skill size: current and candidate exact measurements when compared.

## Recommendation

- Decision: keep | move | consolidate | propose removal | insufficient evidence
- Rationale: concise evidence-based explanation
- Confidence: percentage and evidence supporting it
- Residual risks: unresolved cases or `None`
- Repository changes: None
```
