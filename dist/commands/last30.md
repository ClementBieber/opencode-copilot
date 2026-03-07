---
description: Research a topic across Reddit, X, YouTube, HN, and web — or get a briefing on your watchlist
agent: orchestrator
---

Usage:
- /last30 [topic]    -> Research the provided topic across configured sources
- /last30           -> Produce briefings for all topics in the watchlist

Behavior:
1. If a topic argument is provided, delegate an ad-hoc research request to the research-synthesizer subagent.
2. If no argument is provided, load the watchlist and request briefings for each topic.
3. In all cases, load the `last30days` skill for workflow, file paths, watchlist handling, URL construction, and persistence rules.
