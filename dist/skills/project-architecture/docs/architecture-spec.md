# General Project Architecture Spec

Status: v2
Scope: project organization for agent-assisted development
Priority: authoritative design reference

## 1. Purpose

This document defines architecture rules for organizing any software project so AI agents can work on it effectively. It is tool-agnostic and project-type-agnostic.

## 2. Core Principles

### 2.1 Unicity

Every instruction, rule, or piece of knowledge must live in exactly one canonical place.

Canonical locations:
- Project documentation owns project context (AGENTS.md, README.md)
- Work tracking owns task state (TASKS.md)
- Code owns implementation details
- Config files own configuration
- Test files own test specifications

If content appears in more than one place, architecture is wrong. Fix by choosing one canonical owner and having others reference it.

### 2.2 Context Minimization

Always-loaded context must stay small:
- Project documentation should be scannable, not exhaustive
- Deep reference material should be discoverable, not preloaded
- Prefer structured formats (tables, lists) over long prose

### 2.3 Discoverability

Agents need to find things quickly:
- Use standard ecosystem conventions for project structure
- Name files and directories clearly
- Document non-obvious structures in AGENTS.md
- Keep directory depth shallow where possible

## 3. Project Files Ownership

### 3.1 AGENTS.md

Owns:
- What the project is (one-line summary)
- Project structure (key directories and their purposes)
- Architecture decisions and constraints
- Current focus areas
- Technology stack highlights

Must NOT own:
- Agent system configuration (models, tools, permissions)
- Work tracking (that's TASKS.md)
- Public-facing documentation (that's README.md)
- Contributor/operator instructions (that's INSTRUCTIONS.md)

Target: ≤30 lines. If it grows beyond this, content probably belongs elsewhere.

### 3.2 TASKS.md

Owns:
- Active work items
- Backlog
- Completed items (for context)

Must NOT own:
- Architecture rules or governance policies
- Design decisions (those belong in AGENTS.md or dedicated docs)
- Duplication tracking (use a dedicated audit doc)

### 3.3 README.md

Owns:
- Public-facing project description
- Quick start / installation
- Usage examples
- Links to further documentation

Must NOT own:
- Internal development context (that's AGENTS.md)
- Work tracking (that's TASKS.md)

### 3.4 INSTRUCTIONS.md

Owns (only for published projects):
- Installation/deployment procedures
- Contributor guidelines
- Operator instructions

Should not exist for private/internal projects unless needed.

## 4. Information Hygiene

### 4.1 Shared knowledge rule

If the same information is needed in multiple places, extract it into one canonical location and reference it from others.

### 4.2 Duplication tracking

When duplicated information is discovered:
1. Identify the canonical owner
2. Record it in a tracking document
3. Consolidate during the next relevant change
4. Verify the duplicate is fully removed

Track at least:
- Source file and duplicate file
- Canonical owner
- Cleanup status

### 4.3 Review heuristic

Every documentation change should be reviewed against:
1. Is anything duplicated across files?
2. Does this increase the amount of always-loaded context?
3. Is this in the right canonical location?
4. Could this reference an existing doc instead of restating?

## 5. Project Structure Conventions

### 5.1 General patterns

- Group by feature/domain, not by file type (when the ecosystem allows it)
- Keep tests near the code they test, or in a parallel directory structure
- Use the ecosystem's standard tooling and configuration files

### 5.2 Documentation structure

For projects with significant documentation:
```
docs/
├── architecture.md     # System design decisions
├── api.md              # API documentation
├── deployment.md       # Deployment procedures
└── ...
```

Keep top-level docs lean. Deep content goes in subdirectories.

## 6. Decision Heuristics

When deciding where something belongs:

| Question | Answer |
|----------|--------|
| Is it project context for agents? | → AGENTS.md |
| Is it active work? | → TASKS.md |
| Is it public-facing? | → README.md |
| Is it for contributors/operators? | → INSTRUCTIONS.md |
| Is it deep reference material? | → docs/ subdirectory |
| Is it implementation detail? | → code + comments |
| Is it configuration? | → appropriate config file |

This is the default architectural sorting rule for project information.
