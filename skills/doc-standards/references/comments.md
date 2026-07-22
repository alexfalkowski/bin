# Code Comment Standard

Apply these rules strictly for code comments, public API comments, docstrings,
RDoc, GoDoc, shell function comments, and any language-specific documentation
near code.

Comment presence is not comment adequacy. A comment that exists only because a
language linter expects a sentence is still weak documentation when it fails to
document the non-obvious repository-owned contract.

For package docs and exported API comments, do not only check whether a comment
exists or starts with the identifier. Audit whether it documents the
repository-owned contract that a caller cannot safely infer from the signature.
For each exported package, type, function, method, variable, or constant in
scope, check whether the comment needs to cover:

- behavior and purpose;
- error, panic, nil, empty, or zero-value behavior;
- side effects, lifecycle, cleanup, global registration, or process behavior;
- concurrency, caching, retry, timeout, cancellation, or idempotency behavior;
- configuration defaults, limits, validation, and fallback behavior;
- security, operational, compatibility, or data-loss risks; and
- alias, wrapper, re-export, or dependency ownership boundaries.

Do not require every comment to mention every category. Require the relevant
non-obvious contract to be documented. If none of these categories apply and the
comment only restates the name or signature, remove or keep it minimal according
to the language lint requirement.

These rules follow the rule set from Stack Overflow's "Best practices for
writing code comments":
https://stackoverflow.blog/2021/12/23/best-practices-for-writing-code-comments/

- Do not duplicate the code. Remove or rewrite comments that only translate syntax,
  restate a name, describe a visible assignment, list obvious parameters, or say
  what a nearby line already says.
- Do not use comments to compensate for unclear code. Prefer clearer names,
  smaller structure, or a documented `$code-issues-find` finding when the code cannot
  be made understandable with the local pattern.
- If a clear comment cannot be written, treat that as evidence that the code,
  naming, or abstraction may be wrong; use `$code-issues-find` rather than adding
  vague explanation.
- Comments must reduce confusion. Remove or rewrite comments that are stale,
  cute, ambiguous, speculative, or more confusing than the code.
- Explain unidiomatic, surprising, redundant-looking, compatibility-driven,
  generated, or workaround code when a maintainer might otherwise simplify it
  incorrectly.
- Link to the original source for copied or adapted code, copied formulas,
  external algorithms, standards, protocol rules, compatibility references, or
  tutorials that are necessary to understand why the code is shaped that way.
- Add bug-fix or workaround comments only when the code would otherwise look
  unnecessary or wrong. Reference the issue, upstream bug, version constraint,
  or observable failure when available.
- Mark incomplete implementations with the repository's established TODO/FIXME
  format and include the missing behavior, owner or issue reference when local
  style expects it, and the condition for removing the comment.
- For aliases, re-exports, thin wrappers, or compatibility shims, do not copy
  the upstream package, type, function, constant, method, or command
  documentation. State that this API aliases, re-exports, or wraps the original
  to keep call sites on the project-owned surface, reduce repeated imports, or
  preserve compatibility only when that is the real reason, then link to the
  authoritative upstream or canonical local documentation when practical.
