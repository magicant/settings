---
name: handoff
description: Create a hand-off document that captures the current session's research, considerations, decisions, and next steps so work can continue in a fresh context or with a different AI model. Use when the user asks to hand off, transfer, or continue the session elsewhere without losing context or repeating work.
argument-hint: Optional instructions for what the hand-off should emphasize or where to save it.
---

The user wants to continue this session from this point with a fresh context, possibly using a different AI model. Summarize and save the results of the research, considerations, and decisions made in this session into a hand-off document file. Include all necessary information to prevent subsequent sessions from repeating the same work or heading in a different direction. However, do not prescribe how the remaining work should be carried out. Record the remaining goal and any unfinished work, blockers, or unresolved decisions, and let subsequent sessions decide how to proceed.

Unless otherwise instructed, the hand-off document should be in Markdown format, named `HANDOFF-n.md`, where `n` is the next available natural number, and saved in the workspace root without staging or committing.
