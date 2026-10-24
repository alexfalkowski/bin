# Feature-Gap Find Rules

## Product Discovery

Before selecting candidates for detailed acceptance review:

- Build a short product brief from docs, examples, supported consumers, and
  current behavior: the audience, the outcome they seek, their recurring steps,
  and where they spend effort or cannot progress. Separate observed needs from
  assumptions; mark unknown demand, frequency, and impact instead of inventing
  users or usage figures.
- Follow the audience's workflow through preparation, the core action, and its
  aftermath. Look for manual interpretation, repeated decisions, handoffs, and
  blocked outcomes. Consider both improvements to current capabilities and
  adjacent capabilities serving the same audience and problem. Use technical
  archetypes to locate evidence, rather than as the boundary of product ideas.
- Where workflows involve interpreting text, diagnosing failures, prioritising
  work, or generating changes, assess AI alongside deterministic automation and
  existing integrations. Explain the useful output, required data and access,
  and the added audience benefit. For a promising AI opportunity, identify how
  to evaluate output quality, handle wrong answers, and assess latency, cost,
  data handling, and support. An AI candidate is optional; novelty is not value.
- Research native platform capabilities and relevant mature products when that
  could change the shortlist. Compare building, integrating, and using an
  existing tool; explain the residual need this repository should own. State
  what research was used or why it was skipped or unavailable.
- Rank candidates against each other before developing detailed proposals.
  Compare recurrence, effort saved or outcomes unlocked, importance to the
  primary workflow, strength of demand evidence, differentiation from available
  substitutes, and ongoing cost. Use qualitative judgments when measurements
  are unavailable. Explain why the leading opportunities outrank the strongest
  alternatives; easy implementation and readily provable absence do not
  establish high product value. Do not fill a quota with weak candidates.
- For the strongest leads, define the smallest useful audience outcome and the
  cheapest way to resolve the material unknown: a supported workflow trace,
  user feedback, or a bounded experiment. Explore a new service, dependency
  class, or product direction as a tradeoff or decision before applying the
  confirmation rules below. Developing an experiment proposal does not
  authorize executing it.

## Review And Recording

These rules remain mandatory:

- Read `../../feature-gaps-implement/ledger.yaml` and use its resolved scoped path as the proposal ledger.
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
  `$code-issues-find`, `$security-audit`, `$reliability-gaps-find`,
  `$test-gaps-find`, `$doc-gaps-audit`/`$doc-gaps-fix`, `$project-gaps-find`,
  or `$naming-standards` as appropriate.
- Do not record feature ideas whose evidence is only novelty, personal
  preference, a competitor checklist, a trend, an undocumented future roadmap,
  an uncommon operation, a broad rewrite, a new framework preference, or
  optional polish with no concrete workflow improvement.
- Do not record feature proposals that require a new product direction,
  breaking public behavior, new external service, new dependency class, or
  significant maintenance commitment unless the current repository already
  points to that direction or the human has explicitly approved it. The
  proposal must explain the compatibility and maintenance tradeoff and satisfy
  the acceptance gate. Keep promising proposals needing that decision in
  opportunity closeout notes.
- If a candidate would mostly require documentation, examples, tests, or
  reliability controls for existing behavior, route it to the matching gap
  workflow instead of recording it here.
- If a candidate would mostly require CI, build, Makefile, release, validation
  preflight, command discovery, setup, or repository workflow changes, route it
  to `$project-gaps-find` instead of recording it here.

## Opportunity Closeout

Present the ranked shortlist with audience outcomes, evidence, comparative
value and fit, and material unknowns. Identify confirmed gaps by their ledger
IDs and keep them in the shared summary format. Present promising hypotheses
separately as **Opportunities to investigate**, with the next evidence to gather,
smallest useful experiment, or product decision needed. Do not give hypotheses
ledger IDs, confirmed status, or implementation follow-ups, and do not create a
ledger solely for them. Include no hypotheses when none have credible audience
and repository grounding. A no-confirmed-gap outcome does not establish that the
product has no further opportunities; retain the shared coverage and validation
requirements for that outcome.
