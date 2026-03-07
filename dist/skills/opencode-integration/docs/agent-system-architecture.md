# Agent System Architecture

How OpenCode's agent system works: agents, skills, commands, and plugins.

## Component Types

### Agents
Markdown files with YAML frontmatter. Define behavior, role, model, and permissions.

- **Primary agents**: interact directly with the user
- **Subagents**: invoked by primary agents via the Task tool for focused work

Agent prompts should be:
- Short and behavioral — define *how* the agent works, not *what* it knows
- Free of duplicated instructions — shared behavior belongs in skills
- Free of domain knowledge — that belongs in skills loaded on demand

### Skills
Named directories containing a `SKILL.md` with optional `docs/` subdirectory. Provide on-demand knowledge.

Loading model (progressive disclosure):
1. **Metadata** — name and description (always visible in skill tool)
2. **SKILL.md** — operational instructions (loaded when agent calls the skill)
3. **docs/** — deep reference material (loaded only when explicitly needed)

Keep SKILL.md lean. If content is deep, optional, or rarely needed, put it in `docs/`.

### Commands
Markdown files invoked as `/command-name` by the user. Route to agents/skills for execution.

Commands should be thin routing instructions:
- What to do
- Which agent/skill to use
- What parameters to pass

Commands must not duplicate workflows or knowledge.

### Plugins
TypeScript files using the `@opencode-ai/plugin` SDK. Handle runtime events.

Available hooks include session compaction. Plugins should not become knowledge stores.

## Design Principles

### Unicity across components
- Agent prompts own behavior
- Skills own knowledge
- Commands own user-facing invocation shortcuts
- Plugins own runtime hooks
- If the same instructions appear in multiple agent prompts, extract to a skill

### Context efficiency
- Primary agents should orchestrate, not execute heavy work
- Subagents on cheaper models do the heavy lifting
- Skills load on demand — not preloaded into every conversation
- Keep always-loaded context (prompts, metadata) small

### Prompt hygiene
All agent prompts should:
1. Be short and behavioral
2. Not contain repeated shared standards
3. Not embed skill catalogs beyond minimal routing references
4. Not contain long examples unless unique to that agent
5. Reference shared skills for shared behavior

Prompt duplication across agents is a design bug.

## Review Checklist

When modifying agent system components, check:
1. Is anything duplicated across agent prompts?
2. Does this increase always-loaded context?
3. Could this be a skill instead of prompt text?
4. Could this be a command instead of a new agent?
5. Does it preserve delegation clarity between agents?

## Decision Heuristics

| What is it? | Where does it go? |
|-------------|-------------------|
| Repeated across agents | → skill |
| Deep domain knowledge | → skill/docs |
| Runtime hook | → plugin |
| User shortcut | → command |
| Role/behavior policy | → agent prompt |
| Project context | → AGENTS.md (in the project, not in agent system) |
| Active tasks | → TASKS.md (in the project) |
