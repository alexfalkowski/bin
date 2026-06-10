# NALSD Review Standards

Use this reference for Non-Abstract Large System Design (NALSD) reviews and
production-readiness questions that require concrete scale, resource, and
failure-domain reasoning.

Primary sources:

- https://sre.google/workbook/non-abstract-design/
- https://cloud.google.com/blog/products/management-tools/sre-principles-and-flashcards-to-design-nalsd
- https://research.google/pubs/the-site-reliability-engineering-workbook-chapter-introducing-non-abstract-large-system-design-nalsd/
- https://static.googleusercontent.com/media/sre.google/en//static/pdf/rule-of-thumb-latency-numbers-letter.pdf

## NALSD Loop

Apply the loop only where scale, availability, performance, freshness,
durability, or cost assumptions matter.

1. State the problem and requirements.
2. Sketch a basic design that works in principle.
3. Ask whether the basic design can be made simpler, faster, smaller, or more
   efficient.
4. Scale the requirements up to the claimed or expected production size.
5. Check feasibility against concrete resources: CPU, memory, disk, network,
   storage, IOPS, latency, connection counts, queue depth, request rate, data
   volume, and cost where relevant.
6. Check resilience: component failure, dependency failure, zone/region failure,
   partial failure, retries, overload, stale data, and operator recovery.
7. Iterate until the design is concrete enough to evaluate or the missing
   assumptions are explicit.

## Evidence To Look For

- Workload assumptions: QPS, events/sec, data size, payload size, cardinality,
  fanout, retention, freshness, latency, concurrency, burst behavior, and growth.
- Resource estimates: CPU, memory, disk, network, IOPS, connections, workers,
  queue depth, cache size, and storage retention.
- Bottleneck reasoning: which resource saturates first and what happens next.
- Failure domains: process, host, disk, network, dependency, queue, database,
  zone, region, account, credential, config, and deployment boundaries.
- Graceful degradation: what can be disabled, delayed, cached, dropped,
  sampled, backfilled, retried later, or served stale.
- Operator controls: feature flags, rate limits, circuit breakers, drain
  commands, rollback, backfill, repair, and diagnostic commands.

## When To Record A Gap

Record a NALSD-related reliability gap only when the repository already makes a
scale, latency, availability, freshness, durability, or production-use claim and
the design lacks enough concrete assumptions or controls to evaluate it.

Do not record a gap merely because a small tool, library, or local script lacks
distributed-system design notes. For shared tooling, focus on downstream blast
radius, idempotency, failure output, destructive operations, dependency
availability, and whether failures are diagnosable.

## Useful Estimation Checks

- Convert rates into daily volume and retention footprint.
- Convert fanout into downstream request pressure.
- Convert retry policy into worst-case amplified load.
- Compare queue capacity with producer rate and consumer drain rate.
- Compare timeout and deadline choices with caller expectations.
- Compare data freshness promises with batching, polling, scheduling, and
  replication delays.
- Compare rollback time with the expected error budget burn or user impact.

## Rule-Of-Thumb Latency Numbers

Use latency rule-of-thumb material for rough order-of-magnitude calibration,
not as current hardware guarantees. Prefer measured local production data,
benchmark output, cloud/provider documentation, or repository-owned SLOs when
they exist.

When using rule-of-thumb numbers:

- Compare magnitudes, not exact values: cache, memory, local disk, SSD, network
  transfer, same-datacenter round trips, and cross-region or cross-continent
  round trips have very different cost profiles.
- Identify the dominant operation before optimizing secondary costs. A design
  dominated by seeks or remote round trips will not be fixed by small CPU-level
  improvements.
- Convert object size, fanout, and per-request operations into latency and
  throughput estimates before accepting a design.
- Re-check assumptions when hardware, cloud instance type, region distance,
  storage class, compression, batching, or concurrency model differs from the
  reference example.
- Treat surprising conclusions as prompts for measurement or prototype
  validation, not as proof by spreadsheet.
