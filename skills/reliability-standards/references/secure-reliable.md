# Secure And Reliable Systems Standards

Use this reference when reliability overlaps with security, resilience,
recovery, deployment, investigation, or crisis response.

Primary source:

- https://google.github.io/building-secure-and-reliable-systems/raw/toc.html

## Design Tradeoffs

- Treat reliability and security as product qualities, not late-stage add-ons.
- Identify nonfunctional requirements explicitly: availability, integrity,
  latency, freshness, recovery time, recovery point, confidentiality, audit, and
  operator control.
- Prefer designs whose safety properties are understandable and enforceable by
  common frameworks or shared libraries.
- Make tradeoffs explicit when security controls can reduce availability or
  when reliability controls can weaken security.

## Resilience

- Use defense in depth for critical paths: one missed check, failed dependency,
  bad config, or compromised component should not create total failure.
- Control degradation deliberately. Define what gets slower, stale, disabled,
  queued, dropped, or isolated.
- Control blast radius through role separation, location separation, time
  separation, bounded credentials, and scoped permissions where relevant.
- Continuously validate important assumptions with tests, smoke checks, audits,
  or operational exercises.

## Recovery

- Define what the system is recovering from: random errors, accidental errors,
  software defects, malicious action, dependency failure, data corruption, or
  disaster.
- Know intended state well enough to rebuild, verify, revoke, rotate, replay,
  restore, or reconcile it.
- Keep recovery paths testable. Untested backup, restore, breakglass, and
  incident procedures are weak controls.
- Reduce dependency on wall-clock timing when recovery correctness depends on
  event ordering, expiry, revocation, or coordination.

## Deployment And Change

- Prefer automated, reviewable, reproducible deployment and config paths.
- Verify artifacts and deployed state, not only the person or command that
  triggered deployment.
- Treat config as code when it controls reliability, security, routing,
  credentials, limits, or operational behavior.
- Include rollback, breakglass, post-deploy verification, and actionable errors
  for high-impact deployment paths.

## Investigation And Logging

- Collect logs and events that help operators answer what happened, who or what
  caused it, which users or data were affected, and what mitigation occurred.
- Preserve privacy and least privilege in logs. Do not add sensitive data just
  to make diagnosis easier.
- Make debugging access reliable enough for incidents and constrained enough to
  avoid creating a new security or availability problem.

## Disaster And Crisis Readiness

- Define severity, ownership, escalation, communication, and handoff
  expectations when the repository owns incident or recovery workflows.
- Pre-stage people, access, systems, and procedures before incidents.
- Validate plans through nonintrusive tabletop exercises, smoke checks, restore
  tests, red-team-style checks, or production exercises where appropriate and
  authorized.

## DoS And Abuse

- Check both hostile and self-inflicted overload: client retries, batch jobs,
  cron overlap, thundering herds, fanout, expensive queries, and unbounded
  queues can all create denial of service.
- Prefer defendable services: resource limits, quotas, admission control,
  rate limiting, load shedding, prioritization, and useful monitoring.
