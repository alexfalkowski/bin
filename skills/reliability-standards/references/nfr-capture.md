# Non-Functional Requirement Capture

Use this reference when a reliability concern needs to become an explicit
requirement, acceptance criterion, design constraint, validation target, or
consistent cross-cutting implementation pattern.

Primary source:

- https://microsoft.github.io/code-with-engineering-playbook/design/design-patterns/non-functional-requirements-capture-guide/

Related implementation note:

- https://jessemcdowell.ca/2024/05/Cross-Cutting-Concerns/

## Requirement Quality

Capture reliability requirements as concrete engineering constraints, not broad
aspirations.

- Tie the requirement to business, user, operator, or downstream-system impact.
- Name the affected component, workflow, API, command, job, or operational path.
- Make the requirement measurable or testable when practical.
- Define the expected condition, threshold, boundary, or behavior under failure.
- Identify who owns implementation, verification, and operational response.
- Record tradeoffs when availability, latency, integrity, security, cost,
  usability, or delivery speed pull in different directions.

Prefer:

- "Dashboard freshness is less than 5 minutes for 99.9% of successful reads."
- "Worker retries stop after 3 attempts with exponential backoff and jitter."
- "The migration can be safely rerun after interruption without duplicating rows."

Avoid:

- "The dashboard should be reliable."
- "Add observability."
- "Make retries robust."
- "Improve scalability."

## Reliability NFR Categories

Use these categories to discover missing precision:

- **Availability**: What must keep working, for whom, and at what tolerance?
- **Latency**: Which path has a deadline, percentile, or timeout expectation?
- **Freshness**: How stale may data become before users or operators are harmed?
- **Durability**: What data must survive process, host, dependency, or disaster
  failure?
- **Integrity**: What duplication, loss, corruption, ordering, or reconciliation
  behavior is acceptable?
- **Recoverability**: What are the expected recovery time and recovery point?
- **Scalability**: What workload, burst, cardinality, retention, or fanout is
  expected?
- **Operability**: What logs, metrics, alerts, runbooks, commands, or dashboards
  let operators detect and remediate failure?
- **Release safety**: How can deploys, config changes, migrations, and feature
  changes be rolled out, verified, disabled, or rolled back?
- **Security/reliability interaction**: How do auth, least privilege, audit,
  secret rotation, DoS controls, or breakglass behavior affect availability and
  recovery?

## Acceptance Criteria

Turn reliability NFRs into acceptance criteria that can be validated. Use one or
more of these forms:

- **Behavioral**: Given a dependency timeout, the command exits non-zero with an
  actionable error and does not leave partial output.
- **Metric**: 99.9% of requests complete under the documented latency target.
- **Bounded resource**: Queue length, concurrency, retries, memory, subprocesses,
  or file handles are capped with a defined overflow behavior.
- **Recovery**: Interrupted work can be resumed, replayed, restored, or rolled
  back without data loss beyond the stated boundary.
- **Operational**: Logs, metrics, or docs expose enough context for the named
  operator action.
- **Release**: The change has a rollback or disablement path and a post-deploy
  verification signal.

## Cross-Cutting Controls

Reliability controls often span many code paths: logging, tracing, metrics,
timeouts, retry policy, authorization failure handling, idempotency, error
classification, rate limiting, and health checks.

When implementing a cross-cutting reliability control:

- Prefer established local mechanisms before adding a new abstraction.
- Centralize policy where consistency matters and the repository has a natural
  integration point, such as middleware, client wrappers, shared command helpers,
  framework hooks, libraries, or Make/script helpers.
- Keep the mechanism understandable during debugging and incidents. Avoid hidden
  behavior that operators and maintainers cannot trace.
- Allow explicit exceptions near the policy so reviewers can see why a path is
  different.
- Use tests or static checks to enforce consistency only when the policy cannot
  be centralized safely.
- Do nothing deliberately when the scope is small, the risk is low, and a shared
  abstraction would add more maintenance cost than reliability value.

Do not record cross-cutting abstraction advice as a reliability gap by itself.
Record a gap only when inconsistent implementation creates a concrete
reliability failure mode or prevents a required reliability NFR from being
verified.
