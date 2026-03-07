---
name: project-architecture
description: "Agentic project architecture pattern: minimal project files, agent hierarchy, on-demand skills, dist/ deployment via symlinks."
license: MIT
compatibility: ">=1.0.0"
---

# Project Architecture Skill

Reusable pattern for multi-agent projects using OpenCode's native configuration.

## Core Principle: Unicity

Every piece of information exists in exactly one place:
- **Agent prompts** define behavior (dist/agents/*.md)
- **Skills** hold domain knowledge (dist/skills/*/SKILL.md) — loaded on-demand
- **TASKS.md** tracks work state
- **AGENTS.md** provides minimal architecture overview
- **README.md** is the public entry point

Never duplicate information across files. Reference it instead.

## Minimal Project Files

Only keep files that serve a distinct, non-redundant purpose:

| File | Purpose |
|------|---------|
| `AGENTS.md` | Minimal architecture overview (hierarchy, layout, principles) |
| `TASKS.md` | Active work items |
| `README.md` | Public-facing project description and quick start |

All other knowledge lives in skills (loaded on-demand) or agent prompts (always loaded with that agent).

## Agent Hierarchy Pattern

```
Primary (expensive model) — orchestration, delegation, user interaction
├── Manager (cheap model) — task decomposition, coordination
├── Specialist (cheap model) — focused execution
└── System (cheap model) — diagnostics, infrastructure
```

Design for context efficiency:
- Primary agent delegates aggressively to minimize its own context usage
- Subagents use cheaper models for all heavy lifting
- Skills provide knowledge on-demand — not preloaded into every conversation

## Deployment Pattern

`dist/` is the source of truth. Deploy via symlinks.

```
dist/
  agents/     → ~/.config/opencode/agents/
  skills/     → ~/.config/opencode/skills/
  commands/   → ~/.config/opencode/commands/
  plugins/    → ~/.config/opencode/plugins/
```

Scripts:
- `scripts/deploy.sh` — creates symlinks (idempotent)
- `scripts/undeploy.sh` — removes symlinks

Changes to files in dist/ reflect immediately via symlinks. Agent prompt changes require a session restart.

## Bootstrap a New Project

1. Create `dist/agents/` with at least a primary agent
2. Create `dist/skills/` for domain knowledge
3. Create `scripts/deploy.sh` and `scripts/undeploy.sh`
4. Create minimal root files: `AGENTS.md`, `TASKS.md`, `README.md`
5. Run deploy script
6. Start working

Keep it minimal. Add files and skills only when they serve a clear, non-redundant purpose.
