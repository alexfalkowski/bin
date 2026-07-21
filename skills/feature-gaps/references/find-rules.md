# Feature-Gap Find Rules

These rules remain mandatory:

- Read `../ledger.yaml` and use its resolved scoped path as the proposal ledger.
- Before assigning review agents or starting local review, build a recursive
  scope inventory for the requested package or folder: relevant file count,
  first-level subfolders, nested packages, dominant languages, tests, public
  entrypoints, generated, vendor, build, and cache exclusions, user-facing
  product surfaces, package-consumer or service-author surfaces,
  operator-facing surfaces, docs, examples, command help, and likely product
  extension points.
- Prefer slices based on repository-owned feature surface and user value:
  public commands/APIs, library or service behavior, package-consumer and
  service-author workflows, documented product examples, product onboarding
  paths, integrations, extension points, changed or recently touched product
  areas, and nearby tests. Use depth only as a discovery aid, not as the review
  boundary.
- For delegated review, each assigned agent owns recursive review only within
  its bounded slice. Each agent must perform feature-gap discovery for that
  slice, pairing with
  `$project-workflow`, `$doc-standards`, `$naming-standards`, relevant language
  standards, `$change-safety`, `$testing-standards`, and `$change-validation`
  as the proposed feature surface requires. Agents must use `$testing-standards`
  and `$project-workflow` to route test-harness, build, CI, Makefile, release,
  validation, command-discovery, or repository-workflow candidates away from
  the resolved scoped ledger before returning feature proposals.
- Confirm each candidate feature against `acceptance-gate.md`, code, generated
  surfaces, framework wrappers, shared helpers, vendored dependency behavior
  when delegated, docs, tests, examples, command behavior, current
  architecture, and available comparable-tool evidence before recording it.
  Use the gate's questions to try to disprove the candidate before recording
  it.
- When sub-agents are authorized and candidate volume justifies delegation,
  assign at least one disprover slice when practical. The disprover should look
  for existing APIs, commands, endpoints, health/metrics, generated contracts,
  docs, examples, tests, shared helpers, framework behavior, or workflow routing
  that already covers each proposed feature, and should try to route weak leads
  to another gap workflow or optional follow-up.
- Record feature gaps only when the proposal satisfies every item in
  `acceptance-gate.md`.
- Do not record confirmed bugs, security issues, compatibility breaks,
  reliability gaps, missing tests, test-harness quality issues, stale docs,
  project workflow gaps, or unclear naming as feature gaps. Route them to
  `$code-issues`, `$security-audit`, `$reliability-gaps`, `$test-gaps`,
  `$doc-gaps`, `$project-gaps`, or `$naming-standards` as appropriate.
- Do not record feature ideas whose evidence is only novelty, personal
  preference, a competitor checklist, a trend, an undocumented future roadmap,
  an uncommon operation, a broad rewrite, a new framework preference, or
  optional polish with no concrete workflow improvement.
- Do not record feature proposals that require a new product direction,
  breaking public behavior, new external service, new dependency class, or
  significant maintenance commitment unless the current repository already
  points to that direction and the proposal explains the compatibility and
  maintenance tradeoff.
- If a candidate would mostly require documentation, examples, tests, or
  reliability controls for existing behavior, route it to the matching gap
  workflow instead of recording it here.
- If a candidate would mostly require CI, build, Makefile, release, validation
  preflight, command discovery, setup, or repository workflow changes, route it
  to `$project-gaps` instead of recording it here.
