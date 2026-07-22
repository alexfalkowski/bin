# Doc-Gap Audit Rules

These rules remain mandatory:

- Read `../../doc-gaps-fix/ledger.yaml` and use its resolved scoped path as the audit ledger.
- If the resolved scoped ledger already exists, stop unless the human explicitly asked to refresh or overwrite it.
- Use the same delegation, surface-routing, candidate confirmation, severity, and out-of-scope rules as `$doc-gaps-fix`.
- Stop after presenting the audit ledger. Do not make fixes in this skill; hand confirmed entries to `$doc-gaps-fix`.
