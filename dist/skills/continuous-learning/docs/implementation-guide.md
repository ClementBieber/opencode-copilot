Extractor design
----------------
The extractor is a post-session component that converts redacted transcripts into candidate patterns. It must be framework-agnostic, modular, and conservative by default.

High-level pseudocode:

```
extract_patterns(redacted_transcript, metadata):
  units = split_into_units(redacted_transcript)
  candidates = []
  for u in units:
    issues = detect_issues(u)
    for issue in issues:
      p = summarize(issue, u, metadata)
      score = score_pattern(p)
      if score >= candidate_threshold:
        candidates.append({pattern: p, score: score})
  return sort_by_score(candidates)
```

Notes:
- Splitting: use conversational turns, task boundaries, or file-change events.
- Detection: start with simple heuristics (diffs, explicit user corrections, error messages); ML classifiers can be added later.
- Summarization: produce concise problem→fix descriptions and minimal repro steps.

Pattern record format
---------------------
Store patterns in a compact, versioned schema. Minimal fields:
- id: stable unique id (hash)
- type: error-resolution | user-correction | workaround | debugging-technique | convention
- title: short human title
- description: problem, context, resolution, steps
- confidence: 0.0 - 1.0
- examples: optional redacted snippets [{session_id, snippet}]
- source_sessions: [session_id]
- created, last_seen: timestamps
- metadata: tags, project, file_refs

Confidence model
----------------
Design conservatively. Principles:
- Start with a low base (e.g., 0.2).
- Reinforce on independent observations with diminishing returns.
- Apply slow time-based decay when not observed.

Simple formulas:
- confidence = 1 - (1 - base) * decay_rate ** observations
- time decay: confidence *= time_decay_factor ** weeks_since_last_seen

Suggested thresholds:
- suggestion: ~0.5 (agent may surface as a hint)
- promotion (curation): ~0.75 (eligible for skill doc)
- archive: ~0.1 (consider pruning)

Storage options
---------------
Select storage based on scale and workflow:
- Skill docs/: write approved patterns as files for small teams and git-backed history.
- Dedicated knowledge dir: structured YAML/JSON under dist/knowledge/continuous-learning/ for curated stores.
- Database: document store (SQLite/Postgres/NoSQL) for scale, indexing and queries.

Hook integration
----------------
Integrate at session lifecycle points generically:
- on_session_end: if project allows and user opted-in, enqueue redacted transcript for extraction.
- manual trigger: allow users to queue specific sessions for extraction.
- batch runs: periodic extraction for archived transcripts.

Curation workflow
-----------------
Human review is mandatory. Minimal flow:
- Candidates land in a review queue with summary, confidence, and redacted example(s).
- Curator actions: Approve, Reject, Edit, Defer.
- On approval, persist pattern, record curator id and rationale, and log the action.
- Maintain an audit trail of decisions and pattern provenance.

Privacy checklist
-----------------
Before any automated analysis enforce redaction rules:
- Remove API keys, tokens, and credentials (long alphanumeric tokens, known prefixes).
- Remove direct PII: names, emails, phone numbers, addresses, national IDs.
- Replace file paths containing usernames, secret repo names, or absolute system paths with placeholders.
- Scrub or generalize IPs, hostnames, and DB connection strings.
- Ensure review UI only shows redacted snippets; never expose raw secrets.

Evolution path
--------------
Start conservative and increase automation as confidence and controls improve:
1) Manual extraction + human curation only.
2) Assisted metadata suggestions and tagging.
3) High-confidence suggestions shown to agents as non-actionable hints.
4) Automated skill generation from very high-confidence, curated patterns with strict audits.

Implementation notes
--------------------
- Decouple extractor, storage, and UI so components can be swapped independently.
- Log every extraction and curation action for traceability and compliance.
- Defaults must be conservative: opt-in, low base confidence, human approval required for persistence.

References
----------
This guide is intentionally generic. See SKILL.md for a short summary and adapt these recommendations to your orchestration stack.
