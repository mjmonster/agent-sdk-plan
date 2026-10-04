# 03 — GitHub-Backed Approval Records and Recovery

## 1. Physical layout is replaceable

A logical workspace stores repository identity and path bindings in a trusted registry. Agents use IDs and service APIs rather than synthesizing repository names or arbitrary paths.

```text
private delivery repository

main — accepted artifact/policy baseline
  governance/
    approval-policy.yaml
    roles.yaml
  workspaces/WS-DEMO-001/
    workspace.yaml
    artifacts/BRD.md
    artifacts/technical-spec.md
    requirements/snapshots/
    decisions/DEC-DEMO-017.md
    work-items/

control — trusted operational records; do not merge wholesale into main
  registry/workspace-bindings/
  workspaces/WS-DEMO-001/
    approval-requests/
    events/
    state/projection.json
    integrations/jira-mapping.json
    integrations/outbox/

feature/ws-demo-001/... — proposed artifact changes, reviewed through PRs
```

`main` is the accepted document/policy baseline. `control` contains operational facts, including requests that are still pending. A pending request being durably stored is not business approval. The control branch is a separate writer lane, not a second approval system or an access-isolated data store.

Keep working-memory checkpoints in the existing scratch repository or configured scratch binding. Store pending approval IDs, task references, unresolved questions, observable actions, and concise rationale summaries. Do not store hidden chain-of-thought. Scratch state cannot grant permission or override accepted artifacts.

## 2. Avoid the self-invalidating approval-record commit

Do not append the human's approval record to the artifact PR head after review and then assume the review still applies. That changes the reviewed revision. Persist normalized evidence on the control branch and retain exact references to the reviewed artifact head. After merge, add a new event naming the resulting accepted baseline.

Provider review objects are evidence sources. Git-stored request/event records support rebuilding the platform state and preserve the subject and policy context. A current-state file is a disposable projection, not the only authority.

## 3. Minimal event contract

Every trusted event needs a schema version, event ID, tenant/workspace ID, aggregate/request ID, trusted receive time, source event ID where present, event type, causation/correlation references, and relevant payload digest. Human-action events additionally distinguish actor from recorder. For untrusted incoming events, verification and scope checks precede authoritative admission.

Useful event types include request opened, review recorded, review dismissed, decision evaluation changed, authorization issued/consumed, PR merged, baseline accepted, transition applied, operation outcome recorded, request superseded/revoked, and external synchronization completed/failed.

Use append-only logical behavior: corrections are new events, not edits to earlier evidence. Git history and branch protection do not constitute an immutable regulatory archive against repository administrators; do not make legal-compliance or absolute tamper-proof claims for this design.

## 4. Writer and concurrency model

Use one trusted serialized writer per control repository for the MVP. Multiple agent processes submit bounded operations to it, rather than writing shared status files directly. Restart recovery must not rely on an in-memory queue alone.

An update reads the current control head, computes new files and a commit whose parent is that head, then attempts a non-forced reference update. A concurrent sibling update should fail; reread and re-evaluate before retrying. GitHub's reference API supports non-forced updates with fast-forward validation. It is not a general multi-repository transaction or a database compare-and-swap API. [G6](REFERENCES.md#g6-git-reference-updates)

Use stable event IDs and a tenant-qualified external-object registry. On replay, identical IDs and payloads are no-ops; an ID with differing payload is an integrity error, not a last-write-wins update.

Where an operation must atomically record a state transition plus an outbound Jira intent, write both in the same control-branch commit. This provides atomicity for those Git records only. It does not atomically commit Jira and GitHub together.

## 5. Recovery protocol

On resume, resolve the authorized workspace binding, read durable requests/events and the latest accepted baseline, then reconcile current PR/review state and relevant Jira requirement snapshots. Rebuild the projection and perform only still-authorized operations.

| Failure point | Recovery |
| --- | --- |
| Approval arrives but evidence commit fails | Do not report durable platform approval. Re-fetch provider evidence and retry admission. |
| PR merges but baseline event is missing | Verify the actual merged PR and exact content, then append the missing event idempotently. |
| State/outbox commit succeeds but Jira call has not happened | Retry the persisted intent after rechecking current preconditions. |
| Jira issue creation succeeds but response is lost | Search/reconcile using the persisted operation marker; do not blindly recreate. |
| Jira status moves manually without a valid gate | Record drift; block governed agent operations; do not fabricate approval. |
| GitHub cannot persist an approval/action authorization | Fail closed for the governed effect. Drafting can continue only with an honest durability status. |
| External action's result cannot be established | Keep outcome unknown and escalate rather than double-execute. |

The initial GitHub-only design assumes relatively low event volume. Consolidate non-critical observations where appropriate, but persist governance-critical intent before claiming it is durable. A storage outage does not become lossless merely because a retry loop exists; document which upstream providers can replay evidence and which cannot.

## 6. Security and policy bootstrap

A trusted administrator must bootstrap repository bindings, approved policies, role mappings, and branch controls. The proposal being evaluated cannot select arbitrary permissive policy. A policy update follows the existing policy's authorization path.

Keep credentials outside Git records and outside model-visible content. Runtime authorization verifies tenant, repository, path, work-item scope, artifact references, and tool parameters. Agents cannot use a user-provided repository name to broaden their read/write scope.

The control writer needs carefully limited operational write permissions; delivery agents must not inherit that credential. Protected main/control policies differ: human artifact review on main, narrow trusted event persistence on control, no uncontrolled history rewriting. Review bypass privileges rather than assuming branch names imply safety.

## 7. Relation to the dreaming repository

Workspace truth, scratch checkpoints, and improvement evidence have different semantics. An RSI observation about approval friction does not authorize weakening a gate. A Dreaming Agent can propose a reviewed SDK improvement, not rewrite a client's accepted business policy. Preserve source workspace provenance separately from improvement target routing and enforce client data isolation.
