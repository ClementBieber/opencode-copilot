# Deployment Instructions

These instructions guide an agent (or human) through deploying OpenCode Copilot on a new machine. Follow each section in order. Verify each step before proceeding.

## Prerequisites

Ensure the following are installed and available in PATH:

| Tool | Required | Verify with | Install (macOS) | Install (Linux/Ubuntu) |
|------|----------|-------------|-----------------|----------------------|
| Node.js 18+ | Yes | `node --version` | `brew install node` | [NodeSource](https://deb.nodesource.com/) or `nvm install --lts` |
| Git | Yes | `git --version` | `brew install git` | `sudo apt install git` |
| OpenCode CLI | Yes | `command -v opencode` | See [opencode.ai](https://opencode.ai) | See [opencode.ai](https://opencode.ai) |

## Step 1: Clone the Repository

```bash
git clone <REPO_URL> opencode-copilot
cd opencode-copilot
```

## Step 2: Prepare OpenCode Config Directory

The plugin system needs `@opencode-ai/plugin` installed in `~/.config/opencode/`.

```bash
mkdir -p ~/.config/opencode

# Create package.json if it doesn't exist
if [ ! -f ~/.config/opencode/package.json ]; then
  echo '{"dependencies":{"@opencode-ai/plugin":"latest"}}' > ~/.config/opencode/package.json
fi

# Install node dependencies
npm install --prefix ~/.config/opencode
```

**Verify:** `ls ~/.config/opencode/node_modules/@opencode-ai/plugin` should exist.

## Step 3: Deploy Configs via Symlinks

```bash
./scripts/deploy.sh                # deploys lite profile (default)
```

For the full profile (includes last30days research extras):
```bash
./scripts/deploy.sh --profile full
```

This creates individual symlinks for each agent, skill, command, and plugin from `dist/` into `~/.config/opencode/`. A deployment record is stored at `~/.config/opencode/.opencode-copilot-deployed` for clean removal.

**Available profiles:**
| Profile | Contents |
|---------|----------|
| `lite` (default) | 4 agents, 4 skills, 3 commands, 1 plugin |
| `full` | Everything in lite + research-synthesizer agent, last30days skill, last30 command |

**If deploy.sh reports errors** about existing files or directories, back them up first:
```bash
mv ~/.config/opencode/agents/orchestrator.md ~/.config/opencode/agents/orchestrator.md.bak
# Repeat for any conflicting file, then re-run deploy.sh
```

**Verify:** `ls -la ~/.config/opencode/agents/` should show symlinks pointing to the project's `dist/` directory.

## Step 4: Verify Deployment

Open OpenCode in any project directory:

```bash
cd ~/some-project
opencode
```

Check that:
1. The Orchestrator agent is available as the primary agent
2. Subagents (Manager, Specialist, System) are accessible via `@`
3. Commands work: try `/overview`
4. Skills load: the agent should be able to load skills on demand


## Troubleshooting

| Issue | Solution |
|-------|---------|
| Plugin errors on startup | Run `npm install --prefix ~/.config/opencode` to ensure `@opencode-ai/plugin` is installed |
| `deploy.sh` refuses to link | Back up existing files: `mv ~/.config/opencode/agents/orchestrator.md ~/.config/opencode/agents/orchestrator.md.bak` |
| Agent not appearing | Restart OpenCode — agent prompt changes require a session restart |
| Commands not recognized | Verify symlink: `ls -la ~/.config/opencode/commands/` should show the symlink |

## Uninstall

To remove all deployed symlinks:

```bash
./scripts/undeploy.sh
```

This reads the deployment record (`~/.config/opencode/.opencode-copilot-deployed`) to remove exactly what was deployed. It never deletes real files.

## File Structure Reference

```
opencode-copilot/
├── dist/                    # Source of truth (symlinked to ~/.config/opencode/)
│   ├── agents/              # 4 agent definitions
│   ├── skills/              # 4 skill definitions
│   ├── commands/            # 3 commands (/init, /overview, /order)
│   └── plugins/             # Compaction plugin
├── profiles/
│   ├── lite.txt             # Default profile (core items)
│   └── full.txt             # Full profile (core + extras)
├── scripts/
│   ├── deploy.sh            # Creates per-item symlinks (--profile flag)
│   └── undeploy.sh          # Removes deployed symlinks via record
├── AGENTS.md                # Project architecture overview
├── TASKS.md                 # Work tracking
├── INSTRUCTIONS.md          # This file
└── opencode.json            # Project-level OpenCode config
```
