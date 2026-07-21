# Doc-Gap Audit-Only Rules

These rules remain mandatory:

- Read `../ledger.yaml` and use its resolved scoped path as the audit ledger.
- If the resolved scoped ledger already exists, stop unless the human explicitly asked to refresh or overwrite it.
- Use the same delegation, surface-routing, candidate confirmation, severity, and out-of-scope rules as one-pass mode.
- Stop after presenting the audit ledger. Do not make fixes in audit-only mode.
