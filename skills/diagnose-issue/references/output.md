# Output

Use this final response shape unless the user asks for a different format.

## Required Shape

Start with the selected target:

```markdown
**Repository:** owner/repo
**Mode:** ci
**Target:** latest pipeline on feature-branch
```

For deployment mode:

```markdown
**Repository:** owner/repo
**Mode:** deployment
**Target:** v1.2.3
```

Then include these sections:

1. `**Likely Cause**`
2. `**Evidence**`
3. `**Suggested Fixes**`
4. `**Data Gaps**`

## Likely Cause

Use 1-3 bullets. State only conclusions supported by the selected pipeline or
deployment target. If evidence is insufficient, say that and name the missing
source. Include the actual confidence percentage, for example `Confidence: 96%`,
for each stated likely-cause finding. Use an explicit confidence target from
the current request when provided; otherwise use the 95% default. If confidence
is below the active threshold, move the item to `Data Gaps` or phrase it as
evidence to collect instead of a likely cause. When a lower explicit target is
used, label the result as a lower-confidence hypothesis and state the residual
uncertainty.

## Evidence

List concrete source facts:

- Pipeline ID/number, workflow status, failed job names, job numbers, contexts,
  raw command output for every failed step, raw test-result messages and expected/actual assertions, and recurring failure counts
  across reruns. Keep primary failures separate from cascading errors.
- For revision targets with multiple matching pipelines, the bounded candidate
  workflow metadata and selection reason. Treat
  `observed_matching_pipeline_count` as the count observed during the scan, not
  a total when `candidate_scan_truncated` is true. The legacy
  `matching_pipeline_count` is the retained-candidate count and
  `matching_pipeline_truncated` aliases `candidate_scan_truncated`. For matching
  merged PRs, include only bounded identical-tree and terminal-status comparison
  evidence; do not present this as proof of determinism.
- Current PR number/title when available, plus matching open or closed PRs for
  a selected commit target.
- Selected version and deploy job status for deployment mode.
- Runtime image, deployment readiness, pod phase, restart count, or monitor
  status when relevant; do not include log bodies.
- Exact source gaps such as missing token, missing CLI, missing monitor mapping,
  missing `.cd`, or unavailable selected target.

## Suggested Fixes

Provide ordered suggestions. Each suggestion should include either the next
command to run through the repository's documented entrypoint, the source log to
inspect, or the exact deployment/runtime object to check.

Do not suggest remote write actions such as rerun, redeploy, rollback, push,
release, or cluster mutation unless the user explicitly asks for action after
the diagnosis.

## Data Gaps

If there are no gaps, write:

```markdown
- None from the selected target evidence.
```

Otherwise list the missing credential, CLI, mapping, source, or selected-target
limitation and how to fill it.
