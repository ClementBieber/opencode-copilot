---
description: "Overview current science knowledge on a topic, or run a comprehensive literature review saved to ~/research-work/reviews"
agent: researcher
---

Provide a science literature overview or comprehensive review on a given topic.

## Usage

```
/litterature <TOPIC>            — quick overview of current knowledge
/litterature review <TOPIC>     — comprehensive literature review, saved to file
```

## Implementation

### Step 0: Load the research skill

Load the `research` skill first for source conventions, output templates, archive format, and prior-research handling.

### Step 1: Parse the command arguments

Parse the text following `/litterature`:

- **If the first word is `review`** → comprehensive review mode. The remaining text is the TOPIC.
- **Otherwise** → quick overview mode. The entire text is the TOPIC.
- **If no arguments** → ask the user what topic they want to explore.

### Step 2: Check for existing reviews

Before doing any research, check `~/research-work/reviews/` for existing reviews on related topics:

1. List all files in `~/research-work/reviews/`.
2. Read file names and, if any look potentially related to the TOPIC (by keyword overlap in filename), read their frontmatter and first ~50 lines to assess relevance.
3. If closely related reviews exist:
   - In **quick overview mode**: summarize the existing review's key findings and mention its date. If the review is recent (< 30 days old), use it as the primary source and supplement with a brief check for newer developments. If older, note it as prior work and proceed with fresh research.
   - In **comprehensive review mode**: note the existing review as prior work. Reference and build upon it rather than restarting from scratch. Mention in the output what was carried forward.

---

### Quick Overview Mode

Produce a rapid overview of current scientific knowledge on TOPIC (~300-500 words):

1. Search arXiv, Semantic Scholar, and PubMed using the source conventions from the research skill.
2. Use `webfetch` to retrieve key papers, review articles, and authoritative sources.
3. Synthesize findings using the **Quick Summary** template from the research skill's output templates:
   - TL;DR (2-3 sentences)
   - Key Points (bullet list)
   - Notable Sources (with links)
   - Confidence assessment
4. Present the overview directly to the user (do NOT save to file unless asked).
5. If existing related reviews were found in Step 2, reference them and note how the current overview relates.

---

### Comprehensive Review Mode (`/litterature review <TOPIC>`)

Produce a full literature review on TOPIC (~1000-2000 words) and save it:

1. Search arXiv, Semantic Scholar, and PubMed using the source conventions from the research skill. Cast a wider net than quick overview: use keyword variants, check citations of key papers, and review at least 15-20 sources.
2. Use `webfetch` to retrieve full abstracts, key figures, and methodology details from the most relevant papers.
3. Synthesize findings using the **Literature Review** template from the research skill's output templates:
   - Background & Motivation
   - Methodology (search terms, databases, selection criteria)
   - Thematic Analysis (organized by themes/subtopics)
   - Gaps & Open Questions
   - Conclusions & Recommendations
   - References (numbered, with links and DOIs)
4. Add frontmatter metadata:

```markdown
---
topic: <Topic Name>
review_date: YYYY-MM-DD
sources_reviewed: <N>
databases: [arxiv, semantic-scholar, pubmed]
query: <original query>
tags: [<relevant-tags>]
related: [<filenames of related prior reviews>]
template: literature-review
---
```

5. Save the review to `~/research-work/reviews/YYYY-MM-DD-<slug>.md` where:
   - `YYYY-MM-DD` is today's date
   - `<slug>` is the topic lowercased, spaces replaced with hyphens, special characters removed, max 60 characters

6. Verify the file was saved successfully by reading it back.
7. Report to the user: the file path, a brief summary of key findings, and the number of sources reviewed.
8. If prior related reviews were found in Step 2, include them in the `related` frontmatter field and reference their findings in the Background section.
