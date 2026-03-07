# OpenCode Copilot

Multi-agent orchestration system for OpenCode.

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

Project-specific overview belongs here.
Agent details live in `dist/agents/*.md`.
Skill knowledge lives in `dist/skills/*/SKILL.md` and related `docs/` directories.

<skills_system priority="1">

## Available Skills

<!-- SKILLS_TABLE_START -->
<usage>
When users ask you to perform tasks, check if any of the available skills below can help complete the task more effectively. Skills provide specialized capabilities and domain knowledge.

How to use skills:
- Invoke: `npx openskills read <skill-name>` (run in your shell)
  - For multiple: `npx openskills read skill-one,skill-two`
- The skill content will load with detailed instructions on how to complete the task
- Base directory provided in output for resolving bundled resources (references/, scripts/, assets/)

Usage notes:
- Only use skills listed in <available_skills> below
- Do not invoke a skill that is already loaded in your context
- Each skill invocation is stateless
</usage>

<available_skills>

<skill>
<name>last30days</name>
<description>"Research a topic from the last 30 days. Also triggered by 'last30'. Sources: Reddit, X, YouTube, TikTok, Instagram, Hacker News, Polymarket, web. Become an expert and write copy-paste-ready prompts."</description>
<location>global</location>
</skill>

</available_skills>
<!-- SKILLS_TABLE_END -->

</skills_system>
