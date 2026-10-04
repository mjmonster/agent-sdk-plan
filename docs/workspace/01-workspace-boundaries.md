# 01 — Workspace Boundaries Without a Business-Domain Reorganization

## 1. Replace the one-workspace-one-repository assumption

The earlier recommendation to allocate a repository to every independently governed project was too strong as a platform default. It conflated delivery identity, business categorization, and physical persistence. Separate them.

| Concept | Meaning in this design | Example |
| --- | --- | --- |
| Tenant/access boundary | Who is allowed to see the information | A particular client and authorized delivery group |
| Business category | Optional knowledge/discovery label | Payments, time deposits, bonds, mutual funds, brokerage |
| Delivery group | Optional portfolio/project/engagement grouping | Payments modernization |
| Workspace | A durable case for a coherent piece of delivery work | Add payment-status notifications |
| Work item | A story, task, defect, or sub-deliverable inside a case | Notification requirements or integration tests |
| Repository binding | Where the workspace's artifacts and control records are persisted | A private client delivery repository |
| Implementation repository | Code affected by the change | API service and notification worker |

Do not require the AI-platform builder to identify all functional owners or perform domain-driven decomposition before users can create a case. Familiar Investments categories could organize reusable knowledge, but they are not automatically suitable finite delivery workspaces.

A single change can involve several business categories, systems, and approval roles. Conversely, one business category can contain many unrelated changes. This is a reason to use many-valued labels and explicit dependencies rather than a fixed domain folder tree.

## 2. Default workspace definition

A workspace is a stable identifier plus the scope, artifacts, decisions, work items, approval dependencies, and resumable context needed to complete a coherent delivery case. It spans the relevant SDLC activities; it is not one workspace per agent or conversation.

Use an existing client change request or epic when it is the delivery envelope. An independent story can be the envelope when no larger common baseline is being managed. Child tasks and stories inherit the enclosing workspace by default. An ongoing giant epic is not automatically one suitable workspace; identify independently accepted increments when useful.

The platform should support a group containing several workspaces without requiring a parent workspace to carry every artifact or gate. Keep delivery hierarchy and approval dependencies explicit rather than forcing a universal business hierarchy.

## 3. Resolution and creation rules

Resolve workspace identity in trusted code, before loading cross-agent context.

1. An explicit, authorized `workspace_id` wins.
2. Otherwise look up an existing mapping for the referenced external work item.
3. Otherwise apply the tenant's configured parent/anchor rule and reuse the mapped change request or epic, if applicable.
4. Create a new workspace only when the item is an independent delivery case, or create a provisional intake case when the envelope is not yet known.
5. When there are conflicting mappings or uncertain access, do not let the model guess a workspace or copy material across boundaries. Route to scoped triage.

Use a stable local workspace ID, plus provider instance and provider object ID for external references. Keep a human-readable Jira key as a display alias. Persist the mapping before returning creation success. Serialize or use optimistic conflict detection to prevent two agents opening the same case concurrently from creating two authoritative workspaces.

A provisional intake case permits drafting and questions. It must not become a broad shared inbox containing data from unrelated clients. It cannot authorize protected actions while ownership is unresolved.

## 4. A practical client-facing interaction

Instead of asking the client to divide the Payments domain into repositories, ask:

> Which existing request, epic, or story is this work for? Is this part of the same deliverable, or a separate change?

The ordinary screen can require only an authorized client/access group, work-item reference or short change title, and a sponsor or triage contact. Domain tags are optional. The repository is selected by trusted configuration, not generated from the user's wording.

For example, fictional epic `PAY-120` describes a payment-status notification change. The Requirements Agent, Design Agent, and Verification Agent all resolve `WS-DEMO-001`; child stories reuse it. A separate reconciliation-report change gets another case even if both are labeled Payments. One case can link several implementation repositories.

The examples are illustrative; they do not assert anything about the user's actual Payments organization.

## 5. When to split or retain a workspace

Keep related work together when it shares an evolving baseline and is reviewed as one deliverable. Multiple approvers or code repositories alone do not force a split; approval subjects can have different policies within the same workspace.

Split logically when increments can be independently accepted or closed, have substantially independent artifacts and schedules, or would otherwise cause unrelated work to share approval invalidation. Keep explicit dependency links between the resulting cases.

A required confidentiality or access separation is different: it can force both a logical and a physical split. Shared upstream artifacts should be referenced with authorized immutable baselines rather than copied into every case. Broader scope does not automatically confer access.

On a later split, merge, or repository migration, retain existing IDs and provenance. Record successor/predecessor relationships, reassignment of active work, and updated storage bindings. Do not silently rewrite historical approvals or copy an old approval onto a new subject.

## 6. Repository allocation

Recommended initial policy: one private delivery-storage repository per client/access boundary, containing many workspace directories. A customer with distinct restricted groups may need several repositories. Separate client organizations are not placed together merely to minimize repository count.

```text
client-a-delivery repository
  main:
    governance/
    workspaces/
      WS-DEMO-001/
      WS-DEMO-002/
  control:
    registry/
    workspaces/
      WS-DEMO-001/
      WS-DEMO-002/
```

GitHub's documented repository roles grant repository access, including the ability to pull content. A folder or branch is therefore not a separate read-security boundary for someone with repository access; use repository/access separation where necessary. CODEOWNERS routes ownership/review; it does not grant per-directory secrecy. [G1](REFERENCES.md#g1-repository-access), [G3](REFERENCES.md#g3-code-owners)

A dedicated repository per workspace remains a supported deployment option when access, independent governance, retention policy, scale, or a client's established practices justify it. It is not the workspace identity model.

## 7. Ownership without pretending the platform owns Payments

The platform builder owns workspace mechanics, policy evaluation, integration, and SDK behavior. Client-authorized business and technical owners approve their corresponding material. Repository administration or authorship of the agent does not confer domain approval authority.

The client must supply an initial sponsor or triage authority and approve delegation rules. The agent can identify a missing owner and suggest a candidate, but cannot authorize that candidate. Model unknown authority explicitly as `owner_resolution_required`: allow draft work, block baselining and protected operations. There is no safe automatic solution to missing real-world accountability.
