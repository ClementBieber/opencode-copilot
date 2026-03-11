# Presentation Flavor Spec

Date: 2026-03-11
Project: `opencode-copilot`
Status: Phase 1

## Purpose

Define the canonical presentation-flavor model for OpenCode Copilot before applying it to any agent prompts.

This spec covers user-facing presentation only. It does not change delegation, tools, permissions, routing, model selection, or safety behavior.

## Boundary

Presentation flavor and delegation protocol are separate systems.

- **Presentation flavor** controls how primary agents present information to the user.
- **Delegation protocol** controls how parent agents and subagents communicate internally.

Delegation behavior remains governed by `docs/delegation-protocol-rollout-report.md` and the canonical delegation protocol under `dist/skills/delegation-protocol/`.

Presentation flavor must never leak into parent/subagent traffic unless a future protocol-specific system explicitly allows that.

## Scope

Phase 1 applies only to user-facing primary agents.

In the current architecture, that means:

- `orchestrator`
- `researcher`

Subagents do not inherit presentation flavor. They continue to follow the delegation protocol.

## Model

OpenCode Copilot uses **presets backed by dimensions**.

- **Presets** are the user-facing flavor names.
- **Dimensions** are the internal control axes that make presets consistent and composable.

Phase 1 defines the model and the initial presets only. It does not yet apply them to prompts.

## Dimensions

Phase 1 standardizes these five flavor dimensions:

1. **verbosity**
   - `low`
   - `medium`
   - `high`
2. **structure**
   - `light`
   - `stepwise`
   - `structured`
3. **explanation_depth**
   - `low`
   - `medium`
   - `high`
4. **terminology_density**
   - `low`
   - `medium`
   - `high`
5. **presentation_tone**
   - `clear`
   - `guiding`
   - `precise`

These values are intentionally small and mechanical. They are formatting and communication controls, not personas.

## Initial presets

Phase 1 defines three presets:

- `concise` — default
- `teaching`
- `technical`

Preset mapping:

```json
{
  "concise": {
    "verbosity": "low",
    "structure": "light",
    "explanation_depth": "low",
    "terminology_density": "medium",
    "presentation_tone": "clear"
  },
  "teaching": {
    "verbosity": "medium",
    "structure": "stepwise",
    "explanation_depth": "high",
    "terminology_density": "medium",
    "presentation_tone": "guiding"
  },
  "technical": {
    "verbosity": "medium",
    "structure": "structured",
    "explanation_depth": "medium",
    "terminology_density": "high",
    "presentation_tone": "precise"
  }
}
```

## Baseline intent of each preset

- `concise`
  - Short and clear by default
  - Structure only when it improves scanability
  - Minimal explanation beyond what is needed to act
- `teaching`
  - Stepwise and explanatory
  - Surfaces reasoning and tradeoffs more explicitly
  - Optimized for understanding, not just speed
- `technical`
  - Uses denser technical vocabulary when it improves precision
  - Emphasizes mechanics, architecture, and implementation detail
  - Assumes technical literacy without becoming performatively complex

## Precedence model

Phase 1 defines the flavor precedence contract for later phases:

1. **Agent persona** — base role and domain identity in the agent prompt
2. **Global presentation flavor** — future shared active flavor
3. **Primary-agent override** — future explicit override for a specific user-facing primary agent
4. **One-turn user override** — future transient override for a single reply

Delegation protocol is outside this precedence stack and must not be overridden by presentation flavor.

## Non-goals for Phase 1

Phase 1 does not include:

- prompt edits in `dist/agents/*.md`
- rules files under `rules/`
- style skills under `dist/skills/style-*`
- global switching via `ctrl+s`
- project-local overrides
- one-turn overrides
- dimension-level manual controls

## Next phases

- **Phase 2** — define the default `concise` formatting contract for primary agents
- **Phase 3** — define full preset behavior for `teaching` and `technical`
- **Phase 4** — integrate the shared presentation layer into primary-agent prompts
- **Phase 5+** — global switching and later overrides are documented externally in `src/opencode/specs/flavor.md`

## Acceptance criteria

Phase 1 is complete when:

- this document is the canonical flavor spec for `opencode-copilot`
- the delegation boundary is explicit
- only primary agents are in scope
- presets and dimensions are fixed
- mechanical `presentation_tone` values are fixed as `clear`, `guiding`, and `precise`
- follow-on implementation phases can reference this document without redefining the model
