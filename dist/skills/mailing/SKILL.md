---
name: mailing
description: Cross-project MAIL.md conventions for drafting, appending, and safely handing off implementation context.
---

# Mailing Conventions

Use `MAIL.md` as a lightweight cross-project handoff document when work in one project needs to be investigated or implemented in another.

## Goals

- preserve important context outside the current chat session
- give the receiving project a self-contained explanation
- separate durable project handoffs from transient chat messages

## Default Behavior

When a user asks to "mail" something to another project:

1. identify the source project and target project
2. inspect the target project before writing, especially `AGENTS.md` and any existing `MAIL.md`
3. draft a self-contained message with enough context for the receiving project to act independently
4. append to `MAIL.md` by default if it already exists
5. overwrite only when the user explicitly asks

## File Format

Use a clear markdown structure like this:

```markdown
# Mail: <Topic>

- From: `<source project path>`
- To: `<target project path>`
- Date: YYYY-MM-DD
- Status: draft

## Background
- ...

## Current State
- ...

## Proposal
- ...

## Implementation Plan
- ...

## Open Questions
- ...
```

For appended entries, insert a separator and create a new top-level mail section so each handoff remains readable.

## Reading Mail

- treat each top-level `# Mail: <Topic>` heading as a distinct mail entry
- when multiple entries exist, summarize the newest-looking entry first when the order is obvious from the file
- if a field is missing, say it is unspecified instead of guessing
- keep read behavior summary-only unless the user explicitly asks to update mail state

When summarizing a `MAIL.md`, extract these fields when present:

- title
- from
- to
- date
- status
- background/current-state summary
- main proposal or requested work
- open questions

Use a compact inbox-style summary that helps the receiver decide what to act on next.

## Content Rules

- write for a reader who does not have the original chat context
- explain why the handoff exists, not just what to do
- include concrete paths, scripts, or files only when operationally useful
- capture tradeoffs, assumptions, and unresolved questions
- keep action items specific enough to implement later

## Safety Rules

- never write API keys, tokens, passwords, private credentials, or recovery material into `MAIL.md`
- avoid copying large generated files or logs into the mail
- if the target project is not yet onboarded, note assumptions clearly instead of inventing structure
- preserve existing `MAIL.md` content unless the user asks to replace it

## Recommended Workflow

- inspect the target project first
- use a system-oriented planning pass when the handoff spans environments, tooling, or multiple repositories
- write the mail
- tell the user exactly which file was created or updated
