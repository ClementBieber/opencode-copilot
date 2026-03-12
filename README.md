# OpenCode Copilot

OpenCode Copilot is a multi-agent configuration for [OpenCode](https://opencode.ai). The repo treats `dist/` as the source of truth, then deploys those agents, skills, commands, plugins, and the base `opencode.json` into `~/.config/opencode/` via symlinks.

## Quick Start

```bash
git clone https://github.com/ClementBieber/opencode-copilot opencode-copilot
cd opencode-copilot
./scripts/deploy.sh
# Open OpenCode in any project - agents are available immediately
```

For installation, troubleshooting, and operator guidance, see `INSTRUCTIONS.md` and `dist/skills/publication/docs/`.

## Deployment Model

```bash
./scripts/deploy.sh
./scripts/deploy.sh --verbose
./scripts/undeploy.sh
```

`./scripts/deploy.sh` links the canonical files from `dist/` into `~/.config/opencode/` item by item. That includes `dist/opencode.json` -> `~/.config/opencode/opencode.json` plus the currently declared agents, skills, commands, and plugins.

By default it prints a concise summary. Use `-v` or `--verbose` to show per-item deployment details.

Each deployment writes `~/.config/opencode/.opencode-copilot-deployed`, which `./scripts/undeploy.sh` uses for clean removal.

## Architecture

See `AGENTS.md` for the high-level project map and `dist/agents/*.md` for canonical agent behavior.

Today the hidden `orchestrator` acts as the default general handler, while focused agents such as `researcher` remain available for domain-specific flows.

## Refreshing System Context

If you move the repo to a different machine or the local environment changes materially, refresh the observed host block before redeploying:

```bash
./scripts/update-system-agent.sh
```

That script updates only the `## Known Environment` section in `dist/agents/system.md` so `@system` stays current without making the rest of the agent set host-specific.

## Repository Layout

```text
dist/      # canonical OpenCode config content deployed by symlink
scripts/   # deploy, undeploy, and maintenance helpers
docs/      # supporting design and contract docs
AGENTS.md  # compact architecture overview
TASKS.md   # active planning and work log
```

## Canonical Docs

`dist/skills/*/SKILL.md` contains canonical skill instructions.
`dist/commands/*.md` contains canonical slash-command behavior.
`dist/skills/project-architecture/SKILL.md` defines the core architecture principles.
