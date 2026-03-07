# Active Tasks & Work Items

Last Updated: 2026-03-07

---

## Completed

- ✅ Migrate to OpenCode native config
  - ✅ Create 4-agent deployment (Orchestrator, Manager, Specialist, System)
  - ✅ Create project-architecture skill
  - ✅ Create /overview, /init, /order commands
- ✅ Implement Orchestrator loop using native `question` tool
- ✅ Context efficiency optimization
- ✅ Plugin enhancements — dynamic context injection (AGENTS.md, TASKS.md, git, project path)
- ✅ Anonymization review and git history cleanup for public release
- ✅ Rename project to OpenCode Copilot
- ✅ Clean export to ~/opencode-copilot/ (sole project folder)
- ✅ All dist/ files made fully project-agnostic
- ✅ Development skill rewritten as generic dev knowledge
- ✅ INSTRUCTIONS.md cleaned (no Python/yt-dlp, plugin version "latest")
- ✅ Orchestrator model changed to gpt-5.4
- ✅ Old ~/oc-system-project/ deleted
- ✅ Profile-based deployment system (lite/full profiles, deploy.sh, undeploy.sh)
- ✅ Pushed initial commit to GitHub (ClementBieber/opencode-copilot)
- ✅ Documentation updates for profile system (README.md, INSTRUCTIONS.md)
- ✅ Last30days extras created (research-synthesizer agent, last30days skill, /last30 command)
- ✅ Full profile deployed and verified (17/17 items)
- ✅ Researcher primary agent created with BCI domain knowledge, output templates, and enhanced archive system

## In Progress

- 🔄 Push commits to GitHub (5 commits ahead of remote, needs SSH)

## Backlog

- Import legacy session archives into OpenCode DB (optional)
- Formalize delegation protocol for parent/subagent contracts (inputs, outputs, blocked state, noise limits)
- Review the full OpenCode sessions system for project-specific and system-wide session handling; evaluate using sessions as the source of project context and history
- Analyze https://github.com/affaan-m/everything-claude-code as a potential source of reusable skills for this architecture
- Track and remove duplicated information across prompts, skills, docs, and root files with explicit canonical ownership
