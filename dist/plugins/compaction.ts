import fs from "fs/promises"
import path from "path"
import crypto from "crypto"
import type { Plugin } from "@opencode-ai/plugin"

// Excerpt policy defaults
const EXCERPT_MAX_CHARS = 800
const EXCERPT_MAX_LINES = 50

// Development files to include in session manifest
// Only include files that track active project state, not publication files
const CANONICAL_FILES = ["AGENTS.md", "TASKS.md"]

interface PointerEntry {
  path: string
  pointer: string
  sha256: string
  size_bytes: number
  line_count: number
  excerpt_range: string
  excerpt: string
  note: string
}

async function buildPointerEntry(
  filePath: string,
  projectRoot: string
): Promise<PointerEntry | null> {
  try {
    const content = await fs.readFile(filePath, "utf8")
    const stats = await fs.stat(filePath)
    const lines = content.split(/\r?\n/)
    const sha256 = crypto.createHash("sha256").update(content, "utf8").digest("hex")
    const relPath = path.relative(projectRoot, filePath) || path.basename(filePath)

    const isSmall = content.length <= EXCERPT_MAX_CHARS && lines.length <= EXCERPT_MAX_LINES

    let excerpt: string
    let excerptRange: string
    let note: string

    if (isSmall) {
      excerpt = content
      excerptRange = "full"
      note = "full"
    } else {
      const excerptLines = lines.slice(0, EXCERPT_MAX_LINES)
      excerpt = excerptLines.join("\n").slice(0, EXCERPT_MAX_CHARS)
      excerptRange = `lines:1-${Math.min(EXCERPT_MAX_LINES, lines.length)}`
      note = "excerpt_truncated"
    }

    return {
      path: relPath,
      pointer: `file://${filePath}`,
      sha256,
      size_bytes: stats.size,
      line_count: lines.length,
      excerpt_range: excerptRange,
      excerpt,
      note,
    }
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

async function findFile(filename: string, dirs: string[]): Promise<string | null> {
  for (const dir of dirs) {
    const filePath = path.join(dir, filename)
    try {
      await fs.access(filePath)
      return filePath
    } catch {
      continue
    }
  }
  return null
}

export const CompactionPlugin: Plugin = async (ctx) => {
  return {
    "experimental.session.compacting": async (input, output) => {
      const dir = ctx.directory
      const worktree = ctx.worktree
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

      // Build pointer entries for canonical files
      const entries: PointerEntry[] = []
      for (const filename of CANONICAL_FILES) {
        const filePath = await findFile(filename, searchDirs)
        if (filePath) {
          const entry = await buildPointerEntry(filePath, projectRoot)
          if (entry) entries.push(entry)
        }
      }

      // Session manifest (YAML-like readable format)
      if (entries.length > 0) {
        const manifestLines = [
          "## Session Manifest",
          "",
          `version: 1`,
          `project_root: ${projectRoot}`,
          `timestamp: ${new Date().toISOString()}`,
          `excerpt_policy: { max_chars: ${EXCERPT_MAX_CHARS}, max_lines: ${EXCERPT_MAX_LINES} }`,
          "",
          "files:",
        ]
        for (const entry of entries) {
          manifestLines.push(
            `  - path: ${entry.path}`,
            `    sha256: ${entry.sha256}`,
            `    size: ${entry.size_bytes}b, ${entry.line_count} lines`,
            `    excerpt: ${entry.excerpt_range} (${entry.note})`,
          )
        }
        sections.push(manifestLines.join("\n"))
      }

      // File excerpts (human-readable)
      for (const entry of entries) {
        sections.push(
          `## ${entry.path}\n` +
          `_Pointer: ${entry.pointer} | sha256: ${entry.sha256.slice(0, 12)}... | ${entry.excerpt_range}_\n\n` +
          entry.excerpt
        )
      }

      // Git context
      const git = await getGitContext(ctx.$, projectRoot)
      if (git) {
        sections.push(`## Git\n${git}`)
      }

      // Recovery instructions (pointer-aware)
      sections.push(`## Post-Compaction Recovery

Use the manifest and excerpts above to resume work. Fetch full files via pointer paths when needed. Validate via SHA-256 hash. Delegate heavy work to subagents.`)

      output.context.push(sections.join("\n\n"))
    },
  }
}
