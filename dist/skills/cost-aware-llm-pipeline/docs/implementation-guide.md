# Cost-aware LLM pipeline — implementation guide

This document provides a provider-agnostic reference for implementing a cost-aware LLM pipeline. Examples use pseudocode and illustrative configs.

## Model routing implementation

Pseudocode: route_model(task)

-- inputs: task {id, prompt, expected_output_tokens, required_capabilities}
-- outputs: model_descriptor {tier, model_hint, estimated_cost}

function assess_complexity(task):
  score = 0
  if task.prompt.length > 1000: score += 2
  if task.expected_output_tokens > 512: score += 2
  if task.required_capabilities.contains('tool-use'): score += 3
  if task.required_capabilities.contains('long-form-reasoning'): score += 3
  if task.required_capabilities.contains('safety-high'): score += 2
  return normalize(score)  # LOW/MED/HIGH

function route_model(task):
  complexity = assess_complexity(task)
  if complexity == LOW:
    return {tier: 'cheap', model_hint: 'fast-small', estimated_cost: low}
  if complexity == MEDIUM:
    return {tier: 'balanced', model_hint: 'mid', estimated_cost: medium}
  if complexity == HIGH:
    return {tier: 'capable', model_hint: 'large', estimated_cost: high}

## Cost tracker implementation

Pseudocode: immutable CostRecord and CostTracker

structure CostRecord:
  timestamp
  task_id
  model_tier
  model_name_hint
  input_tokens
  output_tokens
  estimated_cost
  actual_cost  # optional if provider returns cost
  metadata  # e.g. trace id, reason, session id

structure CostTracker:
  ledger = []  # append-only list of CostRecord

function record_call(tracker, record):
  tracker.ledger.append(record)  # immutable append

function aggregate(tracker, by):
  # returns sums/counts grouped by `by` (e.g., per-task, per-session)
  return grouped_aggregates

## Pipeline composition

Pseudocode for end-to-end call

function call_pipeline(task, tracker, config):
  complexity = assess_complexity(task)
  model = route_model(task)
  if not check_budget(config, tracker, task, model):
    model = fallback_to_cheaper(model, config)
    if model is null:
      return failure('budget_exceeded')

  prompt = prepare_prompt(task, config)
  prompt = apply_prompt_caching(prompt, config)

  response, meta = call_with_retry(model, prompt, config.retry)
  record = CostRecord(
    timestamp=now(),
    task_id=task.id,
    model_tier=model.tier,
    model_name_hint=model.model_hint,
    input_tokens=meta.input_tokens,
    output_tokens=meta.output_tokens,
    estimated_cost=estimate_cost(model, meta),
    actual_cost=meta.actual_cost,
    metadata={...}
  )
  record_call(tracker, record)
  return response

## Retry wrapper

Pseudocode: call_with_retry(model, prompt, retry_config)

function call_with_retry(model, prompt, retry_config):
  attempts = 0
  while attempts <= retry_config.max_attempts:
    attempts += 1
    try:
      return call_provider_api(model, prompt)
    except transient_error as e:
      if attempts > retry_config.max_attempts:
        raise e
      sleep(exponential_backoff(attempts) + jitter())
    except non_transient_error as e:
      raise e

## Config template

Example YAML-like configuration (illustrative):

budget:
  per_session_usd: 5.00
  per_task_usd: 0.50
  warning_threshold: 0.7  # emit warning at 70%

model_tiers:
  cheap:
    name_hint: small
    cost_per_token_estimate: 0.000001
  balanced:
    name_hint: medium
    cost_per_token_estimate: 0.00001
  capable:
    name_hint: large
    cost_per_token_estimate: 0.0001

retry:
  max_attempts: 3
  base_delay_ms: 200
  max_delay_ms: 10000

prompt_cache:
  enabled: true
  max_entries: 500
  invalidate_on_change: true

## Provider mapping

This section maps conceptual pieces to common provider features (illustrative, not exhaustive).

- Cost per token: provider APIs often return token usage or cost estimates; map to estimated_cost in CostRecord.
- Retry: implement transient detection using HTTP status codes (5xx), rate-limit errors, or SDK-specific transient flags.
- Model tiers: map 'cheap'/'balanced'/'capable' to concrete model names per provider in deployment config.

Examples (conceptual):
- OpenAI: model_tier -> {"gpt-small": cheap, "gpt-medium": balanced, "gpt-large": capable}; use usage.tokens from responses for actual_cost reconciliation.
- Anthropic: map Claude model family similarly; use returned token counts if available.
- Generic: if provider returns no cost, use cost_per_token_estimate * tokens as estimated_cost and mark actual_cost null.

## Notes and tips
- Keep routing rules interpretable and easy to override.
- Record both estimates and provider-reported usage when available so you can reconcile differences.
- Make prompt caches addressable by checksum or id to avoid resending large static prompts.

## Further reading
- See SKILL.md in the same directory for the concise guidance and best-practices checklist.
