# 02 — One Shared Approval Service in the SDK

## 1. Mechanism, policy, and records

Implement shared approval contracts and deterministic policy evaluation in `sdlc-dev-kit`. Run authority-bearing evaluation, evidence verification, and protected operations in the trusted platform runtime. Agent-facing SDK methods are clients of that boundary; importing a library does not make a caller trusted.

This is a logical service, not a requirement to create a new microservice. A modular component in the existing platform process is sufficient initially, provided the model cannot bypass it or access its privileged credentials.

Accepted policies and role/delegation records live in the governing repository. Workspace approval requests and events live in the workspace's GitHub storage binding. Policies governing all agents belong to the shared kit's governance scope, not an arbitrarily selected client workspace.

## 2. Two gate types, reusable machinery

| Gate type | Question | Typical effect |
| --- | --- | --- |
| `lifecycle` | May this reviewed artifact/milestone become an accepted baseline or enable the next stage? | Permit a named merge/baseline/transition after all prerequisites |
| `decision_action` | May we accept this decision/material/exception or perform this bounded action? | Unblock a specified decision, work item, or protected operation |

Use `decision`, `material`, `exception`, and `action` as subtypes, not separate unrelated approval systems. A stage association is optional for a decision/action gate. Avoid the label 'uncategorized' as the only classification: the record needs a precise subject and authorized consequence.

A lifecycle gate may depend on decision gates. Scope exclusions can require a business decision before final BRD baselining. The accepted exclusion is then reflected in the BRD revision under review. Do not let BRD approval silently approve unresolved exceptions. Do not stop unrelated work for a local decision.

One explicit confirmation may satisfy multiple named requirements only when the policy, subject set, and authorization support it. Reuse evidence intentionally; do not request duplicate clicks or infer expanded authority.

## 3. Approval subjects and evidence

Each request binds to an exact subject bundle: tenant/workspace, artifact or decision IDs, source repository, paths, reviewed commit, content digest, relevant dependency baselines, and applicable policy revision. A multi-document review needs an explicit bundle manifest. Action subjects additionally bind operation, parameters, destination/environment, expiration, and intended use count where applicable.

Record both the immutable policy snapshot used for historical interpretation and any mandatory current controls checked before execution. An old approval is not a mechanism to bypass an emergency policy revocation.

Record each human decision as its own event. Preserve approver identity, identity provider, verified role/delegation evidence, review source/reference, decision time, subject digest, and the service identity that recorded the event. Separate author, approver, recorder, merger, and executor. A bot committing an approval record is the recorder, not the approving human.

GitHub's review API exposes reviewer information, review state, submission time, and reviewed commit ID. The adapter can retain those provider facts and a normalized evidence digest. [G4](REFERENCES.md#g4-pull-request-reviews)

A model-authored `approved_by`, ordinary comment, issue assignment, or conversational 'looks good' is not sufficient evidence. Authenticated conversation approval is possible only through an explicit confirmation bound to the shown request and revision, with authority checked independently.

## 4. Roles and authorization

A BRD may require a business owner; a technical specification a technical owner; a consequential exception both. Configure these requirements per subject and scope. Enforce distinct people or separation of duties when required. An unknown role remains blocking.

Listing multiple CODEOWNERS for one pattern does not require every listed owner to approve; one owner's approval can satisfy that ownership condition. Enforce 'business AND technical' and other role quorum rules in the approval evaluator. [G3](REFERENCES.md#g3-code-owners)

The agent maintainer cannot approve a client's business requirement merely because they own the SDK. The proposing agent cannot waive its own checks. A policy change must be approved through the existing trusted policy process, not under a looser policy introduced in the same proposal.

## 5. Keep states orthogonal

Do not compress everything into `approved: true`.

- **Request:** open, withdrawn, superseded, or expired.
- **Decision evaluation:** pending, satisfied, rejected, revoked, or stale, with reasons and evidence references.
- **Artifact application:** draft, PR open, merged, or failed.
- **Execution:** not authorized, authorized, started, succeeded, failed, or outcome unknown.
- **External synchronization:** not needed, pending, synchronized, or failed.

These are proposed state axes, not existing SDK enums. A request can have satisfied decisions while waiting for merge; an accepted Git baseline can have pending Jira synchronization; an authorized action can fail execution. Current projections are derived from durable events and verified external state.

## 6. Lifecycle flow

```text
Draft artifacts and explicit dependency bundle
  -> proposed branch and PR
  -> approval request bound to reviewed revision
  -> authenticated human review
  -> deterministic evaluation of roles, freshness, dependencies, and checks
  -> merge authorization for that exact PR head
  -> verified merge result and accepted artifact baseline
  -> persisted workflow transition
  -> optional Jira projection through durable outbox
```

Create the proposal before asking for approval so the human can inspect a fixed version. Recheck immediately before applying the consequence. A PR approval is not proof of merge, and a merged PR is not by itself proof that required business approvals were satisfied.

GitHub's merge endpoint accepts an expected `sha`; use it to reject an unexpected PR head rather than applying authorization to newly changed content. This alone does not validate external requirement freshness, policy dependencies, or every base-branch race. [G5](REFERENCES.md#g5-pull-request-merge)

## 7. Invalidation and material changes

A changed subject or relevant dependency requires revalidation. Conservative v1 behavior is to require fresh approval on any covered-content change. Do not ask an LLM to waive reapproval based on 'probably insignificant.' Metadata fields explicitly outside the approved subject, such as backlog ranking, need not invalidate the requirement baseline.

Preserve the old approval as a historical fact while marking its applicability stale. For an already merged baseline, a new requirement revision creates a proposed successor; it does not erase the accepted historical version. Block dependent work when policy requires the newer revision to be reviewed.

Configure stale-review handling and trusted status checks on protected artifact branches. GitHub documents these controls, expected-app check sources, and administrator bypass behavior. Verify actual plan and permissions; the service must not claim protection that was never enabled. [G2](REFERENCES.md#g2-protected-branches)

A passing check can itself become stale when an off-commit dependency changes. Where automatic merge is enabled, the trusted merge coordinator must verify live dependencies, update/reject stale check results, and control authorized merge paths. For v1, do not enable an independent auto-merge path that outruns these checks.

## 8. Decision/action lifecycle

Draft the decision or action intent, show consequences and alternatives, request authorization, and enforce it at the operation boundary. An action request must name exactly what is permitted, such as sending a specified document to a specified recipient. It is not blanket permission to send future documents.

Consume single-use authorization through a serialized durable record before execution and use provider-supported idempotency where available. Following a crash, reconcile the external outcome before retrying. For a non-idempotent external operation whose outcome cannot be queried, record `outcome_unknown` and require reconciliation; Git-only state cannot guarantee exactly-once effects in another service.

Do not conflate delivery-artifact approval, runtime action authorization, or improvement PR approval. The same SDK primitives may serve all three, but their scopes, policies, evidence, and effects remain distinct.
