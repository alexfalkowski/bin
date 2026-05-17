---
name: makefile-includes
description: Works with shared bin/build/make/*.mak includes and downstream Makefile integration. Use when editing, reviewing, or debugging reusable Make targets, included make files, ./bin path semantics, or downstream projects that include this repository's make files.
---

# Makefile Includes

## Steps

1. Confirm which `bin/build/make/*.mak` files the root `Makefile` includes.
2. Read `references/fragment-map.md` after identifying the included fragments.
3. Treat the root `Makefile` as the interface and shared fragments as implementation context.
4. Preserve downstream `./bin` path expectations unless the user explicitly asks to change them.
5. Identify Make targets that clone, fetch, push, publish, open PRs, update remote state, or require SSH/GitHub/registry auth before running them.
6. Validate path-sensitive behavior from the consuming repository root when the target depends on `$(PWD)/bin/...`.

## References

- Read `references/fragment-map.md` after discovering which shared Makefile includes are used.
