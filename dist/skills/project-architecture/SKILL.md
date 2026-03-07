---
name: project-architecture
description: "General project organization guidelines for agent-assisted development: minimal project files, documentation practices, context efficiency, and information hygiene."
license: MIT
compatibility: ">=1.0.0"
---

# Project Architecture Skill

Guidelines for organizing any software project so that AI agents can work on it effectively. These principles apply regardless of project type — web apps, APIs, libraries, CLI tools, or agent systems.

## Core Principle: Unicity

Every piece of information exists in exactly one place. If the same content appears in multiple files, the architecture is wrong.

- Each concept has one canonical location
- Other files reference it, never duplicate it
- When information needs updating, there is exactly one place to change

## Project Files

Only keep files that serve a distinct, non-redundant purpose.

### Development files (track active project state)

| File | Purpose | When to create |
|------|---------|----------------|
| `AGENTS.md` | Project context for AI agents: what the project is, how it's structured, key areas, constraints | Always — created by `/init` |
| `TASKS.md` | Active work items, backlog, completed work | When tracking multi-step or multi-session work |

### Publication files (describe the project to external users)

| File | Purpose | When to create |
|------|---------|----------------|
| `README.md` | Public-facing project description and quick start | Standard for all repos |
| `INSTRUCTIONS.md` | Contributor/operator instructions | Only for published projects |

### What NOT to put in these files

- **AGENTS.md** should describe the *project*, not the *agent system*. No agent definitions, no model assignments, no tool configurations. Agents already know how to behave — they need to understand the project.
- **TASKS.md** is for work tracking only. No architecture rules, no governance policies, no design decisions.

## AGENTS.md Guidelines

A good AGENTS.md answers these questions for an agent:
1. What is this project? (one line)
2. What's the structure? (key directories and their purposes)
3. What are the current focus areas or constraints?
4. What should I know before making changes?

Keep it under 25 lines. See the `/init` command for the standard template.

## Context Efficiency

Agents have limited context windows. Help them by:

- **Keeping docs scannable** — use headers, tables, and short paragraphs
- **Avoiding redundancy** — if something is in code comments, don't repeat it in docs
- **Preferring structured formats** — tables over prose, lists over paragraphs
- **Loading details on demand** — keep top-level docs lean, put deep content in subdirectories

## General File Organization

Organize project files so agents can discover and navigate them:

- Group related code by feature or domain, not by file type
- Keep test files near the code they test (or in a parallel structure)
- Use standard ecosystem conventions (package.json, pyproject.toml, Cargo.toml, etc.)
- Document non-obvious directory purposes in AGENTS.md

## Duplication Tracking

When duplicated information is discovered across project files:

1. Identify the canonical owner
2. Track the duplication explicitly
3. Consolidate during the next relevant change

See `docs/duplication-audit.md` for a tracking template.

## Detailed Standards

For the full architecture guidelines, see `docs/architecture-spec.md`.
