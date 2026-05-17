---
name: change-validation
description: Chooses and reports credible validation commands for tests, linting, CI checks, security checks, benchmarks, and generated outputs. Use when running or selecting validation after code, docs, Makefile, shell, Dockerfile, Go, Ruby, or shared ./bin changes.
---

# Change Validation

## Steps

1. Discover the repository's validation entrypoints before running checks.
2. Read `references/check-selection.md` when choosing between targeted tests, lint commands, make targets, CI mirrors, benchmarks, or security checks.
3. Run the repository's setup or dependency target first when validation depends on installed dependencies or generated/vendor state.
4. Ask for user permission before running validation commands that require SSH credentials, GitHub auth, registry auth, cloning, pushing, publishing, opening PRs, or updating remote state.
5. Run the narrowest check that credibly exercises the changed behavior, then expand only when risk justifies it.
6. Notice wrappers that no-op because optional tools are missing, and do not report them as full validation.
7. When reporting standalone validation, use the exact structure in `references/check-selection.md`; when another skill embeds validation, preserve the command, result, coverage, and gap details.

## References

- Read `references/check-selection.md` when selecting validation commands or explaining validation scope.
