# OpenCode Copilot

Multi-agent orchestration system for OpenCode. 5 agents deployed as markdown configs via symlinks.

## Architecture

```
Orchestrator (gpt-5.4, primary)
├── Manager (gpt-5-mini, subagent)
├── Specialist (gpt-5-mini, subagent)
└── System (gpt-5-mini, subagent)

Researcher (gpt-5-mini, primary)
├── @specialist (delegation)
└── @explore (delegation)
```

## Layout

- `dist/` — source of truth (agents, skills, commands, plugins)
- `scripts/deploy.sh` — symlinks dist/ → ~/.config/opencode/
- `TASKS.md` — active work items

## Design Principles

- **Context efficiency** — Primary model orchestrates, gpt-5-mini executes. Skills load on-demand.
- **Unicity** — each piece of information exists in one place only. Skills hold knowledge, agent prompts hold behavior.
- **Delegation** — push all heavy work to subagents on cheaper models.

Agent details live in their own files: `dist/agents/*.md`
Skill knowledge lives in: `dist/skills/*/SKILL.md`
