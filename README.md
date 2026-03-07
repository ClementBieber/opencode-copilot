# OpenCode Copilot

Multi-agent orchestration system built on [OpenCode](https://opencode.ai)'s native configuration. 4 agents coordinate development tasks through a delegation hierarchy, deployed globally and available in every project.

## Quick Start

```bash
git clone <repo-url>
./scripts/deploy.sh                # deploys lite profile (default)
# Open OpenCode in any project — agents are available immediately
```

## Deployment Profiles

| Profile | Items | Description |
|---------|-------|-------------|
| `lite` (default) | 12 | Core agents, skills, commands, plugin |
| `full` | 15 | Everything in lite + last30days research extras |

```bash
./scripts/deploy.sh                # lite profile (default)
./scripts/deploy.sh --profile full # full profile with extras
./scripts/undeploy.sh              # remove all deployed symlinks
```

Deploy creates individual file/directory symlinks from `dist/` into `~/.config/opencode/`. A deployment record at `~/.config/opencode/.opencode-copilot-deployed` tracks what was deployed for clean removal.

## Agent Hierarchy

| Agent | Model | Role |
|-------|-------|------|
| Orchestrator (primary) | gpt-5.4 | User-facing coordination, delegation |
| Manager (subagent) | gpt-5-mini | Task decomposition, multi-domain coordination |
| Specialist (subagent) | gpt-5-mini | Focused execution (code, config, research) |
| System (subagent) | gpt-5-mini | Diagnostics, infrastructure, troubleshooting |

## Project Structure

```
dist/                    # Source of truth — deployed via symlinks
  agents/                # Agent definitions (YAML frontmatter + markdown)
  skills/                # Skill definitions (on-demand knowledge)
  commands/              # Custom commands (/init, /overview, /order)
  plugins/               # Plugins (compaction.ts)
profiles/                # Deployment profiles (lite.txt, full.txt)
scripts/                 # deploy.sh / undeploy.sh
AGENTS.md                # Minimal architecture overview
TASKS.md                 # Active work items
```

## Skills

| Skill | Purpose |
|-------|---------|
| opencode-integration | OpenCode config format, deployment |
| development | Coding patterns, architecture, testing |
| task-management | TASKS.md format and conventions |
| project-architecture | Agentic project architecture pattern |

## Commands

| Command | Purpose |
|---------|---------|
| `/init` | Interactive project onboarding — creates lean AGENTS.md |
| `/overview` | Project state inspection via specialist |
| `/order` | File reorganization |

## Design Principles

- **Context efficiency** — Primary model orchestrates, gpt-5-mini executes. Skills load on-demand only.
- **Unicity** — information exists in one place. Skills hold knowledge, agent prompts hold behavior.
- **Delegation** — push heavy work to cheaper subagent models.
