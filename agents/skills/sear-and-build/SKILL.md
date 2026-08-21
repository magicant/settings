---
name: sear-and-build
description: Settle a design by interviewing the user only about the decisions they alone can make, then implement speculatively while they review the rest, and hand back a map from each decision to the diff that realizes it. Use when the user wants a change designed and built with the shortest possible time to a reviewable implementation.
argument-hint: The change we want to design and implement.
---

The goal is **lead time**: the shortest wall-clock path from here to an implementation the user can review. The user's reading and deliberating time is the critical path — measured at 90% of a comparable interview session — so every rule below exists to take work off it, not to be thorough for its own sake.

This is a sibling of `grill-me`. That workflow interviews the user about every decision; this one interviews them about the few decisions that are actually theirs, and implements the rest while they read.

## Phase 1 — explore before asking

Enumerate every open decision behind the change, and do **all** environment exploration up front, before the first question. The user should never be waiting on a tool call. Keep the decision list explicit and revise it after every answer; a deep branch is exactly where a forgotten decision hides.

Then sort each decision along two axes, in order.

**Axis 1 — where the answer comes from.**

- **Derivable**: you can justify the answer using only facts inside the repository, the relevant standard (POSIX, an RFC, a spec), or an established convention in this codebase. **Do not ask.** Decide it.
- **Intent-dependent**: the justification requires knowing what the user wants — their priorities, their plans for future work, their editorial voice, their sense of scope. Continue to axis 2.
- If you find yourself genuinely unsure which recommendation is right, treat the decision as intent-dependent regardless of axis 1.

**Axis 2 — what changes if the decision is reversed.** Applies only to intent-dependent decisions.

- **Shape**: reversing it changes types, enum structure, function signatures, module boundaries, public API, or **the scope of what gets written**. **Ask.**
- **Content**: reversing it changes only prose, error message wording, test case coverage, comments, or commit splitting. **Do not ask.** Decide it.
- When the call is unclear, treat it as shape and ask. The user can always reply "that's content — don't ask, just implement it", and you take that as a standing correction for similar decisions in this session.

Recurring process preferences — whether to commit, how to split commits, which checks to run — are not design decisions. They belong in whatever long-lived instruction or memory file this environment already provides. Act on what is recorded there; if nothing is, note the preference for the final list rather than spending a question on it.

## Phase 2 — ask only the shape-changing, intent-dependent questions

One question at a time, waiting for each answer.

**Before each question, state the outlook**: which decisions remain open and how many questions you still expect. The user schedules their day around this.

**Never graft.** Do not build a question around a derivable decision and then append the real question at the end as "related, cheap" or "agreed?". The derivable part is not a question at all — it goes in the phase 3 list. Start the question at the intent-dependent point itself and give one or two sentences of context, no more.

**Offer concrete options and a recommendation**, with the reasoning for the recommendation in a line or two. State the cost of the recommendation honestly where there is one.

**Show the evidence at the right grain.** If the decision turns on a small, self-contained fact, quote the code or prose inline — a link makes the user leave the conversation to see it. If it turns on something broad — a ten-line design, several interacting types, a dependency web — quote nothing and give a link instead, because an excerpt would be misleading and the user will want to navigate the real thing.

## Phase 3 — the settled-decisions list, then build

When no shape-changing intent question remains, post **one** list of everything you decided without asking, and **immediately begin implementing**. Do not wait for approval. The user reads the list while the build runs; that overlap is the point.

Each entry gets:

1. The decision, in a sentence.
2. Its classification — *derivable* or *content* — so the user can catch a misclassification.
3. **The single strongest alternative, in one sentence.** Never omit this. Without an alternative the user has to construct one themselves before they can judge, which costs more than reading the one you supply.

Order the list by **how likely the user is to object**, most contentious first, so an objection arrives as early as possible. Do not reorder the implementation to match — dependencies govern that.

The list doubles as the design record. No separate hand-off document is needed; design and implementation live in one session so the context carries over intact.

If the user objects to an entry mid-build, rework what that entry touched. No special containment machinery: by construction the list holds only derivable decisions and content-level ones, so the exposure is small, and the branch itself is the safety net.

## Phase 4 — hand back a map, not a diff

When the implementation is done, present a **decision-to-diff map**: each decision you made without asking, paired with where it landed — file, section, rough size. The user then checks decisions one by one instead of reading the whole diff to find them.

**Never cite a line number from memory.** Any number you noted while editing is stale: every later insertion or deletion above it shifts it, and those shifts accumulate silently across a multi-file build. A map full of off-by-a-few links costs the user exactly the navigation time the map was supposed to save.

So resolve every location **after the last edit**, from the file as it now stands:

- Run `git diff` (or `git diff --stat` plus the hunks) once at the end and read the locations off the **new-file** side of the hunk headers — the `+` number in `@@ -old,n +new,m @@`. That is the authoritative post-edit numbering.
- Or, for a specific anchor, grep the finished file for a unique string from the change and use the line number the grep reports.
- Verify before writing each link, not once for the batch. Re-running the same file's numbers is cheap; a wrong link is not.

**Prefer anchors that cannot drift.** Name the function, type, heading, or test case, and attach the line number as a convenience: "the `--strict` branch in `parse_args` (`src/cli.rs:212`)". If the name and the number ever disagree, the name still lands the user in the right place. Give a line range only when the change genuinely spans one, and take both ends from the same final read.

Keep the decision review separate from correctness review. Present the map; let the user choose how to verify the code itself.
