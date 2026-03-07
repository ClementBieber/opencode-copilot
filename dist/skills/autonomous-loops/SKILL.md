---
name: autonomous-loops
description: Patterns and safety guidance for designing autonomous iterative agent loops
---

When to load
-------------
Load this skill when an agent or automation is expected to run iterative or multi-step flows that may loop, retry, or decompose work across time. Typical triggers include: long-running tasks, systems that must self-correct, automated code/work workflows, or any agent that may re-enter a cycle of act → observe → decide.

Pattern spectrum
----------------
This skill presents a spectrum of loop patterns from simple to complex. Pick the simplest pattern that satisfies requirements.

1. Sequential pipeline
   - Run tasks A → B → C in order, no iteration unless the whole pipeline is restarted.

2. REPL loop
   - Interactive session with stateful persistence (session transcripts, shared notes) and explicit user prompts between iterations.

3. Autonomous iteration
   - Repeated run → verify → fix → repeat until success or a stop condition.

4. Continuous PR loop
   - Branch → implement changes → open PR → wait CI → auto-fix or iterate until merge/abort.

5. DAG orchestration
   - Decompose into a Directed Acyclic Graph (DAG) of tasks, run independent branches in parallel, then merge results with conflict resolution.

Exit conditions (CRITICAL)
-------------------------
Every autonomous loop MUST define explicit exit conditions before running. Minimum required controls:

- Max iterations: a hard upper bound on the number of loop cycles.
- Max cost/tokens: a monetary or token budget cap to prevent runaway consumption.
- Max duration: absolute time limit for the loop (wall clock).
- Completion signal: objective success criteria that must be checked each iteration.
- Failure threshold: maximum allowed consecutive failures (or error rate) before aborting.

State persistence
-----------------
Maintain state explicitly and conservatively. Patterns:

- Shared notes file: append human-readable summaries and decisions to a SHARED_NOTES.md
- Session transcript: store inputs/outputs per iteration for audit and replay
- Checkpoint files: save compact machine-readable checkpoints for resuming
- Isolated worktrees: use separate workspaces for parallel branches (see docs/patterns.md)

Verification gates
------------------
Insert verifiable checks between iterations. Types of gates:

- Unit checks (fast, deterministic)
- Integration tests (system-level)
- Property assertions (invariants that must hold)
- Human review gates for high-risk changes

Decision matrix
---------------
Use this quick guide to select a pattern:

- If task is one-pass and deterministic => Sequential pipeline
- If human interaction is required => REPL loop
- If automated self-correction is needed => Autonomous iteration
- If workflow targets a codebase with CI => Continuous PR loop
- If problem decomposes into parallel subtasks => DAG orchestration

Anti-patterns
-------------
- Infinite loops without exit conditions
- No cost or duration limits (unbounded expense)
- No verification between iterations
- Silent failures (errors ignored or swallowed)

References
----------
See docs/ for detailed patterns, pseudocode, templates, and a safety checklist.
