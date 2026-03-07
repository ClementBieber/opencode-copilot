Autonomous Loops — Patterns and Templates
========================================

This document is a focused, tool-agnostic reference for designing safe autonomous loops. It includes concise pseudocode and operational guidance.

1) Sequential pipeline
-----------------------
When to use: deterministic one-pass workflows where each stage depends on the previous.

Pseudocode:
- inputs := load_inputs()
- a := stepA(inputs)
- b := stepB(a)
- out := stepC(b)
- verify(out)

Guidance: make stages idempotent when possible and log inputs/outputs for traceability.

2) Autonomous iteration (run → verify → decide)
----------------------------------------------
When to use: problems that benefit from repeated refinement or self-correction.

Core loop pseudocode:
- state := load_checkpoint() or init_state()
- iterations := 0; failures := 0
- while true:
  - check_exit_conditions(iterations, elapsed, cost, failures)
  - output := run_step(state)
  - pass, evidence := verify(output)
  - if pass:
    - persist_checkpoint(output)
    - if completion_met(output): return success
    - state := prepare_next_state(output)
    - failures := 0
  - else:
    - failures += 1
    - if failures >= MAX_CONSECUTIVE_FAILURES: abort("too many failures")
    - state := apply_fix(state, evidence)
  - iterations += 1

Notes: keep verification lightweight; always persist transcripts and checkpoints before risky actions.

3) Continuous PR loop
----------------------
When to use: automated changes to repositories where CI is the primary verification signal.

Workflow pseudocode:
- branch := create_branch(base)
- attempts := 0
- while not merged and attempts < MAX_ATTEMPTS:
  - make_changes(branch)
  - run_local_checks(branch)
  - push(branch)
  - pr := create_pr(branch)
  - wait_for_ci(pr)
  - if ci_passed(pr):
    - if auto_merge_allowed(pr): merge(pr); return success
    - else: request_human_review(); return pending
  - else:
    - diagnose := collect_ci_logs(pr)
    - if can_autofix(diagnose): apply_fix(branch)
    - else: attempts += 1
- abort("max PR attempts")

Guidance: isolate each attempt in a separate worktree; cap concurrent open PRs and attempts.

4) DAG orchestration
---------------------
When to use: problems that decompose into independent or partially-dependent subtasks suitable for parallel execution.

Pattern:
- tasks := decompose(problem)
- dag := build_dag(tasks)
- schedule := topological_sort(dag)
- for tier in schedule.tiers:
  - run tier.tasks in parallel (respecting resource limits)
  - wait for results
  - merge_into_shared_state(results) with deterministic conflict resolution
- final := finalize(shared_state)
- verify(final)

Conflict handling: prefer deterministic merges and retries; escalate to human review for irreconcilable conflicts.

5) Shared state patterns
------------------------
SHARED_NOTES.md: append concise entries like "TS — iter — summary — decision" for human-readable audit trails.

Checkpoint files: store minimal machine-readable state (iteration, last-success-digest, artifact pointers). Always atomically write checkpoints before risky operations.

Session transcripts: keep full IO per iteration for debugging; rotate or truncate archives to control growth.

6) Worktree isolation
---------------------
Use separate workspaces for parallel branches/experiments to avoid contamination and accidental merges. Export artifacts or create PRs from isolated worktrees.

7) Safety checklist (mandatory)
------------------------------
- Define hard exit conditions: MAX_ITERATIONS, MAX_COST, MAX_DURATION, MAX_CONSECUTIVE_FAILURES
- Define completion criteria and verification gates per loop
- Persist notes, transcripts, and checkpoints each iteration
- Limit concurrency and per-worker resource usage
- Require human approval for high-risk actions (production deploys, destructive writes)
- Implement backoff strategies for repeated failures
- Never record secrets in shared notes or checkpoints

Appendix: keep templates and implementation code separate; use the pseudocode above as design references.
