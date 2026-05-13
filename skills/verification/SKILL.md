---
name: verification
description: Chooses and reports credible validation commands for tests, linting, CI checks, security checks, benchmarks, and generated outputs. Use when running or selecting verification after code, docs, Makefile, shell, Dockerfile, Go, Ruby, or shared ./bin changes.
---

# Verification

## Steps

1. Discover the repository's validation entrypoints before running checks.
2. Read `references/check-selection.md` when choosing between targeted tests, lint commands, make targets, CI mirrors, benchmarks, or security checks.
3. Run the narrowest check that credibly exercises the changed behavior, then expand only when risk justifies it.
4. Notice wrappers that no-op because optional tools are missing, and do not report them as full validation.
5. In the final response, list what ran, what passed or failed, and what could not be verified.

## References

- Read `references/check-selection.md` when selecting validation commands or explaining verification scope.
