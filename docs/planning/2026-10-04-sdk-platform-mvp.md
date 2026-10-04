# SDK Workspace, Approval, and RSI MVP Plan

Date: 2026-10-04, America/New_York.

**Status:** Proposed MVP release profile requested by the user. Implementation is reportedly at WS-01 in the separate SDK checkout; this planning session has not inspected that code or verified completed tasks.

**Goal:** Demonstrate shared resumable work, exact-revision human approval, and one evidence-to-improvement PR through the existing `sdlc-dev-kit`, with minimal new infrastructure and implementation overhead.

**Execution:** Continue in the existing Copilot implementation session using direct implementation. Do not use Superpowers or a TDD/test-first workflow. This user-directed MVP workflow replaces the older plan's execution process; retain repository security, compatibility, build and review requirements. No new planning interview, agent per task, or repeated whole-repository review is required.

**Access constraint:** Copilot can work on the SDK checkout but cannot connect to the agent platform. The agent's GitHub adapter is an MCP capability on that platform, not an SDK-local GitHub client. Implement from available source and documented interfaces, run local checks, and hand platform/MCP wiring and validation to a person/session with access. Do not provision platform access, invent tool names/payloads, or repeatedly attempt unavailable end-to-end checks. A missing interface contract blocks only the affected integration, not unrelated local work.

**Architecture and stack:** The SDK owns shared workspace/capture/approval logic, record contracts, and persistence/recovery coordination. The agent platform owns the existing GitHub MCP connection, provider authentication and tool execution. Reuse the existing host-to-SDK interface to exchange operation requests and trusted results; add only narrow missing integration points when their contracts are known. Preserve Python constraints, tools, public consumers, and local changes. Dreaming remains a separate agent using the SDK. Responsibilities below do not mandate separate classes or modules.

**Relationship to existing documents:** The [full implementation plan](../superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md) and [design](../superpowers/specs/2026-10-04-rsi-workspace-approval-design.md) remain the long-term roadmap. This document narrows the first release and sets its current execution workflow. Historical handoffs and the [RSI](../rsi/README.md) / [workspace](../workspace/README.md) baselines remain unchanged. Do not import the old plan's TDD, orchestration or live-check prerequisites into Copilot's MVP tasks. Do not mark full-roadmap tasks complete when only their MVP subset is done.

## Release boundary and decision status

Confirmed constraints: lightweight SDK extension; workspace, approval, and RSI all represented; CLI and GitHub PR interaction; existing drafts; no new Python pin; no SDK source access required here; preserve completed work and the old plan; no Superpowers or TDD; Copilot has no agent-platform connection; GitHub access is the agent platform's existing MCP capability.

**Proposed approval simplification:** A human merges in GitHub. The SDK verifies human review, the reviewed revision, and the observed merge before recording acceptance. It does not execute merges or arbitrary protected actions in this release. This choice is awaiting the user's answer; it is not a previously confirmed requirement. If SDK-executed merging is required, include full-plan APP-02 rather than disguising that work as a lightweight observer. Do not remove working application/recovery code already present.

MVP operating limits:

- One configured access boundary and storage binding; multiple distinct logical workspaces within it. Unknown boundaries are rejected, not silently mapped into the default.
- One existing real delivery consumer, exercised by two authorized identities/sessions. SDK packaging remains reusable by every agent; broad consumer rollout is later work.
- One configured improvement target repository with an explicit allowed prompt/skill-text path set. The source, workspace store, and improvement target remain separate identities even if deployment co-locates them.
- One explicit approval policy per supported subject kind: delivery artifact and improvement PR. Use trusted reviewer configuration; a reviewer does not acquire another subject's authority by association. If the host already requires stronger policy, retain it.
- Automatic capture after eligible completed delivery responses; bounded manual Dreaming runs. No scheduler, UI, Jira, general policy language, plugin framework, database, queue, or replacement controller.
- No SDK-driven deployment, consumer upgrade, rollback, arbitrary command execution, or cross-repository coordinated changes. Existing release/upgrade procedures remain human-operated.

The later platform demonstration imports an existing draft through the native CLI, resumes the same workspace from another authorized session, captures a correction, and creates an evaluated improvement PR. A human reviews/merges; the SDK records verified acceptance separately from release or consumer adoption. A platform operator performs this after Copilot hands off the local implementation. It is not a prerequisite for Copilot to finish its SDK work.

## SDK and platform responsibilities

| SDK implementation in Copilot | Agent platform integration |
| --- | --- |
| Validate records, scope, revisions and approval evidence; decide the next allowed operation. | Authenticate the caller and invoke the existing GitHub MCP tools with appropriate permissions. |
| Prepare scoped read/write or PR requests, stable operation IDs and expected revisions; process success/conflict/unknown outcomes. | Perform GitHub reads/writes, retrieve complete review/merge evidence, create/query PRs, and return actual provider results. |
| Coordinate replay/reconciliation and validate receipts before advancing state. | Supply trustworthy provider revisions/receipts and the documented concurrency/error semantics needed by that coordination. |

Do not implement a second GitHub REST/GraphQL client, MCP server, credential store, or generic MCP framework in the SDK. This plan does not require a local GitHub login/token or a `gh` workaround. Use the SDK's existing host callback/tool-result mechanism if available; a documented operation/result boundary is sufficient until platform wiring is accessible.

The platform operator must confirm tool names, input/output contracts, pagination/completeness, expected-revision writes, duplicate reconciliation and error semantics. These are required capabilities, not claims that the current MCP provides them. In particular, a separate read followed by an unconditional write does not enforce atomic uniqueness or prevent lost updates. Missing guarantees leave the affected feature unsupported/pending; do not hide them with in-memory locks or a successful fixture.

The SDK accepts authoritative evidence only through the trusted host integration, never a model-authored summary of a tool response. Platform permissions must prevent agents bypassing protected SDK decisions through unrestricted MCP writes. Record this as an operator verification item, not a new gateway product for Copilot to build.

## Guarantees retained

1. Check host-authenticated access before reading workspace/evidence data. Model output cannot set identity, policy, target ownership, or approval.
2. Keep draft, reviewed, merged, accepted, released, and adopted facts distinct. A scratch summary, model score, or bare GitHub `merged` flag cannot establish acceptance.
3. Use exact revision/digest checks, conditional writes, stable operation IDs, and reconciliation before retrying uncertain writes. Preserve conflicts; never fabricate durable success.
4. Redact/minimize before extraction and persistence; reject fabricated or inaccessible evidence. Preserve historical schemas and contradictory evidence.
5. Capture/evaluation/Dreaming calls cannot recursively produce delivery captures. Capture failure is reported independently from the original delivery result.
6. Protect human merge permissions and authoritative records through the existing host/GitHub boundary. SDK installation is not an isolation mechanism for agents holding unrestricted credentials.

## Reuse the work already underway

Read the existing integration map and execution log first. Do not repeat INT-00 or recreate CORE-01/STORE-01/WS-01 because this plan has a new filename. Verify only the entries needed for the next change; retain extra working functionality even when it is outside MVP scope. If current STORE work assumes a direct GitHub client, preserve it and record the mismatch; adapt the narrow host boundary when documented rather than automatically replacing working modules or implementing another transport.

| Full-plan work | MVP treatment | Preserved later work |
| --- | --- | --- |
| INT-00, CORE-01, STORE-01 | Reuse mapped paths, trusted context, versioning and record/conflict/retry logic; bind actual GitHub operations to platform MCP. | Wider integration adapters as consumers require them. |
| WS-01 | Finish shared resolution, checkpoints/questions and resume; preserve any additional implemented behavior. | New split/attach workflows and complex anchor discovery if absent. |
| CAP-01, CAP-02 | Implement scoped admission and the real completion hook with existing schemas/resources. | Broader consumer integration and capture performance tuning. |
| APP-01 | Implement revision-bound review evaluation for two explicit subject kinds. | New policies, role combinations, and additional action kinds. |
| APP-02 | Under the proposed manual-merge boundary, verify/record external merge and recover missing records. | SDK effect execution, single-use authorization consumption and distributed application coordination. |
| RSI-01, RSI-02 | One bounded Dreaming run, one configured target, one candidate/PR, explicit behavioral evaluation. | Broader ownership routing, executable-code changes and cross-repository proposals. |
| RSI-03 | Preserve merge/evaluation provenance; report release/adoption as unobserved unless independently verified. | Automated lifecycle records, consumer adoption/benefit measurement and rollback coordination. |
| DIST-01, VERIFY-01 | Local package checks and an operator handoff for one real consumer/GitHub demonstration. | Second distinct consumer and full lifecycle/adoption/rollback acceptance. |

Unsupported operations return a clear unsupported result; they must not silently succeed or alias to a weaker operation. Do not delete compatible existing APIs to fit these limits.

## Task map and verification method

Native filenames and commands come from the receiving session's existing integration map. Extend mapped source files and reuse available local checks; no new package or test layout is prescribed. Resolve missing paths from the actual checkout. For unavailable platform symbols, document the required input/output contract and leave that wiring explicitly pending instead of guessing it.

| Slice | Existing responsibilities / local checks to reuse | Public outcome |
| --- | --- | --- |
| MVP-0 | CORE/STORE/WS; mapped contract, store and workspace tests | Same authorized case and durable pending work across sessions. |
| MVP-1 | CAP-01/02; mapped admission and hook tests | Valid scoped capture or explicit independent capture failure. |
| MVP-2 | APP-01 and observation subset of APP-02; mapped approval/application tests | Review status plus separately verified accepted revision. |
| MVP-3 | RSI-01/02; mapped dreaming/improvement tests and separate agent entry point | One evaluated target PR or a recorded non-candidate/blocked outcome. |
| MVP-4 | DIST/VERIFY; available package checks and operator instructions | Locally checked SDK with an explicit platform-validation handoff. |

For each slice: implement the smallest missing behavior, then use the existing local build/import, lint/format and relevant offline regression commands to check it. There is no requirement to write tests first, demonstrate an initial failure, scaffold a new test suite, or add a mutation-testing workstream for this MVP. Preserve existing tests and configured CI checks. If a material local behavior has no coverage, a small post-implementation check is appropriate; use explicit expected results rather than a passing command alone.

The behavior lists below are acceptance criteria, not instructions to generate a test for every bullet. Local fixtures may exercise contracts without a platform connection; label them simulated. Only an authorized platform run can establish real identity, hook invocation, permissions and end-to-end behavior.

Use one concise execution-log entry per slice: changed files, local checks/results, unavailable integration points, and next slice. Mark checks requiring platform access as pending for the operator. Do not convert unavailable checks into passing results or weaken the runtime's authorization/recovery behavior.

## MVP-0 — Continue and finish the necessary WS-01 behavior

**Depends on:** existing CORE-01/STORE-01. **Consumes:** authenticated context, explicit configured anchor/storage binding. **Produces:** durable workspace identity and resumable state.

**Acceptance behavior (local checks where possible; platform checks deferred):**

- Two authorized sessions resolving the same anchor receive the same ID; a different anchor receives a different ID.
- An unauthorized identity or unknown access boundary reads no restricted state and cannot write it.
- Restart retains pending questions, draft references and accepted revision separately.
- Competing checkpoint writes either preserve both contributions through existing reconciliation or report a conflict without overwriting one.
- Repeated durable operations return the same result; unknown provider outcome never produces a success receipt. Reuse STORE-01 tests for these guarantees.

- [ ] Check existing WS-01 progress and implement only missing behavior; reuse available local checks.
- [ ] Keep a direct configured anchor path; reject ambiguity explicitly. Defer absent split/attach UI or discovery machinery.
- [ ] Check local resolve/checkpoint/resume using available SDK entry points. List real consumer resume as an operator check; record local completion separately from platform verification.

## MVP-1 — Capture through the existing consumer

**Depends on:** MVP-0. **Consumes:** trusted completed response, bounded authorized evidence, existing extraction client/assets. **Produces:** validated versioned capture and durable receipt/status.

**Acceptance behavior (local checks where possible; platform checks deferred):**

- A known correction yields a scoped observation with real evidence; no signal yields a valid empty capture. Preserve existing schema bounds and version fixtures.
- Missing/cross-workspace evidence is rejected before writing; secrets in excerpts or summaries are redacted or rejected, including diagnostics.
- Delivery callback replay and repeated SDK initialization do not re-extract a committed event. Concurrent first attempts converge on one committed result; do not promise exactly one simultaneous model call.
- Capture, evaluation, replay and Improvement-group events invoke the delivery extractor zero times.
- Timeout after write reconciles the committed record; confirmed failure retains the original delivery output and exposes capture failure separately.

- [ ] Implement the missing CAP-01 admission behavior using the existing versioned schemas and redaction path.
- [ ] Implement CAP-02 against the existing documented completed-response interface; reuse committed receipts before extraction. Keep finite time/retry limits in existing configuration. Edit consumer wiring only if its source/contract is available; leave actual hook invocation for platform verification.
- [ ] Package the prompt/schema/skill through the existing resource loader as part of this slice, not a future framework task.

## MVP-2 — Verified review and observed acceptance

**Depends on:** MVP-0; can precede MVP-1 if existing implementation favors it. **Consumes:** trusted subject/policy, authenticated human reviews, current GitHub state. **Produces:** pending/satisfied/blocked/stale review status and a separately verified accepted revision.

This slice uses the proposed human-merge path. GitHub native branch rules and permission separation must enforce the chosen review/check requirements at merge time. The SDK cannot prevent an administrator bypass by observing afterward; it must reject unverified acceptance. Implement the local verification logic and adapter contracts without requiring a live platform session. An operator later verifies the deployed permission boundary; unsupported or unverifiable runtime evidence still fails closed.

**Acceptance behavior (local checks where possible; platform checks deferred):**

- Configured eligible human approval of the exact revision satisfies the gate. Bot, self-asserted approval, comment-only, wrong-scope reviewer, dismissed review and incomplete evidence do not.
- Changed subject, policy or covered dependency makes prior approval stale; historical evidence remains available. Required change requests block acceptance.
- Approved but unmerged remains unaccepted. Merge observation must reconcile reviewed PR head/diff, actual merged content, policy/dependency checks and required-check evidence; unexplained changes remain blocked/unknown.
- Repeated merge observation records one acceptance. Lost acceptance-write response or restart reconciles without duplication; provider outage cannot invent approval or acceptance.
- An accepted delivery artifact does not approve an improvement. Acceptance never initiates publishing or consumer upgrades.

- [ ] Reuse APP-01's subject/policy/evidence checks for delivery and improvement with explicitly configured reviewer scopes. Consume complete review/merge evidence supplied by the trusted platform MCP integration; Copilot implements local validation without live GitHub retrieval.
- [ ] Add/reuse the CLI review/refresh operation and a merge-observation/reconciliation operation. Do not introduce an SDK merge command in this profile.
- [ ] Require a protected, SDK-verifiable acceptance record before downstream consumers treat the artifact as accepted. Unsupported sensitive actions remain unavailable.

## MVP-3 — One bounded Dreaming proposal

**Depends on:** MVP-1 and MVP-2. **Consumes:** scoped captures, one trusted target mapping, explicit limits, an evaluation procedure. **Produces:** one traceable evaluated PR or an explicit no-candidate/insufficient-evidence/unresolved-owner/blocked result.

Start with a prompt/skill-text improvement in the configured owner repository. Do not add an ownership discovery service, code-generation platform, or evaluator framework. Use existing isolated evaluation facilities; alternatively, a trusted human may execute the declared behavioral cases and record inputs, expected/actual outcomes and exact revisions. Model self-assessment alone is not evaluation. If neither path can verify the cases safely, keep the candidate blocked and do not claim an evaluated PR.

**Acceptance behavior (local checks where possible; platform checks deferred):**

- Duplicate extractions count as one incident; contradictions remain visible. Empty/insufficient evidence creates no invented candidate.
- Unknown owner, wrong workspace, disallowed path or a proposal changing authority/evaluation gates creates no target change. Project-specific evidence cannot silently justify global policy.
- Finite evidence/model-call/time/candidate budgets stop the run. The acceptance fixture permits at most 20 captures, three model calls and one candidate; these are test/demo limits, not fabricated production defaults.
- Baseline and candidate evaluation cover one intended improvement and its counterexample. For fewer redundant questions: already-confirmed information avoids repetition, genuinely missing information still triggers clarification. Include a malicious instruction case that must not gain authority.
- Evaluation binds exact base/head, cases, evaluator identity and policy. Changed covered revision invalidates it; failed negative cases block review readiness.
- Lost PR-creation response reconciles the same proposal key/PR instead of creating another. Dreaming cannot approve/merge or trigger ordinary capture.

- [ ] Reuse SDK evidence reads/candidate records. Implement the separate Dreaming Agent entry point only where its source is available; otherwise deliver its documented SDK call sequence, prompt assets and input/output contract for the platform operator. Do not create a replacement agent runtime.
- [ ] Implement allowed-patch validation, revision-bound evaluation records and PR request/result reconciliation. The platform performs actual PR creation/query through its existing GitHub MCP. Check deterministic SDK behavior locally with available fixtures. Actual model evaluation and PR creation run later where the required connections exist; never mark a fixture result as an evaluated candidate.
- [ ] Connect MVP-2's improvement gate. Keep candidates awaiting external evaluation/review in an explicit pending or blocked state. Candidate evaluation must not inherit writer credentials or gain access to mandatory gate definitions. Release, adoption and benefit remain outside this release's completion claim.

## MVP-4 — Package locally and hand off platform validation

**Depends on:** the locally implementable parts of MVP-0 through MVP-3. **Consumes:** existing build/install process, documented platform interfaces. **Produces:** locally checked SDK and a short operator checklist.

- [ ] Build/install using existing tooling and check packaged schema/prompt loading and SDK initialization locally. Reuse existing checks for repeated initialization and capability exclusions. No per-agent implementation copies.
- [ ] Run available offline regressions, lint/format and required code review. Keep pre-existing failures and checks requiring external access separate. Do not add an E2E harness or emulate the whole agent platform.
- [ ] Add an operator checklist to the existing execution log: required configuration names (no secrets), remaining consumer/agent and GitHub MCP wiring, confirmed/missing tool contracts and concurrency guarantees, installed SDK version, entry points, expected results and supported recovery steps.
- [ ] Hand off these platform checks: draft/resume across two identities; actual completion-hook capture; one evaluated proposal; human review/merge and verified acceptance; unauthorized record/merge rejection; one lost-write recovery and one stale-review case.
- [ ] Mark the SDK delivery locally checked with platform validation pending. The operator later records real PR/revisions, approval evidence, accepted record and outcomes. Copilot need not obtain platform access or perform these runs to finish its assigned scope.

## Release decision and economical execution

**Copilot completion:** available SDK implementation and locally accessible wiring are finished, available local checks are recorded, and unavailable platform interfaces/wiring/checks are explicitly handed off. Where an interface cannot be determined from source/docs, report that specific incomplete item; do not claim the integration is implemented.

**Platform release verification:** a person/session with access completes the remaining integration and operator checks before claiming a live verified MVP. These are separate completion states. Neither certifies full-roadmap M2/M3/M4, multi-consumer rollout, automatic promotion, or measured RSI benefit.

Use the current agent for direct implementation without Superpowers or TDD. Apply the repository's required independent review to meaningful changes; avoid extra planning/specification review chains for each checkbox. Read this plan and the existing integration map once, then the current slice and its actual dependencies. Consult the full plan only for a concrete semantic question; its older execution workflow and deferred scope do not apply to this MVP.

Use a lower-cost available model for straightforward adapters/tests and a stronger model for difficult approval/recovery decisions as needed. Model selection is an execution preference, not a package dependency. After two unsuccessful repairs of the same failure, summarize evidence and escalate that problem rather than starting an open-ended rewrite. No quota percentage or completion-cost guarantee is implied.

### Copilot continuation prompt

```text
Continue the existing sdlc-dev-kit implementation from its current WS-01 state
using docs/planning/2026-10-04-sdk-platform-mvp.md.
Read the repository instructions and existing integration map/execution log.
Preserve local work and reuse verified CORE/STORE/WS behavior; do not restart.
Use this MVP profile for release scope and the full plan as a reference roadmap.
Resolve the stated human-merge decision before implementing MVP-2.
Use direct implementation. Do not use Superpowers or TDD/test-first workflows.
The GitHub adapter is the agent platform's MCP capability, inaccessible from
Copilot. Do not build an SDK GitHub client or require local GitHub credentials.
Implement SDK logic against available host interfaces; leave MCP tool mapping
and live execution to the platform operator. Run existing local checks and required
review. Do not build a new test harness or attempt unavailable platform E2E.
Document unknown interfaces and remaining platform wiring/checks for the operator.
Do not claim live integration from fixtures or block unrelated SDK work on access.
Use existing paths, tooling, adapters, resource loading and approval boundaries.
Update the existing execution log with concise evidence. Do not claim full-plan
tasks complete for an MVP subset. Do not push, deploy or upgrade consumers.
```

### Planning status

- [x] Preserve the full roadmap and map completed/remaining work to an MVP profile.
- [x] Define bounded slices, acceptance behavior, deferred work and an implementation handoff.
- [x] Remove Superpowers/TDD execution requirements and separate local completion from platform validation.
- [x] Locate GitHub transport/authentication on the agent platform's MCP; retain SDK logic and record/recovery contracts.
- [ ] Confirm the proposed human-merge release boundary.
- [ ] Receiving session verifies existing progress and implements the missing MVP behavior.
- [ ] An operator with platform access completes remaining integration and live validation after Copilot's handoff.
