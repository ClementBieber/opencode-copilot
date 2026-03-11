---
description: Analyze and reorganize project files when the root directory gets cluttered
agent: orchestrator
---

Analyze the current project root directory structure and determine if reorganization is needed.

## Steps

1. List all files at the project root (excluding directories)
2. Count the files. If fewer than 15, report "Project root is well-organized (N files)" and stop.
3. If 15 or more files at root:
   a. Analyze file types and purposes
   b. Identify logical groupings (docs, config, tracking, etc.)
   c. Propose a reorganization plan showing:
      - Current files and their purposes
      - Proposed folder structure
      - Which files move where
      - What cross-references need updating
   d. Present the proposal and wait for user approval
   e. If approved, execute the reorganization:
      - Create new directories
      - Move files
      - Update any internal file references
      - Verify all references still work
   f. Report what was done

## Rules

- Never move .git/, dist/, scripts/, src/, archive/, node_modules/, or logs/ directories
- Never move `dist/opencode.json` or `.gitignore`
- Always ask for approval before moving files
- Update any markdown cross-references after moving files
- Provide a clear before/after summary
