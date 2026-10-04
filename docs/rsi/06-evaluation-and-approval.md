# 06 — Evaluation, Human Approval, and Release

## Keep three approval types separate

**Artifact approval** accepts business/project truth such as a BRD. **Runtime
authorization** permits a specific sensitive action. **Improvement approval**
authorizes a reviewed change to future agent behavior. None implies the others.
A high evaluation score does not approve a BRD or waive workspace access rules.

## Evaluation contract

Each candidate revision names a fixed baseline commit, candidate head commit,
kit/model configuration, evaluation-set revision, evaluator revision, scenarios,
repetitions, metrics, budget, and mandatory invariants. Capture results for both
versions under comparable conditions. Predeclare acceptance thresholds rather
than choosing them after seeing the result.

Start with a compact representative suite. Use repeated paired runs for
stochastic behavior where practical. Report uncertainty and raw failures, not
only one favorable aggregate. No universal score threshold is prescribed by
these documents; calibrate it to task variability, cost, and consequence.

| Check | Required evidence |
| --- | --- |
| Targeted effect | Improvement on the failure class that motivated the proposal |
| Negative cases | Cases where the new behavior must not activate |
| Regressions | Existing expected behaviors still work |
| Cross-agent compatibility | Relevant consumers of a shared-kit change still work |
| Mandatory invariants | Approvals, data isolation, permissions, and artifact integrity remain intact |
| Efficiency | Tokens, elapsed time, tool calls, and failure/retry cost |
| Maintainability | Scope, complexity, dependency changes, and a feasible rollback |

For redundant clarification, test already-confirmed information, missing
information, contradictory records, stale information needing reconfirmation,
and restricted information in another workspace. Asking fewer questions is not
itself success if necessary clarification is suppressed.

## Independence and evaluation leakage

The candidate may add tests for its hypothesis. Required checks and evaluator
criteria are separately maintained and must not be weakened by the same change.
Use an isolated runner without production or writer credentials. Record network
access, fixtures, and non-deterministic dependencies where they affect results.

Distinguish development cases repeatedly used for iteration from an assessment
set used to check transfer. Once detailed assessment failures inform the next
candidate, those cases are development evidence for that loop. Do not continue
calling them untouched holdout evidence. Restrict access to protected assessment
fixtures to the evaluator when that separation is required.

Evaluate cost of discovering an improvement separately from cost of using the
improved agent. An economical runtime change may still have an unjustifiably
expensive search process. Set a run budget and preserve no-improvement outcomes.

## PR evidence package

Use [the PR template](templates/improvement-pr.md). Include source observations,
contradictions, target-owner rationale, candidate ID/revision, exact base/head
commits, test/evaluator versions, results, regression evidence, cost changes,
known uncertainty, affected consumers, rollout steps, and rollback details.

Evidence belongs to the exact evaluated diff and base. If either materially
changes, rerun the required checks; a prior PR comment is not a permanent pass.
A user saying "good idea" in conversation is not a repository review.

## Enforced promotion controls

Require appropriate human reviews and trusted status checks on target branches.
Invalidate stale approval or require review of the latest relevant push, and
ensure the automation cannot bypass protections. GitHub documents required PR
reviews, stale-review handling, status checks, and bypass behavior
[S6](REFERENCES.md#s6-protected-branches). Verify the available rules for the
actual repository's plan and organization configuration before deployment.

The model receives no merge or administrative tool. Repository credentials and
branch protection enforce the boundary even when model output is adversarial.
The Dreaming Agent must not edit evaluator policy, approval rules, registry
permissions, or workflow credentials through the ordinary improvement path.
A legitimate change to those controls requires a separate authorized review.

## Release and adoption

After merge, create or identify a versioned release through the normal release
process. Record the accepted code revision, skill/prompt versions, compatibility
expectations, and migration instructions. Pin consumers to an explicit resolved
kit version rather than assuming a shared repository edit updates all agents.

Track each consumer: previous version, approved new version, deployment or
initialization reference, adoption time, and verification outcome. A generated
copy installed at initialization will not be treated as upgraded merely because
the central template changed. Long-running sessions should keep a consistent
version unless an explicit safe migration policy says otherwise.

Initial adoption can be limited to a controlled consumer or project before a
broader rollout. Expanding adoption requires its own evidence and authorization
where the change-management policy requires it.

## Rollback and post-adoption evidence

Define the previous known-good version and restoration steps before release.
A reverted kit commit is not proof that every consumer has rolled back; track
actual deployed versions and pending migrations. Preserve incident references
and revert reasons. New adverse evidence can trigger a review or rollback
request, but the agent does not gain permission to deploy autonomously.

Do not label a proposal "successful" merely because a human approved or merged
it. Track measured outcome and evidence limitations separately from governance
status. Mandatory approval and security safeguards remain out of scope for
performance-driven deletion.
