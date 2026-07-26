# CI Diagnosis

Use this reference for failing CI, checks, build jobs, current branch, and PR
questions.

## First Pass

Run the collector from the repository being diagnosed:

```bash
<skill-dir>/scripts/collect --mode ci --repo <repo-path>
<skill-dir>/scripts/collect --mode ci --pipeline <circleci-pipeline-number> --repo <repo-path>
<skill-dir>/scripts/collect --mode ci --revision <commit-sha> --repo <repo-path>
```

CI mode defaults to the latest CircleCI pipeline on the current branch. Use
`--branch` only when the failing branch differs from the local checkout. Use
`--pipeline` when the user names a specific numeric CircleCI pipeline. UUIDs
are accepted for compatibility, but do not ask users for UUIDs.

Use `--revision` when the user identifies a commit. A uniquely resolvable local
abbreviated SHA is expanded before selecting the pipeline whose CircleCI
`vcs.revision` exactly matches it. When multiple pipelines match, the collector
examines up to five candidates and prefers terminal workflow evidence over an
empty pipeline; it records the bounded candidate metadata and selection reason.
`observed_matching_pipeline_count` is the number of matches seen before the
scan stopped, while `candidate_scan_truncated` states whether that scan was
bounded rather than exhaustive. The legacy `matching_pipeline_count` is the
number of retained candidates and `matching_pipeline_truncated` is an alias for
`candidate_scan_truncated`; preserve them for compatible consumers. It cannot
be combined with `--branch`, `--pipeline`, `--pipeline-id`, or `--version`.

The collector command must exit with status zero; a nonzero exit status, empty
file, invalid JSON, or anything other than one JSON object is an invocation
failure, not diagnosis evidence.

## Evidence Priority

1. Selected CircleCI pipeline.
2. Workflow status and the first failed workflow.
3. Failed job names, job numbers, contexts, and the failed step name, status,
   and exit code when CircleCI exposes them. Test-result evidence is limited to
   bounded, sanitized expected/actual assertions, primary-versus-cascading
   classification, and recurring signatures across rerun attempts. For RSpec
   matcher wording such as `expected <actual> to be a kind of <expected type>`,
   label the values as `actual` and `expected` respectively. Do not collect log
   bodies, URLs (including `output_url` and presigned URLs), tokens, or secrets.
4. For a revision with a matched merged PR, compare up to three locally
   available merge revisions with an identical Git tree. Record bounded terminal
   workflow-status comparisons as evidence only: matching trees and statuses can
   support a deterministic-failure hypothesis but do not prove it.
5. Failure category, especially compile, lint, test, security, dependency,
   deploy, release/versioning, and auth jobs.
6. Current branch and open PR from local git and GitHub when available. For a
   commit target, also collect matching historical open or closed PRs.
7. Local repository config such as `.circleci/config.yml`, Make targets, and
   documented CI entrypoints.

## Diagnosis Guidance

- Treat the first failed job in the selected pipeline as the highest-value
  starting point unless a later job failed because an earlier artifact was
  missing.
- Treat `running`, `failing`, `on_hold`, and `queued` workflows as active
  evidence, not failures; wait for their terminal state before inferring a
  cause.
- Do not summarize a date range by default. The unit of diagnosis is the
  selected pipeline.
- If the latest branch has no pipeline, check whether the branch exists
  remotely, whether branch filters skip it, and whether CircleCI tokens can read
  the project.
- If GitHub PR evidence is unavailable, continue with branch and CircleCI data
  instead of guessing PR state.

## Fix Suggestions

Order suggestions by confidence. Use an explicit confidence target from the
current request when provided; otherwise use the 95% default. State a fix as a
likely cause only when the selected target evidence meets the active threshold,
and state the actual percentage. If a lower explicit target is used, label the
result as a lower-confidence hypothesis and state the residual uncertainty;
otherwise suggest the next evidence to collect.

1. Direct fix supported by the failing job or error category.
2. Narrow command to reproduce locally through the repository's documented
   target.
3. Credential, token, dependency, or environment check if the failure is
   infrastructure-shaped.
4. Rerun only when evidence points to flakiness or transient infrastructure.
