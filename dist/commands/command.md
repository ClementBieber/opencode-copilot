---
description: Create or update OpenCode slash commands, agents, and skills — globally or for the current project.
agent: orchestrator
---

Create or update OpenCode slash commands. Works from any working directory.

Commands, agents, and skills can live in two locations:
- **Global (system):** `~/.config/opencode/` — available in every OpenCode session
- **Project-local:** `.opencode/` in a project root — scoped to that project

The opencode-copilot repo (`~/opencode-copilot/dist/`) is the source of truth for global configs; edits to global commands should target `dist/` there and be redeployed.

## Process

1. Determine the user's command-management request from the slash-command arguments and the current conversation.
2. If no actionable request was provided, ask exactly one focused question asking what command should be created or updated.
3. Delegate to the `command` subagent using the Task tool. Include the user's request verbatim and the current working directory. Instruct the subagent to:
   - load `opencode-integration` before editing OpenCode config files
   - determine scope: **global** (edit files under `~/opencode-copilot/dist/` + redeploy) or **project-local** (edit `.opencode/` in the current project) — ask the user if ambiguous
   - for global commands, inspect `~/opencode-copilot/dist/commands/`, `dist/agents/`, `dist/skills/`, `profiles/`, `TASKS.md`, and `AGENTS.md` as needed
   - for project-local commands, inspect `.opencode/commands/`, `.opencode/agents/`, `.opencode/skills/` in the current project
   - verify understanding before editing, using the `question` tool for focused assignment-shaping questions when needed
   - implement the requested command end-to-end, including supporting agents, skills, and deployment profile updates when appropriate
   - avoid duplicating existing commands when an update is cleaner
   - verify internal consistency and summarize the changed files
4. Return a concise implementation summary to the user, including any follow-up actions.
