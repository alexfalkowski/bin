# Deployment Diagnosis

Use this reference for deploy failures, rollout issues, service runtime state,
DigitalOcean/Kubernetes evidence, UptimeRobot monitor signals, and latest
version questions.

## First Pass

Run the collector from the repository being diagnosed:

```bash
ruby <skill-dir>/scripts/collect.rb --mode deployment --repo <repo-path>
ruby <skill-dir>/scripts/collect.rb --mode deployment --version <version-tag> --repo <repo-path>
```

Deployment mode defaults to the latest local version tag. Use `--version` when
the user names a specific version. Deployment diagnosis only runs when a `.cd`
file exists at the repository root.

## Evidence Priority

1. Selected version tag and matching CircleCI pipeline when available.
2. CircleCI `deploy` job status for the selected version's pipeline.
3. Kubernetes deployment readiness, runtime image, and desired/ready replicas.
4. Pod readiness, phase, restart count, and start time.
5. UptimeRobot monitor status and current logs.
6. DigitalOcean cluster status when it explains broader platform availability.

## Diagnosis Guidance

- Do not summarize a date range by default. The unit of diagnosis is the
  selected version and its deploy/runtime evidence.
- Treat Kubernetes and pod data as collection-time state unless a historical
  metrics source is available.
- Correlate selected version, deploy job status, runtime image, pod start time,
  restart count, and monitor state before claiming causality.
- For unready deployments, prioritize rollout status, image pull failures,
  readiness/liveness probes, configuration, secrets, and recent namespace events.
- If no `.cd` file is found, report that deployment diagnosis does not apply
  instead of probing clusters broadly.

## Fix Suggestions

Order suggestions by confidence:

1. Failed deploy job or rollout fix supported by collected evidence.
2. Runtime fix supported by image mismatch, unready deployments, failing pods,
   or restarts.
3. Monitor correlation if external downtime overlaps the selected version.
4. Access or mapping remediation when credentials or service identity are
   missing.
5. Redeploy or rollback only when evidence identifies a bad version or broken
   rollout and the user has explicitly authorized write actions.
