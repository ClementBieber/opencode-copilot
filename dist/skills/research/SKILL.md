---
name: research
description: Science research workflow, source conventions, archive format, and evolving domain knowledge. Load when performing research tasks.
---

Source Conventions

- arXiv
  - Search URL: https://arxiv.org/search/?query=<QUERY>&searchtype=all
  - API: http://export.arxiv.org/api/query?search_query=<QUERY>&sortBy=submittedDate&sortOrder=descending&max_results=20

- Semantic Scholar
  - API: https://api.semanticscholar.org/graph/v1/paper/search?query=<QUERY>&limit=20&fields=title,authors,year,abstract,url,citationCount

- PubMed
  - Search URL: https://pubmed.ncbi.nlm.nih.gov/?term=<QUERY>&sort=date

- Google Scholar
  - Search URL: https://scholar.google.com/scholar?q=<QUERY>&as_sdt=0&as_ylo=<YEAR>
  - Note: Google Scholar is commonly rate-limited and may block automated requests; prefer other APIs when feasible.

- Documentation
  - Context-dependent. Prefer official sites, MDN for web APIs, language/runtime docs, and standards bodies (W3C, IETF, ISO) for specifications.

Research Workflow

1. Clarify scope with the requester: domain, time window, depth, and any preferred or excluded sources.
2. Construct precise queries for each target source, including keyword variants and year filters when needed.
3. Fetch results using the `webfetch` tool. Prefer canonical DOIs, publisher pages, or open PDFs.
4. Parse and extract metadata: title, authors, year, abstract/summary, URL, and citation count when available.
5. Filter and rank by relevance, recency, methodological rigor, and citation metrics.
6. Synthesize into a structured briefing: Key Findings, Evidence & Sources, Methodology notes, Open Questions, Next Steps.
7. Save the briefing to the archive location and reference prior archives when applicable.

Archive Format

- Location: ~/.config/opencode/research/archive/
- Filename pattern: YYYY-MM-DD-<slugified-topic>.md
- Frontmatter and body structure:
```markdown
---
topic: <Topic Name>
research_date: YYYY-MM-DD
sources: [arxiv, semantic-scholar, pubmed]
query: <original query>
---
# <Topic Name> — Research Summary (YYYY-MM-DD)

## Key Findings
...

## Papers & Sources
...

## Synthesis
...
```

Skill Evolution

- The SKILL.md contains workflow and conventions and should be updated sparingly.
- For accumulated domain knowledge, create or update files under dist/skills/research/docs/ with topic-specific notes. Example:
  - dist/skills/research/docs/llm-architectures.md
- When asked to persist findings, create a new docs/ file or append to an existing one with clear provenance and dates.

Reading Prior Research

- Before beginning new research, check ~/.config/opencode/research/archive/ for existing summaries on the topic or related areas.
- Reference and build upon prior findings; avoid unnecessary duplication.

Output Conventions

- Cite sources with direct links and DOIs when available.
- Differentiate clearly between established consensus and emerging or contested findings.
- Report a confidence level (low/medium/high) and justify it briefly.
- Use structured markdown: headers, bullets, and tables for comparisons. Keep summaries scannable (~500-1500 words depending on scope).

Operational Notes

- When using APIs that require rate limits or keys, surface these constraints to the user and offer alternatives.
- Prefer open-access copies (preprints, institutional repositories) when possible; note paywalled sources explicitly.
