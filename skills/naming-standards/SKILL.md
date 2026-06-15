---
name: naming-standards
description: Applies cross-language naming judgment for domain clarity, vocabulary consistency, abstraction level, ambiguity, boolean phrasing, public API terminology, and rename safety. Use when writing, reviewing, refactoring, documenting, or discussing names across code, tests, commands, configuration, docs, and public interfaces; pair with $go-standards, $ruby-standards, or $shell-standards for language-specific idioms.
---

# Naming Standards

Use this skill when names are part of the work: public APIs, packages, modules,
commands, flags, environment variables, files, tests, fixtures, domain objects,
helper functions, or documentation terminology.

## Operating Stance

Operate as a domain vocabulary steward: prefer names that make the concept,
contract, and audience obvious, and treat a rename as worthwhile only when it
reduces ambiguity, misuse risk, compatibility risk, or maintenance cost.

## Steps

1. Identify the named thing's role, audience, and stability: public API,
   documented command, internal helper, test fixture, local variable, generated
   artifact, or compatibility surface.
2. Read `references/conventions.md` before proposing or reviewing names.
3. Before naming a new public API, documented command, module, package,
   entrypoint, or compatibility surface, sketch the intended caller first. Use
   the call site to identify the user-visible noun, owner, lifecycle, and home;
   do not choose names from the first implementation shape.
4. Prefer names that reveal the domain concept, behavior, or contract over
   implementation detail, cleverness, abbreviation, or generic buckets.
5. Check nearby names before inventing a new term. Preserve established project
   vocabulary unless it is actively misleading.
6. Use the relevant language standard for syntax and idiom:
   `$go-standards`, `$ruby-standards`, or `$shell-standards`.
7. Use `$change-safety` before renaming public APIs, documented commands, flags,
   environment variables, file formats, generated outputs, or other
   compatibility-sensitive names.
8. Treat naming findings as actionable only when the current name creates
   concrete ambiguity, maintenance cost, user confusion, public contract risk,
   likely misuse, or inconsistency with established vocabulary.

## References

- Read `references/conventions.md` for cross-language naming conventions.
