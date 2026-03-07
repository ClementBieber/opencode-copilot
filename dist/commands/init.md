---
description: Initialize or update a project for use with OpenCode agents. Interactive onboarding that creates a lean AGENTS.md.
agent: orchestrator
---

Onboard the current project directory for use with OpenCode's agent system. This is an interactive guided experience.

## Process

Use the `question` tool at each step to guide the user interactively.

### Step 1: Discover

Before asking anything, silently analyze the project:
- List the root directory to understand structure
- Read README.md, package.json, Cargo.toml, pyproject.toml, or any project manifest if present
- Check if AGENTS.md already exists (update flow vs. create flow)
- Check if TASKS.md already exists
- Identify the tech stack, language, and framework from files present

### Step 2: Confirm Understanding

Present your analysis to the user via the `question` tool:
- "I found a [language/framework] project with [key characteristics]. Is this accurate?"
- Let the user correct or add context

### Step 3: Gather Project Context

Ask the user (via `question` tool) about:
1. **Project purpose** — What does this project do? (1 sentence)
2. **Key areas** — What are the main components or domains? (e.g., "API, database, frontend")
3. **Current priorities** — What are you working on right now?
4. **Special considerations** — Any constraints, conventions, or things the agents should know?

### Step 4: Generate AGENTS.md

Create a **lean** AGENTS.md (target: 15-25 lines max). It should contain:

```markdown
# [Project Name]

[1-sentence description of what the project does]

## Structure
[2-5 bullet points: key directories/files and what they contain]

## Context
[2-3 bullet points: tech stack, conventions, constraints]

## Current Focus
[1-2 bullet points from user's priorities]
```

Rules for AGENTS.md:
- **Maximum 25 lines** — this is loaded on every agent interaction, so brevity is critical
- No redundant info — don't repeat what's obvious from file structure
- No agent instructions — agents already know how to behave (that's in their prompts)
- Focus on what an agent NEEDS TO KNOW to work effectively in this project

### Step 5: Optionally Create TASKS.md

If the user mentioned priorities, offer to create a TASKS.md:

```markdown
# Tasks

## In Progress
- [priority items from the conversation]

## Backlog
- [other items mentioned]
```

### Step 6: Confirm

Show the user what was created and ask if adjustments are needed.

## Update Flow

If AGENTS.md already exists:
- Read the current content
- Ask what has changed (new components, shifted priorities, etc.)
- Update surgically — don't rewrite from scratch unless requested
- Keep it under 25 lines
