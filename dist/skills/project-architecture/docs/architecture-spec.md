# General Project Architecture Spec

Status: draft  
Scope: repository architecture only  
Priority: authoritative design reference

## 1. Purpose

This document defines strict architecture rules for projects that follow this multi-agent, skill-based design.

Goals:
- maximize context efficiency
- eliminate duplicated instructions
- provide reusable design rules for project organization

## 2. Core Principles

### 2.1 Unicity

Every instruction, rule, or workflow must live in exactly one canonical place.

- agent prompts own behavior
- skills own knowledge
- skill docs own deep reference material
- commands own invocation shortcuts
- plugins own runtime behavior
- AGENTS.md owns general project structure and project-specific overview
- TASKS.md owns active work tracking

If content appears in more than one place, architecture is wrong.

### 2.2 Context Minimization

Always-loaded context must stay small.

- prompts should be short
- skill metadata should be lightweight
- full skill instructions load on demand
- deep docs/examples/scripts load only when needed

### 2.3 Delegation First

The primary model should orchestrate, not perform most heavy work.

- Orchestrator delegates aggressively
- Manager coordinates multi-step work
- Specialist executes focused work
- System handles environment/infrastructure work

## 3. Canonical Ownership

### 3.1 `dist/agents/*.md`

Own:
- role
- behavior
- delegation boundaries
- allowed tools
- loop/interaction contract

Must not own:
- domain workflows
- reusable reference knowledge
- repeated protocol text shared by multiple agents

### 3.2 `dist/skills/<skill>/SKILL.md`

Own:
- capability description
- operational guidance
- protocol rules used across contexts
- invocation/usage guidance
- concise, actionable instructions

### 3.3 `dist/skills/<skill>/docs/*`

Own:
- long-form standards
- examples
- templates
- advanced references
- migration plans

### 3.4 `dist/commands/*.md`

Own only:
- trigger phrase
- intent
- parameters
- which skill/agent the command routes to

Commands must not duplicate workflows.

### 3.5 `dist/plugins/*`

Own:
- runtime hooks
- context injection logic
- session behavior

Plugins must not become knowledge stores.

### 3.6 Root files

`AGENTS.md`
- general project overview, structure, and project-specific context

`README.md`
- public entry point only

`INSTRUCTIONS.md`
- contributor/operator guidance only, and only for published projects

`TASKS.md`
- active work tracking only

## 4. Skill System Standard

### 4.1 Skill structure

Each skill should follow this pattern:

```text
dist/skills/<skill>/
├── SKILL.md
├── docs/
├── scripts/        # optional
├── assets/         # optional
└── tests/          # optional
```

### 4.2 Loading model

Three levels of disclosure:

1. metadata / name / description
2. `SKILL.md`
3. `docs/`, `scripts/`, `assets/`

Only load the deepest level required.

`SKILL.md` should stay as lean as possible. If content is exploratory, optional, or only relevant in a deeper branch of the skill tree, move it into `docs/` or a sub-skill instead of bloating the parent `SKILL.md`.

### 4.3 Shared behavior rule

If the same instructions are needed in more than one prompt, they must become a skill.

Example:
- delegation/blocked-state behavior belongs in `delegation-protocol`
- not in three separate agent prompts

### 4.4 Registry direction

The long-term target is:
- a thin central skill registry/index
- agents reference skill ids only
- skill details live only inside the target skill

Avoid large parent skills that are always loaded.

## 5. Agent Prompt Rules

All agent prompts must follow these rules:

1. short and behavioral
2. no repeated shared standards
3. no embedded skill catalogs beyond minimal routing references
4. no long examples unless unique to that agent
5. reference shared skills for shared behavior

Prompt duplication across agents is a design bug.

Agent-specific behavior standards belong in the corresponding agent prompt, not in this architecture skill.

## 6. Review Rules

Every architecture change should be reviewed against these questions:

1. is anything duplicated?
2. does this increase always-loaded context?
3. could this be a skill instead of prompt text?
4. could this be a command instead of a new agent?
5. could this be repo-level instead of system-level?
6. does it preserve Orchestrator loop behavior?
7. does it preserve delegation clarity?

If any answer is poor, redesign before merging.

## 7. Duplication Tracking

Duplicated information should be tracked explicitly whenever discovered.

Track at least:
- source file
- duplicate file
- canonical owner
- proposed destination
- cleanup status

Duplication tracking should live in a dedicated cleanup or governance document, not in `TASKS.md`. Duplicates should never remain invisible.

## 8. Immediate Remediation Targets

Current priorities:

1. shrink root architecture docs
2. reduce agent-local skill descriptions
3. introduce thin skill registry/index
4. normalize research-related prompt/skill boundaries
5. track and remove discovered duplication systematically

## 9. Non-Negotiable Rules

- no duplicated instructions across agent prompts
- no prompt-owned domain knowledge
- no new tool without an architecture placement decision
- no system mutation without an integration rationale

## 10. Decision Heuristics

Use this test:

- repeated across agents? → skill
- deep domain knowledge? → skill/docs
- runtime hook? → plugin
- user shortcut? → command
- role/behavior policy? → agent prompt
- general project structure/context? → AGENTS.md
- active task tracking? → TASKS.md

That is the default architectural sorting rule.
