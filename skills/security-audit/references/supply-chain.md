# Supply Chain Security

Use this reference for dependency resolution, generated inputs, CI credentials,
build caches/artifacts, signing, packaging, or release/promotion paths.
Read `shared.md` for the evidence, confidence, execution, and reporting rules.

## Inspect

- Follow dependency and tool resolution through configured registries, source
  priorities, mirrors, lockfiles, checksums, and install/update hooks. Include
  generators and their inputs, downloaded tools, submodules, and platform-specific
  resolution when they affect executed or shipped content.
- Treat CI configuration as authorization logic: identify the trigger,
  contributor-controlled fields and source ref, executed code, runner authority,
  available secrets/tokens, and permitted writes. Trace branch names, messages,
  event fields, and generated outputs into shell commands and resource selectors.
- Trace caches, artifacts, and workspaces from producer to consumer. Check
  whether lower-trust jobs can supply content that protected jobs execute or
  publish, including shared keys, persistent runners, and mutable artifact names.
- Follow source and resolved inputs through build, scan/test, repackaging,
  multi-platform assembly, signing, and publication. Verify that the promoted
  bytes/digests are the ones approved and validated; inspect build-context and
  package exclusions for unintended secret or private-file inclusion.
- Check signature/attestation verification against the expected issuer,
  repository, workflow/ref, artifact digest, and release destination. An SBOM
  inventories components; its existence does not establish trusted provenance
  or a SLSA level. A checksum needs an authenticated trust source.
- Review failure and recovery paths: missing verification data, download or scan
  failure, credential rejection, partial release, retries, revocation, and
  rollback. Establish whether an error permits unverified publication or
  substitution of a different artifact.

## Evidence And Validation

- Name the lower-trust actor/input, trusted consumer, authority gained, and
  affected artifact or action. Mutable inputs or broad permissions generate
  leads; verify the reachable security consequence before assigning severity.
- For dependency advisories, verify the resolved affected version and supported
  usage, distinguish scanner evidence from demonstrated exploitability, and
  apply the shared upstream-ownership rule to the repository's response.
- Use repository-defined checks and harmless local fixtures when reproduction
  is needed. Testing a release path does not itself authorize publication or
  mutation of a registry, signing service, or deployed environment.
- Keep unknown hosted controls, such as branch/environment protection, registry
  policy, or runner isolation, as exact validation gaps when decisive. Do not
  infer them from host defaults or treat an unobserved control as absent.

## Verification Sources

- [SLSA specification v1.2](https://slsa.dev/spec/v1.2/) for source/build
  provenance and artifact verification; verify the version relevant to a claim.
- [Cloudflare supply-chain and release audit prompts](https://github.com/cloudflare/security-audit-skill/blob/main/skills/security-audit/SUPPLY-CHAIN-AND-RELEASE.md)
  for additional investigation leads; local evidence and the repository's
  execution policy remain authoritative.
