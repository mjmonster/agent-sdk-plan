# SDLC platform handoff review and planning decisions

Review date: 2026-10-03, America/New_York.

Status updated 2026-10-04: the user clarified that an existing `sdlc-dev-kit` prototype is installed for all SDLC agents. The current work plans RSI, workspace, and approval functions inside that SDK, without changing Python or requiring prototype access in this session. The receiving Copilot session will map the plan to its SDK checkout. Earlier delivery-only/new-stack recommendations below are retained as history and superseded where noted.

Current entry points: [SDK design](../superpowers/specs/2026-10-04-rsi-workspace-approval-design.md) and [detailed implementation plan](../superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md). The plan is a documentation deliverable, not a claim of implementation or local end-to-end validation.

## Purpose and source precedence

The requested outcome is a practical, portable plan that the user can push to a remote repository and execute later through GitHub Copilot in VS Code. This session is limited to review, design, and planning documents.

The current historical source is [CODEX-HANDOFF(1).md](<../../CODEX-HANDOFF(1).md>). It preserves the original [handoff](../../CODEX-HANDOFF.md) and adds research section 17. The [RSI package](../rsi/README.md) and [workspace package](../workspace/README.md) remain preserved baselines. Confirmed user requirements outrank recommendations in those packages. New choices must be recorded as proposed or accepted individually; approval of this review does not approve every historical proposal.

The corrected RAG paragraph in section 17.1 does not establish a Chroma/BGE dependency. Research ideas remain optional experiments. Implementation must not import an unrelated project's stack.

## Verified local state and publication setup

- At the initial review, `C:/WORKSPACE/sdlc-agent` had no Git metadata or remote configuration. On 2026-10-04, at the user's request, it was initialized on `docs/sdk-platform-plan` with remote `https://github.com/mjmonster/agent-sdk-plan.git`; the remote was verified empty before initialization.
- No application, package manifest, test harness, CI configuration, or deployed agent was found in this documentation folder. This finding does not describe the separate SDK prototype, which the user confirms exists and the receiving Copilot session can access.
- All 44 files listed in `handoff-manifest.json` still match their recorded SHA-256 hashes. The updated handoff is outside that original manifest and retains the original handoff as its byte-identical prefix.
- The updated handoff SHA-256 at review time is `a1ec1cb0e66cc5a94d0945b2168d646580e2ca31266efe3d86332fc555c2fb33`.
- Earlier inspection validated all five RSI example records against the supplied schemas. That demonstrates structural conformance only. A fabricated evidence reference also passes the schema; semantic admission is unimplemented.
- The root `Install-WorkspaceDocs.ps1` and `PACKAGE-README.md` are extra copies from the workspace archive. The installer requires its original `manifest.json`, which is absent. Its previously checked `-WhatIf` invocation fails before copying. Do not run it against the combined handoff manifest.
- The project has no `.cloud`, `.claude`, or `.Codex/rules` directory. The requested rules were located in `C:/Users/KyuEu/.claude/CLAUDE.md` and `C:/Users/KyuEu/.claude/rules/`.
- `C:/WORKSPACE/.claude/settings.example.json` is a hook example, not evidence of active hooks in this project.

## Confirmed constraints retained

| Constraint | Consequence for the plan |
| --- | --- |
| Shared `sdlc-dev-kit` capabilities | Initialization, workspace access, capture, and approval support belong in shared contracts; agent-specific behavior keeps its owner. |
| Collaborative, recoverable work | Workspace identity survives changes of person, agent, and session. Resume reconstructs authoritative state and pending work. |
| GitHub-backed durable platform records | No new database, vector store, hosted queue, or unrelated durable service is an MVP prerequisite. |
| Separate Dreaming Agent | Capture gathers evidence; dreaming proposes improvements through its own bounded workflow. |
| Human-governed promotion | Evidence, candidate, approval, merge, release, consumer adoption, and measured benefit remain different facts. |
| Shared approval mechanism | Mechanism, client policy, and records remain separate. Model-authored identity or approval text grants no authority. |
| Important non-stage decisions | The design must accommodate scoped decision/action subjects as well as lifecycle artifacts. |
| Preserve earlier alternatives | Historical names, storage layouts, and hypotheses are linked rather than overwritten as though never considered. |

## Reconciliation and planning consequences

This table distinguishes supplied documentation from required behavior. Existing SDK implementation status is unverified here, not presumed absent. The receiving Copilot session checks and reuses implemented capabilities before making changes.

| Area | Current state | Plan must establish |
| --- | --- | --- |
| Shared kit | Existing prototype confirmed by user; only documentation available in this folder | Map platform extensions into existing SDK boundaries, contracts, initialization, and consumers; preserve Python/tooling. |
| Workspace identity | Logical case model proposed; YAML examples only | Stable tenant/workspace IDs, access-bound storage bindings, resolver behavior, concurrency, and conflict handling. |
| Approval | Confirmed principles; illustrative requests and policies | Authenticated evidence adapter, real test-role mappings, canonical subjects, freshness rules, and application checks. |
| Persistence and resume | GitHub writer and reconciliation described | Durable receipts, expected-head handling, idempotency, explicit ambiguous outcomes, and reconstruction after crashes. |
| Capture | Prompts, skill template, schemas, and examples exist | Trusted response boundary, authorized evidence registry, redaction, reference checks, and durable writer. |
| Capture provenance | v1 workspace field contains repository and commit only | A separately versioned successor must represent logical workspace identity and storage binding without rewriting historical v1 assets. |
| Dreaming | Proposed workflow and candidate schema | Ownership routing, evaluation, PR recovery, release/adoption tracking, and rollback evidence. |
| Jira | Optional proposed extension | Verified provider, field ownership, and synchronization contract when that release is planned. |
| Research | Inputs for evaluation design | No automatic additions to MVP scope or acceptance thresholds. |

The handoff's exact runtime/scratch bindings remain unverified here. The plan delegates native module/interface/command mapping to the receiving SDK session rather than treating those missing local files as a blocker or designing a replacement runtime.

## Historical release-order discussion and retained alternatives

**2026-10-04 correction:** RSI is part of the active plan together with workspace and approval. Foundation-first now means implementing missing prerequisites in dependency order. It does not defer the improvement loop out of the requested plan, and it does not authorize rebuilding the SDK.

On 2026-10-03, the user accepted delivery foundation first; the resulting draft proposed capture and dreaming as a later release. The 2026-10-04 clarification replaces that delivery-only scope. The alternatives below remain historical context, not current instructions to omit RSI.

| Approach | Benefit | Tradeoff |
| --- | --- | --- |
| Delivery foundation first, selected | Demonstrates shared workspace, human-reviewed baseline, and recovery; creates a real workflow for later improvement evidence. | Capture and dreaming arrive in a subsequent release. |
| RSI first | Tests the evidence-to-improvement workflow sooner. | Requires choosing or supplying a delivery runtime and workspace context before the platform foundation is complete. |
| Both loops in the first release | Demonstrates the broad vision together. | Couples identity, governance, recovery, runtime integration, evaluation, and adoption into a much larger acceptance boundary. |

The previous recommendation for workspace-aware capture admission remains a useful technical increment. It is too small to stand alone as the first user-visible release of the entire SDLC platform. The selected delivery-first sequence preserves RSI requirements for the following release.

### Earlier delivery demonstration, retained within the broader plan

Two authorized collaborators can open the same delivery case, propose a BRD revision, obtain authentic human review of that revision, establish an accepted baseline, and resume correctly after an interrupted session.

Recommended scope is one test tenant, one BRD artifact type, one CLI/shared client interface, one shared kit/controller contract, lifecycle approval, and one standalone scope-decision gate. Existing person/agent-authored drafts enter through the CLI; a built-in LLM Requirements Agent is deferred. Use independent proposal branches and explicit conflict reconciliation. Keep event writes serialized initially.

In that earlier proposal, Jira, arbitrary external actions, autonomous supervision, full dreaming, and research experiments were later stages. Bounded dreaming is now explicitly in the active plan; the other expansions remain deferred. Multiple callers test collaboration; a second actual agent adapter is required before claiming broad runtime portability.

### Proposed foundation work packages

1. Define identity, storage bindings, the canonical review subject, and explicit state/event contracts.
2. Implement authorized workspace resolution and conflict-safe GitHub persistence.
3. Implement proposal creation, verified review admission, and deterministic approval evaluation.
4. Implement exact-revision application and separate baseline/transition records.
5. Implement checkpoint recovery and reconciliation of partial outcomes.
6. Demonstrate the complete workflow with two callers, authentic test-environment review, and injected failures.

These are planning work packages, not executable task instructions. The detailed plan must add exact paths, types, commands, test code, and task boundaries after runtime and remaining scope choices are settled.

## Decisions to resolve in order

| Decision | Recommendation | Status |
| --- | --- | --- |
| First working release | Shared prerequisites first, with RSI/workspace/approval all covered in the current plan. The older delivery-only boundary is superseded. | Clarified by the user on 2026-10-04. |
| Implementation stack | Extend the existing SDK; retain its Python version and tooling. Python-first was previously selected; a new Python floor or mandatory standalone controller was not accepted. | Clarified by the user on 2026-10-04. |
| First user interface | Command-line interface with GitHub PR reviews. A web UI and existing-host integration remain later options. | Accepted by the user on 2026-10-03. |
| BRD drafting integration | Accept a BRD drafted by a person or external agent through the CLI. A built-in LLM Requirements Agent remains a later scope expansion. | Accepted by the user on 2026-10-03. |
| Code and data repository boundaries | Shared platform implementation is inside the installed SDK; reuse its topology and configurable authorized GitHub data bindings. Dreaming remains a separate agent. | SDK placement confirmed on 2026-10-04; exact native paths map during execution. |
| Approval interface and ownership | GitHub PR reviews first, backed by explicit test reviewer/role mappings and a trusted controller identity. | Proposed. |
| Initial availability and volume | Low volume, bounded retries, one writer; protected effects stop when durable authorization cannot be established. | Proposed. |

Real repository names, credentials, and client policies need not be collected to write a plan using configurable deployment inputs. They must be verified before an integration test can be called a live success. Never substitute synthetic examples for real authority.

Prototype access and live testing are not required in this planning session. The user explicitly assigned those integration responsibilities to the receiving Copilot session. Plan task INT-00 records exact SDK paths and commands there.

## Rules to carry into the implementation plan

The source is the user's existing `~/.claude/CLAUDE.md` and `~/.claude/rules/`. This review does not modify those global files.

- Enumerate edge cases before coding. Write behavior tests first and observe the relevant failure before implementation, especially for I/O, errors, retries, and state transitions.
- Test public behavior with concrete values or observable effects; use parameterized cases for equivalent inputs.
- Carry forward stack-specific tooling after the language is chosen. Python uses pytest/Hypothesis; Java uses JUnit 5/AssertJ/Mockito/jqwik.
- Keep coverage floors and mutation testing in their documented CI/periodic roles rather than treating every task as a coverage exercise. Reconcile stack-specific thresholds in the selected plan.
- Use clear modules and OOD/SOLID boundaries. Keep mutable external state behind explicit interfaces.
- Externalize environment-specific repositories, paths, endpoints, feature flags, and logging configuration. Do not invent production configuration values.
- Preserve historical documentation and update task completion checkboxes honestly.
- Keep design decisions in planning. If implementation reveals a scope ambiguity, return to planning rather than silently redefining the task. Some source rules use `.md.txt` filenames; do not assume another harness discovers them automatically.
- Use Windows-compatible commands, including `curl.exe` when a curl example is needed.
- Run targeted checks per task, the full suite before merge, and real-system verification where the change's integration boundary requires it.
- Include `tests catch:` or the applicable `tests skipped because:` explanation in commits touching tests.

### Conflicts requiring an explicit project interpretation

| Rule conflict or portability problem | Proposed treatment, not yet an override |
| --- | --- |
| Git sync hardcodes `origin/master`; this folder has no Git or known remote default branch. | Verify the actual default branch before preparing commits. Record the selected branch in the plan rather than copying a guessed command. |
| The sync procedure recommends rebasing, while another rule forbids history rewriting without explicit instruction. | Use a non-rewriting integration path by default; rebase only within explicit authorization and an appropriate unshared branch. |
| Smoke-test language is unconditional in `testing.md` but has pure-logic/simple-task exemptions in `workflow.md`. | Put an explicit applicability matrix in the project plan. Integration/wiring changes require boot and real-system checks. Documentation review has no product runtime to smoke-test. |
| Agent review is universal in one workflow section and risk-tiered in `agents.md`. | Clarify which review gate applies to each implementation task. Preserve the explicit documentation/simple-task exemptions when translating the tiered rule. |
| Exception logging requests real messages/tracebacks, while evidence handling prohibits secret leakage. | Define redacted diagnostic logging at the boundary, preserving error category and useful trace context without storing credentials or unrestricted payloads. |
| Claude hooks, agent names, and permission settings are harness-specific. | Translate the required outcomes into the Copilot workflow and executable checks; verify discovery and enforcement rather than assuming compatibility. |

The dated model recommendations in the global rules are not evidence of current Copilot model availability or performance. The final plan should work with any sufficiently capable approved implementation model.

## Acceptance cases for the proposed foundation

Each case needs a concrete public-surface assertion in the eventual plan.

- Concurrent resolution of the same authorized anchor returns one durable workspace mapping.
- Distinct cases sharing a repository retain different workspace identities.
- An unauthorized caller cannot load another case or its evidence.
- Missing ownership permits drafts but rejects protected baseline application.
- Model-authored approval and bot recorder identity do not satisfy human approval.
- Repeated decisions by one person do not satisfy a distinct-person quorum.
- Subject or covered-dependency changes make prior approval inapplicable without deleting its history.
- Approved but unmerged work is not an accepted baseline.
- Merge success followed by event-write failure reconstructs and records the baseline once.
- Replayed identical events are no-ops; reused IDs with changed payloads produce integrity conflicts.
- A restart reconstructs accepted artifacts, proposals, questions, approvals, and the next permitted action.
- Competing proposals retain both contributors' work and expose the conflict.
- A standalone decision blocks only its declared dependent effect.
- A GitHub outage produces an honest failure or unpersisted status, never fabricated durability.

## Research verification and limits

This review checked the primary pages for the new section 17 references. RAGScope and MemAgent titles, dates, and the broad summarized methods are supported by their [RAGScope abstract](https://arxiv.org/abs/2609.39075) and [MemAgent abstract](https://arxiv.org/abs/2609.32521). This does not verify experimental reproducibility or applicability to this platform.

The [Self-Evolving Harness paper](https://arxiv.org/html/2609.38372v1) supports the reported aggregate gains, its runnability-only update check, and the 11 banking runs where compaction lost the original request. These remain results and limitations of that experiment; they do not authorize autonomous promotion here.

The [NVIDIA OpenShell article](https://developer.nvidia.com/blog/add-runtime-controls-to-ai-agents-with-nvidia-openshell/) supports the described independent runtime controls. No OpenShell installation, Windows compatibility, deployment configuration, or actual repository enforcement was tested. Its adoption remains optional.

The older section 9 RRSI attribution and detailed historical claims have not been comprehensively re-audited. Neither those claims nor the newer studies set acceptance thresholds for the MVP. References to complete trajectories must remain subject to authorized access, minimization, redaction, and retention; they are not permission to centralize raw client transcripts.

## Planning progress

The [current SDK design](../superpowers/specs/2026-10-04-rsi-workspace-approval-design.md) and [implementation plan](../superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md) incorporate the 2026-10-04 corrections. The earlier [delivery foundation design](../superpowers/specs/2026-10-03-delivery-foundation-design.md) remains a superseded alternative. The first integrated milestone is workspace-bound capture in an existing consumer, followed by shared approval, separate dreaming, and governed promotion/adoption.

- [x] Review latest handoff and preserve its historical predecessors.
- [x] Locate and read the requested Claude rules.
- [x] Separate implemented assets, confirmed requirements, proposals, and gaps.
- [x] Obtain read-only architecture and planning input.
- [x] Write a portable [VS Code and Copilot guide](copilot-handoff-guide.md).
- [x] Record the earlier foundation-first preference and its later correction: RSI is in the active plan.
- [x] Confirm existing SDK implementation placement and preserve Python/tooling.
- [x] Select CLI interaction with GitHub PR reviews.
- [x] Select import of existing BRD drafts; defer built-in LLM drafting.
- [x] Write the first-release design draft with accepted decisions distinguished from proposals.
- [x] Complete the first-release design with engineering defaults and the smallest useful slice/tests.
- [x] Incorporate the user's written-design corrections and instruction to finish the plan without SDK access.
- [x] Write the detailed implementation plan with contracts, task/test cases, and SDK mapping assigned to Copilot.
- [ ] User reviews the corrected complete implementation plan.
- [ ] Verify a fresh Copilot session can execute the plan without this conversation.

No SDK product code, runtime dependencies, root agent instructions, or production policy was created or changed by this review. The user's subsequent publication request authorized local Git initialization and pushing this planning bundle to the specified repository. Historical source-package files remain unchanged.
