# Doc-Gap Audit-Only Rules

These rules remain mandatory:

- Use `DOCS.md` in the requested package or folder as the audit ledger, for example `PACKAGE_OR_FOLDER/DOCS.md`.
- If `DOCS.md` already exists in the requested package or folder, stop unless the human explicitly asked to refresh or overwrite that scoped ledger.
- Use the same delegation, surface-routing, candidate confirmation, severity, and out-of-scope rules as one-pass mode.
- Stop after presenting the audit ledger. Do not make fixes in audit-only mode.
