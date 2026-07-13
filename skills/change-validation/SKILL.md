---
name: change-validation
description: Use when running or selecting validation after code, docs, Makefile, shell, Dockerfile, Go, Ruby, generated-output, CI, security, benchmark, or shared ./bin changes. Choose and report credible repository-defined checks.
---

# Change Validation

## Steps

1. Discover the repository's validation entrypoints before running checks.
2. Read `references/check-selection.md` when choosing between targeted tests, lint commands, make targets, CI mirrors, benchmarks, or security checks.
3. Before running, retrying, replacing, or recommending validation commands, establish the execution environment: repository root, documented entrypoint, CI analogue, initialized user shell, and any macOS/Homebrew tool-path assumptions. Do not invent direct commands or bypass Make targets just because the agent shell cannot find the right tool.
4. Run the repository's setup or dependency target first when validation depends on installed dependencies or generated/vendor state.
5. Identify whether validation commands use network access, credentials, SSH,
   registries, cloning, pushing, publishing, opening PRs, or remote state. Rely
   on the active agent configuration for command approval behavior; do not add
   a separate model-level permission request.
6. Run the narrowest check that credibly exercises the changed behavior, then expand only when risk justifies it.
7. Treat validation as valid only for the file state it tested. If files change while a validation command is still running or after it completes, report that result as stale and rerun the relevant checks after final edits.
8. Notice wrappers that no-op because optional tools are missing, and do not report them as full validation.
9. Use `$testing-standards` when the task needs decisions about what tests to add or whether coverage is credible; keep this skill focused on selecting and reporting commands.
10. For standalone output, use `references/check-selection.md`; when embedded,
    preserve command, result, coverage, and gap details in the caller's format.

## References

- Read `references/check-selection.md` when selecting validation commands or explaining validation scope.
