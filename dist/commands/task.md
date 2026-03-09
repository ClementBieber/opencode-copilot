---
description: Manage project tasks — add new tasks, check status, or get help with TASKS.md. Fully delegated to keep conversation context clean.
agent: orchestrator
---

Manage project tasks in TASKS.md.

## Process

1. Parse the slash-command arguments to determine the operation:
   - **`add <text>`** — add a new task
   - **`check`** — summarize current tasks
   - **No arguments or free text** — general task helper
2. Delegate the entire operation to the `taskmaster` subagent using the Task tool. Pass the user's arguments verbatim.
3. Return only the subagent's result to the user — do not add commentary or follow-up questions.

## Important

- This command must be **fully isolated** — all TASKS.md reading and writing happens inside the subagent.
- Do NOT read TASKS.md yourself. Do NOT load the task-management skill yourself.
- The subagent returns a brief success/error message. Relay it as-is.
- After relaying the result, do NOT call the `question` tool — the task is complete, stop.
