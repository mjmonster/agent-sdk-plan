# 05 — The Dreaming Agent

## Mission

Turn authorized experience records into bounded, testable improvement proposals.
This is a separate agent in the `improvement` group. It reads evidence across
explicitly permitted repositories, while delivery agents remain focused on
project work. "Dreaming" is the product name; its technical responsibility is
evidence distillation and governed harness improvement.

Do not equate an impressive narrative with an effective change. A run may
correctly conclude that evidence is insufficient, the incident is transient,
the proposal is already implemented, or the material belongs in task knowledge
rather than agent behavior.

## Inputs and authority

A run receives an authorized evidence range, fixed registry/policy revision,
readable repository allowlist, writable target allowlist, evaluation budget,
and trigger identity. Initial runs are human-triggered. Read executable
configuration from protected revisions, never from captured evidence.

The agent may propose and revise candidates, inspect permitted code, prepare
bounded changes in isolated checkouts, request approved tests, and open or
update its own proposal PRs through trusted tools. It may not approve or merge,
change repository permissions, access another scope's evidence, weaken required
checks, or deploy a new version itself.

## Staged workflow

### 1. Select and normalize evidence

Load a bounded range of captures from a known data-branch snapshot. Validate
schemas and provenance, distinguish original incidents from re-extractions,
link later corrections, and preserve contrary evidence. Ignore ineligible
capture purposes and rejected ingress. Record exactly which records were used.

### 2. Distill a candidate

Describe the observed failure or scoped policy request, supporting and opposing
evidence, hypothesized mechanism, applicability, exclusions, expected benefit,
possible downside, and falsifiable evaluation plan. Separate root-cause
hypotheses from facts. A single severe incident can justify investigation; it
cannot establish broad effectiveness without testing.

Compare with existing skills, open PRs, accepted changes, and rejected proposals.
Merge genuinely duplicate ideas, but preserve independent source incidents.
Deletion or simplification is a legitimate candidate when redundant mechanisms
are evidenced; mandatory safety and approval controls are not pruning targets.

### 3. Resolve the behavior owner

Inspect implementation and consult the trusted registry. Route by where the
behavior is owned, not by where the incident appeared.

| Finding | Candidate destination |
| --- | --- |
| Requirements-specific elicitation technique | Requirements Agent repository |
| Shared context, checkpoint, or capture mechanism | `sdlc-dev-kit` |
| Verification Agent discovers an implementation defect | The repository owning that implementation |
| Project-only business decision or factual update | Governed workspace artifacts or scoped knowledge; not global agent code |
| Change to distillation itself | Dreaming repository, through separately authorized maintainer review |

A shared-kit proposal must explain affected consumers, shared assumptions,
compatibility risk, and cross-agent evaluation. Similar words across projects
are not proof of a shared abstraction. Unresolved ownership stops code-change
preparation; preserve the candidate as `needs_routing` rather than guessing.
The candidate schema represents unresolved routing as `target: null`; lifecycle
state is tracked separately.

### 4. Version and prepare one bounded change

Create an immutable candidate revision. Resolve the actual target base commit,
create an isolated checkout, and implement one clear behavioral hypothesis.
Record touched paths and ensure they fit the approved scope. Do not bundle
unrelated prompt, retrieval, retry, and security changes in one proposal.

When one logical change requires several files, explain why they form one
mechanism. When a shared-kit change requires consumer changes, use explicitly
linked PRs with compatibility and ordering constraints; v1 defaults to one
target repository per candidate revision, not an implied atomic cross-repo merge.

### 5. Evaluate and assemble a PR

Run the authorized baseline/candidate comparison and mandatory checks from
Document 06. Candidate-authored tests can add evidence but cannot replace the
trusted gate. Record failures and costs as well as successes.

Prepare the change branch in the target repository or an authorized fork.
The Dreaming Agent's working location does not make the unrelated dreaming
repository the PR head. GitHub PRs specify a head and a receiving base branch
[S5](REFERENCES.md#s5-github-pull-requests). Use a deterministic proposal branch
such as `rsi/CAND-0042-v1` and link the exact candidate revision.

### 6. Reconcile review and outcomes

Read authoritative PR/review state and record events. On requested changes,
create a new candidate revision when the hypothesis, scope, or implementation
plan materially changes; always record the new head SHA and rerun applicable
checks. Prior evidence for a different diff does not automatically validate it.

Record merge, release, each consumer's adopted version, and observed outcome
separately. A rejection is useful evidence with scope and reasons, not an
instruction to circumvent the reviewer. A closed unmerged PR remains unmerged.

## Candidate lifecycle

```text
proposed -> needs_routing OR ready_for_evaluation
ready_for_evaluation -> evaluation_failed OR ready_for_review
ready_for_review -> changes_requested OR rejected OR approved
approved -> merged -> released -> adopted [per consumer]
released/adopted -> superseded OR reverted [with references]
```

This is a logical workflow. Some steps may repeat and a draft PR may be opened
earlier for discussion, but it is not marked ready for promotion before the
required evidence exists. Approval and merge state are derived from GitHub,
not self-reported by the agent. "Adopted" is a per-consumer fact, not a universal
single flag for every agent using the kit.

## Recovery and idempotency

Persist candidate identity before preparing a change. Before opening a PR,
look for an existing proposal with the same target, candidate ID, revision, and
branch. An API timeout can occur after a successful PR creation; reconcile
before retrying. A run that fails after PR creation must not create a duplicate.

Use bounded runs with explicit stop reasons, consumed budget, evidence snapshot,
and next actionable state. Do not keep retrying indefinitely or widen scope to
manufacture progress. Shared branch concurrency must be serialized or resolved
with guarded compare-and-update behavior in the trusted adapter.
