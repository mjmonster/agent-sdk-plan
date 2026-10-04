# SDLC Workspace and Approval Design

**Version:** 0.1.0 · **Prepared:** 2026-10-01 · **Target:** `C:\WORKSPACE\sdlc-agent`

## Decisions and recommendation status

The user confirmed one shared Approval Service in the SDK, separation of mechanism/policy/records, revision-bound human approval evidence, distinction between approval/merge/transition, deterministic enforcement, and recoverable GitHub-backed state. These are the confirmed design direction, not a claim that code has been implemented or a production policy has been approved.

The logical-workspace model, default repository grouping, and Jira integration described here are proposed refinements responding to the user's Payments-domain concerns. They replace the earlier blanket recommendation that each project workspace requires a new repository. They remain architecture recommendations for review.

**Central recommendation:** a workspace is an identifiable delivery case, not a business domain and not necessarily a repository. Use an existing change request, epic, or independently delivered story as an anchor. Store multiple logical workspaces in a repository only when they share the appropriate access boundary. Business categories are optional metadata and reference-knowledge scopes, not mandatory storage partitions.

**Integration recommendation:** use Jira for live delivery work; GitHub for versioned accepted baselines, approval evidence, policy, and durable agent-control records; the SDK/controller for enforcement. Jira is optional, so the platform can still operate with GitHub as its only durable store. Adding Jira changes the list of systems of record, but does not require an additional database owned by this platform.

## Documents

| File | Purpose |
| --- | --- |
| [01 — Workspace boundaries](01-workspace-boundaries.md) | Identity, client onboarding, split/attach rules, domains versus cases, and repository mapping |
| [02 — Shared approval service](02-shared-approval-service.md) | Gate semantics, authorization, revision binding, service boundaries, and lifecycle |
| [03 — GitHub persistence](03-github-persistence.md) | Branch layout, evidence records, durable events, concurrency, and recovery |
| [04 — Jira integration](04-jira-integration.md) | Data authority, story/backlog flow, field ownership, synchronization, and approval UI |
| [05 — Implementation backlog](05-implementation-backlog.md) | MVP slices and acceptance scenarios |
| [References](REFERENCES.md) | Primary vendor documentation supporting platform-specific facts |
| [Validation](VALIDATION.md) | Checks performed and limits of this documentation package |

## Starter examples

The [workspace](examples/workspace.example.yaml), [approval request](examples/approval-request.example.yaml), [decision/action request](examples/action-approval-request.example.yaml), [approval event](examples/approval-event.example.yaml), [policy](examples/approval-policy.example.yaml), and [outbox](examples/sync-outbox.example.yaml) examples are synthetic documentation contracts. They are not existing SDK configuration files and must not be deployed as production policy. The identity values and hashes are placeholders, not real approvals.

## Relation to the RSI package

This addendum uses `sdlc-dev-kit`, consistent with the separately prepared `docs/rsi` package. Earlier conversation used `sdlc-agent-kit`; no repository is renamed here. Delivery-artifact approval, sensitive-action authorization, and agent-improvement approval remain separate subjects and permissions even when they reuse approval primitives. The workspace is not the dreaming repository. Resumable scratch context is not accepted business truth.

The installer adds only `docs/workspace/`. It does not alter `docs/rsi`, root instructions, SDK code, workflows, production configuration, or repository remotes. The actual Windows repository has not been inspected and has not been changed from this environment.
