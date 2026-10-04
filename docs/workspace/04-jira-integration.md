# 04 — Jira Integration Without Competing Truth

## 1. Adopt the client's work system

Recommended direction: integrate with Jira rather than replacing the client's backlog, issue assignment, and delivery-board practices. Workspaces remain portable logical cases that can attach to existing client work items. Jira does not need a new project for each workspace, and a workspace does not need a new GitHub repository for each Jira issue.

Two modes are supported by the proposed architecture. In GitHub-only mode, the platform persists its own work-item metadata in Git. In Jira-connected mode, Jira owns designated delivery fields and GitHub retains accepted baselines, approval evidence, policy, and durable integration state. The second mode adds an external system of record but does not require another platform-managed database.

The vendor examples below use **Jira Cloud**. Client hosting/version, authentication, issue types, custom fields, permissions, board filters, and workflows have not been inspected. Jira Data Center requires a separately verified adapter; do not assume Cloud API contracts apply unchanged.

## 2. Decide ownership field by field

| Data | Authoritative writable source in the proposed Jira mode | Other representation |
| --- | --- | --- |
| Live story description/acceptance criteria | Jira, until a snapshot is proposed for baseline review | Versioned approved snapshot in GitHub |
| Priority, assignee, sprint, delivery status | Jira | Observed metadata/checkpoints, not competing editable masters |
| BRD and technical-spec accepted revisions | GitHub | Jira link and review/progress display |
| Approved requirement baseline | GitHub snapshot plus its source references and digest | Live Jira content may later diverge |
| Policies, human approval evidence, gate applicability | GitHub-backed Approval Service records | Jira display/link only |
| Agent execution checkpoints and authorization consumption | GitHub-backed trusted controller | Resume/sync indicators |
| Provider mappings, incoming event IDs, outbound intents | GitHub control records | Integration's reconstructible cache |

This separates live working content from an accepted historical baseline, rather than insisting that either Jira or GitHub owns every fact. A client preferring Git-authored requirements can choose a different declared ownership policy, but must not allow both systems to silently overwrite the same authoritative fields.

For a baseline, snapshot only the covered fields in a documented canonical format, preserving the source instance, issue ID/key, fetch time, field names, and digest. When Jira acceptance criteria change afterward, identify drift and open a proposed successor/reapproval path. Do not erase the old baseline or silently update Git to match the newest text. Changes to out-of-scope planning metadata should not stale an unrelated content approval.

## 3. Work-item lifecycle

Start with an existing Jira epic/change/story, or create a draft work item in the client's existing project when authorized. Resolve or create the logical workspace and link it. Requirements work can generate draft stories early; backlog visibility is not a claim of approved requirements.

After a reviewed baseline is accepted, synchronize references and, when configured and permitted, perform the corresponding delivery transition. Later decomposition can create additional stories referencing the approved requirement revision. The client chooses workflow mappings; do not hard-code a universal 'Approved' or 'Ready for Development' status.

Jira Cloud provides issue creation and explicit transition operations. The creation fields depend on project/type metadata; discover valid transitions rather than trying to change status as an ordinary field edit. [J1](REFERENCES.md#j1-jira-issues)

## 4. Backlog is not an approval state

Keep `create_work_item`, `transition_work_item`, and `move_to_backlog` as different adapter operations. Jira Software Cloud's backlog endpoint can remove future/active sprint membership; moving items on a board without sprints has different board-specific behavior. Backlog visibility also depends on board configuration, including its filter. A successful backlog API call is not evidence of business approval. [J2](REFERENCES.md#j2-jira-backlog), [J3](REFERENCES.md#j3-scrum-backlog)

The platform should not remove active sprint assignments merely to reflect that an approval became stale. Raise an explicit delivery-state reconciliation event; let the configured workflow and authorized planner determine scheduling changes.

## 5. Identity and traceability

Store local workspace/work-item IDs alongside provider instance ID, provider issue ID, and display key. Resolve provider IDs from the API, never infer them from a label. Track issue moves and hierarchy changes as mapping updates. A tenant-scoped external ID maps to one active primary workspace; secondary references/dependencies can point elsewhere without creating another owner.

Jira supports remote issue links to external records and can update an existing link using a supplied `globalId`. Use stable workspace/baseline link identifiers instead of appending a new duplicate link on every retry. [J4](REFERENCES.md#j4-jira-remote-links)

These links aid navigation. They are not approval evidence, do not confer GitHub access, and should not expose restricted filenames or content to users outside the source access boundary.

## 6. Human approval interface versus evidence store

GitHub-native review is a straightforward first evidence adapter when required approvers can use GitHub. A later client-facing approval interface may be inside the agent platform or an integrated Jira UI. This architecture does not assume that every Jira edition already exposes a suitable native approval feature.

An approval from another interface needs an authenticated deliberate action showing the exact reviewed subject/digest and consequence. The service verifies identity, required role, current authority, request freshness, and scope, then persists the normalized record in GitHub. Record the human actor and the service recorder separately; do not forge a human's GitHub review using a bot account.

A Jira 'Done' or 'Approved' label, a generic comment, assignment, or webhook about status is not enough. Native GitHub required-review rules are not satisfied automatically by a JSON file describing a Jira approval. Choose and test an enforcement design: retain native reviews, or use a deliberately configured trusted service check and merge coordinator for external human evidence. Do not silently bypass existing repository controls.

## 7. Preventing Jira bypass

There are two separate control promises. The SDK/controller can refuse a governed agent action without approval regardless of Jira's visible status. Preventing a human from making a particular Jira workflow transition requires customer-side workflow enforcement with the capabilities available in that deployment.

Do not claim the latter is enforced until it is configured and tested. Without it, detect and report manual status drift and keep the agent-side gate closed. Synchronizing a label after the fact is not preventative authorization.

If clients edit Jira requirements concurrently, freeze an explicit review snapshot and recheck the live covered fields before baselining or consuming authorization. Where strict prevention of review/edit races is required, the client workflow must restrict covered edits during the review/application window. GitHub and Jira do not offer a single cross-system transaction here.

## 8. Durable synchronization

Use a Git-backed outbox: first record an outbound operation with its idempotency/correlation key and preconditions, then call Jira, then persist the provider result. Reconcile an ambiguous response before retrying a non-idempotent operation. A failed Jira update leaves synchronization pending; it does not reverse a valid GitHub approval or falsely report successful synchronization.

Jira Cloud documents webhook retries and a tenant-unique identifier stable across those retries. Deduplicate using instance plus event ID, verify the request using the configured integration's supported authentication method, and reread current source state when ordering/freshness matters. [J5](REFERENCES.md#j5-jira-webhooks)

In Git-only durable mode, acknowledge an incoming governance-relevant event as accepted only after persistence, or rely on a verified replayable upstream source with an explicit recovery contract. A webhook failure cannot be hidden behind an in-memory queue. Periodic/on-demand reconciliation repairs missed or reordered signals but is not proof of exactly-once delivery.

For issue creation, persist a unique operation marker and include it in supported issue metadata/properties so reconciliation can find the result. Jira create-issue must not be treated as providing exactly-once behavior merely because the local outbox has a key. After an ambiguous timeout, wait/reconcile or escalate rather than create again immediately.

Avoid two-way loops: know which fields each side owns, store origin/causation IDs, and compare the intended patch to current provider state. Discard stale pending transitions when their approval or preconditions are no longer valid.

## 9. Minimum adapter interface

```text
WorkTrackerAdapter
  get_work_item(provider_ref)
  get_create_metadata(project_ref, issue_type_ref)
  create_work_item(draft, operation_id)
  get_available_transitions(provider_ref)
  transition_work_item(provider_ref, transition_id, preconditions)
  move_to_backlog(provider_ref, board_ref, preconditions)
  upsert_external_link(provider_ref, global_id, link)
  read_requirement_snapshot(provider_ref, covered_fields)
  reconcile_outbound_operation(operation_id)
```

These are proposed SDK interfaces, not working API implementations. A method must validate tenant scope and authorization; some clients may expose only read/link operations initially. Do not grant broad Jira administrative scope merely to make onboarding simpler.
