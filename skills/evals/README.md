# Skill Evals

Skill evals are lightweight cases for recording whether this repository's
skills activate for the right work and improve the resulting output.

CI only validates the shape of these eval definitions through `make
skills-lint`. Runtime routing still needs a manual Codex run or an external
agent harness that can report which skills activated.

## Metrics

- Activation precision: expected skills activate and forbidden skills do not.
- Activation recall: companion skills needed for the task are not missed.
- Outcome quality: the response or change satisfies the case's success criteria.
- Validation honesty: commands, skipped checks, no-op wrappers, and gaps are reported accurately.
- Lifecycle signal: repeated failures identify skills to update, split, merge, or retire.

## How To Use

1. Run or simulate each prompt in `cases.yaml`.
2. Record the skills that activated, the output, validation claims, and any missed criteria.
3. Compare the result against the expected and forbidden skill lists.
4. For failing cases, update routing descriptions, skill instructions, references, or the case itself if the workflow changed.
5. Periodically run representative tasks with and without the skill. Retire skills that no longer improve outcomes.

## Adding Cases

- Base cases on real tasks, PRs, incidents, review corrections, or repeated agent failures.
- Keep each case focused on one workflow or a small intentional composition.
- Include adjacent skills in `forbidden_skills` when routing confusion is likely.
- Prefer concrete success criteria over broad quality labels.
