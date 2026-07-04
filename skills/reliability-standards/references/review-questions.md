# Reliability Review Questions

Use these prompts selectively; do not turn them into findings without concrete
evidence.

- **SLOs and user impact**: What user-visible reliability promise is affected?
  Are SLIs, SLOs, error budgets, latency bounds, freshness bounds, or durability
  expectations documented or implied?
- **Failure modes**: What happens when a dependency is slow, down, stale,
  partially successful, duplicated, reordered, or returns malformed data?
- **Timeouts and retries**: Are deadlines propagated? Are retries bounded, using
  backoff and jitter, and safe for idempotency and downstream load?
- **Overload and backpressure**: Are request, queue, worker, memory, file,
  subprocess, and network resources bounded? Can the system shed load or degrade
  intentionally?
- **Cascading failures**: Can one failing component exhaust shared pools,
  retries, locks, queues, ports, disk, memory, or credentials used by unrelated
  work?
- **Observability and alerting**: Can operators detect symptoms, correlate
  causes, distinguish user impact from noise, and avoid alerting on
  non-actionable conditions?
- **Recovery**: Can state be rebuilt, replayed, rolled back, drained, or
  reconciled? Are data loss, duplication, and corruption boundaries explicit?
- **Release safety**: Are deploys, config changes, migrations, feature flags,
  canaries, rollbacks, and post-deploy checks safe for partial completion?
- **Operational usability**: Are health checks, readiness, runbooks, emergency
  access, diagnostics, and remediation steps available where the repository owns
  them?
- **NALSD fit**: For system design, are workload assumptions, growth factors,
  bottlenecks, resource estimates, failure domains, and graceful degradation
  concrete enough to evaluate?
