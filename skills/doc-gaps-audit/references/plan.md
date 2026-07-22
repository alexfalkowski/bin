# Doc Gaps Audit Plan

Use this reference to instantiate the doc-gap-specific active plan for
`$doc-gaps-audit`. Read it with the shared gap workflow named in `SKILL.md`;
that shared gap workflow owns common plan state, optional goal state,
scoped-ledger, delegation, and coverage gates.

Track doc-gap-specific state for scope, documentation location, delegation,
audience, and public documentation surface.

1. Follow the review and closeout rules in `../../doc-gaps-fix/references/plan.md`,
   but check whether the resolved scoped ledger already exists and stop unless
   the human explicitly asked to refresh or overwrite that ledger.
2. Do not edit documentation. If no confirmed gaps remain, report coverage and
   do not create a scoped ledger; if confirmed gaps remain, write the resolved
   scoped audit ledger with its ID prefix from `../../doc-gaps-fix/ledger.yaml`.
3. Present the scoped audit ledger, coverage state, and runnable follow-up
   scopes, then stop before making fixes. Fixing happens only in
   `$doc-gaps-fix`.
