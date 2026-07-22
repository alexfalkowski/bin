# Feature-Gap Acceptance Gate

Apply this gate before recording any candidate in the resolved scoped ledger. A feature
proposal must satisfy every item below at or above the active confidence
threshold. The active threshold is the explicit confidence target in the
current request when one is provided; otherwise it is 90% by default (or 95%
for high-risk acceptance). A lower explicit target changes the actionability
threshold, not the evidence required by this gate. If any item cannot be
answered from concrete evidence, gather more evidence or reject the candidate
instead of recording it as low priority.

- **Audience**: Name the user, developer, maintainer, operator, package
  consumer, or service author who benefits.
- **Current limitation**: State the existing workflow limitation, missing
  capability, or friction. The limitation must exist today and must not already
  be solved by current code, docs, examples, or command behavior.
- **Existing coverage**: Name the current product surfaces that already address
  part or all of the need, including APIs, commands, endpoints, generated
  contracts, runtime health or metrics, docs, examples, configuration, and
  supported workflows. Reject the candidate if an existing surface already
  solves the practical user action.
- **Residual gap**: After accounting for existing coverage, state the remaining
  supported action or outcome the audience still cannot complete. Reject the
  candidate if the residual is only a weaker spelling of "more flexible",
  "more convenient", or "another way to do the same thing".
- **Negative capability proof**: If the proposal depends on a capability being
  absent, verify that absence across every layer that could already provide it:
  local code, generated code, framework wrappers, shared helpers, vendored
  dependencies, configuration defaults, command behavior, docs, examples, and
  tests. If the behavior is delegated to a framework, shared helper, generated
  surface, or vendored dependency, inspect that delegated implementation before
  assigning confidence at or above the active threshold.
- **Benefit**: Explain why this matters to the named audience and the concrete
  outcome they gain, such as saved time, fewer mistakes, clearer decisions,
  unlocked use cases, safer operation, or reduced support burden. Reject the
  candidate if the benefit cannot be stated as a specific improvement to the
  named audience's workflow.
- **Common operation**: For new product capability, show that the action is a
  normal or credibly recurring workflow for the named audience in this
  repository's domain. Comparable-tool support alone is not enough; reject or
  defer candidates whose value is mostly rare operator preference, library
  affordance parity, or speculative future use.
- **Repository ownership**: Show that this repository owns the behavior,
  interface, workflow, helper, or documentation surface where the feature
  belongs.
- **Product surface**: Identify the main product surface being improved: public
  command, API, library behavior, service/operator behavior, package-consumer
  workflow, shipped integration, reusable template, or documented product
  extension point. Reject candidates whose primary surface is test harnesses,
  CI, build, Makefile, release, validation, command discovery, or repository
  workflow plumbing.
- **Evidence**: Cite concrete local evidence such as code, docs, examples,
  command behavior, tests, recurring maintainer workflow, or comparable mature
  tool behavior. Comparable-tool evidence is supporting evidence, not a
  sufficient reason by itself.
- **Repository fit**: Explain why the feature matches the repository purpose,
  current architecture, local naming, file layout, command style, dependency
  posture, and downstream `./bin` reuse model.
- **Smallest useful version**: Define the smallest feature slice that creates
  real value without a broad rewrite or speculative platform work.
- **Compatibility and maintenance**: Identify public behavior, migration,
  dependency, security, support, and long-term maintenance tradeoffs. Reject
  proposals whose cost or compatibility risk outweighs the demonstrated value.
- **Validation path**: Name the repository-defined command, test, lint, docs
  check, or manual verification path that can credibly validate the change.
- **Correct workflow**: Confirm the candidate is not primarily a code bug,
  security issue, reliability gap, test gap, doc gap, project workflow gap,
  naming issue, style preference, or unsupported roadmap decision.

Reject ideas whose support is only novelty, taste, competitor parity, a trend,
an imagined future user, uncommon operation, framework preference, private
implementation preference, generic "nice to have" polish, or a vague benefit
such as "more flexible", "better", "cleaner", or "more powerful" without a
concrete audience outcome.
