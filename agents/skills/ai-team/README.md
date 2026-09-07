# AI team

An accountable-lead workflow for complex goals that benefit from sub-agents.
The lead uses expensive reasoning capacity where it changes the quality of the
outcome and assigns bounded work to cheaper capable models where it does not.

## What this skill guarantees

- One model remains accountable for the goal from decomposition through final
  acceptance.
- Every delegation has a responsibility, handoff contract, acceptance criteria,
  and model-selection rationale.
- Newest-version selection is enforced within each model family.
- Parallel execution is reserved for independent work that is all required,
  not speculative alternatives.
- Sub-agent outputs are reviewed as evidence rather than accepted blindly.
- The final report explains routing, review, validation, and material
  cost/latency tradeoffs.

## When to use it

Use `ai-team` when a goal has multiple responsibilities, meaningful technical
judgment, or enough context that deliberate delegation can improve quality or
lead time. Do not use it for a small task that the lead can complete and verify
directly; delegation overhead would dominate.

Typical responsibilities include repository exploration, standards research,
mechanical migrations, focused implementation, test execution, security review,
and independent correctness review. Keep goal interpretation, cross-task
consistency, conflict resolution, and final integration with the lead unless
there is a deliberate reason to delegate them.

## How routing works

The lead evaluates each responsibility by judgment load, context load,
verification load, and independence. High-judgment or hard-to-verify work goes
to the strongest suitable model. Bounded exploration, transformations, and
validation go to a cheaper capable model. Different model families may be used
together, but superseded versions within the same family are not used when the
newest version is available.

The lead runs required independent responsibilities concurrently only when doing
so reduces wall-clock time without creating speculative waste. A result can be
accepted, corrected by the lead, independently reviewed, or rejected and redone.
The choice is part of the lead's accountability.

## Expected final report

The lead should return the result, limitations, task-to-agent assignments,
model-routing rationale, treatment of each sub-agent result, validation status,
and material cost or latency tradeoffs. Once the work is complete, the lead may
save verified, non-sensitive model-performance guidance to AI Memory for future
routing decisions. It should not store secrets, source code, personal data, or
claims unsupported by this session.
