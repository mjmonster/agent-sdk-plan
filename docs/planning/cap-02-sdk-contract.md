# CAP-02: SDK completion and capture contract

Date: 2026-10-05, America/New_York.

**Status:** Proposed SDK-side implementation contract for the [MVP plan](2026-10-04-sdk-platform-mvp.md). This defines the boundary Copilot may implement locally. It is not a discovered agent-platform callback, native MCP tool specification, or claim that platform wiring exists. Map it onto compatible SDK types already implemented in CORE-01, STORE-01 and CAP-01; do not create a second set of equivalent types.

**Scope:** Receive one normalized completed-response event, check eligibility, reuse a committed capture or extract/admit/store one, and return an independent capture outcome. No Superpowers, TDD, new runtime, GitHub client, credential setup or live platform connection is required for this SDK work.

## Entry point and ownership

Semantic entry point: `Capture.on_completed(event, context) -> CaptureResult`.

Use the SDK's existing sync/async style and dependency injection. Names below describe SDK inputs/results; they are not required platform field names. Host callbacks and GitHub MCP tool mapping are separate integration work. If the SDK already has an equivalent public entry point, extend it instead of adding another.

- The trusted host normalizes its native completion event and constructs authenticated context, then calls this SDK entry point.
- The SDK makes eligibility/admission/state decisions and coordinates the existing extraction and persistence interfaces.
- The platform performs real model/GitHub operations through its existing facilities. Local fixtures can stand in for those boundaries without asserting that they are connected.
- Registering the actual platform callback is **pending platform integration** until its API is known. Do not invent an event-bus subscription or make that registration a prerequisite for implementing the entry point.

## Inputs

The host supplies the following logical fields. Reuse existing SDK representations; record the field mapping once in the integration map.

| Input | Required meaning |
| --- | --- |
| Event: `event_id`, `response_id` | Stable identifiers for the completed occurrence and response, preserved on redelivery. Never generate a fresh ID per callback/retry. They may be the same when the host uses one identity. |
| Event: `session_id`, `run_id` | Source session/run identities, scoped with the authenticated agent and workspace. |
| Event: `completed` | Host-verified final-response flag. Streaming fragments are not eligible. |
| Event: `call_purpose` | Trusted runtime purpose: delivery is `task_execution`; `capture`, `distillation`, `evaluation`, `replay` and Improvement-group calls are excluded. Missing/unknown purpose is not delivery. |
| Event: `response`, `evidence_refs` | Bounded response content/reference and supporting conversation references. Content is untrusted data. References must resolve through the authorized evidence access used by CAP-01; a raw transcript is not required. |
| Context: access and provenance | CORE-01 authenticated actor, agent ID/group, tenant/access boundary, workspace/storage binding, source snapshot and kit version. Retain CAP-01's stored-envelope provenance requirements. |
| Context: capture configuration | Enabled delivery groups, extractor/prompt/configuration version, allowed evidence bounds, finite extraction/write timeout and attempt limits. Host configuration supplies these; model output cannot override them. |

Missing/invalid required identity, scope or purpose returns `rejected` before extraction/writes. A known excluded purpose/group, disabled capture, or non-final response returns `skipped` with no extractor call or write. An inaccessible workspace returns a sanitized access rejection without reading its records. A source event must be delivered by the trusted host; a model-authored event-shaped dictionary does not establish that trust.

Derive `capture_id` with the existing canonical identity helper from contract version, authorized scope/binding, source agent/session/run/event and extractor configuration version. Compute a separate fingerprint of the stable authorized response/evidence snapshot. Exclude arrival time and retry counters. Same identity with changed source fingerprint is an integrity conflict; a new extractor version yields a distinct capture of the same source incident, not independent evidence.

## Operations CAP-02 needs

These are semantic operations to reuse from the SDK or inject as narrow host functions, not instructions to build a generic adapter framework. CAP-01 still owns validation/redaction/admission. GitHub transport and credentials stay on the platform.

| Operation | Input and result |
| --- | --- |
| Lookup committed capture | Authorized binding + capture ID. Return `found(record, receipt)`, confirmed `missing`, or explicit unavailable/unknown error. Provider failure is not absence. |
| Resolve/minimize evidence | Authorized references + configured bounds. Return the permitted redacted extraction input; inaccessible/fabricated references are rejected. Reuse CAP-01's evidence path. |
| Extract | Redacted bounded input + pinned prompt/configuration, executed with trusted purpose `capture`. Return the existing [capture-output schema](../rsi/schemas/capture-output.schema.json) payload or a typed extraction failure. No new LLM stack. |
| Admit | Existing CAP-01 admission with trusted provenance and authorized evidence. Return its stored-envelope successor or rejection; preserve the historical v1 schema unchanged. |
| Store conditionally | Authorized binding + stable capture ID + admitted envelope. Return `committed(record, receipt)`, `existing(record, receipt)`, or an explicit error including uncertain outcome. The platform must confirm the required conditional-write semantics. |
| Advance capture checkpoint | Source event identity + verified capture receipt, through the existing workspace checkpoint path. Return success or explicit conflict/failure. Checkpoints must not overwrite other workspace progress. |

A receipt identifies the actual repository/binding, record path, provider commit/revision and payload digest. The trusted host supplies provider results; SDK code verifies the requested scope and returned committed record's digest before reporting durability. For an existing winner, verify its source fingerprint/version rather than requiring byte equality with a losing extraction. Neither fixtures nor model text can establish real provider success.

If an operation's real host binding is absent, use an explicit `dependency_unavailable` outcome when execution reaches it. Implement the SDK coordination with supplied local functions/fixtures and mark the binding pending. Do not replace absent MCP capabilities with direct GitHub calls or claim atomicity from a read followed by an unconditional write.

## Processing order

1. Validate trusted context and event structure, check access and eligibility, then derive identity/fingerprint. Return early for rejection or exclusion.
2. Look up the capture. A matching committed record returns its receipt without extraction; a fingerprint/scope mismatch is rejected. Unavailable/unknown lookup stops this attempt without extraction or writing.
3. For confirmed absence, resolve/minimize evidence, extract using purpose `capture`, and pass the result through CAP-01. Zero observations is a valid envelope. Reject invalid/unsafe content before the writer receives it.
4. Store the admitted envelope conditionally. A committed envelope establishes durability only after receipt validation. If another attempt won, verify its scope, source fingerprint and extractor version, then use the winner's record/receipt. Different valid model wording for the same source does not justify overwriting the winner.
5. On an uncertain store response, look up the same ID before any repeat write. Matching durable content resolves the outcome. If still unknown, report `outcome_unknown`; if absence is confirmed, a bounded retry may reuse the already admitted envelope. Do not re-extract merely to retry a write.
6. Advance the capture checkpoint only against a verified durable receipt. If checkpointing fails, keep the receipt and report the checkpoint as pending; replay must reuse the capture and retry only the missing checkpoint work.

Concurrent initial attempts may both extract when the platform supplies no stronger coordination. They must converge on one committed envelope; do not promise exactly one initial model call. After process loss, re-extraction is allowed only from an authorized replayable source when no committed capture exists. Otherwise report unrecoverable capture loss explicitly. No background queue, lossless-delivery claim or indefinite retry loop is introduced.

## Result contract

Use existing SDK result/error types where equivalent. The result must carry these distinct facts:

| Field | Values / rule |
| --- | --- |
| `status` | `skipped`, `rejected`, `persisted`, `failed`, or `outcome_unknown`. These describe capture, never the delivery task. |
| `reason` | Stable reason category and sanitized diagnostic, such as excluded purpose, access denied, identity conflict, invalid evidence, dependency unavailable, extraction timeout, or provider unavailable. |
| `capture_id` | Present once derivable from valid trusted identity; otherwise absent. |
| `receipt` | Present only for verified `persisted`, including committed replay. No success receipt for failed/unknown writes. |
| `observation_count` | Count from the committed envelope for `persisted`, including zero. Otherwise absent rather than pretending failure means no observations. |
| `replayed` | True when reusing an existing committed capture; false for this attempt's newly committed record. |
| `checkpoint` | `unchanged` before durability, `advanced` after confirmed checkpoint success, or `pending` when capture is durable but checkpoint completion is unconfirmed. |
| `next_action` | `none`, `retry_lookup`, `retry_capture`, `retry_checkpoint`, or `operator_required`, chosen from known outcome and replay capability. A retry remains subject to finite host limits. |

`persisted` with zero observations is the no-signal outcome. `persisted` with checkpoint `pending` is durable capture needing checkpoint reconciliation, not a failed capture write. Error details never contain raw secrets or inaccessible identifiers. A recoverable capture error does not replace the original delivery response; use the runtime's existing cancellation/shutdown semantics rather than suppressing all exceptions indiscriminately.

## Local completion and platform handoff

Copilot can implement the input/result mapping, eligibility, identity, operation ordering and outcome handling now. Reuse local SDK checks after implementation; no test-first workflow or new platform simulator is required. Useful fixture checks are: excluded call makes zero side-effect calls; committed replay skips extraction; empty extraction persists; invalid references reach no writer; lost write response reconciles; checkpoint failure retains the receipt. Fixture success establishes local behavior only.

Keep these platform items explicitly pending: native callback name/payload and registration lifecycle; authenticated context construction; evidence access and replay guarantees; model invocation metadata; actual MCP tool mapping, pagination, conditional writes and receipt semantics; real consumer invocation and permissions. Document the needed fields/results from this contract for the operator. Unknown native details do not block implementing this SDK contract, but must not be represented as completed integration.
