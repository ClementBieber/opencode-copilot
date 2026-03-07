---
name: last30days
description: Research topics, manage watchlists, get briefings, query history. Also triggered by 'last30'. Sources: Reddit, X, YouTube, web.
---


This skill documents the watchlist and research workflow used by the research-synthesizer subagent. It is deliberately implementation-focused so the Orchestrator and subagents can follow a predictable set of file locations, URL patterns, and output conventions.

Watchlist management
- Location: ~/.config/opencode/last30days/watchlist.json
- Format: JSON array of topic objects. Example:
  [
    {
      "topic": "example topic",
      "added_date": "2026-03-01",
      "last_researched": "2026-03-05"
    }
  ]
- Fields:
  - topic: canonical topic string
  - added_date: ISO date when the topic was added
  - last_researched: ISO date of the most recent saved briefing (nullable)
- Supported operations (performed by the Orchestrator): add topic, remove topic, list watchlist, update last_researched when a research run is saved.

Research workflow (high-level)
1. For each topic build queries and search URLs for the following sources. Use URL parameters or APIs to restrict to the last 30 days when possible.
   - Reddit (HTML search): https://old.reddit.com/search?q=<QUERY>&sort=new&t=month
   - Hacker News (Algolia API): https://hn.algolia.com/api/v1/search?query=<QUERY>&tags=story,comment&numericFilters=created_at_i>=(<UNIX_TS_30_DAYS_AGO>)
   - YouTube (web results or alternative front-end): https://www.youtube.com/results?search_query=<QUERY>&sp=EgIQAQ%253D%253D
   - X/Twitter (privacy front-end like nitter): https://nitter.net/search?f=tweets&q=<QUERY>%20since%3A<YYYY-MM-DD>
   - General web: search engine query (e.g., Google/Bing) with a time filter (qdr:m or since: param)
2. Translate "last 30 days" to a cutoff timestamp (UNIX seconds) and to an ISO date for front-end search parameters where required.
3. Use the webfetch tool to fetch each constructed URL or API endpoint. Respect rate limits and prefer JSON APIs when available.
4. Parse the responses or HTML to extract candidate items. For each item capture:
   - title/headline
   - author/handle
   - timestamp (normalize to ISO 8601)
   - short excerpt or top comment
   - direct link
5. Filter items to the last 30 days using the cutoff timestamp.
6. Deduplicate items across sources by URL or by normalized title+author.
7. Rank or cluster items by recency and engagement (comments, points, likes) when that metadata is available.
8. Synthesize a markdown briefing following the Briefing format below.

Briefing format (output)
- Top header: Topic — Research date (ISO)
- Source sections (Reddit, X/Twitter, YouTube, Hacker News, Web):
  - Summary line: item count and quick orientation
  - 3–6 key findings (bullets) with short excerpts
  - Notable links: bullet list of canonical URLs
- Trends & themes: 3–8 bullets highlighting recurring narratives, sentiment, or directional signals
- Synthesis: 3–6 clear takeaways and recommended next steps (monitor, escalate for deep research, remove from watchlist, etc.)
- Metadata: list of raw item counts, time window, and any fetch errors or skipped sources

History and persistence
- Save briefings to: ~/.config/opencode/last30days/history/
- Filename pattern: YYYY-MM-DD-<slugified-topic>.md
  - Slugify rules: lowercase, trim, replace whitespace with hyphens, remove non-alphanumeric/`-` characters
  - Example: "Large Language Models" -> 2026-03-07-large-language-models.md
- Stored file contains the full briefing markdown plus a small YAML header with topic and research_date for easy indexing.

Examples (filenames and headers)
- ~/.config/opencode/last30days/history/2026-03-07-large-language-models.md
  ---
  topic: Large Language Models
  research_date: 2026-03-07
  ---
  # Large Language Models — 2026-03-07
  ...

History querying
- The Orchestrator may list or open history files to answer queries like "show last research for X" or "search history for Y". Use simple filename pattern matching and basic text search within history files.

Operational concerns
- Rate limiting: prefer paginated APIs and limit parallel fetches. Back off on HTTP 429 responses.
- Privacy: favor privacy-respecting front-ends (nitter for X, yewtu for YouTube) when available and when it yields usable results.
- Errors: record any fetch or parsing errors in the briefing metadata so the user understands gaps.
- Caching: keep short-lived caches of raw fetch responses (in memory or temporary files) to avoid repeated requests during a single orchestration run.

Commands the Orchestrator should understand
- research [topic]           -> Run an ad-hoc research for the given topic and return/summarize a synthesized briefing.
- brief me                  -> Produce briefings for all topics in the watchlist. Use cached latest results when available unless a refresh is requested.
- add [topic] to watchlist  -> Add a topic to the watchlist with current date as added_date.
- remove [topic] from watchlist -> Remove the topic from the watchlist.
- show watchlist            -> List topics and last_researched dates and suggest stale items (not researched in >30 days).
- last30 [topic]            -> Alias for research [topic].

Notes
- The research-synthesizer subagent should load this skill to follow file locations, URL conventions, and output conventions.
- Keep briefings concise and scannable: the intended consumer is a human who wants a quick update and links for deeper reading.
