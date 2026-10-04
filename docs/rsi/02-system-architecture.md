# 02 — System Architecture and Authority Boundaries

## Components

The proposed platform has three kinds of components, not one agent per stage.
Delivery agents do project work. `sdlc-dev-kit` supplies shared capabilities and
trusted runtime adapters. A separate Dreaming Agent manages improvement work.
The Dreaming Agent can use a deterministic staged workflow without spawning a
new autonomous agent for every stage.

| Component | Owns | Must not do |
| --- | --- | --- |
| Delivery agent | Requirements, design, code, or verification tasks | Install self-authored permanent improvements |
| Shared capture skill | Evidence extraction instructions and output contract | Approve a lesson or select an authoritative target |
| Trusted runtime hook | Eligibility, context assembly, invocation, metadata, retry policy | Treat model-authored identity as trusted |
| Trusted GitHub writer | Authorized branch/path writes and persistence receipts | Expose broad write credentials to the extractor |
| Dreaming Agent | Distillation, target proposal, change preparation, PR explanation | Approve or merge its own proposals |
| Evaluation runner | Execute trusted checks against fixed baseline and candidate revisions | Accept candidate-authored weakened checks as its authority |
| Human/release controls | Review, protected merge, release, and adoption authorization | Treat conversation agreement as an unrelated approval |

The writer and evaluation runner are software components, not necessarily
separate conversational agents. They can be implemented as toolkit services or
adapters. A separate database is not required.

## Conceptual data flow

```text
Delivery-agent task execution
    -> completed-response hook
    -> shared conversation-capture skill
    -> schema/reference checks and redaction
    -> trusted GitHub writer
    -> dreaming repository: evidence records

Human-triggered dreaming run (initial operating mode)
    -> authorized evidence selection and deduplication
    -> distilled candidate with hypothesis and scope
    -> target-owner resolution through repository registry
    -> bounded change on a target-repository branch
    -> baseline/candidate evaluation
    -> target-repository PR with evidence and checks
    -> human review and protected merge
    -> release + per-consumer adoption tracking
    -> observed outcome or rollback
```

Capture at every eligible response does not mean one observation, Git commit,
candidate, or PR per response. Empty results are valid. One distillation run can
consider many records and create no candidates.

## Three stores with different meanings

**Workspace truth:** approved BRDs, requirements, specifications, and other
accepted task artifacts. Pending branches/PRs remain work in progress and are
not promoted to truth merely because an agent produced them.

**Task working state:** checkpoints, unresolved questions, pending approvals,
references, and concise decision notes needed to resume a session. Store
observable actions and useful decision summaries, not hidden chain-of-thought.
A checkpoint never manufactures a missing approval.

**Improvement evidence:** redacted incidents, hypotheses, experiments, PR
references, rejection reasons, and adoption results. This is the dreaming
repository's responsibility. It must not become a backdoor source of business
truth or unrestricted cross-project memory.

These are logical boundaries; they do not force three new databases or a
particular physical repository layout.

## Operating modes

Capture is automatic. Recommended v1 distillation is human-triggered with an
explicit evidence range and budget. Candidate generation and testing can run
without repeated conversational confirmation within that authorization.
Promotion always requires the target repository's governed human review.

Future scheduled distillation is a separate configuration decision. It does
not authorize auto-merge, policy changes, broader repository access, or silent
updates to the Dreaming Agent itself.

## Authority and isolation

Trusted code stamps repository IDs, runtime versions, timestamps, event IDs,
workspace scope, and invocation purpose. The model cannot broaden access by
naming a different repository in its output. The registry verifies both read
scope and permitted target scope.

A skill file is not a permission boundary. Do not give the extraction model
GitHub credentials. Its output goes to a narrow `submit_capture` adapter whose
arguments are checked in code. Similarly, expose bounded branch/PR operations
to the Dreaming Agent rather than arbitrary administrative tools.

Evaluate candidate code in an isolated environment without writer tokens,
production secrets, or unauthorized network access. Adding a prompt that says
"do not access secrets" is not a substitute for removing the credentials.

## Non-recursion rule

Every model invocation carries a trusted `call_purpose`. In v1, only
`task_execution` in a delivery group is eligible. Exclude `capture`,
`distillation`, `evaluation`, and `replay`, and exclude the `improvement` group.
Do not automatically ingest extractor comments or the Dreaming Agent's own
self-assessments as fresh independent evidence.

A later learning-of-the-learner feature requires a separate approved policy and
evaluation path. It must not emerge accidentally from a universal LLM hook.

## Failure behavior

Use bounded budgets and explicit outcomes: captured, no observations, skipped,
failed, or awaiting retry. A failed extraction is not the same as an empty valid
result. Do not mark a checkpoint complete until the chosen persistence contract
has succeeded. See the GitHub-only durability limits in Document 04.

This design does not promise lossless capture during a storage outage without
an available durable event source. That tradeoff must be explicit in the first
implementation.
