# Pointer + Excerpt Compaction Model

## Overview

Replace full-file embedding in session compaction with pointers to canonical files plus short excerpts and metadata. Reduces context duplication while maintaining resume-ability.

## Which Files Are Included

Only **development state files** are included in compaction:
- `AGENTS.md` — project architecture and agent overview
- `TASKS.md` — active work items and backlog

**Publication files** (README.md, INSTRUCTIONS.md) are NOT included. They describe the project to external users, not active development state. Including them wastes context tokens on content that rarely changes during a session.

## Pointer Entry Schema

Each canonical file produces a pointer entry:

```yaml
path: "AGENTS.md"                    # Project-relative path
pointer: "file:///path/to/AGENTS.md" # Absolute file path
sha256: "a1b2c3..."                  # Content hash for stale detection
size_bytes: 2345                     # File size
line_count: 65                       # Total lines
excerpt_range: "lines:1-50"          # What portion is excerpted
excerpt: |                           # The excerpt text
  # OpenCode Copilot
  Multi-agent orchestration system...
note: "excerpt_truncated"            # "full" if entire file included
```

## Excerpt Policy

| Parameter | Default | Description |
|-----------|---------|-------------|
| max_chars | 800 | Maximum characters in excerpt |
| max_lines | 50 | Maximum lines in excerpt |

Rules:
- If file fits within limits: include full content, mark `note: "full"`
- If file exceeds limits: take the first N lines, truncate at max_chars
- Never excerpt files containing secrets (.env, credentials) — use `note: "redacted"` instead

## Session Manifest Format

The compaction plugin produces a manifest embedded in the compacted context:

```yaml
session_manifest:
  version: 1
  project_root: "/home/user/project"
  workdir: "/home/user/project"
  timestamp: "2026-03-07T12:00:00Z"
  files:
    - path: "AGENTS.md"
      pointer: "file:///home/user/project/AGENTS.md"
      sha256: "..."
      size_bytes: 1234
      line_count: 32
      excerpt_range: "full"
      note: "full"
    - path: "TASKS.md"
      pointer: "file:///home/user/project/TASKS.md"
      sha256: "..."
      size_bytes: 3456
      line_count: 80
      excerpt_range: "lines:1-50"
      note: "excerpt_truncated"
  git:
    branch: "main"
    status: "clean"
    recent_commits: |
      abc123 Latest commit message
      def456 Previous commit message
  summary: "Working on session-index skill implementation. Next: update compaction plugin."
```

## Recovery Block

Every compacted session ends with recovery instructions:

```
## Post-Compaction Recovery

Resume work using the manifest above. Key principles:
- Use file pointers to fetch canonical files when you need full content.
- Validate content by comparing SHA-256 hash. If mismatch, re-read from disk.
- Use the manifest summary and excerpts for quick orientation.
- Do NOT re-embed full file contents into future compaction outputs.
- Delegate heavy work to subagents. Load skills on-demand only.
```

## Backward Compatibility

- If SHA-256 cannot be computed, include `sha256: null` with size/mtime for fallback validation
- If git is unavailable, omit the git section
- Agents not yet updated to the pointer model will still see useful excerpts in the compacted context
