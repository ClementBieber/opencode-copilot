# Session Querying and Discovery

## Overview

Recommendations for making compacted sessions discoverable and queryable. This is a future capability — current implementation embeds manifests in compacted context only.

## Useful Index Keys Per Session

| Key | Purpose |
|-----|---------|
| session_id | Unique identifier |
| timestamp | When session was compacted |
| project_root | Which project |
| summary | Short natural-language description |
| files.paths | Which canonical files were referenced |
| git.branch | Which branch was active |
| git.recent_commits | Commit hashes for correlation |

## Query Use Cases

1. **Find recent sessions for this project** — filter by project_root + sort by timestamp
2. **Find sessions that touched TASKS.md** — filter by files.paths containing "TASKS.md"
3. **Find sessions on a specific branch** — filter by git.branch
4. **Resume where I left off** — get the latest session, read its summary and manifest

## Storage Options

### Option A: Platform-level (preferred)
If OpenCode exposes a sessions metadata API, store the manifest under a reserved key (`session_index_v1`) in the platform's session store. This enables cross-project querying and is managed by the platform.

### Option B: Project-local index
Write session manifests to `.opencode/session-index/`:
```
.opencode/session-index/
├── index.json          # Array of summary records (id, timestamp, summary)
└── <session-id>.json   # Full manifest per session
```

Query with standard tools:
```bash
# Find sessions mentioning a task
jq '.[] | select(.summary | test("session-index"))' .opencode/session-index/index.json
```

### Option C: Embedded only (current)
Manifest is embedded in compacted context. No persistent index. Sessions are discoverable only within the active OpenCode session store.

## Best Practices

- Prefer manifest metadata over fetching full file content
- Validate freshness via SHA-256 before trusting excerpts
- Respect redaction flags — never request sensitive files flagged as redacted
- Keep index records small — summary + metadata only, not full excerpts
