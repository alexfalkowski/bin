# CI Diagnosis

Use this reference for failing CI, checks, build jobs, current branch, and PR
questions.

## First Pass

Run the collector from the repository being diagnosed:

```bash
ruby <skill-dir>/scripts/collect.rb --mode ci --repo <repo-path>
ruby <skill-dir>/scripts/collect.rb --mode ci --pipeline <circleci-pipeline-number> --repo <repo-path>
```

CI mode defaults to the latest CircleCI pipeline on the current branch. Use
`--branch` only when the failing branch differs from the local checkout. Use
`--pipeline` when the user names a specific numeric CircleCI pipeline. UUIDs
are accepted for compatibility, but do not ask users for UUIDs.

## Evidence Priority

1. Selected CircleCI pipeline.
2. Workflow status and the first failed workflow.
3. Failed job names, job numbers, web URLs, contexts, and v2 job messages when
   CircleCI exposes them.
4. Failure category, especially compile, lint, test, security, dependency,
   deploy, release/versioning, and auth jobs.
5. Current branch and open PR from local git and GitHub when available.
6. Local repository config such as `.circleci/config.yml`, Make targets, and
   documented CI entrypoints.

## Diagnosis Guidance

- Treat the first failed job in the selected pipeline as the highest-value
  starting point unless a later job failed because an earlier artifact was
  missing.
- Do not summarize a date range by default. The unit of diagnosis is the
  selected pipeline.
- If the latest branch has no pipeline, check whether the branch exists
  remotely, whether branch filters skip it, and whether CircleCI tokens can read
  the project.
- If GitHub PR evidence is unavailable, continue with branch and CircleCI data
  instead of guessing PR state.

## Fix Suggestions

Order suggestions by confidence. State a fix as a likely cause only when the
selected target evidence supports `Confidence: High (>=80%)`; otherwise suggest
the next evidence to collect.

1. Direct fix supported by the failing job or error category.
2. Narrow command to reproduce locally through the repository's documented
   target.
3. Credential, token, dependency, or environment check if the failure is
   infrastructure-shaped.
4. Rerun only when evidence points to flakiness or transient infrastructure.
