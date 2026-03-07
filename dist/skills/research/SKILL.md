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
tags: [neuroscience, bci, deep-learning]
template: quick-summary
related: [YYYY-MM-DD-related-topic.md]
---
# <Topic Name> — Research Summary (YYYY-MM-DD)

## Key Findings
...

## Papers & Sources
...

## Synthesis
...
```

Archive Retrieval & Memory

Before starting new research:
1. List files in ~/.config/opencode/research/archive/ to find prior work on the same or related topics.
2. Read relevant prior archive files and reference their findings — build on prior work, don't restart from scratch.
3. Use the `tags` and `related` frontmatter fields to find connected research across topics.
4. When producing new research, link back to prior archive entries in the `related` field.

Index file (optional, auto-maintained):
- Location: ~/.config/opencode/research/archive/INDEX.md
- Purpose: human-readable index of all archived research, organized by topic/date.
- Format:
```markdown
# Research Archive Index

## By Topic
- **Brain-Computer Interfaces**: [2026-03-07](2026-03-07-brain-computer-interfaces.md), [2026-03-15](2026-03-15-bci-motor-imagery.md)
- **Transformer Architectures**: [2026-03-10](2026-03-10-transformer-architectures.md)

## Recent
- 2026-03-15: [BCI Motor Imagery](2026-03-15-bci-motor-imagery.md)
- 2026-03-10: [Transformer Architectures](2026-03-10-transformer-architectures.md)
```
- Update the index after saving a new archive entry. Create it if it doesn't exist.

Skill Evolution

- The SKILL.md contains workflow and conventions and should be updated sparingly.
- For accumulated domain knowledge, create or update files under dist/skills/research/docs/ with topic-specific notes.
- Available domain knowledge docs (load on-demand for relevant topics):
  - docs/neuroscience-bci.md — Neuroscience and Brain-Computer Interface domain knowledge
  - docs/output-templates.md — Standardized templates for research outputs
- When the user asks to persist findings, create a new docs/ file or append to an existing one with clear provenance and dates.

Output Templates

- Standardized templates are documented in docs/output-templates.md. Available templates:
  - Quick Summary — rapid topic overviews (300-500 words)
  - Literature Review — comprehensive reviews (~1000-2000 words)
  - Paper Analysis — deep-dive on a single paper
  - Comparison Table — structured comparison of methods/tools/approaches
  - Research Briefing — periodic updates on a watched topic
  - Hypothesis & Experiment Design — proposing research directions
- When producing research output, select the appropriate template. The user can also request a specific template by name.

Reading Prior Research

- Before beginning new research, check ~/.config/opencode/research/archive/ for existing summaries on the topic or related areas.
- Check the INDEX.md for a quick overview of available archived research.
- Reference and build upon prior findings; avoid unnecessary duplication.

Output Conventions

- Cite sources with direct links and DOIs when available.
- Differentiate clearly between established consensus and emerging or contested findings.
- Report a confidence level (low/medium/high) and justify it briefly.
- Use structured markdown: headers, bullets, and tables for comparisons. Keep summaries scannable (~500-1500 words depending on scope).

Operational Notes

- When using APIs that require rate limits or keys, surface these constraints to the user and offer alternatives.
- Prefer open-access copies (preprints, institutional repositories) when possible; note paywalled sources explicitly.
