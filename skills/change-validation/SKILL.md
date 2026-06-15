---
name: change-validation
description: Use when running or selecting validation after code, docs, Makefile, shell, Dockerfile, Go, Ruby, generated-output, CI, security, benchmark, or shared ./bin changes. Choose and report credible repository-defined checks.
---

# Change Validation

## Steps

1. Discover the repository's validation entrypoints before running checks.
2. Read `references/check-selection.md` when choosing between targeted tests, lint commands, make targets, CI mirrors, benchmarks, or security checks.
3. Run the repository's setup or dependency target first when validation depends on installed dependencies or generated/vendor state.
4. Ask for user permission before running validation commands that require SSH credentials, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state.
5. Run the narrowest check that credibly exercises the changed behavior, then expand only when risk justifies it.
6. Treat validation as valid only for the file state it tested. If files change while a validation command is still running or after it completes, report that result as stale and rerun the relevant checks after final edits.
7. Notice wrappers that no-op because optional tools are missing, and do not report them as full validation.
8. Use `$testing-standards` when the task needs decisions about what tests to add or whether coverage is credible; keep this skill focused on selecting and reporting commands.
9. When reporting standalone validation, use the exact structure in `references/check-selection.md`; when another skill embeds validation, preserve the command, result, coverage, and gap details.

## References

- Read `references/check-selection.md` when selecting validation commands or explaining validation scope.
