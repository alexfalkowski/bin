# Sources

Use this reference to choose evidence sources and report missing data clearly.

## Source Priority

1. Use local git and repository files for repository identity, current branch,
   recent commits, release files, deployment manifests, CI config, and service
   hints.
2. Use authenticated GitHub sources for PRs, issues, releases, checks, review
   activity, and exact timestamps when available.
3. Use CircleCI Insights for workflow health, duration, success rate, credits,
   flaky tests, and recent workflow runs when the repo uses CircleCI.
4. Use Kubernetes, DigitalOcean, or deployment tooling only for service repos or
   when the user asks for operational state.
5. Use UptimeRobot public status pages or API data for externally visible
   uptime, incidents, monitor status, and response time.

## Local Evidence

Prefer the bundled collector when available:

```bash
ruby <skill-dir>/scripts/collect.rb --repo <repo-path>
```

Useful local commands include:

```bash
git remote get-url origin
git rev-parse --show-toplevel
git branch --show-current
git log --since=<start> --until=<end> --format=%H%x09%aI%x09%an%x09%s
git tag --sort=-creatordate
```

Search the repository for service and release hints with `rg` before using
cloud tools:

```bash
rg --files -g '!.git/**' -g '!vendor/**'
rg 'CircleCI|circleci|deploy|kubernetes|k8s|uptime|UptimeRobot|doctl|kubectl|Dockerfile'
```

If `.cd` exists at the repository root, classify the repo as a deployed service.
For these repos, use DigitalOcean/Kubernetes and UptimeRobot when credentials
and monitor mappings are available.

## GitHub

Prefer `gh` when it is authenticated and installed. Use the REST or GraphQL API
when `gh` is unavailable but a token exists.

Common environment variables:

- `GITHUB_TOKEN`
- `GH_TOKEN`

Useful data:

- pull requests created, merged, closed, open, and stale;
- median PR age and review latency;
- commits in the requested period;
- releases and tags;
- check runs or commit statuses when CircleCI data is unavailable;
- issues opened and closed when the user asks for planning or support signals.

For unauthenticated public repos, local git can provide commits but not reliable
PR, review, or private CI data.

Useful `gh` patterns:

```bash
gh pr list --repo <owner>/<repo> --state all \
  --search "created:<start-date>..<end-date>" \
  --json number

gh pr list --repo <owner>/<repo> --state merged \
  --search "merged:<start-date>..<end-date>" \
  --limit 100 \
  --json number,title,createdAt,mergedAt,url,reviews

gh pr list --repo <owner>/<repo> --state closed \
  --search "closed:<start-date>..<end-date> -merged:<start-date>..<end-date>" \
  --json number

gh pr list --repo <owner>/<repo> --state open \
  --json number,title,updatedAt,createdAt

gh release list --repo <owner>/<repo> \
  --limit 100 \
  --json tagName,createdAt,publishedAt,isDraft,isPrerelease
```

When PR review records are empty, report review latency as `n/a` instead of
inferring it from merge time.

## CircleCI

Use CircleCI only when `.circleci/config.yml` exists or project metadata points
to CircleCI.
Read `.circleci/config.yml` before interpreting CircleCI metrics. Record
workflow-level settings that affect counts, especially `max_auto_reruns`, branch
filters, serialized jobs, and required release/deploy jobs.

Common environment variables:

- `CIRCLE_TOKEN`
- `CIRCLECI_TOKEN`

If neither environment variable is set, check the CircleCI CLI config at
`${CIRCLECI_CLI_CONFIG:-$HOME/.circleci/cli.yml}` and use its `token` field
when present. Do not print the token.

The common project slug shape is `gh/<owner>/<repo>`. If the slug is ambiguous,
derive it from the GitHub remote and state the assumption.

Useful data:

- workflow success rate;
- median and p95 workflow duration;
- failed workflow count;
- recent failed workflows;
- flaky tests;
- credit usage when useful for cost or throughput context.

CircleCI Insights can have retention and reporting-window limits. If the
requested window is outside the available range, state the truncation.

Useful read-only API pattern:

1. List project pipelines for `gh/<owner>/<repo>` and the relevant branch:
   `/api/v2/project/gh/<owner>/<repo>/pipeline?branch=<branch>`.
2. Page backward until the oldest collected pipeline is before the comparison
   period start.
3. For each pipeline, list workflows with `/api/v2/pipeline/<pipeline-id>/workflow`.
4. Bucket workflows by `created_at`; count completed workflows, successes, and
   failures.
5. Calculate workflow duration from `created_at` to `stopped_at`.
6. Check flaky tests with
   `/api/v2/insights/gh/<owner>/<repo>/flaky-tests?branch=<branch>`.
7. For service repos, collect job-level data with
   `/api/v2/workflow/<workflow-id>/job` and report deploy health from jobs named
   `deploy` rather than inferring deploys from tags alone.

Use a successful completed workflow count as the denominator for success rate
only after excluding running, on-hold, and not-run workflows.
Report releases/tags separately from successful deploy jobs when both exist.
When `max_auto_reruns` is configured, state that CircleCI workflow totals are
API-visible completed workflow records after rerun behavior, not necessarily
first-attempt pipeline outcomes.

## Kubernetes And DigitalOcean

Use operational sources only for service summaries or explicit user requests.
Prefer read-only commands.

Common environment variables and tools:

- `DIGITALOCEAN_ACCESS_TOKEN`
- `doctl`
- `kubectl`

Useful data:

- deployment image and rollout status;
- running, pending, crash-looping, or restarting pods;
- deployment age and replica readiness;
- recent Kubernetes events when they explain reliability issues.

Do not change clusters, contexts, resources, deployments, secrets, or
annotations while producing a summary.
Label Kubernetes values as collection-time state unless historical metrics are
available from a time-series source.

For library/shared-tooling repos with no `.cd`, deployment manifest, Kubernetes
object, service monitor, or explicit service mapping, skip DigitalOcean and
Kubernetes instead of probing clusters.

## UptimeRobot

Use UptimeRobot data when a monitor ID, status page, repo config, README,
environment variable, or user-provided URL maps the service to a monitor.

Common environment variables:

- `UPTIMEROBOT_API_KEY`
- `UPTIMEROBOT_MONITOR_IDS`
- `UPTIMEROBOT_STATUS_PAGE_URL`

Prefer sources in this order:

1. Public status page URL, when it has enough uptime and incident information
   for the requested summary.
2. One account/main API key plus monitor IDs for all relevant services.
3. Monitor-specific API keys only when the user deliberately chooses
   per-service least-privilege credentials.

Do not require one UptimeRobot key per service. If the only available setup
would require per-service keys, report UptimeRobot as unavailable for richer
monitor data and use public status-page evidence instead.

After creating a main API key, discover monitor IDs with `getMonitors` and map
them to friendly names:

```bash
curl -fsS -X POST https://api.uptimerobot.com/v2/getMonitors \
  -d "api_key=${UPTIMEROBOT_API_KEY}&format=json" |
  jq -r '.monitors[] | "\(.id)\t\(.friendly_name)\t\(.url)"'
```

Set `UPTIMEROBOT_MONITOR_IDS` to the comma-separated IDs for the services in
scope.

Useful data:

- current monitor status;
- uptime ratio for the requested period;
- average response time;
- incidents, downtime windows, and recovery time.

When only a public status page is available, report only the facts visible from
that page and label them as public status-page evidence.
When an API key is available, use `custom_uptime_ranges` with exact Unix-second
window boundaries for current and comparison periods. UptimeRobot returns the
range values as a hyphen-separated string in the same order as requested.
Request `logs=1` for incidents and `response_times=1` for response-time
samples. If response-time samples do not cover the comparison window, report the
previous response time as `n/a` instead of reusing account-level averages.

For library/shared-tooling repos with no `.cd` or repo-specific monitor mapping,
skip UptimeRobot even when general UptimeRobot credentials are configured.

## Missing Source Reporting

For every unavailable source that would materially improve the summary, include
one short data-source note:

```text
CircleCI: unavailable because CIRCLE_TOKEN is not set.
UptimeRobot: unavailable because no monitor ID or status-page mapping was found.
Kubernetes: skipped because this repo has no service/deployment evidence.
```
