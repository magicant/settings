# Grill and build

A sibling of [grill-me](../grill-me/), aimed at lead time rather than exhaustiveness.

Where `grill-me` interviews the user about every open decision, this workflow asks only about
decisions the user alone can settle, decides the rest itself, and starts implementing while
the user reviews the decisions it made.

The rules come from measuring a real `grill-me` session (yash-rs, the `portable` option for
the `kill` built-in, 2026-08-11):

- 101 minutes total: 91 minutes of user time, 9.8 minutes of agent time.
- 15 questions asked; the agent's recommended option was accepted 15 out of 15 times.
- 7 of those questions produced no change at all — 28 minutes spent to reply "(A)".
- In 5 of the 8 questions that did change something, the value came from a sub-question
  grafted onto the end of a question about something else.
- The user opened files in the editor before answering 5 times, costing 42 minutes; no
  question had quoted the code it was pointing at.

Use `grill-me` when the point is to stress-test thinking exhaustively.
Use this when the point is to get to a reviewable implementation quickly.

## Portability

This workflow is meant to be usable by any coding agent, not one vendor's. The prose avoids
naming a specific assistant or a specific instruction file. Only the YAML front matter in
`SKILL.md` is host-specific — adjust or drop those keys when porting to another agent's
prompt-file format.
