# Code-Issue Find Rules

These rules remain mandatory:

- Read `../ledger.yaml` and use its resolved scoped path as the review ledger.
- Prefer slices based on repository-owned behavior and risk: public commands/APIs, changed or recently touched areas, auth/network/filesystem/process boundaries, config/CI/release paths, documented workflows, and nearby tests. Use depth only as a discovery aid, not as the review boundary.
- For delegated review, each assigned agent owns recursive review only within its bounded slice. Each agent must perform a thorough and accurate `$code-review` and `$security-audit` for that slice, using `$testing-standards` for concrete missing-coverage or weak-test analysis and `$change-validation` for likely validation commands.
- Confirm each candidate finding against the code before recording it. Findings must be concrete bugs, security issues, compatibility breaks, or violated public contracts with user-visible impact.
- Treat provider-to-public-contract adapters, lookup tables, data enrichment,
  normalization maps, embedded assets, vendored static data, and generated
  schema/value translations as high-risk review slices when they affect API
  output, routing, auth, billing, persistence, or user-visible behavior.
- When reviewing code that maps provider, asset, generated, embedded, or
  vendored data values into repository-owned public values, inspect the actual
  emitted data set or representative fixtures. Do not assume names in a mapping
  table match provider output. Check for unmapped provider values, stale
  fixtures, fallback-to-empty behavior, and public contract violations caused
  by normalization drift.
- For candidates based on documentation or comments contradicting code, require non-prose proof that the implementation is wrong before recording a code issue. Existing tests, helper names, runtime behavior, or commit history that support the implementation mean the candidate is a doc gap, not a code issue.
- Do not record standalone missing, weak, flaky, misleading, or wrong-layer tests as code issues unless they are tied to a confirmed bug, security issue, compatibility break, or violated public contract. Use `$test-gaps` for standalone missing or weak test coverage passes.
- Do not record standalone missing, weak, stale, misleading, or wrong-location documentation, README, example, comment, or docstring gaps as code issues unless they reveal a confirmed bug, security issue, compatibility break, or violated public contract. Use `$doc-gaps` for standalone documentation review passes.
- Do not report optional regression tests, unused convenience aliases, API symmetry, or documentation polish as findings by themselves. List them only as testing gaps, doc gaps, or optional follow-up notes when relevant.
