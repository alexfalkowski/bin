---
name: reliability-standards
description: Use when reviewing or changing reliability-sensitive behavior, retries, timeouts, backpressure, SLOs, SLIs, error budgets, monitoring, alerting, runbooks, release safety, overload handling, cascading failures, data integrity, disaster recovery, or concrete NALSD design estimates. Apply SRE, NALSD, and secure/reliable systems standards to code, designs, scripts, Make targets, services, jobs, deployment/config, observability, incident, recovery, capacity, and production-readiness work; pair with $reliability-gaps for scoped reliability-gap discovery.
---

# Reliability Standards

## Operating Stance

Operate as a practical SRE reviewer: connect reliability concerns to concrete
user impact, operator burden, production failure modes, and observable code,
config, docs, or workflow evidence. Treat a concern as unverified until the
current repository evidence shows a real failure path or missing reliability
control. Reject broad architecture advice, environment preferences, and quick
pattern-matching conclusions that cannot be tied to a current requirement,
documented promise, code path, or operational risk.

## Steps

1. Identify the reliability surface in scope: services, APIs, CLIs, jobs,
   scripts, queues, storage, migrations, config, deployment, CI, docs, runbooks,
   dashboards, or shared tooling used by downstream projects.
2. Read the smallest matching reference before applying detailed standards:
   - `references/sre.md` for SLOs, monitoring, alerting, toil, automation,
     release engineering, overload, cascading failures, data integrity,
     incident response, postmortems, or launches.
   - `references/nalsd.md` for system design, capacity planning, scaling,
     bottleneck estimates, failure domains, graceful degradation, and concrete
     resource assumptions.
   - `references/secure-reliable.md` for security/reliability tradeoffs,
     resilience, recovery, least privilege, change safety, DoS, deployment,
     investigation, disaster planning, crisis response, or breakglass behavior.
   - `references/nfr-capture.md` for turning reliability concerns into
     specific, measurable, testable non-functional requirements and for choosing
     how to implement cross-cutting reliability controls consistently.
3. Use `$project-workflow` before selecting validation or reasoning about
   repository entrypoints, CI, shared `./bin` wiring, or Make targets.
4. Pair with `$change-safety` when reliability-sensitive behavior touches public
   APIs, commands, flags, environment variables, file formats, migrations,
   deployment, config, auth, or documented operator behavior.
5. Pair with `$testing-standards` and `$change-validation` when reliability work
   needs failure-path tests, smoke checks, load checks, linting, CI, or manual
   validation guidance.
6. Pair with `$security-audit` when the reliability concern depends on attacker
   behavior, auth, secrets, privilege, supply chain, DoS, logging privacy, or
   incident containment.
7. Before reporting a reliability concern, identify the requirement or promise
   it affects, the trigger condition, the failure mode, the existing control or
   missing control, and the likely user/operator impact.
8. Try to disprove the concern before reporting it. Trace the code path, read
   the documented workflow, check the relevant config, inspect tests, or run an
   allowed local command so the concern is based on verified current behavior
   instead of a brief observation.
9. For reusable libraries, helpers, and shared tooling, calibrate reliability
   confidence against supported usage evidence. Synthetic tests, fakes, manual
   construction, and unsupported downstream patterns are leads, not enough for
   high-confidence reliability concerns unless a supported consumer, executable
   example, integration test, module wiring path, documented contract, CI
   workflow, or comparable real usage path can trigger the failure mode.
10. Prefer small, locally consistent fixes: bounded retries before new
   infrastructure, useful logs before broad telemetry redesigns, rollback-safe
   migrations before process-only mitigations, and documented runbook steps
   before vague operational advice.
11. Report uncertainty explicitly. When scale, SLO, traffic, durability, or
   recovery targets are unknown, ask for the missing assumption or record the
   need for a concrete assumption only when the code or docs already imply one.

## Review Questions

Read `references/review-questions.md` for reliability triage prompts. Use them
selectively; do not turn them into checklist findings without concrete
evidence.

## Boundaries

- Use `$reliability-gaps` when the user asks to find or implement scoped
  reliability gaps through that skill's contract-resolved ledger.
- Use `$code-review` or `$code-issues` when the finding is a concrete bug,
  violated contract, or broken behavior rather than a missing reliability
  control.
- Use `$security-audit` when exploitability, secrets, auth, privilege, or
  attacker-driven behavior is the primary concern.
- Use `$test-gaps` when the only confirmed issue is missing failure-path or
  reliability test coverage.
- Use `$doc-gaps` when the only confirmed issue is missing, stale, or misleading
  operational documentation.
- Do not report repository preferences, transport choices, hosting choices,
  private implementation preferences, or environment setup assumptions as
  reliability concerns unless they demonstrably break a documented
  repository-owned workflow for intended users or operators.

## References

- Read `references/sre.md` for distilled SRE book standards.
- Read `references/nalsd.md` for Non-Abstract Large System Design review
  prompts.
- Read `references/secure-reliable.md` for secure and reliable systems standards.
- Read `references/nfr-capture.md` for non-functional requirement capture and
  cross-cutting reliability-control implementation guidance.
- Read `references/review-questions.md` for reliability review prompts.
