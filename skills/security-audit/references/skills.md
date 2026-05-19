# Skill Security

Use this reference when adding, updating, importing, or auditing skills.

## Review Checklist

- Treat external skills like third-party dependencies: review the full folder before use, especially scripts, assets, references, and metadata.
- Inspect `description` text for prompt-injection attempts, hidden instructions, remote URLs, or routing language that would trigger the skill outside its intended scope.
- Check bundled scripts for command injection, broad filesystem access, network calls, credential reads, destructive commands, and unpinned dependency downloads.
- Keep permissions and command scope as narrow as the workflow allows; avoid workspace-wide access when a specific directory or file is enough.
- Prefer references for procedural knowledge and scripts only for deterministic operations that justify executable code.
- For generated or model-drafted skills, require human review before adoption and test them against representative tasks before relying on them.
- Record validation gaps when a skill cannot be executed safely in the current environment.

## Common Findings

- High: skill instructions or scripts exfiltrate secrets, disable safety checks, run untrusted remote code, or escalate permissions.
- Medium: scripts have injection-prone argument handling, broad writes/deletes, unsafe temp files, or network access beyond the skill's purpose.
- Low: vague routing descriptions, missing metadata, stale references, or missing representative-task review that make incorrect activation likely.
