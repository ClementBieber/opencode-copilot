---
name: cost-aware-llm-pipeline
description: Lightweight guidance for routing, tracking and budgeting LLM calls to minimize cost while preserving capabilities.
---

When to load
-------------
- Load this skill when an agent or pipeline will make multiple LLM calls, or when the system must balance capability and cost across tasks. Use it for multi-step workflows, orchestration, or services that run at scale.

Model routing
-------------
- Use a tiered model routing pattern: categorize models into tiers (cheap / balanced / capable) and select a tier based on assessed task complexity and required capabilities.
- Decision criteria:
  - Task complexity: estimated by prompt length, reasoning depth, number of steps, and expected token output.
  - Required capabilities: safety, up-to-date knowledge, tool-use, reasoning depth, multi-modal needs.
  - Cost thresholds: apply hard/soft thresholds per-call or per-session.
- Routing pattern (conceptual):
  - If complexity is LOW and no advanced capabilities required → route to CHEAP tier.
  - If complexity is MEDIUM or needs higher reliability → route to BALANCED tier.
  - If complexity is HIGH or requires deep reasoning/multimodal/tooling → route to CAPABLE tier.

Cost tracking
-------------
- Maintain immutable CostRecords for each external LLM call. A CostRecord should capture at least: timestamp, model/tier, input tokens, output tokens, cost-per-call (computed), request metadata (reason, task id).
- Keep CostRecords append-only and store them in a session-level ledger. Use aggregates for reporting (per-task, per-session, per-day).

Budget controls
----------------
- Enforce per-session and per-task budgets. When a planned call would exceed budget, the pipeline should either:
  - Fall back to a cheaper model tier, or
  - Truncate/abbreviate the request, or
  - Defer or fail the task with a clear budget-exceeded result.
- Emit alerts when usage crosses warning thresholds (e.g., 70% of budget) and enforce hard stop at the limit.

Prompt caching
-------------
- Cache long, immutable system prompts or shared context and reference them by id/hashing rather than resending each call. Include a cache invalidation policy tied to version or checksum changes.
- Reuse cached context across calls in the same session to reduce tokens and cost.

Retry policy
------------
- Retry only on transient failures (network errors, provider rate limits, 5xx). Do not retry on validation, authentication, or provider-identified client errors.
- Use exponential backoff with capped retries (e.g., 3 attempts) and jitter to avoid thundering herd.

Best practices (checklist)
-------------------------
- Instrument every call with a CostRecord and attach a reason/task-id.
- Prefer cheaper tiers for deterministic, template-driven tasks.
- Cache and deduplicate prompts and shared contexts.
- Implement graceful degradation: fallbacks and truncation strategies.
- Monitor budgets and emit early warnings before limits.
- Keep routing rules simple and auditable.

Anti-patterns
-------------
- Blindly sending the same long system prompt with every call.
- Retrying on non-transient errors (causes repeated failures and cost spikes).
- Routing only by model name or cost without assessing task complexity.
- Omitting immutable cost records — losing auditability.
- Allowing unlimited background/batch calls without budget controls.

Further reading
---------------
- See docs/implementation-guide.md for pseudocode, config templates, and provider mappings.
