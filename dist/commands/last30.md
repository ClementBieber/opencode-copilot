---
description: Research a topic across Reddit, X, YouTube, HN, and web — or get a briefing on your watchlist
agent: orchestrator
---

Usage:
- /last30 [topic]    -> Research the provided topic across configured sources
- /last30           -> Produce briefings for all topics in the watchlist

Behavior:
1. If a topic argument is provided, delegate an ad-hoc research request to the research-synthesizer subagent.
2. If no argument is provided, load the watchlist from ~/.config/opencode/last30days/watchlist.json and request briefings for each topic (use cached results if present unless forced to refresh).
3. In all cases, load the last30days skill for workflow, file paths, and URL construction.
4. Persist finalized briefings to ~/.config/opencode/last30days/history/ with the filename pattern YYYY-MM-DD-<slugified-topic>.md when instructed by the user or by policy.
