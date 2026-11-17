# Skill Security

Use this reference when adding, updating, importing, or auditing skills.

## Review Checklist

- Treat external skills like third-party dependencies: review the full folder before use, especially scripts, assets, references, and metadata.
- Record the reviewed source and revision, inspect per-file licensing and
  provenance before reuse, and re-review changed content on update. A catalog
  listing, scanner pass, or self-declared hardening flag is not an endorsement.
- Inspect `description` text for prompt-injection attempts, hidden instructions, remote URLs, or routing language that would trigger the skill outside its intended scope.
- Check bundled scripts for command injection, broad filesystem access, network calls, credential reads, destructive commands, and unpinned dependency downloads.
- Keep permissions and command scope as narrow as the workflow allows; avoid workspace-wide access when a specific directory or file is enough.
- Prefer references for procedural knowledge and scripts only for deterministic operations that justify executable code.
- For generated or model-drafted skills, require human review before adoption and test them against representative tasks before relying on them.
- Record validation gaps when a skill cannot be executed safely in the current environment.

## Agent And Tool Boundaries

- Trace untrusted documents, tool results, and model output through prompt
  assembly, memory, tool dispatch, and the eventual filesystem, network, or
  privileged API action. Identify who can supply the content and whose
  authority the action uses.
- Check whether retrieved content or model summaries become durable policy or
  memory for another task, user, or tenant. Verify provenance and access checks
  on both storage and retrieval, including shared caches.
- Treat tool descriptions, schemas, and responses as input. Check server/tool
  identity, handler-side resource authorization, and argument validation; a
  schema or guardrail prompt does not itself grant or constrain authority.
- Verify that delegated tasks receive only the required authority and that
  returned content cannot enlarge it. Where an action requires approval, check
  that execution uses the approved operation, arguments, resource, and
  principal, including retries and resumed sessions.
- A prompt-injection string alone does not establish a product vulnerability.
  Require a demonstrated boundary failure, such as unauthorized disclosure,
  persistent cross-user influence, or an action the affected principal did not
  request. An intentional action within the requester's authority is not a
  delegation defect by itself.

## Common Findings

- High: skill instructions or scripts exfiltrate secrets, disable safety checks, run untrusted remote code, or escalate permissions.
- Medium: scripts have injection-prone argument handling, broad writes/deletes, unsafe temp files, or network access beyond the skill's purpose.
- Low: vague routing descriptions, missing metadata, stale references, or missing representative-task review that make incorrect activation likely.
