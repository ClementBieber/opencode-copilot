# Deployment Guide

Status: canonical publication/operator guide

## 1. Purpose

This guide explains how to install, deploy, verify, troubleshoot, and uninstall a published OpenCode-style project.

## 2. Prerequisites

Ensure these are available in `PATH`:

| Tool | Required | Verify with | Install (macOS) | Install (Linux/Ubuntu) |
|------|----------|-------------|-----------------|------------------------|
| Node.js 18+ | Yes | `node --version` | `brew install node` | NodeSource or `nvm install --lts` |
| Git | Yes | `git --version` | `brew install git` | `sudo apt install git` |
| OpenCode CLI | Yes | `command -v opencode` | See opencode.ai | See opencode.ai |

## 3. Clone the Repository

```bash
git clone <REPO_URL> opencode-copilot
cd opencode-copilot
```

## 4. Prepare OpenCode Config Directory

The plugin system requires `@opencode-ai/plugin` in `~/.config/opencode/`.

```bash
mkdir -p ~/.config/opencode

if [ ! -f ~/.config/opencode/package.json ]; then
  echo '{"dependencies":{"@opencode-ai/plugin":"latest"}}' > ~/.config/opencode/package.json
fi

npm install --prefix ~/.config/opencode
```

Verify that `~/.config/opencode/node_modules/@opencode-ai/plugin` exists.

## 5. Deploy via Symlinks

```bash
./scripts/deploy.sh
```

This deploys the canonical published configuration.

By default the script prints a concise summary. Use `./scripts/deploy.sh --verbose` to show per-item deployment details.

Deployment creates symlinks from `dist/` into `~/.config/opencode/`, including `dist/opencode.json` -> `~/.config/opencode/opencode.json`, and records what was deployed in `~/.config/opencode/.opencode-copilot-deployed`.

## 6. Verify Deployment

Open OpenCode in any project directory:

```bash
cd ~/some-project
opencode
```

Check that:
1. the primary agents are available
2. subagents are accessible
3. commands such as `/overview` work
4. skills load on demand

## 7. Troubleshooting

| Issue | Solution |
|-------|----------|
| Need full deployment detail output | Run `./scripts/deploy.sh --verbose` |
| Plugin errors on startup | Run `npm install --prefix ~/.config/opencode` |
| `deploy.sh` refuses to link | Back up conflicting files, then retry |
| Agent not appearing | Restart OpenCode |
| Commands not recognized | Verify symlinks in `~/.config/opencode/commands/` |

## 8. Uninstall

```bash
./scripts/undeploy.sh
```

This removes only recorded deployed symlinks and leaves real files intact.
