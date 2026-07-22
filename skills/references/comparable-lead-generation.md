# Comparable Lead Generation

Use this reference from `gap-lead-generation.md` when a ledger-style find,
audit-only, or one-pass review would benefit from similar repositories,
templates, or ecosystem frameworks. Comparable evidence improves recall only;
it does not lower the selected skill's ownership, confidence, reproduction,
validation, or approval gates.

## When To Use

Use comparable lead generation for broad or ambiguous scopes, shared tooling,
service templates, reusable libraries, project workflow reviews, reliability
reviews, test-harness reviews, documentation audits, and feature discovery.

Skip it when the requested scope is narrow, the relevant behavior is already
fully explained by local evidence, the run is blocked by time or permissions,
or comparable research would mainly add parity/taste ideas instead of
repository-owned risks.

## GitHub Inventory First

Treat the GitHub owner as the canonical inventory and local checkouts as the
evidence cache.

Default owner selection:

1. Use the owner explicitly named by the human.
2. Otherwise derive the owner from the current repository's `origin` remote.
3. In this repository ecosystem, use `alexfalkowski` when the owner is still
   ambiguous.

Use `gh repo list` when GitHub network/auth access is available and approved:

```sh
gh repo list <owner> --limit 1000 \
  --json nameWithOwner,sshUrl,url,isArchived,isFork,primaryLanguage,repositoryTopics,pushedAt
```

If `gh` is unavailable, unauthenticated, blocked by sandbox/network policy, or
not approved for the current request, record GitHub inventory as `blocked` and
continue with local-only comparable evidence only when that still supports the
selected skill's confidence threshold.

## Local Checkout Mapping

Do not hard-code a machine-specific checkout path into a skill. Discover local
checkouts from configured or inferred roots:

1. Use `CODEX_REPO_ROOTS` when set. Treat it as a colon-separated list of
   search roots.
2. Otherwise search the current repository's parent directory and, when useful,
   its grandparent directory.
3. If no plausible local checkout root exists and comparable evidence is needed
   for credible confidence, ask the human for a local checkout root.

For each candidate local Git repository, read its origin and normalize SSH,
HTTPS, and `ssh://` GitHub URLs to `owner/repo`:

```sh
git -C <candidate> remote get-url origin
```

Use local checkouts only when their normalized `owner/repo` matches the GitHub
inventory. Treat unmatched local directories, forks, mirrors, vendored
submodules, generated repos, and archived repos as supporting context only
unless the selected scope explicitly owns them.

## Selecting Comparables

Prefer a small, relevant comparison set:

- same archetype: service, library, shared tooling, Docker/infra, Ruby/static;
- same public surface: gRPC, HTTP, CLI, package API, Make fragment, test
  harness, release workflow, or operator workflow;
- same shared dependency or template family;
- recent activity or recent changes in the same area;
- known consumers of the package, helper, command, or shared `bin` behavior.

Record which comparables were checked and why. For broad no-finding closeout,
also record relevant comparables that were skipped, blocked, or deferred.

## What To Compare

Use comparables to generate leads for the selected skill:

- `code-issues-find`: contract drift, sibling error cases, adapter mappings,
  generated/provider values, compatibility behavior, and supported call paths.
- `test-gaps-find`: dominant harness shape, feature/scenario coverage, failure-path
  coverage, fixtures, flaky-test controls, fuzz/benchmark/race/property tests,
  and wrong-layer tests.
- `doc-gaps-audit`/`doc-gaps-fix`: README shape, command help, API examples,
  operational notes, migration notes, configuration docs, and discoverability.
- `feature-gaps-find`: product-facing capabilities, service-author ergonomics,
  operator diagnostics, extension points, and first-use workflows.
- `project-gaps-find`: Make targets, CI jobs, setup, command discovery,
  validation preflight, release/versioning, generated checks, and shared
  tooling ownership.
- `reliability-gaps-find`: health/readiness, startup/shutdown/drain, overload,
  timeout/retry/backpressure, observability, rollback, recovery, and
  deployment controls.

## External Frameworks

Use external frameworks only as lead-generation checklists, not as acceptance
evidence:

- DORA for delivery, deploy, change failure, and recovery leads.
- SPACE or DevEx-style frameworks for balanced productivity signals and
  avoiding activity-only conclusions.
- OpenSSF Scorecard-style checks for security and project-health leads.
- Backstage/catalog scorecard ideas for ownership, metadata, discoverability,
  service classification, and operational maturity leads.

Do not record a finding merely because a comparable repository or framework has
something the target lacks. First prove the target repository owns the surface,
the current limitation is real, the audience benefits, and the smallest fix
fits local patterns.

## Accounting

Include comparable evidence in the selected skill's normal lead accounting:

- `Confirmed`: comparable lead became a local finding after reproduction.
- `Rejected`: comparable pattern does not fit, is already covered, or is only
  parity/taste.
- `Routed`: lead belongs to shared `bin`, another repository, an upstream
  library, a third-party tool, or another ledger skill.
- `Deferred`: exact comparable repo or framework area not reviewed deeply.
- `Blocked`: GitHub inventory, local checkout mapping, auth, network, or local
  root discovery was unavailable.
