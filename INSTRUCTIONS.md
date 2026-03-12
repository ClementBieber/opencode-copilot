# Deployment Instructions

This file exists because the project is published/external-facing.

Canonical publication and operator guidance lives in:

- `dist/skills/publication/SKILL.md`
- `dist/skills/publication/docs/deployment-guide.md`
- `dist/skills/publication/docs/published-project-docs.md`

Quick start:

```bash
git clone https://github.com/ClementBieber/opencode-copilot opencode-copilot
cd opencode-copilot
./scripts/deploy.sh
```

This deploys the canonical OpenCode Copilot config, creating symlinks from `dist/` into `~/.config/opencode/`, including `dist/opencode.json` as the global base config.

Use `./scripts/deploy.sh --verbose` if you want the per-item link report.

If you need installation, troubleshooting, verification, or uninstall details, use the canonical publication docs above.
