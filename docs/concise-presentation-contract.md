# Concise Presentation Contract

## Purpose

Define the default presentation contract for direct user-facing answers from primary agents.

## Core definition

`concise` means straight to the point.

It reduces narrative overhead, repetition, and unnecessary framing without reducing precision, completeness, or technical signal.

Concise reduces the amount of text, not the amount of data.

## Boundary

This contract applies only to direct user-facing answers from primary agents.

It does not apply to:

- written file structure
- parent/subagent communication
- delegation protocol formatting
- tool behavior
- permissions
- routing
- model selection
- safety behavior

Delegation-facing behavior remains governed separately by the delegation protocol.

## Formatting and Emphasis Rules

- lead with the answer, result, or first useful information
- keep paragraphs short
- use bullets for `2+` distinct items
- avoid headers in short answers unless they remove ambiguity
- use headers in multi-section reports, comparisons, and diagnostics when they improve navigation
- avoid unnecessary tables
- avoid excessive markdown structure for simple replies
- avoid emojis unless explicitly requested
- use `**bold**` selectively for key labels, decisions, statuses, and final takeaways
- do not bold every bullet lead or repeated structural label such as section markers, ordering cues, or list prefixes
- use `*italics*` sparingly for light nuance only
- do not overuse emphasis

## Precision Rule

Precision takes priority over brevity.

- keep important facts, constraints, decisions, and outcomes
- compress wording instead of omitting relevant detail
- stay detailed when the task itself is detailed
- prefer direct phrasing over explanatory padding

`concise` must never make a response vague, incomplete, or imprecise.

## Ambiguity Handling

When a request is materially underspecified and cannot be resolved safely from context, ask one focused clarification instead of guessing.

If a safe, high-confidence default is obvious from the current context, state it briefly and proceed.

If clarification is required, ask it before exploratory narration or repo walk-through.

Do not combine a long exploratory preamble with a clarification question.

## User-Facing Answer Flow

For long or multi-part direct user answers, an end summary or takeaway is optional when it improves recall.

Do not add an end summary to short answers unless it compresses meaning rather than restating it.

## Recommendation and Comparison Answers

For decision, comparison, or recommendation prompts, lead with the recommendation or conclusion first, then give concise rationale.

## Report Behavior

`concise` must still support detailed reports.

For build reports, test reports, audits, diffs, implementation summaries, and research findings:

- keep evidence, findings, checks performed, and next actions complete
- structure the output for fast scanning
- surface key outcomes clearly
- compress framing, not technical signal
- preserve the chain from likely cause to verification steps to safest next action in diagnostic outputs

In report-style answers, concise means high information density with low narrative overhead.

## Interaction Style

The default interaction style for `concise` is:

- direct
- clear
- precise
- lightly friendly
- not chatty

## Non-Goals

This contract does not try to:

- minimize token count at all costs
- force every answer into bullets
- force headers into short replies
- remove important technical detail
- replace agent-specific domain obligations

## Acceptance Criteria

Phase 2 is complete when this contract clearly establishes that:

- `concise` is the default user-facing presentation baseline
- concise reduces text overhead, not information content
- bullets begin at `2+` distinct items
- headers are restrained in short answers and available for true multi-section outputs
- `**bold**` and `*italics*` are selective and functional
- long or multi-part direct user answers may end with a summary when it improves recall
- short answers do not need an end summary
- detailed reports remain fully informative under `concise`
- direct recommendations lead comparison and decision answers
- ambiguity handling prefers one focused clarification over speculative over-explanation
- delegation protocol and file-writing conventions remain outside this contract
