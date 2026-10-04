# SDK RSI, Workspace, and Approval Implementation Plan

Date: 2026-10-04, America/New_York.

> **For the receiving Copilot session:** Implement this plan task by task inside the existing `sdlc-dev-kit`. The user selected Copilot in VS Code as the execution method. Use the destination repository's instructions and available planning/TDD/review tools; this handoff does not require Codex-specific tools. Checkboxes describe implementation progress and start unchecked. This document author has no SDK checkout and has not executed these tasks.

**Goal:** Add reusable workspace, approval, and governed RSI functions to the SDK installed across all SDLC agents, then exercise them through existing agent consumers and a separate Dreaming Agent.

**Architecture:** The SDK owns contracts, workspace/recovery services, approval evaluation/application coordination, shared capture assets and hooks, GitHub persistence, and reusable RSI governance functions. Existing trusted agent hosts supply identity, policy, provider adapters, lifecycle callbacks, and credentials; SDK installation does not grant authority. The separate Dreaming Agent orchestrates evidence-to-improvement work through those SDK functions.

**Tech stack:** Preserve the SDK's current Python version constraints, dependency manager, libraries, package layout, test runner integration, and deployment conventions. No interpreter pin, version bump, new framework, standalone controller, database, or queue is prescribed.

**Spec:** [Current SDK scope/design](../specs/2026-10-04-rsi-workspace-approval-design.md). Also read the [handoff review](../../planning/2026-10-03-handoff-review.md), [RSI baseline](../../rsi/README.md), and [workspace/approval baseline](../../workspace/README.md). The 2026-10-03 delivery-only design is a superseded alternative, not this plan's implementation source.

## Global constraints

- Implement shared platform functions within the existing SDK; preserve its public consumers and local changes.
- Do not change the Python version, replace tooling, rebuild the delivery-agent suite, or require SDK access in the planning session.
- GitHub is the durable store for platform/RSI/approval records. Ephemeral caches are disposable; never claim that an in-memory queue survives process loss.
- Keep source agent, tenant/access boundary, logical workspace, storage binding, target repository, human actor, and recorder identities distinct.
- Trust host-authenticated identity and configured policy, not model-authored identity, routing, or approval text. Check access before loading restricted context.
- SDK code alone does not isolate an agent that can execute arbitrary code with the same privileged credentials. Verify the existing host's tool/credential boundary; protected operations run there through SDK implementations, without requiring a new standalone service.
- Keep evidence, candidate, human approval, application/merge, accepted baseline, workflow transition, release, adoption, and measured benefit distinct.
- Automatic capture applies only to eligible completed delivery responses. A separate, initially human-triggered Dreaming Agent cannot approve, merge, deploy, or widen permissions for itself.
- Use existing BRD drafts only as a workspace/approval example. No BRD-authoring agent, Jira integration, new UI, RAG stack, model-weight training, or research reproduction is required.
- Preserve historical documents, schemas, examples, and unsuccessful/contradicted evidence. Introduce versioned successors where contracts change.
- Protected effects fail closed on missing durable authorization. Capture failures remain independently visible from delivery-task outcomes.
- Use test-first development for state, I/O, retries, authorization, hooks, and errors; enumerate edge cases before writing tests. Test public effects with concrete assertions.
- No automatic push, production rollout, permission expansion, or wholesale replacement of repository instruction files.

## Review focus

| Failure class | Expected result | Owning task |
| --- | --- | --- |
| Two agents write the same workspace/capture after a timeout | One identity/result, no lost record, no fabricated durability | STORE-01, WS-01, CAP-02 |
| Shared installation accidentally enables capture in dreaming/evaluation | No recursive capture or ordinary delivery observations from those calls | CAP-02, DIST-01 |
| Model emits plausible but unauthorized provenance or approval | Reject before admitting evidence or applying effects | CORE-01, CAP-01, APP-01 |
| Human reviewed one revision but code/policy/dependencies change | Historical decision retained; current applicability fails | APP-01, APP-02, RSI-02 |
| Kit release is mistaken for consumer adoption or benefit | Pinned consumers unchanged; adoption, outcome, and rollback recorded separately | RSI-03 |

## Task 0: INT-00 — map onto the actual SDK, without redesigning it

**Owner:** receiving Copilot session. **Dependency:** none. **Deliverable:** `docs/planning/sdk-platform-integration-map.md` in the destination source checkout.

The planning folder intentionally does not contain the SDK. This task resolves native filenames and command prefixes; it is not a request to send source code back to the planning session. Existing behavior that already satisfies a task should be verified and reused, not rebuilt.

- [ ] Read destination instructions, inspect branch/status and uncommitted changes, and identify the package root and existing consumer(s). Do not reset, move, or overwrite local work.
- [ ] Record existing interpreter constraints, package/dependency commands, test invocation, lint/format commands, CI gates, agent initialization, skill resource loader, completed-response callback, auth context, GitHub adapter, and release/adoption mechanism.
- [ ] For every capability ID below, record: native source modules/symbols; existing or proposed test paths; implemented/partial/missing status; integration seam; and exact targeted/full/lint/format/smoke commands. Reuse existing contracts or add narrow adapters where semantics match.
- [ ] Run the existing baseline tests/checks appropriate to the touched SDK area; record pre-existing failures separately. Do not fix unrelated failures or upgrade Python to make the plan fit.
- [ ] Map the semantic names and test examples in this document onto the SDK's native APIs. Naming/layout differences are routine integration work, not grounds for another scope interview.

**Completion evidence:** every later task resolves to concrete source/test paths and runnable native commands, and the chosen real consumer is named. If a capability is missing, its owning task implements it. Escalate only an actual conflict in product scope, authorization, data boundaries, or a required unsupported capability.

### Responsibility map for new or extended code

These are module responsibilities, not claims about current SDK filenames. INT-00 supplies exact existing/new paths. Keep related functions together under the SDK's established conventions; do not create a second parallel SDK namespace.

| Capability | Source responsibility | Proposed test filename if no equivalent exists |
| --- | --- | --- |
| CORE-01 | Public records, trusted context, versioning, canonical identity/digests, policy lookup | `tests/platform/test_contracts.py` |
| STORE-01 | GitHub durable records, idempotency, conflict/reconciliation, receipts | `tests/platform/test_store.py` |
| WS-01 | Workspace resolution, authorized bindings, checkpoints/questions, resume | `tests/platform/test_workspace.py` |
| CAP-01 | Capture schema successor, evidence admission, minimization/redaction | `tests/platform/test_capture_admission.py` |
| CAP-02 | Completed-response adapter, installed capture skill/prompt, replay/checkpoint coordination | `tests/platform/test_capture_hook.py` |
| APP-01 | Shared approval requests, evidence verification, deterministic applicability | `tests/platform/test_approval.py` |
| APP-02 | Protected effect coordination, application recovery, baseline/transition records | `tests/platform/test_application.py` |
| RSI-01 | SDK evidence querying/candidate records; separate Dreaming Agent orchestration | `tests/platform/test_dreaming.py` |
| RSI-02 | SDK ownership registry/evaluation/PR coordination; Dreaming Agent uses those services | `tests/platform/test_improvement.py` |
| RSI-03 | SDK promotion, release/adoption/feedback/rollback records | `tests/platform/test_promotion.py` |
| DIST-01 | Existing SDK initialization, packaged assets, consumer compatibility | `tests/platform/test_distribution.py` |
| VERIFY-01 | Contract/integration fixtures and gated live-provider journey | `tests/platform/test_acceptance.py` |

Use the current test-root convention if it differs; record the translation once in the integration map. Dreaming's orchestration belongs in its existing/separate agent package; shared functions still belong in the SDK.

## Semantic contracts to implement or map

The signatures below define required behavior, not a mandatory new API naming scheme. Native classes versus dictionaries, sync versus async, and constructor conventions follow the SDK. Do not add an HTTP service solely to expose these operations.

| Contract | Input authority and result |
| --- | --- |
| `Workspace.resolve(anchor, context) -> WorkspaceBinding` | Host-authenticated context; unique authorized anchor mapping or explicit ambiguity/access failure. |
| `Workspace.create(operation_id, context) -> WorkspaceBinding` | Explicit provisional intake; absence of business ownership permits drafts but blocks protected progress. |
| `Workspace.checkpoint(workspace_id, expected_revision, progress, operation_id, context) -> Receipt` | Conditional update of concise progress/questions/references; stale writes conflict. |
| `Workspace.resume(workspace_id, context) -> ResumeState` | Accepted revisions, pending drafts/questions/gates, incomplete operations, next permitted actions, and evidence receipts. |
| `Store.put(record_id, payload, scope, operation_id) -> Receipt` | Atomic durable record or identical replay; changed bytes under one identity conflict. |
| `Store.lookup(record_id, scope) -> StoredRecord or Missing` | Read only within authorized binding; distinguish verified absence from provider outage. |
| `Approval.request(subject, effect, operation_id, context) -> ApprovalRequest` | Policy resolved from trusted scope; immutable reviewed subject, not a caller-selected weaker gate. |
| `Approval.refresh(request_id, context) -> Evaluation` | Host-only verifier fetches current human evidence; no client-supplied verified flag. |
| `Approval.authorize(request_id, expected_digest, operation_id, context) -> Authorization` | Host-only, effect-scoped, revision-bound, durably recorded authorization after fresh checks. |
| `Application.apply(authorization, operation_id, context) -> ApplicationResult` | Trusted executor revalidates and records the observed effect; reconciliation before ambiguous retries. |
| `Capture.on_completed(event, context) -> CaptureResult` | Trusted callback verifies eligibility, extracts/admit/persists once, and reports capture status separately. |
| `Capture.admit(output, capture_context, evidence_registry) -> CaptureRecord` | Model output contains observations only; context/provenance/authority supplied by trusted sources. |
| `Dreaming.run(run_spec, context) -> RunResult` | Separate agent; bounded authorized evidence set, possibly no candidate or unresolved owner. |
| `Improvement.prepare(candidate_id, context) -> ProposalResult` | Verified target and evaluation scope, bounded diff, no implicit promotion; idempotent PR creation. |
| `Promotion.record_release`, `record_adoption`, `record_outcome`, `record_rollback` | Independently verified facts linked to exact candidate/revision/version/consumer; no inferred adoption. |

### Record requirements

- **Trusted context:** tenant/access-boundary, stable actor identity, actor kind, agent identity/group, run/session/event, and effective policy references. Runtime owns its construction/verification. Model-call arguments cannot overwrite it.
- **Workspace binding:** stable workspace ID, immutable external anchor identity where present, storage binding identity, permitted repository/path scope, ownership status, and policy references. Human display labels are not identities. Splits/attachments record lineage explicitly; ambiguous anchors are not guessed.
- **Subject:** kind (`lifecycle`, `decision_action`, `improvement`), workspace/target scope, initiating actor, artifact path/content digests/revisions, relevant dependencies, policy revision, requested effect/parameters, and validity/reuse rules. An improvement additionally binds target base/head, evaluation result IDs, and evaluator/policy revisions.
- **Decision/evaluation:** human decision records retain source identity/revision/time; derived evaluation reports `pending`, `satisfied`, `blocked`, or `stale` with reasons and exact subject digest. Evidence is never rewritten into a fabricated approval.
- **Authorization:** operation ID, subject digest, effect/destination, policy reference, verified evidence, and consumption state. Initial protected applications are single-use per operation; another effect needs another authorization.
- **Receipt:** provider/repository ID, branch/ref, record path, commit OID, payload digest, and replay indicator. A pending/error result cannot carry a success receipt.
- **Operational event:** version, stable event ID, scope, actor and recorder, operation/correlation/causation references, trusted timestamp, and canonical payload. Event identity includes event kind and stable occurrence as well as operation ID, so multiple reviews in one refresh do not collide.
- **Capture successor:** preserve the v1 observation vocabulary; add explicit tenant/access/workspace/binding provenance in a separately versioned stored-envelope schema. Source agent snapshot, source event, kit version, extractor/prompt version, and redacted evidence remain separate. Historical v1 records load as lacking verified logical-workspace provenance; do not invent that provenance or admit them into another scope silently.
- **Candidate/evaluation/promotion:** evidence IDs, incident grouping, scope, ownership status, hypothesis/downside, target revision, behavioral cases/results, review reference, released version, consumer identity/adopted version, observed outcome, and rollback reference. Each fact has its own record and authority check.

Reuse an existing equivalent canonicalization if tested. Otherwise define canonical JSON with sorted string keys, UTF-8, no BOM/insignificant whitespace, deterministic array ordering per contract, and no floats/duplicate keys/invalid Unicode. Hash exact artifact bytes separately. Add one shared byte-and-digest fixture. Never embed a containing commit's OID in its own contents; return it in the receipt. Reviewed manifests bind declared data first; the full subject adds the resulting reviewed revision afterward.

**Public error categories:** invalid input, unauthenticated, inaccessible/not found, ownership unresolved, ambiguous mapping, stale subject, approval unsatisfied, revision conflict, identity conflict, provider unavailable, outcome unknown. Native exception names may differ, but retryability and any already-observed side effect must remain explicit. Do not leak restricted identifiers through error messages/logs.

## Verification convention for every implementation task

INT-00 records the SDK's actual runner. The task filenames and test names below define targeted invocations: run that named test through the recorded runner for RED, then the owning test file for GREEN. Use the existing environment, not a newly selected Python version. Each implementation task follows these steps:

1. Enumerate its listed boundaries/errors and add any discovered native-runtime edge case.
2. Write one observable-behavior test per case (parameterize equivalent cases); run the named new test and verify the intended failure before implementation.
3. Implement the smallest SDK change/adapter that passes; keep provider/model/clock fakes at boundaries, not inside the function under test.
4. Run its targeted tests, relevant existing consumer tests, lint, and formatter check. Wiring/schema/config changes also run the mapped SDK/consumer boot smoke.
5. Record RED/GREEN commands/results, actual paths, and remaining limitations. Review nontrivial code, update only verified checkboxes, and use the repository's authorized commit workflow. Include `tests catch:` or an applicable documented exemption in commit bodies touching tests.

Full-suite checks precede branch integration. Python line/branch coverage at least 80% is a CI/repository floor; do not add meaningless assertions to hit it per task. Mutation testing applies to the core approval decision logic and periodic runs, not every documentation/task change; inspect and resolve every survivor. Use the repository's supported mutation environment rather than changing Python. No tests or live-provider actions are required in this planning session.

The test snippets below are semantic public-surface examples. INT-00 binds their `env` fixture to the native SDK. `env` supplies two authenticated actors, one inaccessible actor, isolated repositories, deterministic clock/model/provider fakes, and captured public provider effects. Result-field spellings are mapped once; do not introduce product APIs merely to match these snippets. Fixture counters measure calls at injected provider/model boundaries, not private implementation details.

### Concrete fixture set

Keep test authority separate from real deployment authority. These synthetic values are test inputs, not production policy.

| Fixture | Fixed input and observable expectation |
| --- | --- |
| Shared case | Actors A/B can access tenant T and anchor G-101; both resolve workspace W-101. Anchor G-102 resolves a different workspace. Actor C cannot read either. |
| Provisional case | No owner role is configured; storing a draft succeeds, authorizing its acceptance returns ownership-unresolved. |
| Capture evidence | Authorized message E-1 states a correction; E-X is absent and E-OTHER belongs to another access boundary. Only E-1 can support an admitted observation. |
| No signal/boundary | Zero observations gives `no_observations` and zero stored excerpts. Ten valid observations are accepted; eleven fail structural validation. |
| Redaction | Inject marker `TEST_SECRET_DO_NOT_STORE` into an excerpt and a summary. It must occur in neither persisted payload nor logged/returned diagnostics; rejection is acceptable if safe redaction loses attribution. |
| Replay | Event R-1 with extractor X-1 is committed once; replay reuses its capture/receipt. X-2 creates a distinct extraction of the same incident, not a second independent incident. |
| Capture exclusion | Each of capture/distillation/evaluation/replay and Improvement-group final events yields zero extractor invocations and zero ordinary capture writes. |
| Distinct humans | A policy requires two distinct reviewers. Two approvals from B do not satisfy it; current approvals from B and D do. A bot recorder is not either reviewer. |
| Freshness | Subject H-1/dependency D-1/policy P-1 is reviewed. Change each covered value independently and expect stale applicability; change a display-only label and retain applicability. |
| Recovery | Inject failure after the provider merges but before baseline storage. Reconcile to one observed merge, one accepted-baseline event, and one separately recorded transition. |
| Evaluation | Candidate removes redundant questions on confirmed facts but also suppresses a necessary question on missing facts. The negative case fails and no satisfied improvement authorization is issued. |
| Adoption | Consumer A stays on kit K-1 after release K-2; explicit verified adoption changes A only. Verified rollback restores K-1; consumer B's recorded version never changes implicitly. |

Bind helpers in the snippets to these fixtures. `new_sdk_session` discards process caches while retaining only fake-provider durable state; failure injection operates at provider/store boundaries. `add_human_review` supplies a trusted-provider response fixture, never a public agent API for inventing approval. Candidate/authorization fixtures are built through the earlier public tasks rather than bypassing their validation.

## CORE-01 — contracts, trusted scope, and compatible SDK initialization

**Depends on:** INT-00. **Consumes:** current initialization/auth/config interfaces. **Produces:** the records/errors above, canonical identities/digests, and platform capability access through current SDK initialization.

**Edge cases:** absent/forged context; unknown schema; optional workspace on historical capture; invalid/duplicate JSON keys; Unicode/newline differences; array ordering; self-referential commit; missing capability configuration. New SDK import must not perform network writes or demand privileged credentials for disabled capabilities.

- [ ] RED: `test_model_scope_cannot_override_runtime_scope` and parameterized schema/canonicalization cases in `test_contracts.py`.

```python
def test_model_scope_cannot_override_runtime_scope(env):
    output = {"observations": [], "tenant_id": "another-tenant"}
    result = env.contracts.validate_extractor_output(output)
    assert result.error_code == "invalid_input"
    assert env.provider.writes == []
```

- [ ] Implement trusted-context construction at the existing host boundary, strict input/output schema separation (including `validate_extractor_output` mapped to the SDK's validator), version handling, and canonical digest fixture. Semantic evidence admission belongs to CAP-01. Package capabilities under existing SDK initialization; no duplicate bootstrap framework.
- [ ] GREEN: contract file plus existing initialization/public-import tests. Assert installed version/provenance and that disabled capabilities cause zero network effects.

**Done:** existing consumers still initialize unchanged; model output cannot manufacture trusted context; historical records retain honest provenance status.

## STORE-01 — durable records and retry/reconciliation

**Depends on:** CORE-01. **Consumes:** trusted storage bindings, native GitHub adapter. **Produces:** `Store.put/lookup`, receipts, conditional event batches, and recoverable operation records.

**Edge cases:** identical replay; changed payload/actor under an operation key; multiple logical events per operation; competing ref updates; response lost before/after commit; deleted/rewritten control history; permissions failure; rate limits; first-write outage; timestamps regenerated on retry.

- [ ] RED: `test_same_record_replay_preserves_commit`, `test_changed_payload_conflicts`, `test_multi_review_events_do_not_collide`, and fault cases in `test_store.py`.

```python
def test_same_record_replay_preserves_commit(env):
    first = env.store.put("event-1", {"value": 7}, env.scope, "op-1")
    again = env.store.put("event-1", {"value": 7}, env.scope, "op-1")
    assert again.commit_oid == first.commit_oid
    assert again.replayed is True
    assert env.provider.record_count("event-1") == 1
```

- [ ] Extend the writer to commit records, operation progress, and relevant indexes atomically. Build against an observed parent; use non-forced conditional ref advancement, reread/recompute on conflicts, and preserve both independent events. Do not assume a local mutex coordinates all installed agents.
- [ ] Freeze admitted payload/timestamps for attempts; after ambiguous completion, look up deterministic identities before retrying. Persist intents before non-idempotent external effects; distinguish verified absence from failed lookup. Bound attempts/deadlines using existing configuration, and report exhausted/unknown outcomes explicitly.
- [ ] Protect authoritative record writes in the trusted host/provider configuration; an agent importing the SDK must not acquire arbitrary record-writing credentials. No forced ref rewrite or silent overwrite repair.
- [ ] GREEN: writer file and adapter contracts, including a committed-but-response-lost replay. Run mapped provider-adapter smoke; record live permission checks for VERIFY-01 if external access is not yet provisioned.

**Done:** public results distinguish durable success, replay, conflict, and uncertainty. No test claims lossless recovery of payloads that never reached a durable source.

## WS-01 — shared workspace, questions, and resume

**Depends on:** CORE-01, STORE-01. **Consumes:** trusted anchor/policy resolution and conditional persistence. **Produces:** `Workspace.resolve/create/checkpoint/resume`.

**Edge cases:** same anchor across agents/sessions; distinct cases in one repository; missing/ambiguous anchor; provisional owner; unauthorized tenant; rename aliases; conflicting checkpoint answers; split/attach lineage; restart; missing or unknown event versions.

- [ ] RED: `test_two_agents_resolve_one_case`, access/ambiguity cases, and `test_restart_retains_pending_question` in `test_workspace.py`.

```python
def test_two_agents_resolve_one_case(env):
    first = env.workspace.resolve(env.anchor, env.actor_a)
    second = env.new_sdk_session().workspace.resolve(env.anchor, env.actor_b)
    assert second.workspace_id == first.workspace_id
    assert env.provider.anchor_mapping_count(env.anchor) == 1
```

- [ ] Implement explicit ID/anchor resolution and atomic uniqueness with the store; allow provisional cases without silently treating unresolved ownership as permission. Separate source repo and logical workspace/binding.
- [ ] Persist concise progress, questions/answers, accepted references, and pending work using expected revisions. On conflicts, preserve the submitted work and report the current revision; no last-write-wins replacement of another answer.
- [ ] Rebuild resume state from authoritative records; keep draft, approved, applied, and transitioned states separate. Bind split/attach operations to explicit lineage and authorization, not label changes.
- [ ] GREEN: workspace file, concurrent first-resolution fault test, restart test, and existing context/agent resume checks.

**Done:** two consumers share one authorized case safely; neither local cache nor scratch text can manufacture an accepted baseline.

## CAP-01 — workspace-aware capture contract and admission

**Depends on:** CORE-01, WS-01. **Consumes:** trusted completed-event context, an authorized evidence registry, and extractor output. **Produces:** `Capture.admit` and a separately versioned stored capture schema/resource in the SDK.

Use [capture output v1](../../rsi/schemas/capture-output.schema.json), [stored capture v1](../../rsi/schemas/capture-record.schema.json), and the [capture design](../../rsi/03-conversation-capture.md) as preserved inputs. Retain the output's six signal types, zero-to-ten observations, reference limits, and verification-state conditions unless an explicit new version changes them. The stored-envelope successor adds logical workspace/access/binding provenance; do not edit historical v1 fixtures to pretend they already contain it.

**Edge cases:** empty observations; maximum observation count and one over; empty/oversized fields; unknown fields; fabricated or cross-workspace evidence; unverifiable recovery; secrets in excerpts and summaries; invalid Unicode; injected instructions; later contradiction; legacy envelope without logical scope; source/target repository confusion.

- [ ] RED: `test_unknown_evidence_is_rejected_before_write`, schema boundary cases, and `test_no_signal_is_valid_empty_capture` in `test_capture_admission.py`.

```python
def test_no_signal_is_valid_empty_capture(env):
    record = env.capture.admit(
        {"observations": []}, env.capture_context, env.evidence_registry
    )
    assert record.outcome == "no_observations"
    assert record.observations == []
    assert record.evidence == []
    assert record.workspace_id == env.workspace_id
```

- [ ] Validate structure before semantic admission. Resolve every supporting/contradicting/verification reference through the authorized registry, not strings in model output. Resolve `related_observation_ids` against stored observations with the same existence/access checks; test both a fabricated ID and a real ID from an inaccessible workspace. Reject the whole envelope on an invalid observation/reference; never persist a partial envelope as successful capture.
- [ ] Apply evidence minimization and redaction before sending context to extraction and again across every string field before persistence. Omit unnecessary excerpts; reject if safe attribution cannot be retained. An injected instruction stays evidence text and cannot alter policy, routing, or tool permissions.
- [ ] Stamp identities, source versions, extractor version, received time, and record IDs from trusted context. Group identical source incidents across extractor versions without treating re-extraction as independent evidence. Later correction/contradiction appends a linked observation; it does not delete earlier evidence.
- [ ] Read legacy records with explicit unknown logical scope; they cannot be exported or used to authorize another workspace without a verified migration mapping. Unknown versions fail explicitly. Record access/retention policy in the binding; Git history means deleting a current file is not a guarantee of historical erasure.
- [ ] GREEN: admission/schema fixtures, property tests for provenance non-overridability, redaction, and deterministic IDs. Preserve the five historical RSI example files unchanged.

**Done:** admitted captures are scoped evidence, never approved requirements, and the writer receives only validated redacted envelopes.

## CAP-02 — common response hook and durable capture lifecycle

**Depends on:** CAP-01, STORE-01. **Consumes:** actual host completed-response callback, configured extractor, evidence registry, and store. **Produces:** `Capture.on_completed`, packaged shared skill/prompt, explicit capture status/checkpoints.

Use the existing model client and resource/skill loader. Package the [capture skill](../../rsi/skills/conversation-capture/SKILL.md) and [prompt](../../rsi/prompts/capture-system.md) through the SDK's existing distribution mechanism, with version metadata. Do not create a second LLM stack or treat a copied skill file as proof of invocation.

**Edge cases:** streaming fragments; eligible final event; duplicate callback; repeated SDK initialization; capture calling a model; improvement/evaluation/replay calls; no signal; malformed extraction; model timeout; provider unavailable; committed write whose response is lost; missing replay source after restart.

- [ ] RED: `test_capture_calls_do_not_recapture`, `test_committed_duplicate_skips_extractor`, and interruption cases in `test_capture_hook.py`.

```python
def test_committed_duplicate_skips_extractor(env):
    first = env.capture.on_completed(env.delivery_event, env.delivery_context)
    again = env.capture.on_completed(env.delivery_event, env.delivery_context)
    assert again.capture_id == first.capture_id
    assert again.receipt.commit_oid == first.receipt.commit_oid
    assert env.extractor.calls == 1
```

- [ ] Register once per active runtime boundary. Eligibility requires trusted `task_execution`, a completed response, an enabled delivery group, and an authorized binding. Exclude `capture`, `distillation`, `evaluation`, `replay`, and Improvement-group calls before invoking extraction. Missing trusted purpose fails eligibility explicitly rather than defaulting to capture.
- [ ] Derive capture identity from trusted scope/source/session/event/extractor version. Before extracting, check for an already committed capture and compare the source fingerprint, including the trusted input/evidence snapshot and extractor configuration version. An identical event returns its receipt; changed source content under the same event identity is an integrity conflict.
- [ ] Handle overlapping callbacks from different SDK instances. Reuse existing host coordination if available; otherwise permit redundant extraction but converge on the first valid committed envelope. If a put loses to another capture, re-read it and compare trusted scope, source fingerprint, and extractor version. For an identical source, return the committed winner's receipt without overwriting it, even if the losing extraction produced different observations. A different source remains an integrity conflict. Add `test_concurrent_capture_converges_on_committed_winner`, asserting one envelope and identical receipts; do not promise exactly one model call for simultaneous initial attempts.
- [ ] Extract once for the current attempt, admit through CAP-01, and persist through STORE-01. Advance the capture checkpoint only after receipt verification. Persist empty envelopes for eligible no-signal events so replay does not repeatedly extract them.
- [ ] Preserve the original delivery result when capture fails, returning a separate typed capture failure with retry/replay information. Bound extraction/write latency and attempts using existing runtime configuration; report timeout/rate-limit outcomes without an unbounded blocking loop.
- [ ] Reconcile ambiguous writes before repeating them. Reuse committed output on retry. If extraction never became durable and process memory is gone, re-extraction is permitted only from an authorized replayable source; record that recovery path. Without such a source, report unrecoverable capture loss, not exactly-once extraction or lossless delivery.
- [ ] GREEN: hook file, the actual first consumer's completed-response integration, and startup/shutdown/cancellation tests for the existing runtime model. Assert the same consumer's normal output is unchanged under capture-storage failure.

**Milestone M1:** one existing delivery consumer produces workspace-bound capture, valid no-signal outcomes, honest failure state, and restart/retry behavior. This is the smallest integrated result; it does not complete approval or dreaming.

## APP-01 — one shared approval service and verified human evidence

**Depends on:** CORE-01, STORE-01, WS-01. **Consumes:** configured role policy, subject snapshots, current dependencies, native evidence adapter. **Produces:** `Approval.request/refresh/authorize` and immutable evidence/evaluation records. APP-01 can be developed independently of CAP-01/CAP-02 once its dependencies are ready.

**Edge cases:** missing ownership; unknown actor; bot recorder; self-approval forbidden by policy; same human counted twice; multi-role overlap; comments versus decisions; dismissed/pending/older reviews; incomplete pagination; changed head/content/dependency/policy; unrelated uncovered metadata change; approval service/storage outage.

- [ ] RED: `test_changed_subject_invalidates_approval`, distinct-person/role cases, and fabricated-evidence cases in `test_approval.py`.

```python
def test_changed_subject_invalidates_approval(env):
    request = env.approval.request(
        env.subject_v1, env.accept_effect, "approval-op", env.actor_a
    )
    env.provider.add_human_review(request.id, env.reviewer_b, env.subject_v1)
    assert env.approval.refresh(request.id, env.actor_a).status == "satisfied"
    env.provider.replace_subject(env.subject_v2)
    assert env.approval.refresh(request.id, env.actor_a).status == "stale"
    assert env.provider.merge_calls == []
```

- [ ] Resolve policy from trusted workspace/target scope. Construct the fixed subject/digest and persist the request. Validate all covered artifacts and effects; no proposal may select weaker policy or add its own reviewer authority.
- [ ] Fetch authenticated human decisions through the host's provider adapter. Record reviewer separately from recorder, bind reviewed revision, and retrieve complete evidence. Ignore non-decisive comments/pending reviews; a dismissed/outdated approval counts zero. A later decisive decision replaces that person's current applicability without deleting prior records. Active required-reviewer change requests block the effect.
- [ ] Count distinct eligible humans according to policy, including cross-role distinctness where required. Recompute applicability from current subject/dependencies/policy and verified evidence; never admit a model's `approved=true` or a client-supplied verified-evidence payload.
- [ ] Use the same mechanism for lifecycle, scoped decision/action, and improvement requests, but separate policy and effect scopes. Bind action destination/parameters/reuse; permit only registered effects. No generic arbitrary-command executor is introduced.
- [ ] GREEN: approval file and adapter contracts. Run mutation analysis of core applicability/authorization decisions in the supported environment; kill or explain survivors. Verify historical human decisions remain inspectable after staleness.

**Done:** deterministic applicability is independent from application, and a valid approval in one scope cannot authorize another scope's effect.

## APP-02 — protected application, scoped decisions, and recovery

**Depends on:** APP-01, STORE-01, WS-01. **Consumes:** revision-bound authorization and trusted effect adapter. **Produces:** observed application result, accepted baseline/decision, separate transitions, and recovery.

**Edge cases:** satisfied approval without merge; changed head immediately before merge; dependency/policy drift; concurrent applications; repository protection refusal; lost merge response; merge succeeded but baseline event failed; baseline succeeded but transition failed; manual/out-of-band merge; unresolved scoped decision; retry after authorization consumption.

- [ ] RED: `test_merge_then_record_failure_recovers_once`, `test_unmerged_approval_is_not_baseline`, and concurrency cases in `test_application.py`.

```python
def test_merge_then_record_failure_recovers_once(env):
    env.fail_next_baseline_write()
    result = env.application.apply(env.authorization, "apply-op", env.actor_a)
    assert result.status == "outcome_unknown"
    resumed = env.new_sdk_session().reconcile("apply-op", env.actor_a)
    assert resumed.accepted_revision == env.provider.actual_merge_revision
    assert env.provider.merge_count == 1
    assert env.provider.event_count("baseline.accepted", "apply-op") == 1
```

- [ ] First acquire the effect-scope reservation. Serialize protected applications sharing an accepted-artifact repository through an existing trusted host mechanism or a durable conditional operation reservation in the SDK store. Acquisition is atomic across agents; a crashed owner is reconciled before release, never unlocked solely because a timer expired. Test two SDK instances contending for the same effect scope.
- [ ] While holding the reservation, recheck actor access, full subject/diff, current policy/dependencies, reviewer evidence, and expected baseline. Require the authorization's operation ID/effect/destination to match the application. Atomically persist its single-use reservation/consumption together with the application intent before invoking the external adapter. Same-operation recovery reconciles the existing intent; another operation cannot reuse that authorization. Add tests for two operation IDs presenting one authorization and a waiting operation whose baseline changes before it acquires the reservation.
- [ ] Use the provider's expected-revision guard and required native protections. The SDK coordinator cannot atomically transact arbitrary policy changes with an external merge; document trusted-writer assumptions and reject unexpected observed results. Model-callable wrappers cannot invoke the internal executor with fabricated authorization.
- [ ] Record actual merge/application separately from accepted baseline and subsequent transition. Verify the effect's exact revision/content before baseline acceptance. Approval with no merge is not a baseline. Unexplained out-of-band changes require explicit reconciliation rather than automatic acceptance.
- [ ] Recover missing records once using deterministic operation/event identities and durable intent. Preserve uncertainty if the provider cannot establish the outcome. A scoped decision updates only its own accepted revision and declared dependents; it does not globally block unrelated work or advance a lifecycle stage automatically.
- [ ] GREEN: application file, public resume integration, provider refusal/fault fixtures, and mapped application smoke. Record live branch-rule checks separately for VERIFY-01.

**Milestone M2:** an existing draft can receive actual human review, apply only the reviewed effect, and resume correctly after partial failure. Shared mechanism covers standalone scoped decisions without requiring a new drafting agent.

## RSI-01 — bounded dreaming over authorized evidence

**Depends on:** CAP-02, WS-01, STORE-01; APP-01 supplies the later improvement gate. **Consumes:** admitted captures, authorized registry/policy, and bounded run specification. **Produces:** SDK evidence-query/candidate-record capabilities and the separate Dreaming Agent workflow.

**Edge cases:** no evidence; insufficient independent incidents; same incident extracted twice; conflicting later evidence; cross-workspace access; project-local policy versus reusable improvement; unknown owner; an exhausted run/model budget; rerun after candidate-record failure.

- [ ] RED: `test_unknown_owner_creates_no_target_change`, duplicate-incident grouping, and no-candidate cases in `test_dreaming.py`.

```python
def test_unknown_owner_creates_no_target_change(env):
    env.registry.remove_owner(env.behavior_id)
    result = env.dreaming.run(env.bounded_run, env.improvement_context)
    assert result.candidates[0].routing_status == "unresolved"
    assert env.provider.target_branches == []
    assert env.provider.pull_requests == []
```

- [ ] Expose SDK reads constrained by scope, snapshot/window, and capture count. A run specification must contain finite evidence/model-call/candidate/time limits; absent or exhausted limits stop the run explicitly. Use a test run of at most 20 captures, 3 model calls, and 1 candidate; these are fixtures, not imposed production policy.
- [ ] In the separate Dreaming Agent, group source incidents, retain contradictions and failed attempts, and distinguish local project knowledge from an agent/kit behavior defect. Model inference produces hypotheses, not validated causal truth or automatic authority.
- [ ] Produce a candidate with evidence, affected scope, hypothesis, downside, proposed behavior, target ownership status, and positive/negative evaluation cases. `no_candidate`, `insufficient_evidence`, and `unresolved_owner` are valid persisted outcomes. A second interpretation of one incident is not a second independent success.
- [ ] Route through the trusted registry: source-agent repo, workspace repo, and change-target repo can differ. Default one target per candidate revision. Cross-repository kit/consumer changes require linked candidates/PRs with explicit ordering, not an invented atomic transaction.
- [ ] Persist run/candidate progress so restart resumes the same run and candidate IDs. Dreaming model calls use trusted Improvement/distillation purposes and do not feed ordinary capture.
- [ ] GREEN: dreaming file, scope/incident/cost-boundary fixtures, restart tests, and separate-agent initialization through the SDK.

**Done:** a bounded run produces a traceable candidate or an explicit non-candidate outcome without guessed ownership or credential expansion.

## RSI-02 — evaluation and reviewable target PR

**Depends on:** RSI-01, APP-01, STORE-01. **Consumes:** candidate, target registry, target base revision, trusted evaluation runner. **Produces:** evaluation records bound to a concrete patch/head and an idempotently created target PR.

**Edge cases:** allowed behavior fix; already-present fix; wrong target; unsupported evaluation runner; path outside allowed scope; proposal weakens mandatory checks; self-assessment claims success; positive case passes but negative case regresses; evaluated head changes; PR response lost; duplicate target branches; target base drifts.

- [ ] RED: `test_lost_pr_response_reconciles_existing_pr` and `test_changed_evaluated_head_requires_new_evaluation` in `test_improvement.py`.

```python
def test_lost_pr_response_reconciles_existing_pr(env):
    env.provider.lose_next_pr_response_after_creation()
    first = env.improvement.prepare(env.candidate_id, env.improvement_context)
    assert first.status == "outcome_unknown"
    retried = env.improvement.prepare(env.candidate_id, env.improvement_context)
    assert retried.pr_id == env.provider.created_pr_id
    assert env.provider.pr_count == 1
```

- [ ] Implement SDK target verification, bounded proposal metadata, and PR coordination; the separate agent supplies the candidate/patch intent. Use isolated target work according to the target repository's rules. Do not rewrite unrelated work or let a model choose arbitrary repository URLs/paths.
- [ ] Verify the existing evaluator runs candidate-controlled code/tests without provider writer tokens, production secrets, or unauthorized network/filesystem access. Load mandatory evaluation gates from a trusted pinned revision outside the candidate's control. A separate checkout alone does not establish this isolation. Add a negative fixture attempting credential/gate access. If the existing runner cannot enforce this boundary, record a required integration capability and prevent evaluation/promotion through that unsafe runner; do not introduce a replacement platform silently.
- [ ] Run baseline and candidate through the trusted evaluator on a declared test set, recording exact revisions, evaluator version, environment identity, cases/results, and cost/latency where applicable. For a redundant-clarification candidate, include already-confirmed, genuinely missing, contradictory, outdated, and unauthorized cross-workspace information. Fewer questions alone is not a pass condition.
- [ ] Require all mandatory positive/negative/invariant cases to pass and no newly failing required regression. Any additional quality threshold belongs in the versioned evaluation policy; do not transplant a paper's threshold. A runnability-only check or model's own success claim is insufficient.
- [ ] Reject ordinary candidate changes that alter authority, credentials, ownership policy, or mandatory evaluation gates; retain the candidate for a separately governed maintainer path. Dreaming self-modification is not implicitly enabled.
- [ ] Persist intent before branch/PR creation, derive a stable proposal key, and reconcile matching target/head/base before retry. Multiple conflicting matches remain unresolved. Keep evaluation/review evidence in control records so recording it does not change the reviewed PR head.
- [ ] Request improvement approval through APP-01 bound to target base/head/diff, evaluation records, policy, and requested effect. Any covered revision change invalidates relevant evaluation/review; rerun and request fresh approval rather than silently carrying it forward.
- [ ] GREEN: improvement file, provider adapter contracts, target path/policy rejection tests, and evaluator comparison fixture with an intentional negative-case regression.

**Milestone M3:** one candidate becomes a bounded evaluated PR in the verified target repository, or a recorded rejection/unresolved outcome. The Dreaming Agent has not approved, merged, or deployed it.

## RSI-03 — human promotion, release, adoption, and rollback

**Depends on:** RSI-02, APP-02. **Consumes:** exact improvement approval, trusted application/release adapters, consumer registry. **Produces:** separately verified promotion/release/adoption/outcome/rollback records in the SDK.

**Edge cases:** self-approval; delivery approver lacks kit authority; approved PR unmerged; merged but unreleased; released but consumer pinned; some consumers upgrade and others do not; unverifiable version report; regression after adoption; failed or partial rollback; interrupted lifecycle-record write.

- [ ] RED: `test_release_does_not_implicitly_upgrade_consumer`, scope-authority rejection, and `test_verified_rollback_restores_known_good_version` in `test_promotion.py`.

```python
def test_release_does_not_implicitly_upgrade_consumer(env):
    before = env.consumer_a.installed_kit_version
    env.promotion.record_release(env.verified_release, env.maintainer_context)
    assert env.consumer_a.installed_kit_version == before
    assert env.promotion.adoptions_for(env.verified_release.id) == []
```

- [ ] Reuse APP-02 for authorized target application. Require the correct target-maintainer policy; a business artifact approver or the Dreaming Agent cannot authorize kit-wide change by borrowing another scope's decision.
- [ ] Observe/verify release through the existing release machinery and persist its exact revision/version. Do not add automatic publishing credentials or a replacement release system. Merge, release, and acceptance of an evaluation remain distinct.
- [ ] Use the existing explicit consumer upgrade mechanism. Verify adopted SDK/prompt/skill versions from trusted runtime/install evidence and record each consumer independently. SDK version selection here is package adoption, not a Python interpreter change.
- [ ] Record measured post-adoption outcomes with evidence and comparison scope; adoption is not proof of benefit. Preserve contradictory/regression reports and route them to the relevant candidate/release.
- [ ] Reuse the normal scoped approval mechanism for rollback when policy requires it; bind consumer and known-good version. Apply through the existing upgrade mechanism, verify actual restored version and the regression case, and record failed/partial rollback honestly. Do not infer that all consumers rolled back because one did.
- [ ] GREEN: promotion file, per-consumer state/retry tests, and an isolated adoption/rollback rehearsal scheduled under VERIFY-01.

**Done:** governed improvement is traceable from capture to effect and can be reversed for the affected consumer without pretending a release automatically changed every agent.

## DIST-01 — install the shared functions for every SDLC agent

**Depends on:** CORE-01, CAP-02, APP-02, RSI-03. **Consumes:** existing package/resource/version/initialization conventions. **Produces:** one reusable SDK distribution and documented consumer integration.

**Edge cases:** clean package install; missing packaged schema/prompt; repeated initialization; optional capabilities disabled; two different delivery consumers; Improvement-group consumer; agent without protected-effect authority; one consumer still pinned to an older kit.

- [ ] RED: `test_installed_sdk_registers_one_capture_hook`, installed-resource tests, and unauthorized-agent application tests in `test_distribution.py`.

```python
def test_installed_sdk_registers_one_capture_hook(env):
    env.consumer_a.initialize_sdk()
    env.consumer_a.initialize_sdk()
    env.consumer_a.emit_completed_response(env.delivery_event)
    assert env.extractor.calls == 1
    assert env.provider.capture_count(env.delivery_event.id) == 1
```

- [ ] Include shared contracts, schemas, skill/prompt assets, and initialization registration in the existing SDK build. Verify resources from the built/installed package, not only source-tree relative paths. No per-agent copied implementation of workspace/approval/capture.
- [ ] Integrate the first real delivery consumer, then a second distinct delivery consumer through the same SDK contract. Consumer changes are thin lifecycle/context/config adapters; do not rewrite their product logic.
- [ ] Install the SDK for the separate Dreaming Agent too, enabling common services with Improvement-group eligibility exclusions. Availability of a module does not expose host-only authorization/credential operations as model tools.
- [ ] Document required host configuration: access/storage bindings, policies/roles, capture eligibility, evidence/privacy rules, bounded run/retry limits, registry, and version provenance. Missing required configuration fails that capability clearly while preserving unrelated existing behavior.
- [ ] GREEN: distribution file, package install/import/resource smoke, and both consumer compatibility suites under the unchanged supported Python environments.

**Done:** every SDLC agent can use the common platform functions through the installed kit; enabled capabilities and authority remain scoped per host/agent. Passing one consumer proves only that consumer until the second is verified.

## VERIFY-01 — acceptance and execution evidence in the SDK environment

**Depends on:** all selected tasks above. **Owner:** receiving Copilot/SDK execution environment, not this planning session.

- [ ] Run full SDK tests, lint/format checks, applicable coverage/mutation gates, package-resource smoke, and existing consumer regressions using the exact INT-00 commands. Report baseline failures separately; do not mark unchecked work complete.
- [ ] Run fault-injection integration tests: concurrent workspace mapping, conflicting writes, invalid/unauthorized evidence, capture outage, stale approval, interrupted merge records, lost PR response, and partial adoption/rollback. Assert concrete persisted state and absence/count of protected effects.
- [ ] In an authorized test environment, verify authenticated human review and native GitHub access/write/branch controls with real provider identities. A collaborator without control-write authority must fail to inject authoritative records. Synthetic users/mocked permissions do not count as this evidence.
- [ ] Demonstrate an existing delivery draft moving through exact-revision approval and recovery, plus a standalone scoped decision that blocks only its declared dependency. This demonstrates SDK approval functions without building a drafting agent.
- [ ] Demonstrate one correction through real hook invocation, admitted GitHub capture, bounded dreaming, evaluated target PR, correct human review, controlled application/release, explicit consumer adoption, and verified rollback. Use isolated test resources and the existing deployment method; no production rollout is implied.
- [ ] Record unavailable external access as a specific pending integration check. Complete all safe local implementation/tests; do not substitute fakes for real authority or claim end-to-end success. Provisioning a live environment is an execution dependency, not a reason to withhold this written plan.
- [ ] Update `docs/planning/sdk-platform-execution-log.md` with task ID, mapped paths, RED/GREEN evidence, checks, reviewed diff, integration limitations, and next task. Preserve historical alternatives and update documentation completion status.

**Milestone M4:** the installed SDK supports the full workspace/approval/RSI loop, with two delivery consumers, separate dreaming, honest recovery, and governed release/adoption. If live checks remain unavailable, label the result implementation-complete with live validation pending; do not label M4 verified.

## Command and test handoff

INT-00 must record literal commands from the real checkout for these categories; this plan does not invent a dependency manager or interpreter path:

| Category | Exact target to bind |
| --- | --- |
| RED | The new test name shown in the owning task; expected failure must be the missing/incorrect behavior. |
| GREEN | The owning test file plus relevant pre-existing SDK/consumer tests. |
| Full regression | Repository's normal full test-suite command, before integration/merge. |
| Lint/format | Existing linter and formatter check commands; use the formatter to apply formatting. |
| Composition smoke | Existing SDK initialization and real consumer entry point with test configuration. |
| Distribution smoke | Existing package build/install command and installed resource loading. |
| Coverage/mutation | Existing supported CI/test environment and declared SDK package/module scope. |
| Live integration | Test-repository configuration and explicit gated invocation; no secrets in the plan or logs. |

For a repository that already uses pytest in its activated environment, an example resolved target is `python -m pytest tests/platform/test_store.py::test_same_record_replay_preserves_commit -q`, followed by `python -m pytest tests/platform/test_store.py -q`. Preserve the repository's existing runner prefix and mapped path if different. This example sets no Python version and does not authorize installing/replacing tooling.

## Execution order and honest completion

| Milestone | Tasks | Concrete result |
| --- | --- | --- |
| M1 | INT-00 → CORE-01 → STORE-01 → WS-01 → CAP-01 → CAP-02 | Workspace-bound capture through one existing consumer. |
| M2 | APP-01 → APP-02 after their shared prerequisites | Revision-bound approval/application and recoverable scoped decisions. |
| M3 | RSI-01 → RSI-02 | Separate bounded dreaming yields an evaluated reviewable target change. |
| M4 | RSI-03 → DIST-01 → VERIFY-01 | Governed promotion/adoption/rollback and shared installation verified. |

The ordering is a default, not a requirement to reimplement existing functionality. APP-01/APP-02 may proceed before capture if that best fits the existing SDK. Preserve the scope and dependency contracts either way. Do not parallelize tasks that mutate the same modules until ownership and interfaces are explicit.

Implementation starts with INT-00 in the SDK checkout. Planning here is complete when the scope, contracts, tasks/tests, source links, and Copilot handoff are internally consistent; product test results are not claimed by this document. User review of the final plan and later implementation authorization remain separate from writing it.
