# Long-Running Work

Use this reference when a selected skill is handling substantial, ambiguous, or
multi-iteration work where a single context window or a single pass may lose
important state. Keep this subordinate to the selected skill's scope, stop
gates, validation rules, and output format.

## Runtime State Only

- Maintain long-running state in the active conversation, tool plan, or runtime
  goal only when authorized. Do not write progress files, design docs, or
  orchestration artifacts into the repository unless the human explicitly asks
  for a durable file.
- Do not introduce a new top-level workflow when an existing skill owns the
  task. Use this reference as an implementation aid inside that skill.
- Do not use this reference to combine find and implement modes, bypass
  implementation gates, weaken confidence thresholds, skip validation, or replace
  repository-defined Make targets.
- If the selected skill requires a proposed solution and human agreement before
  editing, a request that says "implement" is not enough by itself. Refresh the
  evidence, present the solution, and stop until the human agrees to that
  solution.
- Do not require sub-agents unless the current request authorizes them and the
  active runtime provides them. If sub-agents are unavailable, do not describe a
  local challenge pass as equivalent to independent review.

## Phase Artifacts

For long-running work, keep a compact runtime artifact with only the details
needed for the next step:

```markdown
Objective:
Research:
Open questions:
Current slice:
Done:
Next:
Changed paths:
Validation:
Blockers:
Confidence limit:
```

- `Research`: current-state facts with file paths, command surfaces, public
  contracts, consumers, tests, CI, and local patterns that matter to the task.
- `Open questions`: only questions whose answers affect behavior,
  compatibility, ownership, validation, or the accepted solution.
- `Current slice`: one thin, verifiable vertical slice. Prefer end-to-end slices
  over broad layer-by-layer work.
- `Validation`: commands run, classified results, stale checks, and checks still
  required before acceptance.
- `Confidence limit`: the strongest unresolved counterexample, missing
  evidence, unavailable validation, or blocked delegation that caps confidence.

## Research Before Planning

Before planning substantial work, inspect the repository-owned surfaces that can
confirm current behavior and local patterns. Do not plan from a vague user
request alone when the codebase can answer the question.

After research, ask the human only for blocking decisions. Good questions name
the local evidence and the decision that changes the plan. Do not ask questions
whose answers can be inferred safely from repository instructions, local
patterns, tests, or documented contracts.

## Slice Loop

Use this loop inside the selected skill after the required approval gate has
passed:

1. Confirm this reference has been read for the current task.
2. Refresh the runtime artifact from current files, commands, and user answers.
3. Select the next thin slice with acceptance criteria and validation.
4. Implement the slice using existing local patterns.
5. Run the narrowest repository-defined validation that credibly exercises the
   slice.
6. Update the runtime artifact with changed paths, validation, remaining work,
   blockers, and confidence limit.
7. Continue only when the selected skill allows more work in the same mode and
   validation is not stale.

If the work spans context boundaries, resume from the runtime artifact and
re-check changed files before editing. Treat stale progress as a lead, not as
current evidence.

## Fresh Review Gate

Before accepting substantial work as complete, run a fresh review gate:

- When sub-agents are authorized and available, use an independent reviewer for
  the changed scope. Give the reviewer the objective, changed paths, validation
  evidence, and relevant runtime artifact. Do not pass the intended conclusion
  or ask for agreement.
- When sub-agents are not authorized or unavailable, perform a named local
  challenge pass. State that it is local review, name the strongest remaining
  counterexamples, and lower confidence when unresolved questions remain.
- Resolve blocking review findings or get explicit human approval to leave them
  unresolved before claiming the task is complete.
- If sub-agents were authorized and available but the independent review was not
  run, do not claim substantial work is complete at or above the active
  confidence threshold. State the missed gate as a workflow blocker or
  validation gap.

The reviewer checks whether the implementation satisfies the approved objective,
preserves local contracts, follows the selected skill, and has credible
validation. It should not reopen out-of-scope ideas merely because they are
interesting.
