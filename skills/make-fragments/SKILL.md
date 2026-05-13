---
name: make-fragments
description: Works with shared bin/build/make/*.mak fragments and downstream Makefile integration. Use when editing, reviewing, or debugging reusable Make targets, included make fragments, ./bin path semantics, or downstream projects that include this repository's make files.
---

# Make Fragments

## Steps

1. Confirm which `bin/build/make/*.mak` files the root `Makefile` includes.
2. Read `references/fragment-map.md` after identifying the included fragments.
3. Treat the root `Makefile` as the interface and shared fragments as implementation context.
4. Preserve downstream `./bin` path expectations unless the user explicitly asks to change them.
5. Validate path-sensitive behavior from the consuming repository root when the target depends on `$(PWD)/bin/...`.

## References

- Read `references/fragment-map.md` after discovering which shared make fragments are included.
