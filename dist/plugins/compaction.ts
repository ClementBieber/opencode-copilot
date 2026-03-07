import fs from "fs/promises"
import path from "path"
import type { Plugin } from "@opencode-ai/plugin"

async function readFileIfExists(filePath: string, maxLen = 4000): Promise<string | null> {
  try {
    const content = await fs.readFile(filePath, "utf8")
    return content.length > maxLen ? content.slice(0, maxLen) + "\n...(truncated)" : content
  } catch {
    return null
  }
}

async function getGitContext($: any, dir: string): Promise<string | null> {
  try {
    const [branch, status, log] = await Promise.all([
      $`git -C ${dir} branch --show-current`.text().catch(() => "unknown"),
      $`git -C ${dir} status --porcelain`.text().catch(() => ""),
      $`git -C ${dir} log --oneline -5`.text().catch(() => ""),
    ])
    const parts = [`Branch: ${branch.trim()}`]
    const statusTrimmed = status.trim()
    parts.push(statusTrimmed ? `Status:\n${statusTrimmed}` : "Status: clean")
    const logTrimmed = log.trim()
    if (logTrimmed) parts.push(`Recent commits:\n${logTrimmed}`)
    return parts.join("\n")
  } catch {
    return null
  }
}

async function readFromDirs(filename: string, dirs: string[]): Promise<string | null> {
  for (const dir of dirs) {
    const content = await readFileIfExists(path.join(dir, filename))
    if (content) return content
  }
  return null
}

export const CompactionPlugin: Plugin = async (ctx) => {
  return {
    "experimental.session.compacting": async (input, output) => {
      const dir = ctx.directory
      const worktree = ctx.worktree
      // Determine search directories:
      // - If dir is a subdirectory of worktree: check dir first, then worktree root
      // - If dir equals worktree: just check dir
      // - If dir is unrelated/parent of worktree: use only worktree
      const dirIsSubOfWorktree = dir !== worktree && dir.startsWith(worktree + "/")
      const projectRoot = worktree || dir
      const searchDirs = dirIsSubOfWorktree ? [dir, worktree] : [projectRoot]
      const sections: string[] = []

      // Project path
      sections.push(
        dirIsSubOfWorktree
          ? `Project: ${worktree} (working in: ${dir})`
          : `Project: ${projectRoot}`
      )

      // AGENTS.md — project overview (check dir first, then worktree)
      const agents = await readFromDirs("AGENTS.md", searchDirs)
      if (agents) {
        sections.push(`## AGENTS.md\n${agents}`)
      }

      // TASKS.md — current work state (check dir first, then worktree)
      const tasks = await readFromDirs("TASKS.md", searchDirs)
      if (tasks) {
        sections.push(`## TASKS.md\n${tasks}`)
      }

      // Git context (always use project root for git operations)
      const git = await getGitContext(ctx.$, projectRoot)
      if (git) {
        sections.push(`## Git\n${git}`)
      }

      // Recovery instructions
      sections.push(`## Post-Compaction Recovery

Resume work using the context above. Key principles:
- Delegate heavy work to subagents. Load skills on-demand only.
- Do NOT re-read AGENTS.md or TASKS.md — their contents are already above.
- Check recently modified files for active work context if needed.`)

      output.context.push(sections.join("\n\n"))
    },
  }
}
