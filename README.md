# OpenCode Copilot

Multi-agent orchestration system built on [OpenCode](https://opencode.ai)'s native configuration. Agents coordinate development tasks through a delegation hierarchy and are deployed globally via symlinks.

## Quick Start

```bash
git clone <repo-url>
./scripts/deploy.sh                # deploys lite profile (default)
# Open OpenCode in any project — agents are available immediately
```

For published-project installation and operator guidance, see `INSTRUCTIONS.md` and `dist/skills/publication/docs/`.

## Deployment Profiles

| Profile | Items | Description |
|---------|-------|-------------|
| `lite` (default) | 12 | Core agents, skills, commands, plugin |
| `full` | 23 | Everything in lite + research, delegation, publication extras |

```bash
./scripts/deploy.sh                # lite profile (default)
./scripts/deploy.sh --profile full # full profile with extras
./scripts/undeploy.sh              # remove all deployed symlinks
```

Deploy creates individual file/directory symlinks from `dist/` into `~/.config/opencode/`. A deployment record at `~/.config/opencode/.opencode-copilot-deployed` tracks what was deployed for clean removal.

## Agent Hierarchy

See `AGENTS.md` for the current project overview and `dist/agents/*.md` for canonical agent behavior.

## Project Structure

```
dist/                    # Source of truth — deployed via symlinks
  agents/                # Agent definitions (YAML frontmatter + markdown)
  skills/                # Skill definitions (on-demand knowledge)
  commands/              # Custom slash commands
  plugins/               # Plugins (compaction.ts)
profiles/                # Deployment profiles (lite.txt, full.txt)
scripts/                 # deploy.sh / undeploy.sh
AGENTS.md                # Minimal architecture overview
TASKS.md                 # Active work items
```

## Skills and Commands

Canonical skill knowledge lives in `dist/skills/*/SKILL.md`.
Canonical command behavior lives in `dist/commands/*.md`.

## Design Principles

See `dist/skills/project-architecture/SKILL.md` for canonical architecture principles (unicity, context efficiency, delegation).
