# Doc Gaps Fix Plan

Use this reference to instantiate the doc-gap-specific active plan for
`$doc-gaps-fix`. Read it with the shared gap workflow named in `SKILL.md`;
that shared gap workflow owns common plan state, optional goal state,
scoped-ledger, delegation, coverage, validation, and implementation gates.

Track doc-gap-specific state for scope, documentation location, validation,
delegation, edits, summary, unresolved ledger state, audience, and public
documentation surface.

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   sequencing. Apply the shared gap-workflow delegation gate before review work.
2. When resolving an existing scoped ledger or entry ID, read `../ledger.yaml`,
   then read the resolved scoped ledger when it is a doc-gap ledger; stop if
   the file is unrelated or ambiguous active work. Use its ID prefix for
   unresolved gaps.
3. After the repository archetype and audit scope make lead generation
   relevant, read `../../references/gap-lead-generation.md` and build a lead
   inventory for README, examples, command help,
   package docs, API comments, config docs, operational docs, generated-schema
   docs, and first-use workflows in scope.
4. Inventory documentation locations, examples, command help, package docs,
   README files, user docs, exported API comments, code-comment/docstring
   surfaces, `$doc-standards`, relevant language documentation standards, and
   validation entrypoints.
5. Deduplicate and re-check candidates against code, docs, examples, command
   help, package docs, and public interfaces. For prose mismatches, require
   non-prose evidence before treating code as wrong; otherwise classify stale
   prose as a doc gap.
6. Route each candidate through `$doc-standards`' adequacy gate: public surface,
   audience, reader action or maintenance decision, current and target surfaces,
   minimum successful example or command, adequacy failure, and missing
   non-obvious contract.
7. Confirm only concrete missing, weak, stale, misleading, or wrong-location
   documentation gaps with real user, operator, package consumer, or maintainer
   risk. Dismiss candidates already covered by the correct authoritative surface
   or belonging to code, security, test, or reliability workflows.
8. Before a no-gap closeout, name documentation surfaces, audiences, reader
   actions, authoritative owners, minimum examples or commands,
   missing-contract categories, rejected and routed leads, validation evidence,
   and policy exclusions checked.
9. Implement confirmed doc gaps with the smallest clear documentation changes.
   If a confirmed gap cannot be fixed correctly, write or update the resolved scoped ledger; if
   an existing doc-gap ledger is fully resolved, delete it.
10. Validate changed docs and present fixed gaps, dismissed or out-of-scope
   candidates when relevant, coverage state, unresolved ledger entries if any,
   runnable follow-up scopes, and validation results.
