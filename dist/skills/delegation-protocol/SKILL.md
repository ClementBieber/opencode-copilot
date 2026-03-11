---
name: delegation-protocol
description: Shared protocol for parent/subagent delegation, blocked-state responses, output contracts, and low-noise integration.
---

# Delegation Protocol

Use this skill whenever an agent delegates work to another agent, or when a subagent must report a blocked state back to its parent.

## Core Rules

1. Parents send only the minimum context needed to complete the task safely.
2. Subagents return only what the parent needs to integrate the result.
3. If blocked on missing user input, subagents do not ask the user directly.
4. If a safe assumption exists, state it briefly and proceed.
5. Keep all delegation traffic concise, structured, and free of narrative noise.

## Parent → Subagent

Include:
- one clear objective
- required file paths, constraints, and expected deliverable
- verification command if relevant
- relevant skill to load if domain knowledge is needed

Do not include unnecessary history or repeated documentation.

## Subagent → Parent

Return exactly one of:
- completed result
- blocked result
- failed result

Keep the response compact and directly integrable.

## Blocked Result Format

If blocked on missing user input, return a structured blocked result. See `docs/delegation-spec.md` for the exact format.

## Noise Limits

- No motivational filler
- No repeated restatement of the full task unless needed for safety
- No long summaries when the parent asked for a narrow deliverable
- No user-facing phrasing unless the parent explicitly asked for it

## Parent Integration Rule

If a subagent returns `Status: BLOCKED`, the parent should translate that into the appropriate next action:
- Orchestrator → ask the user via the `question` tool
- Other subagents → return the blocked state upward

## Detailed Standards

For the full delegation standard, see:

- `docs/delegation-spec.md`
