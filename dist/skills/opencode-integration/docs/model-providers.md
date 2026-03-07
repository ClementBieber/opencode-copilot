# Model Providers Reference

## Provider/Model-ID Format

In OpenCode configs, models use `provider/model-id` format.

## Known Providers

| Provider | Example Model ID |
|----------|-----------------|
| anthropic | `anthropic/claude-sonnet-4-20250514` |
| openai | `openai/gpt-5` |
| google | `google/gemini-2.5-pro` |
| github-copilot | `github-copilot/claude-opus-4.6` |
| opencode | `opencode/gpt-5.1-codex` (via Zen) |

## Our Agent Model Assignments

| Agent | Model | Reasoning |
|-------|-------|-----------|
| orchestrator | `github-copilot/claude-opus-4.6` | Best reasoning for complex orchestration |
| manager | `github-copilot/gpt-5-mini` | Good coordination at lower cost |
| specialist | `github-copilot/gpt-5-mini` | Good execution at lower cost |

## Model Selection Guidelines

- **Orchestration/reasoning tasks:** Use the best available model (Claude Opus)
- **Routine execution:** Use capable but cheaper models (GPT-5 mini)
- **Read-only/exploration:** Default model is fine (inherits from parent)
- Use `opencode models` command to see currently available models

## Subagent Model Behavior

If a subagent doesn't specify a model, it inherits the model of the primary agent that invoked it. Our agents explicitly specify models to ensure consistent behavior.
