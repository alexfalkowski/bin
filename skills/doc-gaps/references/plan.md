# Doc Gaps Plan

Use this reference to instantiate the doc-gap-specific active plan for
`$doc-gaps`. Read it with the shared gap workflow named in `SKILL.md`; that
shared gap workflow owns common plan state, optional goal state, scoped-ledger,
delegation, coverage, validation, and implementation gates.

Track doc-gap-specific state for scope, documentation location, validation,
delegation, edits, summary, unresolved ledger state, audience, and public
documentation surface.

## One-Pass Mode Plan

1. Follow `../../references/gap-workflow.md#common-plan-mechanics` for shared
   one-pass sequencing. Apply the shared gap-workflow delegation gate before review work.
2. Read an existing scoped `DOCS.md` when it is a doc-gap ledger; stop if the
   file is unrelated or ambiguous active work. Use `DOC-<number>` IDs for
   unresolved gaps.
3. Inventory documentation locations, examples, command help, package docs,
   README files, user docs, exported API comments, code-comment/docstring
   surfaces, `$doc-standards`, relevant language documentation standards, and
   validation entrypoints.
4. Deduplicate and re-check candidates against code, docs, examples, command
   help, package docs, and public interfaces. For prose mismatches, require
   non-prose evidence before treating code as wrong; otherwise classify stale
   prose as a doc gap.
5. Route each candidate through `$doc-standards`' adequacy gate: public surface,
   audience, reader action or maintenance decision, current and target surfaces,
   minimum successful example or command, adequacy failure, and missing
   non-obvious contract.
6. Confirm only concrete missing, weak, stale, misleading, or wrong-location
   documentation gaps with real user, operator, package consumer, or maintainer
   risk. Dismiss candidates already covered by the correct authoritative surface
   or belonging to code, security, test, or reliability workflows.
7. Before a no-gap closeout, name documentation surfaces, audiences, reader
   actions, authoritative owners, minimum examples or commands,
   missing-contract categories, validation evidence, and policy exclusions
   checked.
8. Implement confirmed doc gaps with the smallest clear documentation changes.
   If a confirmed gap cannot be fixed correctly, write or update `DOCS.md`; if
   an existing doc-gap ledger is fully resolved, delete it.
9. Validate changed docs and present fixed gaps, dismissed or out-of-scope
   candidates when relevant, coverage state, unresolved ledger entries if any,
   runnable follow-up scopes, and validation results.

## Audit-Only Mode Plan

1. Follow the one-pass review and closeout rules, but check whether scoped
   `DOCS.md` already exists and stop unless the human explicitly asked to
   refresh or overwrite that ledger.
2. Do not edit documentation. If no confirmed gaps remain, report coverage and
   do not create `DOCS.md`; if confirmed gaps remain, write the scoped audit
   ledger with `DOC-<number>` IDs.
3. Present the scoped audit ledger, coverage state, and runnable follow-up
   scopes, then stop before making fixes.
