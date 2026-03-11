# Delegation Protocol Rollout Report

Date: 2026-03-11
Project: `opencode-copilot`

## Goal

Align OpenCode Copilot's task plan and prompt-system evolution around a strict parent/subagent delegation protocol before resuming presentation-flavor design.

## Why this comes first

"Flavor" now has two distinct scopes that should not be mixed:

- **Delegation protocol** — the structured contract between parent agents and subagents
- **Presentation flavor** — the user-facing tone, formatting, and interaction style

The delegation layer must be stable, low-noise, and testable before user-facing flavors are added. Otherwise presentation rules can leak into agent-to-agent traffic and make delegation less predictable.

## Existing canonical protocol

OpenCode Copilot already has a canonical delegation reference in:

- `dist/skills/delegation-protocol/SKILL.md`
- `dist/skills/delegation-protocol/docs/delegation-spec.md`

That protocol establishes these core rules:

- Parents send minimum sufficient context
- Subagents return only the requested result
- Missing user input is reported upward, not requested directly by subagents
- Safe assumptions are allowed when low risk and explicitly stated
- Delegation traffic should stay concise and integration-friendly

The spec also defines the blocked-state contract and assigns the Orchestrator responsibility for translating blocked results into the `question` tool.

## Current integration status

### Already aligned

- `dist/agents/orchestrator.md` already instructs the parent agent to provide context and translate blocked states into a focused `question` call
- `dist/agents/research-synthesizer.md` already forbids direct user prompting and defines a narrow return contract
- `dist/skills/delegation-protocol/docs/delegation-spec.md` already exists as the canonical protocol source

### Gaps still to close

- Not all delegating agents explicitly load or reference the shared delegation protocol
- Result contracts are not yet standardized across all subagents
- The boundary between internal delegation protocol and user-facing presentation flavor is not yet documented in project docs
- There is no rollout checklist yet for verifying every delegating agent follows the canonical protocol

## Task-plan updates made

`TASKS.md` now tracks delegation protocol rollout as active work with these subgoals:

- audit parent/subagent prompts against the canonical spec
- standardize blocked-state and result-contract handling
- document the protocol boundary versus user-facing presentation flavor

The backlog now also explicitly records that presentation-flavor planning resumes only after delegation protocol rollout is complete.

## Recommended rollout sequence

1. Update all parent agents that delegate so they explicitly rely on the canonical delegation protocol
2. Update all subagents so their response contract is one of: completed, blocked, or failed/error
3. Add a short verification checklist to confirm blocked-state handling and parent integration behavior
4. Only after that, move back into plan mode for presentation flavors

## Protocol boundary for future flavor work

When flavor planning resumes, use this split:

- **Internal protocol layer**: fixed structure, minimal noise, predictable fields, no persona bleed
- **User-facing flavor layer**: tone, verbosity, formatting, rhetoric, teaching style

Default rule: presentation flavor does not apply to parent/subagent traffic unless a protocol-specific profile explicitly says so.

## Immediate next step

Apply the canonical delegation protocol across the delegating agent prompts in `dist/agents/`, then verify the Orchestrator and subagents all follow the same blocked-state and return-contract semantics.
