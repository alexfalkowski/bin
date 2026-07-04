# Project-Gap Acceptance Gate

Apply this gate before recording any candidate in `PROJECTS.md`. A project
proposal must satisfy every item below at 90% confidence or higher. If any item
cannot be answered from concrete evidence, gather more evidence or reject the
candidate instead of recording it as low priority.

- **Audience**: Name the developer, maintainer, operator, service author, or
  package consumer who benefits from the project workflow improvement.
- **Current limitation**: State the existing build, CI, release, setup,
  validation, command discovery, Makefile, script, reusable tooling, or
  repository workflow friction.
- **Project surface**: Identify the repository-owned project workflow surface:
  Make target or fragment, CI job, setup path, release/versioning flow,
  validation/preflight entrypoint, script, generated-artifact check, local
  developer command, or shared `./bin` wiring.
- **Implementation home**: Identify where the smallest useful fix should live:
  current repo, shared `bin`, external repo, or mixed. Confirm the requested
  scope owns that home before recording a normal project gap.
- **Evidence**: Cite concrete local evidence such as Makefiles, CI config,
  scripts, docs, command behavior, recurring maintainer workflow, or comparable
  mature project workflow behavior. Comparable evidence is supporting evidence,
  not a sufficient reason by itself.
- **Repository fit**: Explain why the improvement matches the repository
  purpose, current command style, dependency posture, validation model, and
  downstream `./bin` reuse model when relevant.
- **Smallest useful version**: Define the smallest project workflow change that
  creates real value without broad build-system churn or speculative platform
  work.
- **Compatibility and maintenance**: Identify public target behavior, migration,
  dependency, security, CI runtime, support, and long-term maintenance
  tradeoffs. Reject proposals whose cost or compatibility risk outweighs the
  demonstrated value.
- **Validation path**: Name the repository-defined command, lint, CI check,
  dry-run, or manual verification path that can credibly validate the change.
- **Correct workflow**: Confirm the candidate is not primarily a product
  feature, code bug, security issue, reliability gap, test gap, doc gap, naming
  issue, style preference, or unsupported roadmap decision.
- **Upstream ownership**: When the evidence points to a third-party library,
  framework, tool, image, or another project-owned library, confirm whether the
  requested scope owns a dependency/workflow response or should route the
  candidate to the owning project.

Reject ideas whose support is only novelty, taste, competitor parity, a trend,
an imagined future workflow, private implementation preference, or generic
"nice to have" polish.
