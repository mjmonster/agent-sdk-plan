# Delivery foundation design

Date: 2026-10-03, America/New_York.

Status: superseded planning alternative as of 2026-10-04. Use the [current SDK RSI/workspace/approval design](2026-10-04-rsi-workspace-approval-design.md). The user clarified that the kit already exists and these platform functions belong inside it. The delivery-only scope, new Python baseline/toolchain, and mandatory standalone-controller assumptions below are historical proposals, not implementation instructions. No implementation is authorized by this document.

## Intent and success

Build the common foundation for collaborative SDLC work. Two authorized collaborators must be able to open the same delivery case, propose a BRD revision, obtain authenticated human review of that revision, establish an accepted baseline, and resume after interruption without losing pending questions or confusing draft content with accepted truth.

The first release proves this delivery workflow. Capture and the separate Dreaming Agent remain subsequent requirements. The application being built is distinct from GitHub Copilot, which the user will use to implement the reviewed plan in VS Code.

Sources: [current handoff](<../../../CODEX-HANDOFF(1).md>), [workspace design](../../workspace/README.md), [RSI design](../../rsi/README.md), and [review and decision record](../../planning/2026-10-03-handoff-review.md).

## Accepted decisions and proposed scope

| Item | Disposition |
| --- | --- |
| Delivery foundation precedes capture/dreaming | Accepted by the user on 2026-10-03. |
| Python-first shared kit and trusted controller | Accepted by the user on 2026-10-03. |
| Command-line interface with GitHub PR reviews | Accepted by the user on 2026-10-03. |
| One test tenant and one BRD artifact type | Recommended initial operating scope. |
| Lifecycle approval and one standalone scope decision | Recommended first demonstration of the shared approval mechanism. |
| BRD drafting integration | Import a person/agent-authored draft through the CLI. Accepted by the user on 2026-10-03. Built-in LLM drafting is deferred. |
| One serialized writer per delivery-data repository | Recommended initial concurrency model. |

The first release contains no built-in LLM drafting agent, agent framework, model provider, or response hook. An external agent can prepare a file and invoke the same bounded CLI as a person. Successful import proves this interface, not portability across every agent runtime.

### Engineering defaults proposed together for review

- One Python source repository and a separate private GitHub delivery-data repository; one test tenant/access boundary. Preserve this documentation bundle in the source repository.
- Withdrawn on 2026-10-04: the proposed new Python floor and `uv`/FastAPI/Pydantic/HTTPX/argparse toolchain. Inherit the existing SDK's Python constraints, tooling, libraries, and packaging. This plan does not change its Python version.
- One controller process, one worker, and serialized mutations per data repository. No database, broker, background worker, webhook receiver, or automatic merge queue in release one. CLI operations explicitly refresh or reconcile state.
- One BRD artifact plus a Markdown scope-decision artifact. Both use the same approval evaluator. Accepting a scope decision does not advance the BRD stage.
- The initial policy requires one configured human business owner, distinct from the proposal's initiating human actor. The evaluator supports distinct-person quorum counts; production ownership is a deployment input.
- Isolate the controller's GitHub App credential from CLI/agent callers using a separate service identity or host. The live acceptance environment must enforce this boundary; a local same-user demo only tests functionality.

These choices keep the first complete journey small. Multi-instance availability, multi-tenant isolation within one repository, additional agent runtimes, and arbitrary action execution require later designs.

## Invariants

1. A workspace is a stable logical delivery case. Changing a user, session, display name, or storage binding does not create a new case automatically.
2. Tenant and workspace authorization is checked before reading context or accepting a mutation. Repository possession, agent persona, and model-authored identity do not establish business authority.
3. Proposed artifacts, accepted baselines, control records, and checkpoints retain separate meanings even if their storage shares an authorized access boundary.
4. A human decision applies to a fixed subject and declared consequence. Approval, merge, accepted baseline, and workflow transition are recorded separately.
5. Required policy and ownership come from trusted configuration. A proposal cannot choose a weaker policy or appoint its own approver.
6. GitHub is the durable platform store. Local clones, caches, projections, and process memory are rebuildable conveniences, not additional authoritative stores.
7. A successful response claiming durability includes verifiable persistence evidence. Failed or ambiguous writes remain explicit.
8. Replaying one operation must not produce another authoritative workspace, event, proposal, or baseline. Reusing an identity with a different payload is a conflict.
9. Historical decisions and older alternatives remain inspectable. Stale applicability does not erase a prior human decision.
10. Checkpoints retain concise rationale and observable evidence references, not hidden reasoning or an invented approval state.

## Proposed component boundaries

Use one distribution with `src/sdlc_dev_kit/` for public contracts/client, `src/sdlc_controller/` for trusted services/adapters, and `src/sdlc_cli/` for the command interface. The controller exposes versioned `/v1` HTTP operations. The client package must be usable without loading controller configuration or credentials. The detailed plan will specify individual files and typed signatures inside these boundaries.

| Component | Responsibility | Authority limit |
| --- | --- | --- |
| Shared kit | Versioned public requests, results, validation contracts, and client integration. | Importing the package grants no privileged identity. |
| Workspace service | Resolve authorized case IDs, external anchors, and configured storage bindings. | Caller text cannot select arbitrary repositories or tenants. |
| Proposal service | Create and inspect a fixed artifact proposal against a declared baseline. | Draft creation does not accept the artifact. |
| Approval evaluator | Derive applicability from authenticated human evidence, role policy, subject freshness, and dependencies. | It does not infer approval from a summary, comment, or model claim. |
| Application coordinator | Recheck authorization and apply the permitted exact revision, then record its observed outcome. | It cannot substitute a newer unreviewed revision. |
| GitHub adapter and event store | Provider requests, serialized control writes, persistence receipts, conflict handling, and reconciliation reads. | Privileged credentials remain in the trusted execution boundary. |
| Checkpoint and recovery service | Reconstruct the accepted baseline, drafts, questions, requests, and next permitted work. | Cached projections do not override current provider or policy evidence. |
| CLI and shared Python client | Import an existing draft, call bounded public operations, and present outcomes. | No direct admission of verified reviews or issuance of authorization. |

The controller's trust boundary must be real in the test deployment. A library and an agent with unrestricted access to the same privileged credential do not demonstrate independent enforcement. The plan must name where credentials reside and test that agent callers cannot bypass the controller.

### Authentication and policy

The CLI reads a caller-owned GitHub token from an explicitly configured environment variable, never a command-line argument. The controller verifies it through GitHub's authenticated-user endpoint on each request, resolves the numeric user ID, and checks configured tenant/workspace membership plus current repository access. It never accepts an actor ID asserted by the client. Tokens stay in memory for that request and are excluded from logs and durable records. HTTPS is required across hosts; loopback HTTP is permitted only for local development.

The controller uses a separately provisioned GitHub App installation credential for repository writes. It has Contents and Pull requests read/write, Issues read for workspace anchors, and the minimum metadata access required for identity/access checks. It receives no administration or bypass privilege through the normal application path. Installation scope is the configured data repository. Secret material comes from the service environment/secret mount; GitHub holds only non-secret policy and audit references.

A trusted operator provisions the initial membership/role policy on the artifact branch and pins its digest in controller configuration. Proposed documents cannot modify policy, repository bindings, or credentials. Policy changes are an operator-governed deployment action in release one. Restarting with an unrecognized or mismatching policy fails closed; policy replacement invalidates outstanding approval subjects. A GitHub username rename does not change membership keyed by numeric user ID.

All first-release workspaces share the same repository confidentiality boundary. Workspace permissions constrain controller operations but do not conceal files from people who already have repository read access. Separate confidentiality domains require separate repository bindings. Repository administrators and service operators remain trusted; the design does not claim protection from their deliberate bypasses.

## Proposed identity and record model

Keep tenant ID, access-boundary ID, workspace ID, work-item ID, actor ID, run/session ID, repository identity, and storage binding identity distinct. Provider references include provider instance and immutable object identity; display keys are aliases.

Workspace resolution first checks an authorized explicit ID, then an existing external-object mapping. Release one supports a GitHub issue in the configured data repository as its external anchor, verified by immutable issue ID; its issue number is a display/lookup alias. An explicit create operation can create a provisional case without an anchor. Parent inference and Jira anchors are deferred. Conflicting mappings produce a scoped resolution error. A new mapping becomes successful only after durable persistence. A provisional case can hold drafts, but unresolved ownership blocks protected progress.

Use UUIDv4 strings for platform IDs and operation keys, and strings for provider numeric IDs. Keep provider commit OIDs opaque; do not assume every Git provider will use the same hash length. Public models reject unknown fields. Each schema has an explicit integer version; incompatible changes require a new version, not reinterpretation of historical records.

A review subject contains schema version, tenant/workspace/access-boundary IDs, initiating actor ID, provider/repository ID, proposal ID, artifact type and allowed paths, SHA-256 digests of exact artifact bytes, expected artifact-branch head, expected accepted artifact revision, covered decision/dependency revisions, policy digest, and requested effect. Requested effects are `accept_brd` or `accept_scope_decision`, with an explicit decision ID for the latter. Human-readable labels, timestamps, and summaries are excluded from authority.

Commit this manifest alongside the proposed Markdown. After GitHub returns the proposal commit, the controller constructs the full subject from the manifest plus that reviewed head OID and hashes it. The manifest cannot contain its own commit OID or subject digest; this avoids a self-referential hash. Reviewers see the manifest and content in the same GitHub diff. Any later commit creates a new full subject and requires new review.

Canonical JSON v1 is UTF-8 without BOM, recursively sorted object keys, no insignificant whitespace, and unescaped Unicode. Permit strings, booleans, null, integers, arrays, and objects only; reject floats, duplicate keys, invalid Unicode, and unknown fields. Sort artifact entries by path and dependencies by typed ID, rejecting duplicates before encoding. Do not normalize Markdown bytes or Unicode. Include a published byte-and-digest test vector in the contract task so future Java consumers can reproduce the result.

Requests, individual human decisions, applicability evaluations, merge/application outcomes, accepted baselines, transitions, and checkpoints are separate records. Each operational event has a stable ID, scope, correlation/causation references, trusted receive time, schema version, and payload integrity information. Actor and recorder identities are separate.

An approval request's derived status is `pending`, `satisfied`, `blocked`, `stale`, or `closed`; it is never the workspace stage. A BRD workspace stage is initially `drafting` and changes to `brd_accepted` only through a separately persisted transition referencing an accepted baseline. A decision has its own accepted revision. Questions have stable IDs, text, and open/resolved status; resolving a question records its answer reference, not an implicit approval.

## Proposed persistence and collaboration

Use configurable GitHub repository bindings. The proposed initial layout keeps accepted artifacts and approved policy on an artifact branch, durable operational records on a control branch, and unaccepted changes on proposal branches. Branch names are configuration, not identities or confidentiality boundaries.

| Location | Proposed content |
| --- | --- |
| Artifact branch, `workspaces/<workspace-id>/brd.md` | Accepted BRD after verified application. |
| Artifact branch, `workspaces/<workspace-id>/decisions/<decision-id>.md` | Accepted standalone scope decisions. |
| Artifact branch, `workspaces/<workspace-id>/subjects/<proposal-id>.json` | Review manifests retained with their accepted content. |
| Artifact branch, `policies/<tenant-id>.json` | Operator-provisioned membership and approval policy. |
| Control branch, `events/<tenant-id>/<workspace-id>/<event-id>.json` | Append-only operational records. |
| Control branch, `indexes/anchors/<anchor-key-digest>.json` | Unique anchor-to-workspace mapping, updated with its creation event in one commit. |
| Control branch, `operations/<operation-id>.json` | Recoverable operation state and request digest; prior revisions remain in Git history. |
| Proposal branch | Only controller-selected artifact and manifest paths changed from the pinned artifact-branch head. |

The controller chooses all repository paths from validated IDs; callers cannot submit server paths, branch names, or arbitrary URLs. BRD and decision content is treated as data, never shell commands or controller instructions. Initial limits are 1 MiB UTF-8 Markdown per artifact, 100 dependencies per subject, and 8 KiB per question/answer field; reject NUL bytes and invalid UTF-8. Preserve submitted artifact bytes. Empty/whitespace-only content is invalid. These resource ceilings are configurable within service policy, not bypassable by the caller.

Keep independently editable artifact proposals separate. Each proposal records its expected accepted baseline. If another proposal changes that baseline first, surface the conflict and preserve both proposals. Automatic semantic merging is outside the first release.

For release one, the expected artifact-branch head is also a repository-wide precondition. An unrelated accepted change can therefore make a proposal stale. This conservative rule reduces ambiguity at the cost of extra reviews. Refreshing a stale proposal creates a new proposal from the current baseline and records the superseded proposal reference; it never rewrites the reviewed history.

The serialized writer must also protect against competing processes or restarts through provider revision checks. An in-process mutex alone is insufficient. Identical replays return the prior result; differing payloads under the same identity fail explicitly. Bound retries and reconcile ambiguous provider outcomes before repeating non-idempotent operations.

Every mutation requires a caller-supplied operation UUID. Its digest covers the authenticated initiating actor, endpoint, and validated semantic payload. An authorized replay with the same key and digest returns the prior operation/result; a different digest gives `IDEMPOTENCY_CONFLICT`. Creation intents are durable before creating branches or PRs. Use a deterministic proposal branch derived from the operation ID, then reconcile existing branch and PR identity after a timeout before attempting creation again. Multiple conflicting matches require operator inspection, not an arbitrary selection.

Control commits are built against an observed parent and update the ref with `force=false`. Competing commits based on the same old parent are siblings, so a losing update must reload and recompute against the winning head. This is optimistic conflict detection, not a distributed lease. Exactly one controller writer is a deployment requirement; detection of a competing controller fails the operation rather than enabling a second active writer. [GitHub Git references API](https://docs.github.com/en/rest/git/refs).

Record a fresh controller-instance UUID in control-commit metadata and capture the starting head on startup. A stale head explained by this instance's already committed operation can be reconciled/recomputed. New commits from another instance appearing after that starting head are unexpected concurrent-writer activity and stop mutations. A non-fast-forward response by itself does not identify another writer. This check diagnoses overlapping deployments; it is not fencing, so deployment must still enforce one active process.

The writer atomically commits events, operation progress, and affected control indexes in one Git tree/ref update. Event IDs derive deterministically from the operation ID, event kind, and stable logical occurrence, such as a provider review ID and observed-state digest. This permits multiple reviews in one refresh without collisions. Freeze event payloads and receive timestamps for write attempts. After ambiguous writes/restarts, first look up the deterministic IDs and reuse persisted payloads; do not regenerate timestamps and then mistake the replay for a conflict. A changed semantic payload under an existing event ID is an integrity error.

Only the controller App may update the control branch; ordinary collaborators cannot write events, operation records, or indexes. Native rules must block control-ref force updates and deletion. Verify this with a rejected write using a collaborator token in the live acceptance environment. Control history must also remain descendant of the trusted bootstrap commit; detected ref rewrites or missing records stop protected writes pending operator repair. Ancestry alone does not prove that a record was admitted by the trusted controller.

The storage outage contract is explicit: protected effects require durable authorization; drafting may continue only with an honest unpersisted status. Do not promise lossless work from an in-memory retry queue.

### Provider limits and error contract

Use finite HTTP timeouts: 5 seconds connect and 20 seconds read/write, with a 60-second operation deadline. Retry safe reads and conflicting control-ref updates at most three attempts with bounded backoff and jitter. Honor provider rate-limit timing only within that deadline; otherwise return the next permitted retry time. Do not blindly replay timed-out PR creation or merge requests. Those enter reconciliation under the original operation key.

All public failures contain `code`, a safe message, `operation_id` when applicable, `retryable`, and an optional `retry_after_seconds`. Defined codes include `INVALID_INPUT`, `UNAUTHENTICATED`, `FORBIDDEN`, `NOT_FOUND`, `OWNERSHIP_UNRESOLVED`, `SUBJECT_STALE`, `BASELINE_CONFLICT`, `APPROVAL_UNSATISFIED`, `IDEMPOTENCY_CONFLICT`, `INTEGRITY_CONFLICT`, `PROVIDER_UNAVAILABLE`, and `OUTCOME_UNKNOWN`. Scope lookup returns the same bounded `NOT_FOUND` response for missing and inaccessible workspaces. A success receipt includes repository ID, branch/ref, commit OID, record path, and payload digest. A memory-only result cannot use that receipt shape.

Use GitHub REST with a pinned API version in configuration, initially `2026-03-10`, and contract fixtures from that version. Follow all pagination for approval evidence; incomplete or capped retrieval cannot satisfy a gate. A provider deadline yields an unsatisfied/unknown result rather than counting a partial page as complete evidence.

## Proposed delivery flow

1. Authenticate the caller and resolve an authorized workspace binding.
2. Load the accepted baseline and current durable control state.
3. Prepare a BRD proposal with a fixed subject and explicit dependencies.
4. Present the proposal for authenticated human review under the configured role policy.
5. Admit verified provider evidence and derive current applicability.
6. Recheck subject, policy, and dependencies immediately before the permitted application.
7. Verify the actual merge/application result and persist the resulting baseline.
8. Persist the workflow transition separately and update resumable context.

A standalone scope decision can be a dependency of the BRD proposal. An unresolved decision blocks its declared dependent effect rather than every workspace operation.

### Concrete first-release operations

| CLI operation family | Observable result |
| --- | --- |
| `workspace open`, `workspace create`, `workspace show` | Resolve/create a stable authorized case; return accepted and pending state with durable references. |
| `brd import --file ...` | Validate the local file, upload bounded content, and return a proposal ID and GitHub PR URL. |
| `decision propose --file ...` | Create a standalone scope-decision proposal with its declared effect. |
| `approval refresh` | Fetch provider reviews and return current applicability plus explicit unmet requirements. |
| `proposal apply` | Recheck current conditions, apply the exact reviewed head, and return observed merge/baseline/transition facts separately. |
| `question add`, `question resolve`, `checkpoint save` | Persist explicit pending questions, answers, and concise progress with expected control revision. |
| `workspace resume`, `operation reconcile` | Rebuild context or repair an interrupted operation from durable facts. |

Mutations accept an explicit operation ID and return it in both human-readable and JSON output. The shared client exposes the same operations. Import reads a local file only in the CLI; the controller receives content, not a path to open on its host. CLI exit codes are 0 for success, 2 for invalid input, 3 for access/authentication failure, 4 for unmet/stale/conflicting state, and 5 for provider/unknown outcomes. The detailed plan will freeze complete command syntax and HTTP request/response schemas.

### Human review and application rules

Only reviews fetched by the controller from the configured repository/PR are eligible. Bind the numeric reviewer ID, review ID, submitted time, review state, and `commit_id` to the current full subject. Require `type=User`, active authorized role membership, the exact head OID, and separation from the initiating human actor. The controller/App is the recorder, not a human approver. Comments, PR-body text, and uploaded approval JSON never satisfy the gate. [GitHub pull request reviews API](https://docs.github.com/en/rest/pulls/reviews).

Process complete provider review history deterministically by submission time and review ID. For each person, the latest submitted decisive review (`APPROVED`, `CHANGES_REQUESTED`, or `DISMISSED`) determines their eligibility. A later comment neither approves nor clears a prior blocking decision. `PENDING` never counts. A dismissed/latest outdated approval contributes zero; do not fall back to an older approval. An active `CHANGES_REQUESTED` from an eligible reviewer blocks application until cleared by a later decisive review. Count each human once per required role, even if they submitted multiple reviews; when policy requires multiple distinct humans across roles, one person's overlap cannot supply two people.

Immediately before merge, reload PR head/base, the complete diff/path allowlist, current policy/membership, dependencies, accepted baseline, and reviews. Persist the authorized application intent with this evaluation evidence. Configure native repository controls to require review, dismiss stale reviews, block direct writes to accepted artifacts, and limit the permitted merge actor to the controller without bypass. The live acceptance task must verify those controls on the actual account/repository; unavailable controls are a release prerequisite failure, not a mock substitute.

Use the synchronous merge endpoint with the exact expected head `sha` and `merge_method=merge`; do not use squash/rebase, auto-merge, or merge queues in v1. A `409`, non-mergeable response, or changed precondition does not create a baseline. Verify the returned merge commit, its parentage, and resulting artifact/manifest bytes before recording acceptance. GitHub's expected-SHA guard covers the PR head, not arbitrary policy/dependency state; the single authorized merge writer and repository protections are required assumptions. [GitHub pull request merge API](https://docs.github.com/en/rest/pulls/pulls#merge-a-pull-request).

External review or access revocation is not atomically transacted with application-specific checks. Native provider controls reduce that gap; the controller records the exact pre-apply evidence and verifies the observed outcome. An out-of-band merge, mismatched parent/content, or unexpected policy change is `INTEGRITY_CONFLICT` and requires operator reconciliation. It must not silently establish a platform baseline merely because GitHub reports a merge.

Once a BRD merge is verified, append `baseline.accepted` referencing the application outcome, then append `workflow.transitioned` to `brd_accepted` referencing that baseline. Scope decisions append their own accepted revision without changing the BRD stage. Recovery can complete either missing record exactly once from the persisted application intent and verified provider outcome. Current review dismissal after a completed authorized merge does not erase historical acceptance; later changes use a new proposal.

## Recovery and error behavior

| Condition | Required observable result |
| --- | --- |
| Same case opened concurrently | One durable mapping; both authorized callers can resolve it. |
| Evidence cannot be verified | Request remains unsatisfied; no protected effect. |
| Reviewed head or covered dependency changes | Approval becomes inapplicable; historical evidence remains. |
| Approval recorded but proposal unmerged | No accepted baseline or completed transition is reported. |
| Merge succeeds and baseline recording fails | Reconcile provider truth and append the missing baseline event once. |
| Provider outcome is ambiguous | Preserve uncertainty and reconcile before retrying. |
| Restart or expired agent session | Rebuild current state and present pending work from durable references. |
| Caller lacks access | Return a bounded authorization failure without restricted context. |
| Conflicting record identity | Return an integrity conflict without overwriting accepted evidence. |

The detailed plan must assign stable public error codes and distinguish retryable provider failures from authorization, validation, and integrity failures. Diagnostic logging must retain useful failure context while redacting credentials and restricted payloads.

Recovery replays versioned control events in committed order and verifies referenced Git objects, application intents, and provider outcomes. It reports accepted artifact references, unapplied proposals, open questions, approval applicability, incomplete operations, and the next permitted action. Checkpoints accelerate presentation but cannot promote a draft or replace an absent event. Unknown event versions, broken references, or contradictory acceptance records produce an integrity failure. Resume never reissues a merge simply because an in-memory task disappeared.

Checkpoint/question updates use an expected control revision. On conflict, return the current revision and preserve the submitted payload for the caller to reconcile; do not silently overwrite another collaborator's answer. Checkpoints contain a short progress summary and referenced next steps, not raw transcripts, secrets, or hidden model reasoning.

## Verification approach

Use the user's Python testing doctrine: pytest for behavioral examples, parameterized boundary cases, and Hypothesis where invariants benefit from generated inputs. Tests exercise public services and adapter boundaries with concrete results. Write and observe failing behavior tests before implementing state transitions, I/O, errors, retries, or authorization.

Unit and contract tests cover deterministic policy and state logic. Adapter integration tests verify real provider response assumptions. A controlled live demonstration must prove actual review identity, configured repository controls, and recovery; synthetic records and mocked permissions cannot substitute for that evidence.

Include a multi-review refresh test asserting distinct event IDs for distinct reviews, plus crash/replay tests asserting unchanged stored payloads/timestamps and exactly one event per logical occurrence. Distinguish recoverable stale reads from an unexpected second controller in persistence tests. Verify control-branch collaborator writes are rejected in the live environment.

The detailed plan will attach the [review's acceptance cases](../../planning/2026-10-03-handoff-review.md#acceptance-cases-for-the-proposed-foundation) to specific tasks and tests. Linting, formatting, full-suite gates, composition-root checks, coverage floors, and any mutation-testing requirement must have explicit commands and applicability once tooling is selected.

### Smallest useful implementation slice

After the planning documents are accepted, first prove authorized workspace creation/resolution, a durable GitHub control receipt, and resume after controller restart through the shared client and CLI. This includes a minimal controller composition root, authentication boundary, versioned contracts, and the control writer. It deliberately stops before BRD import or approval. A package skeleton alone is not completion of this slice.

Enumerate these cases before writing its tests:

1. An authorized caller opens a known anchor and receives the expected stable workspace ID and a verifiable commit/path receipt.
2. A second authorized caller and a restarted controller resolve the same ID from durable state without local cache.
3. Concurrent first opens of one anchor produce one mapping; a losing sibling control commit reloads safely.
4. Different anchors in one repository remain different workspaces.
5. Missing credentials, revoked access, and an inaccessible workspace reveal no restricted state and perform no write.
6. Same operation ID and payload replay returns the original result; changed actor/payload conflicts.
7. Invalid IDs, unconfigured repositories, malformed/oversized input, and conflicting mappings are rejected concretely.
8. A timeout before or after ref update is reconciled without duplicate creation; an outage yields no fabricated receipt.

Unit tests use a deterministic in-memory provider implementation; HTTP adapter tests assert real request/response contracts and conflict behavior; a gated live test verifies actual GitHub persistence and identity. The latter needs provisioned test accounts/repository, but does not require a model provider. Tests that merely validate this design document are not a substitute.

### Completion of the first release

Subsequent slices add proposal import, verified review evaluation, exact-revision application, scoped decisions/questions, and recovery. The final acceptance journey uses two real human test accounts: one imports a BRD, the other resumes the same workspace and reviews the exact PR revision; the controller establishes the baseline and resumes after an injected post-merge failure without duplicate effects. Repeat with a changed revision and a conflicting proposal and assert that stale approvals cannot apply. Demonstrate a scope decision blocking only its declared BRD effect.

Run Ruff lint/format checks and targeted pytest tests per task; full tests before integration/merge. Wiring, HTTP, configuration, or schema changes additionally require a controller/CLI boot and composition smoke check. Enforce Python line and branch coverage of at least 80% in CI, not as a reason to add trivial tests per change. Approval/applicability logic is core decision logic: run the configured mutation tool when that logic changes, and explain every surviving mutant or kill it with a meaningful test. The plan must provide a supported execution environment for mutation testing if Windows is unsupported.

No performance claim is required beyond the configured bounded operations and this low-volume demonstration. No task may count mocked branch permissions, synthetic human approvals, or an unpersisted queue as proof of production authority or durability.

## Later releases and preserved options

The next major capability is governed capture and dreaming. It needs a workspace-aware successor to the preserved RSI v1 capture record, a trusted response boundary, authorized evidence admission, redaction, GitHub persistence, evaluation, and human-reviewed target changes.

Jira integration, a broader UI, multiple agent runtimes, arbitrary external-action authorization, automated semantic conflict resolution, and research experiments remain separately scoped options. Deferral does not remove them from the historical product direction.

## Design review status

- [x] Accepted first-release direction recorded.
- [x] Accepted Python-first stack recorded.
- [x] Accepted CLI interaction and GitHub PR review interface recorded.
- [x] Existing BRD import selected; built-in LLM drafting deferred.
- [x] Repository/access and human-review deployment defaults proposed explicitly.
- [x] Concrete contracts, recovery behavior, and operational limits written for review.
- [x] User corrected the scope: extend the existing installed SDK with RSI, workspace, and approval.
- [x] Superseded this delivery-only proposal; continue from the linked 2026-10-04 design.

This design introduces no application files or configuration and does not provision a policy, credential, repository, model provider, or agent framework. Repository names, account identities, host addresses, and secrets remain deployment inputs. Acceptance of the proposed engineering defaults enables the detailed plan; it does not authorize implementation in this session.
