# RSI, workspace, and approval extensions to the existing kit

Date: 2026-10-04, America/New_York.

Status: corrected planning scope, incorporating the user's clarification. The existing `sdlc-dev-kit` prototype is installed for all SDLC agents. This session writes the plan without access to that prototype and does not run it end to end. The receiving Copilot session has SDK access and maps the plan onto its existing code as its first execution task.

## Scope correction and precedence

Extend the existing `sdlc-dev-kit` with RSI, workspace, and approval capabilities. Do not plan a replacement kit or a new delivery application merely because the current handoff folder contains documentation rather than source code.

The user's 2026-10-04 clarification supersedes the delivery-only release boundary and new-stack assumptions in the [earlier foundation design](2026-10-03-delivery-foundation-design.md). That document remains available as a historical proposal; its unapproved technical choices are not requirements for this work.

| Decision | Current treatment |
| --- | --- |
| Existing prototype | Extend it in the receiving Copilot session; reuse working initialization, runtime integration, services, persistence, and tests. No prototype access is required to finish this plan. |
| Python version | Inherit the prototype's declared constraints and supported environments. Do not select, pin, raise, or otherwise change its Python version as part of this plan. |
| Toolchain and topology | Follow the prototype's package layout, dependency manager, libraries, entry points, and repository boundaries unless a demonstrated capability gap requires a separately explained change. |
| Implementation scope | RSI, logical workspaces, and shared approval. All three belong in the implementation roadmap. |
| Implementation location | Shared workspace, approval, capture, persistence, and enforcement functions belong inside the installed SDK. No replacement kit or mandatory standalone controller product. |
| Foundation-first preference | Establish missing workspace/authority/persistence prerequisites before dependent RSI effects. This is dependency ordering, not a reason to exclude RSI from the plan. |
| Interaction preference | Retain CLI interaction and GitHub PR reviews, adapting existing interfaces rather than requiring a new CLI/controller stack. |
| BRD drafting | Accept existing drafts where needed to demonstrate workspace/approval integration. Building a Requirements Agent or BRD authoring product is not the focus. |
| Execution | Prepare reviewable plans for later implementation through Copilot in VS Code. No product implementation or remote changes in this session. |

Sources: [latest handoff](<../../../CODEX-HANDOFF(1).md>), [RSI baseline](../../rsi/README.md), [workspace/approval baseline](../../workspace/README.md), and [review/decision record](../../planning/2026-10-03-handoff-review.md).

Execution handoff: [detailed SDK implementation plan](../plans/2026-10-04-sdk-rsi-workspace-approval.md). It defines semantic contracts, task dependencies, concrete test cases, and the receiving session's native integration mapping without requiring SDK access here.

## Intended result

An existing delivery agent uses shared kit capabilities to resolve its authorized workspace, preserve resumable state, and request revision-bound human approval. Eligible completed delivery responses also produce validated, appropriately scoped improvement evidence through a trusted capture integration. A separate Dreaming Agent can turn that evidence into a bounded, evaluated, human-reviewed improvement, with release/adoption and rollback tracked separately.

The plan must cover this complete improvement loop. It can divide implementation into small dependent slices, but finishing workspace plumbing alone does not complete the requested RSI work.

## Integration mapping assigned to the receiving Copilot session

At the start of execution, inspect the SDK's repository instructions and local changes before modifying code. Record each capability as implemented, partial, missing, or unverified, with source/test references and the smallest extension needed. This is an implementation preflight, not a blocker to producing or dispatching the plan.

| Inspection target | Planning consequence |
| --- | --- |
| Package metadata, supported Python versions, lockfile, CI, test/lint commands | Reuse the established environment; no speculative version/toolchain migration. |
| Shared initialization and a real delivery-agent consumer | Choose the existing integration seam and prove compatibility with its current public behavior. |
| LLM response lifecycle and trusted call metadata | Identify the actual completed-response hook, eligibility source, and replay/durability limits. |
| Workspace/context/checkpoint services and storage bindings | Extend existing identity and recovery behavior instead of adding competing state models. |
| Approval interfaces, policy sources, evidence verification, and protected effects | Reuse existing authority boundaries; fill gaps in exact-revision evaluation and application. |
| GitHub adapter, writer, credentials, retries, and records | Reuse working transport/persistence; distinguish permissions enforced by the runtime from library conventions. |
| Existing capture or dreaming work | Preserve functional code, prompts, schemas, and older alternatives; plan only missing or changed behavior. |

Absence of source in this handoff folder is not evidence that these capabilities are absent from the prototype. The plan defines semantic interfaces, effects, tests, and ordering now; Copilot records actual module paths, native symbols, and environment commands at execution time. Routine naming/layout mappings do not require another planning interview.

The SDK owns the reusable implementation. The agent runtime supplies authenticated context, approved configuration, provider credentials, and lifecycle callbacks through narrow adapters. Authority-sensitive SDK functions run in that trusted runtime boundary and are not unrestricted model tools. Installation makes a capability available; it does not grant every agent the same roles or credentials. The separate Dreaming Agent uses the SDK but remains a separate agent workflow.

## Capability boundaries and acceptance

### Workspace extensions

A workspace is a stable logical delivery case, distinct from the source-agent repository, storage binding, session, user, and dreaming repository. Multiple cases may share storage only within an appropriate access boundary. Preserve the prototype's existing IDs/contracts where compatible; any needed record evolution requires explicit compatibility behavior.

Implement or complete authorized resolution, durable mappings, independent draft/accepted/control state, pending questions, checkpoints, and recovery. Concurrent collaborators must retain both contributions or receive an explicit conflict. Resume reconstructs accepted facts and pending work without treating scratch summaries as approved truth.

Acceptance includes: two authorized callers resolve the same case across sessions; different cases retain distinct IDs; unauthorized access reveals no restricted content; conflicting updates do not overwrite silently; restart rebuilds state; identical retries preserve one durable result; outages cannot fabricate persistence receipts.

### Approval extensions

Use one shared deterministic approval mechanism with separate policy, evidence, applicability, and effect records. Its subjects include lifecycle artifacts, scoped decisions/actions, and improvements. Reusing the mechanism does not grant the same reviewer or caller authority over all three categories.

Bind approval to the exact subject content/revision, workspace/access scope, relevant dependency baselines, policy revision, and requested effect. Verified human evidence comes through a trusted integration, not model-authored approval text. Recheck applicability before a protected effect. Keep approval, merge, accepted baseline, workflow transition, release, and adoption as separate facts.

Acceptance includes: bot/self-asserted approvals fail; repeated decisions by one person do not satisfy a distinct-person quorum; changed subjects/dependencies/policies invalidate applicability without erasing history; unmerged approvals do not establish a baseline; post-merge record failures reconcile once; a scoped decision blocks only its declared dependent effect; delivery approval does not authorize an improvement or arbitrary action.

The earlier proposal's new HTTP controller, token flow, branch layout, constants, and concrete libraries are not prescribed here. The prototype review must identify the existing trusted boundary and assess whether it enforces these guarantees.

### RSI capture extensions

Distribute the shared capture capability through the existing kit and connect it to the actual trusted completed-response boundary. Installing a skill file does not prove invocation. Eligibility must come from trusted runtime metadata; capture, distillation, evaluation, replay, and Improvement-group calls must not recursively generate ordinary delivery captures.

One eligible response produces a capture envelope with zero or more evidence-backed observations. Empty output is valid. Admit only authorized evidence references, preserve contradictory later evidence, redact before durable storage, and distinguish observable results from model self-assessment. Do not copy raw transcripts, secrets, or hidden reasoning into shared records.

Keep source-agent identity, logical workspace/access scope, source snapshot, event identity, and extractor version distinct. Route improvement targets later using verified ownership. The preserved v1 capture schema lacks logical workspace identity; evolve it through a compatible/versioned successor rather than overwriting the historical schema or claiming its structural validation proves semantic validity.

Persist admitted records in GitHub with verifiable receipts. Transport retries reuse the admitted result rather than rerunning extraction and overwriting evidence. Capture checkpoint advancement follows durable success. Report task outcome and capture-durability outcome independently; do not promise lossless capture without a verified durable/replayable source.

Acceptance includes: ordinary no-signal response; genuine correction; missing/unauthorized/fabricated evidence; secret or injected instruction; no recursive capture; same incident seen again; different extractor version; delayed contradiction; invalid output; writer timeout/restart; and successful task with explicit capture persistence failure.

### Separate Dreaming Agent and governed promotion

Keep Dreaming Agent separate from delivery agents while reusing appropriate kit workspace, persistence, and approval primitives. The initial proposed mode remains a human-triggered bounded run over authorized evidence. Automatic capture does not imply automatic promotion or unrestricted scheduled execution.

The run groups incidents, retains conflicting evidence, resolves the behavior owner, and proposes a bounded candidate. Unresolved ownership or insufficient evidence is a valid recorded outcome. Evaluate the proposed behavior with positive and negative cases before requesting review of a concrete target change. An observation is not an approved requirement, and a candidate cannot choose its own authority.

A human with the correct target scope approves the exact improvement revision. Dreaming cannot approve or merge its own work, widen permissions, or silently update consumers. Track review, merge, released version, explicit consumer adoption, measured effect, and rollback separately. Shared-kit changes and consumer changes may need linked, ordered PRs rather than an assumed cross-repository atomic merge.

Acceptance includes: unknown owner creates no guessed PR; project-only knowledge is not promoted globally; conflicting evidence is retained; an evaluated candidate cannot self-approve; retry recovers the same candidate/PR; target revision changes require reevaluation/review; release without adoption changes no consumer; adoption and rollback reference exact versions.

## Practical sequence for the implementation plans

1. **Reconcile with the prototype.** Produce an implementation/gap map, record existing commands and extension points, and retain existing local changes.
2. **Fill shared prerequisites.** Add only missing workspace identity, authorized storage bindings, durable record/retry contracts, and approval interfaces needed by the next slices. Preserve working implementations.
3. **Complete workspace/approval behavior.** Demonstrate collaboration, exact-revision human review, scoped effects, and recovery through the current kit and an existing consumer. Existing BRD drafts can supply example artifacts.
4. **Integrate capture into that consumer.** Prove real hook invocation, trusted eligibility, workspace provenance, reference admission, redaction, idempotent persistence, and visible failure state.
5. **Deliver a bounded dreaming run.** Produce one attributable candidate, behavioral evaluation, and reviewable change in the correct target repository, including unresolved/insufficient-evidence outcomes.
6. **Prove governed promotion and recovery.** Exercise authenticated improvement review, release/adoption tracking, and rollback without self-approval or implicit deployment.

This is a capability sequence, not a claim that all six require new code. Inspection may show some are already complete. Detailed plans should be divided at testable outcomes, link their shared contracts, and include exact existing files, behavior-first tests, verification commands, and progress checkboxes.

## Candidate smallest useful slice and tests

The preferred first integrated milestone is **workspace-bound capture admission through an existing delivery consumer**: take one eligible completed response, resolve authorized workspace context, admit only valid evidence, persist one capture envelope, and resume/retry without duplicating it. Copilot maps or implements the minimum workspace/writer prerequisites first; it does not scaffold an entire replacement kit. Approval and governed dreaming follow as explicit tasks in the same implementation plan.

Before implementation, enumerate these public-behavior tests:

1. One eligible delivery event with a real correction produces the expected observation and authorized source/workspace references.
2. One eligible no-signal event produces a valid empty result, not an invented lesson.
3. Capture/dreaming/evaluation/replay events cause no recursive extractor invocation or ordinary capture record.
4. Fabricated, inaccessible, or wrong-workspace references produce explicit rejection and no admitted observation.
5. Secret-bearing evidence is redacted or rejected before the writer receives durable content.
6. Duplicate delivery/retry of a committed capture returns the same persisted capture and receipt without another extractor call; replay of work never durably stored has an explicit recovery policy.
7. Changed content under the same capture identity produces an integrity conflict rather than an overwrite.
8. Timeout after persistence is reconciled; restart without confirmed persistence never advances the capture checkpoint falsely.
9. Existing delivery behavior still succeeds independently of an explicitly reported capture-storage failure, under the reviewed fail-open/fail-closed policy for capture.

Use the prototype's public APIs and test infrastructure for these cases; name exact tests after inspecting those interfaces. The complete plan must additionally cover the approval and dreaming acceptance cases above. This slice alone is not completion of RSI.

## Limits and planning progress

Jira integration, model-weight training, research reproduction, replacement of the delivery-agent stack, a new UI, and Python/toolchain migration remain outside this plan unless separately requested. Research and historical design alternatives remain reference material, not automatic implementation requirements.

- [x] Record the existing prototype and withdraw new Python-version requirements.
- [x] Restore RSI, workspace, and approval as the active planning scope.
- [x] Preserve the earlier delivery-only proposal with an explicit supersession notice.
- [x] Assign SDK inspection and native interface/command mapping to the receiving Copilot session.
- [x] Confirm all shared platform functions are SDK implementations installed across agents.
- [x] Write the detailed implementation plan with task dependencies, contracts, and behavior tests.
- [x] Finish document consistency/link/history checks in this planning session.
- [ ] Receiving Copilot session maps existing behavior and executes the selected tasks.

No application files, interpreter configuration, dependencies, credentials, or remotes are changed by this scope correction.
