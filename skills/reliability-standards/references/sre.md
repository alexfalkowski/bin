# SRE Reliability Standards

Use this reference for practical SRE concerns. It distills review prompts from
the public Google SRE book without copying the source text.

Primary source:

- https://sre.google/sre-book/table-of-contents/

## Core Areas

- **Risk and SLOs**: Identify the user-visible behavior, the SLI that would
  measure it, the SLO or error budget if one exists, and the business or user
  tradeoff of accepting failure.
- **Monitoring and alerting**: Prefer symptom-based, actionable alerts tied to
  user impact. Avoid alerting only on internal causes unless the alert has a
  clear operator action.
- **Toil and automation**: Look for recurring manual work caused by code,
  deployment, release, diagnosis, recovery, or maintenance gaps. Automation
  should reduce toil without hiding failure or removing human control where it
  is still needed.
- **Simplicity**: Prefer simpler reliability controls that operators can
  understand during incidents. Complexity is itself a reliability cost.
- **Release engineering**: Check whether changes can be built, reviewed,
  deployed, rolled back, verified after deploy, and traced to source.
- **On-call and incident response**: Check whether responders can detect,
  triage, mitigate, communicate, and hand off incidents using repository-owned
  logs, metrics, docs, and commands.
- **Postmortems and outage tracking**: Favor mechanisms that preserve evidence,
  support blameless analysis, and make follow-up work trackable.
- **Testing for reliability**: Exercise failure paths, recovery paths,
  dependency errors, overload behavior, data integrity, and release paths through
  the narrowest credible established test layer.
- **Overload and cascading failures**: Check for resource bounds, admission
  control, backpressure, load shedding, queue limits, retry budgets, and failure
  isolation.
- **Critical state and data integrity**: Check whether state is durable,
  recoverable, idempotent, reconciled, and protected against corruption,
  duplication, loss, and stale reads according to the repository's promises.
- **Launch readiness**: Check whether new or changed behavior has rollout,
  rollback, observability, capacity, dependency, and support readiness.

## Review Prompts

- What are users or downstream systems unable to do when this path fails?
- What condition would page an operator, and what action would they take?
- What can saturate first: CPU, memory, disk, network, file descriptors,
  subprocesses, goroutines/threads, database connections, queues, or retries?
- What happens during dependency slowness, dependency outage, partial failure,
  stale data, duplicate delivery, process restart, or deploy interruption?
- Can the system fail small, shed load, degrade intentionally, or preserve core
  behavior when optional behavior fails?
- Can state be replayed, rebuilt, reconciled, rolled back, or restored?
- Does the release path make failures discoverable quickly and reversible safely?

## Anti-Patterns

- Treating retries as reliability without deadlines, backoff, jitter,
  idempotency, and downstream load awareness.
- Treating logs as observability without clear fields, correlation, retention,
  and operator queries.
- Treating tests as reliability when they do not exercise the actual failure
  mode or recovery path.
- Treating manual runbooks as sufficient when the repository could make the
  operation bounded, safer, or self-validating.
- Treating "no SLO exists" as proof that user impact does not matter when code,
  docs, or product behavior imply an operational promise.
