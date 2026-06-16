---
name: diagnose-issue
description: >-
  Use when the user asks to diagnose what is wrong with CI, a failing build,
  current branch or PR checks, a deployment, rollout, Kubernetes runtime state,
  DigitalOcean service state, UptimeRobot monitor issue, or the most recent
  deployed/released version. Examples: "$diagnose-issue in CI",
  "$diagnose-issue with deployment", "why is this PR failing?", "what broke
  in the latest deploy?", or "diagnose the rollout".
---

# Diagnose Issue

Use this skill to gather read-only evidence for a concrete CI pipeline or
deployment target, identify the most likely cause, and suggest specific next
fixes. Keep the diagnosis grounded in source evidence; do not retry jobs,
redeploy, mutate clusters, change monitors, push commits, or update PRs unless
the user explicitly asks after the diagnosis.

## Workflow

1. Identify the requested diagnosis mode.
   - Use `ci` for the latest CI pipeline on the current branch or an explicit
     CircleCI pipeline number.
   - Use `deployment` for the latest deployed/released version or an explicit
     version tag.
   - Ask one concise question only when the mode changes which systems may be
     queried and the request is genuinely ambiguous.
2. Read the relevant reference:
   - `references/ci.md` for CI and PR diagnosis.
   - `references/deployment.md` for deployment and runtime diagnosis.
   - `references/output.md` before writing the final answer.
3. Use `scripts/collect.rb` as the default collection path when Ruby is
   available. It returns focused JSON findings plus source evidence for the
   selected target.
4. Collect manually only for missing evidence or a narrower user request that
   the script cannot cover. State why the collector was insufficient before
   relying on manual `gh`, CircleCI, `kubectl`, DigitalOcean, UptimeRobot, or
   local-git commands.
5. Separate facts from inference. Label source gaps, stale data, partial
   windows, missing credentials, and collection-time Kubernetes state.
6. Give fixes as ordered suggestions. Prefer the smallest likely fix first, and
   identify what evidence would confirm or reject each suggestion.

## Collector

Run from the repository being diagnosed:

```bash
ruby <skill-dir>/scripts/collect.rb --mode ci --repo <repo-path>
ruby <skill-dir>/scripts/collect.rb --mode ci --pipeline <circleci-pipeline-number> --repo <repo-path>
ruby <skill-dir>/scripts/collect.rb --mode deployment --repo <repo-path>
ruby <skill-dir>/scripts/collect.rb --mode deployment --version <version-tag> --repo <repo-path>
```

Useful options:

- `--target latest`: inspect the latest CI pipeline or latest deployment
  version. This is the default.
- `--pipeline PIPELINE`: inspect one CircleCI pipeline by numeric pipeline
  number. UUIDs still work, but users should not need to provide them.
- `--version VERSION`: inspect one version tag in deployment mode.
- `--branch BRANCH`: override the branch for latest CI pipeline lookup.

Deployment mode requires a `.cd` file at the repository root. It includes the
CircleCI `deploy` job for the selected version plus current DigitalOcean,
Kubernetes, and UptimeRobot evidence when credentials and mappings are
available.

## Evidence Rules

- Keep collection read-only. API calls, `gh`, `curl`, `git log`, `kubectl get`,
  and repository searches are acceptable; remote or cluster mutations are not.
- Do not expose tokens, API keys, private incident URLs, full logs, or secrets.
- Prefer exact failing workflow, job, deployment, pod, monitor, version, and
  timestamp evidence over broad health summaries.
- If evidence is missing because credentials, CLIs, or mappings are unavailable,
  report that as a data gap and provide the next best local diagnostic step.

## References

- Read `references/ci.md` for CI and current PR diagnosis.
- Read `references/deployment.md` for deployment, latest-version, and runtime
  diagnosis.
- Read `references/output.md` for the final response shape.
