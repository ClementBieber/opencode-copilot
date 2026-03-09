---
description: Compose or append a structured MAIL.md for another project so work can be handed off there.
agent: orchestrator
---

Create or read `MAIL.md` files so cross-project handoffs stay structured and easy to act on.

## Usage

```text
/mail read             - summarize the current project's MAIL.md
/mail <target> <topic> - compose or append a structured mail for another project
```

## Process

1. Parse the user's request to determine the operation.
2. If the request is `read`, go to the Read Flow.
3. Otherwise, go to the Write Flow.

## Read Flow

1. Read the current project's `MAIL.md` only.
2. If `MAIL.md` does not exist, reply that no mail was found in the current project.
3. Load the `mailing` skill for mail-reading conventions and summary format.
4. Delegate to the `specialist` subagent to read and summarize the file.
5. Return a concise summary covering:
   - how many mail entries were found
   - each entry's title, date, status, and source context
   - the main requested work or proposal
   - any open questions called out in the mail
6. Keep the result summary-only. Do not edit `MAIL.md` during read flow.

## Write Flow

1. Determine the target project path and the topic of the mail from the user's request.
2. If either is still materially unclear after checking the current context, ask exactly one focused question.
3. Inspect the target project enough to confirm it is the intended destination:
   - list the root
   - read `AGENTS.md` if present
   - read existing `MAIL.md` if present
4. Load the `mailing` skill for formatting, safety, and append rules.
5. When the handoff spans multiple projects, environments, or operational workflows, use the `task` tool with the `system` subagent to synthesize the mail draft from the current conversation and relevant project context.
6. Write `<target-project>/MAIL.md`:
   - if the file does not exist, create it
   - if the file exists, append a new dated entry unless the user explicitly asks to overwrite
7. Keep the message self-contained so the receiving project can understand it without the original conversation.
8. Never include secrets, tokens, credentials, or private values. Summarize sensitive areas instead.
9. Confirm what was written and where.

## Expected Content

Structure the mail so it is easy to act on:

- title and status
- source and target context
- background and current state
- proposal or implementation plan
- safety notes or constraints
- open questions or decisions needed
