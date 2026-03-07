---
description: Generate a comprehensive overview of the current project — architecture, state, files, and active tasks
agent: orchestrator
---

Generate a comprehensive overview of the current project by delegating to a specialist subagent.

## Implementation

Delegate to the specialist subagent with the following instructions:

1. List the project root directory (`.`) to discover the file structure
2. Read `AGENTS.md` if it exists, for project context
3. Read `README.md` or `package.json` / `pyproject.toml` / `Cargo.toml` for project description
4. Read `TASKS.md` if it exists, for current work state
5. Identify the tech stack from manifest files (package.json, pyproject.toml, go.mod, Cargo.toml, etc.)
6. Look for test setup (test directories, test configs, CI files)
7. Check for OpenCode configuration in `.opencode/` or `opencode.json` (if present)

Present results as a structured overview covering (omit sections that don't apply):
- **Project Summary** — what this project is, based on AGENTS.md, README, or inferred from structure
- **Tech Stack** — languages, frameworks, key dependencies
- **File Structure** — key files and directories with their purposes
- **Work State** — items from TASKS.md (if it exists)
- **Test & CI** — test framework, test directories, CI configuration
- **OpenCode Config** — agents, skills, commands, plugins (only if `.opencode/` or `opencode.json` exists)
