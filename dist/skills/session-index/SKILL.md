---
name: session-index
description: "Session context management: pointer+excerpt compaction model, session manifests, and recovery guidelines for agents resuming work after compaction."
license: MIT
compatibility: ">=1.0.0"
---

# Session Index Skill

Defines how agents and plugins handle session context during compaction and resumption. Replaces full-file embedding with a pointer+excerpt model that preserves signal while minimizing context waste.

## Problem

When sessions compact, the plugin previously embedded full copies of AGENTS.md, TASKS.md, and other canonical files. This wastes context tokens and violates unicity (the same content exists in files AND in the compacted context).

## Solution: Pointer + Excerpt Model

Instead of embedding full files, compaction produces:
1. A **session manifest** with metadata, file pointers, and content hashes
2. Short **excerpts** of canonical files (not full copies)
3. **Recovery instructions** that reference file paths, not embedded content

## Agent Behavior Rules

### On session start (after compaction)
- Read the session manifest to understand project state
- Use file pointers to fetch canonical files only when needed
- Do NOT expect full AGENTS.md/TASKS.md content in the compacted context

### When the compaction plugin runs
- Development files (AGENTS.md, TASKS.md) get pointer+excerpt entries
- Publication files (README.md, INSTRUCTIONS.md) are NOT included — they don't track active development state
- Excerpt policy: first 50 lines or 800 chars, whichever is smaller
- Files smaller than the excerpt limit are included in full (still with pointer metadata)
- Content hash (SHA-256) enables stale-detection on resumption

### On resumption
- Compare content hashes to detect if files changed since compaction
- If hash mismatch: re-read the canonical file from disk
- Prefer the manifest summary and excerpts for quick orientation before fetching full files

## Manifest Schema

See `docs/compaction-model.md` for the full pointer entry schema and manifest format.

## Session Discovery

See `docs/session-querying.md` for recommendations on indexing and querying past sessions.
