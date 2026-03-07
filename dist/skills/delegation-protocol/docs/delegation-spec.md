# Delegation Protocol Spec

Status: draft  
Scope: parent/subagent interaction rules  
Canonical owner: `delegation-protocol`

## 1. Purpose

This document defines the shared parent/subagent protocol for OpenCode Copilot.

Use it whenever:
- one agent delegates to another
- a subagent needs to return a blocked state
- a parent needs integration-friendly, low-noise outputs

## 2. Core Rules

1. Parents send the minimum sufficient context.
2. Subagents return only the requested result.
3. Missing user input is reported upward, never asked directly by subagents.
4. Safe assumptions may be used when low-risk and explicitly stated.
5. Delegation traffic should be concise and integration-friendly.

## 3. Parent → Subagent Contract

Parents should include:
- one clear objective
- exact deliverable expected back
- constraints and file references
- verification command if needed
- skill to load if relevant

Parents should avoid:
- unnecessary backstory
- repeated docs
- large copied context when a path/reference is enough

## 4. Subagent → Parent Contract

Subagents should return one of:
- completed result
- blocked result
- failed result

Subagents should avoid:
- narrative filler
- long summaries unless explicitly requested
- broad restatements of the original task

## 5. Blocked-State Standard

If blocked on missing user input, return exactly:

- `Status: BLOCKED`
- `Needed from user: <exact question>`
- `Why needed: <one sentence>`
- `Next step after answer: <one sentence>`

No extra commentary.

## 6. Parent Integration Rule

- Orchestrator → convert blocked state into a `question` tool call
- Manager → propagate blocked state upward unless it can resolve internally
- Specialist/System → return blocked state upward

## 7. Noise Limits

- no motivational filler
- no performative narration
- no extra formatting unless requested
- no user-facing tone unless parent asked for user-facing output
