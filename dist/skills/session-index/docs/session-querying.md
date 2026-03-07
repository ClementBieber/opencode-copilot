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

## Native Session Storage

OpenCode stores all session data in a SQLite database at `~/.local/share/opencode/opencode.db`. The schema includes projects, sessions, messages, and parts tables with full message content stored as typed JSON blobs (`UserMessage | AssistantMessage`).

Key characteristics:
- **Project-scoped listing**: The TUI session list (`Ctrl+X L`) filters by current `project_id` — this is hardcoded, not configurable. Sessions from other projects are invisible.
- **Cross-project API**: `GET /experimental/session` returns `GlobalSession` type across all projects, but the TUI does not use it.
- **Cost/token tracking**: Every `AssistantMessage` records cost, tokens (input/output/reasoning/cache), modelID, and providerID natively.

### Storage approach

Since OpenCode already persists full session data, avoid duplicating it. The compaction manifest (embedded in compacted context) provides the discovery layer on top:

- **Embedded manifest (current)**: Manifest is included in compacted context with file pointers, SHA-256 hashes, and excerpts. Discoverable within the active session.
- **Platform-level (future)**: If OpenCode exposes a sessions metadata API, store the manifest under a reserved key (`session_index_v1`) for cross-project querying.

A project-local file index is unnecessary — the native SQLite DB already provides persistent, queryable session storage.

## Best Practices

- Prefer manifest metadata over fetching full file content
- Validate freshness via SHA-256 before trusting excerpts
- Respect redaction flags — never request sensitive files flagged as redacted
- Keep index records small — summary + metadata only, not full excerpts
