---
description: Generate a comprehensive overview of the current project — architecture, state, files, and active tasks
agent: orchestrator
---

Generate a comprehensive overview of the current project by delegating to a specialist subagent.

## Implementation

Delegate to the specialist subagent with the following instructions:

1. List the project root directory (`.`) to discover the file structure
2. Read `AGENTS.md` or `README.md` if they exist, for project context
3. Read `TASKS.md` if it exists, for current work state
4. Look for agent configs in `.opencode/agents/` or `dist/agents/` — read each agent's frontmatter (description, model, mode)
5. Look for skills in `.opencode/skills/` or `dist/skills/` — read each SKILL.md frontmatter (name, description)
6. Look for commands in `.opencode/commands/` or `dist/commands/` — read each command's frontmatter
7. Look for plugins in `.opencode/plugins/` or `dist/plugins/` — note each plugin
8. Read `opencode.json` if it exists for project-level configuration
9. Check for deployment scripts (`scripts/deploy.sh` or similar)

Present results as a structured overview covering (omit sections that don't apply):
- **Project Summary** — what this project is, based on README/AGENTS or inferred from structure
- **Architecture** — agent hierarchy and models (if agents found)
- **Agents** — each agent's role, model, and mode
- **Skills** — available skills and their purposes
- **Commands** — available slash commands
- **Plugins** — active plugins
- **Configuration** — key settings from opencode.json
- **Work State** — items from TASKS.md (if it exists)
- **File Structure** — key files and directories
