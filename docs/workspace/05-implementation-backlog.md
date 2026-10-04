# 05 — Implementation Slices and Acceptance Scenarios

## Scope

Implement the smallest end-to-end path with a fictional test tenant first: resolve a case, draft a BRD, obtain real authenticated review of a fixed revision, persist evidence, merge through the trusted path, resume deterministically, and optionally update a mapped Jira work item. No production changes are made by this package.

## Slice A — Workspace registry and resolution

Add stable tenant/workspace/work-item IDs, external mappings, access-bound repository bindings, provisional intake state, and policy resolution. Attach child items to the intended delivery case by default. Preserve separate agent/run IDs for provenance, not workspace identity.

Acceptance: two agents resuming the same external anchor resolve one workspace; two separate changes in the same domain can have separate workspaces in one permitted repository; an unauthorized tenant cannot load another case; a split preserves historical lineage; missing owner permits drafting but blocks protected progress.

## Slice B — Approval core and evidence

Implement request subject bundles, lifecycle and decision/action kinds, policy snapshots, independent role validation, evidence ingestion, and derived applicability state. Keep the authority-bearing service in the trusted runtime even when the implementation belongs to the shared SDK.

Acceptance: unknown approver fails closed; a bot recorder is not counted as a human approver; the same person cannot satisfy a distinct-person requirement twice; a standalone scope decision can block the affected BRD without blocking unrelated work; model-generated approval text never satisfies a gate.

## Slice C — Git persistence and enforced application

Implement the main/control split, serialized writer, stable event IDs, expected-head merge, protected rules/checks, reconstruction, and authorization consumption. Bootstrap with an explicitly approved policy.

Acceptance: changed PR head invalidates earlier authorization; relevant dependency drift blocks application; an approved-but-unmerged artifact is not baselined; a merged-but-unrecorded artifact is reconciled; concurrent control updates do not lose events; policy changes cannot authorize themselves.

## Slice D — Jira attach/read/link integration

Configure one verified hosting/version adapter, tenant-specific field ownership, anchor rule, issue types, and workflow mappings. Import existing references and create baseline links. Store minimal snapshots rather than all client issue history.

Acceptance: an existing client issue does not create a duplicate workspace; link retries do not duplicate links; restricted Jira content is not exposed through a broadly readable GitHub repository; editing covered acceptance criteria produces drift while changing rank alone does not.

## Slice E — Jira write synchronization

Add authorized draft story creation, explicit delivery transitions, and explicit backlog operations through the outbox. Record each result independently from Git approval applicability.

Acceptance: a Jira outage leaves approval valid and synchronization pending; duplicate webhooks do not double-apply transitions; ambiguous issue creation is reconciled before retry; moving a status manually does not grant agent authorization; obsolete queued transitions are rejected; active sprint membership is not removed implicitly.

## Service contracts

```text
WorkspaceService.resolve_or_create(anchor, authenticated_context)
WorkspaceService.get_authorized_binding(workspace_id, authenticated_context)
ApprovalService.request(subject_bundle, effect, authenticated_context)
ApprovalService.ingest_verified_evidence(source_reference)
ApprovalService.evaluate(request_id, current_dependencies)
ApprovalService.authorize_effect(request_id, expected_revision, operation_id)
WorkflowService.apply_authorized_transition(authorization_reference)
EventStore.append(events, expected_control_head)
WorkTrackerAdapter.execute(outbox_operation)
Reconciler.rebuild(workspace_id)
```

Illustrative contracts only. `authenticated_context` is supplied by the platform, not by model-authored arguments. An agent can request an approval but cannot assert verification or inject the result of evaluation. Internal evidence/authorization methods are not exposed as arbitrary LLM tools.

## Definition of done

Each slice has automated positive, negative, access-isolation, freshness, and crash-recovery tests. Demonstrate actual GitHub controls and exact Jira workflow behavior in a test deployment. Preserve an audit trail from source request through baseline, approval, application, and synchronization.

A package of Markdown and YAML is not an implemented service. Passing syntax checks on the examples does not establish runtime authorization, provider compatibility, concurrency correctness, or production security.
