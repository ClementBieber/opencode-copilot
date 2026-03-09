---
description: "Research a topic from the last 30 days across Reddit, X, YouTube, TikTok, Instagram, HN, Polymarket, and web — or run all watchlist topics"
agent: orchestrator
---

Research a topic across configured sources using the last30days skill, or produce briefings for all watchlist topics.

## Usage

```
/last30 <topic>    — research a single ad-hoc topic
/last30            — run all topics from the watchlist
```

## Implementation

### Step 0: Load the last30days skill

Before any delegation, load the `last30days` skill yourself using the skill tool. This gives you URL construction rules, script discovery paths, watchlist conventions, and persistence format. You need this context to construct correct delegation prompts.

### Decision: ad-hoc topic vs. watchlist

Parse the user's command arguments:
- **If a topic argument is present** → go to [Ad-hoc Research](#ad-hoc-research)
- **If no argument** → go to [Watchlist Sweep](#watchlist-sweep)

---

### Ad-hoc Research

Delegate to the `research-synthesizer` subagent using the Task tool with this prompt template (replace `{TOPIC}` with the user's topic and `{DATE}` with today's YYYY-MM-DD):

```
Load the last30days skill. Research the following topic in non-interactive agent mode:

TOPIC: {TOPIC}

Steps:
1. Load the last30days skill for script paths, source conventions, and output format.
2. Run the research script with --agent flag.
3. Supplement with webfetch for blogs/docs/news.
4. Synthesize findings following the skill's Judge Agent rules.
5. Save the briefing to: /home/clement/.config/opencode/tools-history/last30days/{DATE}-{SLUG}.md
   where {SLUG} is the topic lowercased, spaces replaced with hyphens, special chars removed, max 60 chars.
6. Verify the file was written successfully.
7. Return the output contract JSON as your final message.

Output contract — return exactly one of:
- COMPLETED: {"status": "completed", "file": "/abs/path", "title": "...", "summary": "..."}
- BLOCKED: {"status": "blocked", "why": "...", "needed_from_user": "...", "next": "..."}
- ERROR: {"status": "error", "message": "..."}
```

After receiving the result:
- If COMPLETED: show the user the title, summary, and file path.
- If BLOCKED: relay `needed_from_user` to the user and suggest `next`.
- If ERROR: report the error message to the user.

---

### Watchlist Sweep

> **Watchlist source priority:** The command uses the installed skill's
> `watchlist.py` script (SQLite-backed) as the primary topic source.
> If the script is missing or fails, it falls back to the legacy static
> file at `/home/clement/.config/opencode/tools-history/last30days/watchlist.json`.

1. **Obtain the topic list.** Run the upstream skill's watchlist script to get the current topics:

   ```bash
   python3 "$(git rev-parse --show-toplevel)/dist/skills/last30days/scripts/watchlist.py" list
   ```

   Parse the JSON output — the result contains a `topics` array of objects (each with at least a `name` field, plus `enabled`, `schedule`, `search_queries`, and `last_researched`). Keep only topics where `enabled` is true (or missing, which defaults to true).

   **Fallback:** If the script does not exist or exits non-zero, read the legacy watchlist file at `/home/clement/.config/opencode/tools-history/last30days/watchlist.json` instead. That file contains a plain JSON array of topic objects, each with at least a `name` field.

2. If no topics are found from either source, tell the user:
   > No watchlist topics found. Use `/last30 <topic>` for ad-hoc research, or add topics with `python3 dist/skills/last30days/scripts/watchlist.py add "topic name"`.

3. For each topic in the watchlist, delegate to the `research-synthesizer` subagent using the same prompt template from [Ad-hoc Research](#ad-hoc-research), substituting `{TOPIC}` with the topic's `name` field. You may batch multiple Task tool calls in a single message for parallelism.

4. After each successful COMPLETED result, update the topic's `last_researched` timestamp. If using the watchlist script, this is handled automatically by the SQLite store. If using the legacy JSON fallback, update the topic's `last_researched` field in `watchlist.json` to the current ISO 8601 timestamp (e.g., `"2026-03-08T14:30:00Z"`) and write the file back to disk.

5. After all topics are processed, present a summary table to the user:

   | Topic | Status | File |
   |-------|--------|------|
   | ... | completed / blocked / error | path or reason |
