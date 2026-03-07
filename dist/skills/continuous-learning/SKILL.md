---
name: continuous-learning
description: Learn reusable patterns from past sessions and safely persist them as skills or knowledge entries
---

## When to load
Load this skill when an agent or system wants to extract reusable lessons from completed sessions or milestones. This skill is intended for conservative, opt-in use during post-session analysis, curation, or knowledge-management workflows.

## Core concept
Agents can improve over time by extracting recurring, useful patterns from past interactions. These patterns are small, structured records such as problem→fix pairs, user corrections, workarounds, or debugging approaches. Patterns are reviewed by humans and then persisted as skill documents or knowledge records that future agents can consult.

## Pattern taxonomy
- Error resolutions: concrete problem → corrective action pairs (what failed, how it was fixed).
- User corrections: cases where the user changed an agent decision or output (agent did X, user corrected to Y).
- Effective workarounds: non-obvious but repeatable solutions that worked in a specific context.
- Debugging techniques: diagnostic approaches, logs-to-root-cause heuristics, triage steps that succeeded.
- Project-specific conventions: learned preferences, naming conventions, configuration constraints, or style choices.

## Extraction workflow
1. Session ends or reaches an opt-in milestone for review.
2. Extractor reviews the transcript and metadata with strict redaction rules applied.
3. The extractor identifies candidate patterns meeting a relevance/confidence threshold.
4. Candidate patterns are formatted as skill entries or knowledge records.
5. Human curator reviews, edits, approves, or rejects each candidate.
6. Approved patterns persist to skill documents, a knowledge store, or a curated repository.

## Confidence and decay
Each pattern carries a confidence score. Confidence increases when the same pattern is observed in multiple independent sessions and decays over time without reinforcement. Thresholds govern when patterns are eligible for automated suggestion versus manual promotion.

## Safety and privacy
- Opt-in only: extraction must be explicitly enabled for a project or user.
- Redact before extraction: remove secrets, tokens, credentials, direct PII, and other sensitive fragments from transcripts prior to any automated analysis.
- Human-in-the-loop: every candidate pattern requires curator approval before persistence.
- Conservative defaults: low initial confidence, high approval thresholds, and no automatic publication of patterns that reference external systems or credentials.

## Best practices
- Run extraction as a scheduled or manual post-session job, not continuously in real time.
- Require explicit project-level consent before enabling learning.
- Maintain a review queue and audit logs for all accepted patterns.
- Prefer concise, actionable pattern records (problem, context, resolution, steps to reproduce).
- Include source-session references (redacted) to aid curator decisions.
- Regularly prune low-confidence or obsolete patterns.

## Anti-patterns
- Automatically ingesting raw transcripts without redaction or review.
- Promoting noisy or one-off fixes as general rules.
- Allowing extraction to modify runtime behavior without human approval.
- Mixing privacy-sensitive data into persisted patterns.
- Overlapping responsibilities with session-index, research, or task-management — keep learning focused on reusable patterns only.

## Implementation pointers
Keep this skill lean: put operational detail and code examples in docs/implementation-guide.md. Emphasize that continuous learning is conservative, human-curated, and opt-in.

See docs/implementation-guide.md for a detailed reference and pseudocode.
