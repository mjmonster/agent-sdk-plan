# SDLC Platform & RSI — Codex Session Handoff

**Prepared:** 2026-10-02  
**Intended local workspace:** `C:\WORKSPACE\sdlc-agent`  
**Document version:** 1.0  
**Purpose:** Transfer the recoverable project context into a new Codex workspace, including older alternatives, unresolved questions, and the reasons the design evolved.  
**Status:** Historical/context handoff with proposed implementation baselines. This is not evidence that the described system has been implemented or that every proposal was approved.

> **Start here:** We are building an SDLC agent platform, not just a coding agent. The user owns the shared backbone: collaborative workspaces, recoverable state, training/RSI, and approval support. Conversation capture is a shared `sdlc-dev-kit` skill; the Dreaming Agent is separate. GitHub is the current durable platform store, especially for improvement records and approvals. Preserve user-controlled promotion. Inspect the real repository before deciding what already exists or changing anything.

## 0. Instructions for the receiving workspace

Read this handoff as project history, not as a replacement for the repository's existing instructions or a blanket authorization to implement every idea. The user explicitly wants to revisit outdated ideas in the new workspace rather than lose them during migration.

First inspect the actual repository, its instructions, working-tree changes, documentation, runtime, tests, and integration boundaries. Then produce a reconciliation of **implemented / documented only / conflicting / obsolete / missing / unresolved**. Preserve older alternatives with an explicit supersession note. Do not silently turn a prior assistant suggestion into a confirmed user requirement.

Do not assume these files are already installed in the Windows directory. This handoff was prepared from conversations and documentation archives, not by reading or changing the user's Windows filesystem. No remote repository, PR, approval rule, Jira configuration, or deployed agent was inspected or changed during handoff preparation.

### Status labels used here

| Label | Meaning |
| --- | --- |
| **USER** | Explicit user statement, requirement, preference, or reported situation. A design request is not proof of implementation. |
| **CONFIRMED-DIRECTION** | A design direction reported as accepted in the recovered discussion and/or the existing package; still inspect implementation and client-specific policy. |
| **PROPOSAL** | An assistant recommendation or drafted contract. Retain for review; not an approved production policy. |
| **HISTORICAL** | An earlier option, naming convention, or assumption. May be superseded, but remains useful context. |
| **OPEN** | The available discussion does not settle the question. |
| **UNVERIFIED** | External attribution, runtime behavior, or implementation claim not independently checked for this handoff. |

### Fast orientation

There are two loops. The **delivery loop** turns source material into clarified requirements, approved artifacts, design, implementation, verification, and release, with iteration and backtracking. The **improvement loop** captures evidence from delivery work, distills candidates, evaluates changes to agent behavior, opens target-repository PRs, and waits for human-governed promotion.

There are different kinds of durable information: accepted project artifacts, proposed artifact changes, workflow/approval records, resumable task checkpoints, and improvement evidence. They can share physical infrastructure when authorized, but they must not share meaning or authority.

The latest workspace package rejects a universal equation of **one workspace = one repository**. It proposes a logical delivery-case identity with configurable storage bindings. This is an important refinement, not a verified deployed design.

## 1. Source coverage and provenance

This handoff consolidates the relevant context available in the current conversation, recovered earlier SDLC discussions, and two actual documentation archives. It is not a verbatim export of every historical chat. Where only a recovered summary was available, that limitation is preserved rather than filled with invented detail. Unrelated personal, career, and other-project memories have deliberately been excluded.

Use the following source labels when reconciling a statement:

| Source label | Material and evidence type |
| --- | --- |
| **CHAT-RSI** | Current conversation: the user's four RSI requirements; shared capture skill; separate Dreaming Agent; naming question; request for local documentation and this handoff. Direct user text is available. |
| **HIST-WORKSPACE** | “设计共享开发空间,” around 2026-09-23/24: collaborative truth, interactive requirements localization, condensed BABOK question, scratch/checkpoint persistence, unapproved branches/PRs, and recovery after absence. Recovered conversation context plus visible excerpts. |
| **HIST-BACKBONE** | “SDOC训练架构 designing,” 2026-09-29: training/workspace responsibilities, multi-user story/CR collaboration, lifecycle agents, isolation, supervisor/backtracking, shared kit initialization, and human approval. Recovered conversation context plus visible excerpts. |
| **HIST-APPROVAL** | “Approval Gate Design,” around 2026-10-01/02: GitHub persistence, workspace allocation, ordinary and exceptional approvals, Payments/domain ownership concerns, Jira, and `ApprovalService`. Recovered context plus the workspace package. |
| **HIST-PLATFORM** | Parallel discussion around 2026-10-02: development execution may be separate because design, architecture, and decisions require several iterations. Recovered context, not a complete transcript. |
| **PACK-RSI** | Actual `sdlc-agent-rsi-docs.zip`, version 0.1.0. Its `docs/rsi/` payload is preserved unchanged in this bundle. |
| **PACK-WORKSPACE** | Actual `sdlc-agent-workspace-docs.zip`, version 0.1.0, recovered from Library. Its `docs/workspace/` payload is preserved unchanged in this bundle. |
| **CHAT-RESEARCH** | Earlier assistant interpretation of an alleged Google RRSI paper. Preserve the engineering ideas, but treat bibliographic details, publication dates, metrics, and empirical claims as **UNVERIFIED** pending primary-source checking. |

Dates in older document headers use October 1, while recovered message timestamps include October 2 UTC. Do not infer a substantive design conflict from a timezone-dependent date label. Exact timestamps below are used only where recovered; otherwise dates are approximate discussion dates.

The archive payloads, not the original source repository, were inspected. Synthetic organizations, hashes, work-item IDs, reviewers, evaluations, and version numbers inside examples are not real production records.

## 2. User intent and durable constraints

**USER — Product scope.** Build an SDLC platform supporting requirements, design/architecture, development, testing, deployment, and supervision/orchestration. Current work is concentrated on the common backbone and requirements gathering, not on delivering all specialist agents at once. [HIST-WORKSPACE; HIST-BACKBONE; HIST-PLATFORM]

**USER — Shared collaboration.** Multiple people and agents must work on the same story/change request and reuse the relevant project state. A workspace must not be recreated merely because the person, agent, or chat session changes. Separate workspaces must remain isolated according to authorized access. [HIST-BACKBONE]

**USER — Recoverable work.** Runtime conversations/materials may not survive a user being away for approximately two hours. Accepted artifacts, pending proposals, unresolved questions, and enough working context must survive independently of the live session. [HIST-WORKSPACE]

**USER — Common development kit.** Agents initialize through a shared SDLC command/development kit. The common workspace and training capabilities belong there; approval support was subsequently added. Latest user wording is `sdlc-dev-kit`. Earlier wording was `sdlc-agent-kit`. No physical rename has been verified. [HIST-BACKBONE; CHAT-RSI]

**USER — RSI capture.** After each LLM response, inspect conversation evidence for potential improvements and persist useful material into the dreaming repository. The extraction prompt is a high-priority design concern. Capture is a shared skill installed for all SDLC delivery agents, not a separate autonomous agent for every conversation. [CHAT-RSI]

**USER — Separate Dreaming Agent.** The dreaming repository has its own RSI/Dreaming Agent to distill, version, and propose changes. It must retain which repositories produced the experience and route changes to the repository owning the behavior. General improvements may belong in the shared kit. [CHAT-RSI]

**USER — GitHub storage.** GitHub repositories are the only currently available durable storage for distillation candidates and the platform records under discussion. Do not make a new database, vector store, hosted queue, or unrelated storage service an MVP prerequisite. Later interest in Jira is an explicit integration extension, not permission to replace the GitHub approval ledger. [CHAT-RSI; HIST-APPROVAL]

**USER — Human authority.** The Dreaming Agent raises target-repository PRs; humans review and approve. Delivery artifacts and consequential decisions also need explicit human approval. A generated document, a model's assessment, and a conversation summary are not themselves accepted business truth. [CHAT-RSI; HIST-BACKBONE]

**USER — Important non-stage decisions.** Approval must also cover significant material, exceptions, negative cases, and actions that do not fit a conventional lifecycle milestone. [HIST-BACKBONE; HIST-APPROVAL]

**USER — Domain boundaries are not obvious.** The user gave Investments categories such as time deposits, bonds, mutual funds, and brokerage, then contrasted that with Payments work where the user owns AI-agent/platform development rather than the Payments business decomposition. Do not force the platform builder to design the client's complete business taxonomy before creating workspaces. [HIST-APPROVAL]

**USER — Handoff behavior.** Preserve outdated ideas and discuss them in the new workspace. Do not erase history or present one newly polished architecture as though every detail was already agreed. [Current handoff request]

## 3. How the design evolved

| Discussion period | What was raised | Handoff interpretation |
| --- | --- | --- |
| 2026-09-23/24 | Generic BRD/functional requirements should be interactively adapted into localized requirements, then stories/issues. Multiple users share artifacts. | Preserve the requirements-localization use case, not only code-generation use cases. |
| 2026-09-24, recovered UTC 04:05–04:08 | Could condensed BABOK improve clarification? Keep truth artifacts separately from scratch/rationale; survive approximately two-hour absence; unapproved material remains in branches/PRs. | BABOK is an exploratory idea. Truth/scratch distinction and recoverability are explicit user needs. |
| 2026-09-29 | Backbone consists of workspace plus training. Several agents/users work on a story/CR. Supervisor handles dependencies/backtracking. Training is human-triggered and can source multiple agents. | Establish platform responsibilities independently of specialist agent personas. |
| 2026-09-29 | All SDLC agents initialize through the shared kit. BRD approval should lead to PR merge, stored status, then progression. Extra decisions need their own gates. | Preserve approval intent; later refinement fixes the exact proposal/review/merge ordering and evidence binding. |
| 2026-10-01/02 | RSI discussion emphasizes per-response capture, GitHub-only persistence, separate Dreaming Agent, source/target provenance, shared-kit routing, human PR approval. | Strong current direction. Observation-to-candidate distinction and evaluation details are drafted refinements. |
| 2026-10-01/02 | User asks whether every project gets a new repository and whether approval needs two layers. | These were questions, not settled one-repository-per-project or two-service requirements. |
| 2026-10-02, recovered UTC 03:49 | User names `sdlc-dev-kit`, proposes shared capture and separate dreaming, and considers Requirements/Design naming. | Keep latest spelling; taxonomy is proposed, not proof of a deployed rename. |
| 2026-10-02, recovered UTC 03:57 | User discusses Payments/domain ownership, Jira stories/backlog, retaining GitHub approvals, and implementing `ApprovalService` in the SDK. | The workspace package separates confirmed approval principles from proposed workspace/Jira refinements. |
| 2026-10-02, recovered UTC 03:58 | User says the SDLC platform can separate development execution because architecture/design/decisions need repeated runs. | Preserve iterative delivery and shared governance; do not force a one-pass sequence. |
| Current request | Move our session context to Codex and revisit old ideas there. | First task is repository/context reconciliation, not indiscriminate implementation. |

## 4. Overall platform model

### 4.1 Platform, workflows, agents, and capabilities

**PROPOSAL:** Separate the platform's durable mechanics from agent-specific reasoning. [HIST-BACKBONE; HIST-PLATFORM; PACK-RSI]

| Element | Responsibility | Boundary to preserve |
| --- | --- | --- |
| Platform/runtime | Identity, access, workspace resolution, durable state, gate enforcement, integrations, continuity | LLM output cannot manufacture authority. |
| Workflow/controller | Dependencies, transitions, resumable execution, application of authorized consequences | A stage transition is not a conversational opinion. |
| Functional agent | Requirements, technical design, implementation, verification, or improvement work | Agents propose work within a defined remit. |
| Skill | Reusable bounded instructions/resources | Installation does not schedule execution or grant access. |
| Tool/adapter | Typed operation with validation and authorization | A tool's trusted wrapper, not the prompt, controls the operation. |
| Runtime hook | Triggers capture or another capability at a defined lifecycle event | Exclude recursive/non-task invocations deliberately. |
| Human role | Business/technical approval, ownership, review, operation authorization | Agent group membership and repository administration do not confer business authority. |

The shared kit can expose these contracts without requiring a separate microservice for every capability. A logical `ApprovalService` can live in the existing trusted runtime. Inspect the current implementation before choosing deployment topology or language.

### 4.2 Functional naming

**USER:** Asked whether agent-group naming by responsibility would be clearer, with “Requirements Agent” replacing “BA Agent” and “Design Agent” replacing “Architecture Agent.” The examples are function-oriented even though the question used “roles.” [CHAT-RSI]

**PROPOSAL:** Use stable functional groups, separate agent instances, and human accountability roles:

| Group | Initial public agent | Human role, not automatic authority |
| --- | --- | --- |
| Requirements | Requirements Agent | Business analyst / product owner |
| Design | Design Agent, initially system and technical design | Architect / technical lead |
| Implementation | Implementation Agent | Developer / technical lead |
| Verification | Verification Agent | QA / designated reviewer |
| Improvement | Dreaming Agent | Target repository maintainer |

A group may contain one agent initially; future clarification, drafting, and validation specialists need not change the group identity. Release/deployment/operations and supervisor capabilities appeared in the broader scope but are not finalized as separate groups. “Design” should not silently include UX when the deployed agent is architecture-only. The Dreaming Agent is an Improvement-group consumer of shared support, not the kit itself. [PACK-RSI, `01-agent-taxonomy.md`]

Preserve historical BA/architecture labels in old records. Record canonical aliases rather than rewriting provenance. **OPEN:** actual repository names, group IDs, agent IDs, and migration strategy.

### 4.3 Shared kit responsibilities

The discussed common kit covers initialization, workspace access conventions, provenance, approval clients/contracts, conversation capture, validation interfaces, and version metadata. Agent-specific elicitation or design behavior belongs with its owning agent unless a reusable abstraction is established. [HIST-BACKBONE; PACK-RSI]

The user mentioned initialization through an SDLC command; no exact CLI spelling, install directory, hook name, package manager, or skill loader was verified. Do not invent those as existing integration points.

### 4.4 Delivery is iterative

An indicative delivery path is:

```text
Source material / generic BRD or functional requirements
  -> interactive clarification and local adaptation
  -> proposed localized BRD / requirements baseline
  -> explicit human review and governed acceptance
  -> stories / change items and technical design
  -> implementation attempt
  -> verification findings and impact assessment
  -> revise upstream artifacts when necessary
  -> reapproval of affected revisions
  -> continue implementation / verification / release
```

This is not a mandatory universal ordering. Draft stories may exist before final approval; being in a backlog is not acceptance. Development can execute outside the main agent platform while referring to the same approved baselines, decisions, permissions, and work status. An unsuccessful run or a design revision must not create a disconnected project history. [HIST-WORKSPACE; HIST-PLATFORM; PACK-WORKSPACE]

**PROPOSAL:** Separate agent-run state, work-item state, artifact state, approval applicability, execution state, and integration synchronization. One `status` or `approved` flag cannot express all of them.

### 4.5 Supervisor, dependencies, and backtracking

**USER:** Shared lifecycle work needs coordination of PR dependencies, cross-agent work, cycles, and return to earlier stages. A supervisor was part of the discussed scope. [HIST-BACKBONE]

**PROPOSAL:** Deterministic services enforce dependency graphs, invalidation, sequencing, and access. A supervisor can help interpret semantic conflicts, propose rerouting, and identify affected artifacts, but cannot approve a decision or override a failed gate. Clarify its exact remit before building an omnipotent supervisor.

Maintain traceability from source requirement to localized requirement, design decision, story, code change, test evidence, and accepted baseline. Preserve exact revisions and downstream impact, not just mutable document titles. Link earlier accepted versions rather than rewriting history after backtracking.

## 5. Workspace, truth, scratch, and storage

### 5.1 The original two-layer idea

**USER:** One layer contains BRDs, technical specifications, functional requirements, and eventually user stories: the truth layer. Another scratch repository holds working context and rationale for continuity. Unapproved work remains as a branch/PR; merging through the approval path establishes accepted truth. [HIST-WORKSPACE]

The historical wording included recording the agent's “thoughts” and “thinking process.” **PROPOSAL:** implement this as concise decision rationale, assumptions, evidence references, actions/results, unresolved questions, and the next step—not hidden chain-of-thought or a raw internal reasoning transcript. This preserves the user's recovery goal without confusing internal model output with durable evidence.

### 5.2 Refined information boundaries

| Information | Purpose | Must not be confused with |
| --- | --- | --- |
| Source/reference material | Inputs, generic requirements, domain guidance | Automatically approved project requirements |
| Accepted artifacts | Reviewed BRD, specification, requirement snapshots, decisions | Latest draft or latest Jira text |
| Proposed artifacts | Branches, PRs, draft revisions | Approved baseline |
| Control/governance records | Requests, human decisions, authorization, transitions, integration events | Model-authored approval claims |
| Scratch/checkpoints | Resume the task after a session ends | Truth, authorization, or global learning |
| Dreaming evidence | Improvement incidents, hypotheses, experiments, PR/adoption outcomes | Project requirements or unrestricted cross-client memory |

These are logical distinctions. They do not require six databases or six repositories. The latest packages add control/governance records to the older truth/scratch explanation without abolishing either. [PACK-RSI, `02-system-architecture.md`; PACK-WORKSPACE, `03-github-persistence.md`]

### 5.3 Logical workspace versus repository

**HISTORICAL:** A repository per project/workspace was discussed and initially recommended. The user challenged business-domain decomposition and repository boundaries. [HIST-APPROVAL]

**LATEST PROPOSAL:** Define a workspace as a durable delivery case with a stable identity, scope, artifacts, decisions, dependencies, work items, and resumable context. Anchor it to an existing change request, epic, or independently delivered story when suitable. Child items normally reuse that context. The repository is a configurable binding, not the identity. [PACK-WORKSPACE, `01-workspace-boundaries.md`]

The package proposes one private delivery-storage repository per appropriate client/access boundary as an initial deployment option, with several logical workspace directories. A dedicated repository per workspace remains an option for access, retention, independent governance, or client practice. This default is **PROPOSAL**, not a confirmed client policy or irreversible decision.

Keep separate concepts for tenant/access scope, business category, delivery grouping, workspace, work item, artifact, and implementation repository. One change can span Payments categories and several code repositories. Investments or Payments labels do not determine physical persistence automatically.

### 5.4 Resolution, collaboration, and isolation

**PROPOSAL:** Trusted code resolves an authorized explicit workspace ID first, then an existing external work-item mapping, then a configured parent/anchor rule. Create a new case only when needed. Unknown/conflicting mappings go to scoped triage rather than model guesswork. Record provider instance/object IDs and a display alias separately. Persist the mapping before reporting successful creation. [PACK-WORKSPACE]

Concurrent people/agents should converge on one authorized case, without overwriting each other's work or silently forking accepted truth. Branch/worktree isolation for proposed edits was suggested; exact concurrency, ownership, reservation, and merge strategy remain integration work.

The earlier discussion suggested a tester may read the BRD but perhaps not development source. Retain this as an **OPEN access-policy question**, not a blanket ban: verification types differ. Decide by task need and customer policy. Do not assume a folder or group label provides isolation; verify the actual permission boundary before placing restricted records together.

### 5.5 Proposed storage lanes

The package's suggested delivery-repository layout is:

```text
main                          control                         proposal branches
  governance/                  registry/                       feature/<workspace>/...
  workspaces/<workspace>/      workspaces/<workspace>/
    artifacts/                   approval-requests/
    requirement snapshots/       events/
    decisions/                   state projections/
                                 Jira mappings/outbox/

scratch binding: resumable task checkpoints and compact rationale
```

`main`, `control`, and the scratch location are proposed conventions, not inspected existing branches. Do not merge a control branch wholesale into accepted artifacts. Operational persistence of a pending approval is not approval of the subject. Keep the actor who approved separate from the bot/service that writes the evidence. [PACK-WORKSPACE, `03-github-persistence.md`]

### 5.6 What resume should reconstruct

A resumable checkpoint should identify the authorized workspace/work item, relevant accepted baseline revisions, current draft branch/PR, completed observable steps, pending questions and approval request IDs, tool outcomes, blockers, and next permitted action. On resume, re-read authoritative artifacts and reconcile current approval/PR state; do not trust a stale cached `approved` value. [HIST-WORKSPACE; PACK-WORKSPACE]

A user being away does not complete an approval, and a successful LLM run does not complete the work item. The runtime may continue drafting where permitted, but governed progression must wait for valid evidence.

## 6. Approval architecture

### 6.1 What the user asked for

**USER:** Record who approved final BRDs/specifications, persist approval in the workspace/GitHub, and allow workflow progress only after approval. Also cover important decisions or material outside a normal SDLC step. The user plans an `ApprovalService` in the SDK. [HIST-BACKBONE; HIST-APPROVAL]

The workspace package reports confirmation of these principles: one shared approval service; separation of mechanism, policy, and records; human evidence bound to exact revisions; distinct approval, merge, and transition; deterministic enforcement; recoverable GitHub-backed state. Treat those as **CONFIRMED-DIRECTION**, not as proof of working code or approval of every YAML example. [PACK-WORKSPACE, `README.md`]

### 6.2 One mechanism, several approval subjects

**PROPOSAL:** Do not build two unrelated approval systems simply because two kinds of gate exist.

| Gate/subject | Decision | Consequence |
| --- | --- | --- |
| Lifecycle artifact/milestone | Is this exact reviewed baseline acceptable? | Authorize the specified baseline/merge/transition. |
| Decision/material/exception | Is this scoped consequential choice or material accepted? | Unblock named dependent work; stage association may be absent. |
| Runtime action | May this bounded operation occur with these parameters? | Authorize that action, possibly single-use and time-limited. |
| Agent improvement | May this reviewed change alter future agent behavior? | Authorize the target repository's governed promotion process. |

The package groups the first two broad gate kinds as `lifecycle` and `decision_action`, with decision/material/exception/action subtypes. Improvement approval can reuse primitives but has a different subject, scope, reviewer policy, and effect. “Uncategorized” should not mean “unscoped.” [PACK-WORKSPACE, `02-shared-approval-service.md`; PACK-RSI, `06-evaluation-and-approval.md`]

A stage can depend on a separate decision gate. A scope exception should be resolved and reflected in the BRD before that BRD revision is accepted. A local exception should not automatically block unrelated work. One explicit confirmation can cover several named requirements only when the displayed subject and authorized policy support it; avoid redundant confirmation without inferring extra permission.

### 6.3 Mechanism, policy, evidence, and authority

The kit contains shared interfaces and deterministic approval logic. The trusted runtime performs evidence verification and protected operations. Workspace/client policy defines appropriate business/technical approvers; shared-kit governance defines who can approve platform-wide changes. Importing the SDK does not make arbitrary code trusted. [PACK-WORKSPACE]

Each approval request should bind the tenant/workspace, subject IDs, repository/path set, reviewed revision, content digest, relevant dependency baselines, policy revision, requested effect, and necessary validity limits. A multi-document review needs an explicit subject bundle. An action also binds parameters, destination/environment, and permitted reuse.

Record the human actor, identity provider, verified role/delegation evidence, decision, time, reviewed subject, and source evidence. Separately record the service that persisted it, the merger, and the executor. A model-authored `approved_by` field does not establish human approval. The platform builder's ownership of the AI agents does not establish authority to approve Payments business requirements.

Authenticated chat confirmation is a possible future adapter only when it shows and binds a concrete request/revision and verifies authority. A generic “go ahead” from an unbound conversation must not approve whichever document happens to be newest.

### 6.4 Corrected sequencing and freshness

**HISTORICAL:** Earlier wording sometimes placed business approval before PR creation and included a second “go ahead” before merge. The underlying user intent is explicit human review plus durable progression, not necessarily two approvals for the same thing.

**LATEST PROPOSAL:**

```text
Prepare fixed draft and dependency bundle
  -> open proposal branch / PR
  -> create revision-bound approval request
  -> obtain authenticated human decision(s)
  -> evaluate authority, required roles, freshness, dependencies, checks
  -> authorize and verify application to the reviewed revision
  -> record accepted baseline / actual merge
  -> persist workflow transition
  -> synchronize external work tracker if configured
```

Do not append approval evidence to the reviewed artifact PR in a way that changes its head and invalidates its own approval. The package suggests persisting normalized evidence in control records with references to the reviewed head. Recheck current subject/dependency/policy validity immediately before applying the effect. [PACK-WORKSPACE, `02-shared-approval-service.md`, `03-github-persistence.md`]

Covered-content or dependency changes can stale approval; keep the old approval as historical evidence. Do not have an LLM waive reapproval because it considers a change insignificant. Precisely define any metadata excluded from the approved subject.

### 6.5 Orthogonal state and recovery

The package proposes separate state axes for request lifecycle, decision applicability, artifact application, action execution, and external synchronization. Names are illustrative until reconciled with code. An approved-but-unmerged artifact, a merged-but-unrecorded baseline, and a valid baseline with failed Jira synchronization are different cases.

A protected effect should fail closed when required durable authorization cannot be established. For an ambiguous external action outcome, reconcile before retry; when the result cannot be determined, preserve `outcome_unknown` rather than claiming exactly-once execution. Policy changes must not authorize themselves under the looser rule they propose. [PACK-WORKSPACE]

## 7. Jira and backlog integration

**USER:** Prefer integrating Jira user stories/backlog with the SDLC platform while retaining GitHub approval records. **PROPOSAL:** Support a GitHub-only mode and an optional Jira-connected mode. Jira adds an external system of record; it does not require an additional platform-owned database. [HIST-APPROVAL; PACK-WORKSPACE, `04-jira-integration.md`]

### Proposed field ownership

| Information | Proposed authority in Jira-connected mode |
| --- | --- |
| Live story text and acceptance criteria | Jira working content, until captured for baseline review |
| Priority, assignee, sprint, delivery status | Jira |
| Accepted BRD and technical-spec revisions | GitHub |
| Approved requirement baseline | Versioned GitHub snapshot with source identity and digest |
| Approval requests/evidence, policy, applicability | GitHub-backed approval/control records |
| Checkpoints, provider mappings, integration intents/results | GitHub-backed platform control state |

This is a proposed ownership policy, not a universal mandate. A client may prefer Git-authored requirements, but two systems must not silently be writable masters for the same fields.

A change to live Jira acceptance criteria can create drift from the approved snapshot and trigger successor review. A change to a planning field outside the subject should not automatically invalidate content approval. Backlog presence, “Done,” an “Approved” label, assignment, or a generic comment does not independently satisfy an approval gate. [PACK-WORKSPACE]

Use stable provider instance/issue identity plus display keys. A Jira project is not automatically a workspace, and every issue does not require a new GitHub repository. Workspace references and baseline links are navigation aids, not authorization.

The proposed adapter separates reading, issue creation, allowed-transition discovery, transition execution, backlog operations, external links, requirement snapshots, and reconciliation. Do not hard-code a universal customer workflow or implicitly remove sprint membership because an approval becomes stale.

Synchronization uses persisted intent, bounded execution, and persisted outcome. Keep failed synchronization separate from a valid GitHub decision. Reconcile ambiguous issue creation before retrying; deduplicate events and prevent two-way update loops. The platform can block its agents without proving that every manual Jira transition is prevented. Customer-side enforcement must be inspected and tested separately.

**OPEN:** Jira Cloud versus Data Center, authentication, actual fields, workflow mappings, issue types, board behavior, approval UI, and permissions. The existing package's vendor examples are Cloud-oriented and are not verified against the user's deployment. No Jira connection or write was performed for this handoff.

## 8. RSI: purpose, operating model, and boundaries

### 8.1 What “training” means here

The earlier term “training repository” evolved into “dreaming repository.” The work discussed is experience capture, distillation, and governed changes to prompts, skills, tools, retrieval/context management, and workflows. Do not silently convert this into model-weight fine-tuning or a vector-memory project. [HIST-BACKBONE; CHAT-RSI; PACK-RSI]

The initial training discussion described a human-triggered process. The current user explicitly requests automatic capture. The packages recommend **automatic capture + human-triggered bounded dreaming runs + human-governed promotion** as v1. Later scheduled distillation remains an optional design question; it would not authorize automatic merge or deployment.

### 8.2 Objects that must remain distinct

```text
Observable incident / user request
  -> observation with evidence
  -> distilled candidate / falsifiable hypothesis
  -> concrete target-repository change
  -> baseline-versus-candidate evaluation
  -> human-reviewed PR
  -> merge
  -> release
  -> consumer adoption
  -> measured outcome / rollback evidence
```

An observation is not a permanent lesson. A lesson is not a tested change. Human approval is not empirical proof of effectiveness. Merge is not release, and a released kit is not necessarily adopted by running agents. The process may produce no observations, no candidate, a rejected candidate, or no accepted improvement. [PACK-RSI]

### 8.3 Shared capture is a skill plus runtime integration

**USER:** Distribute capture through `sdlc-dev-kit` to all SDLC agents; keep Dreaming Agent separate. **PROPOSAL:** A trusted runtime hook invokes the installed skill after each eligible completed LLM response. A skill file on disk does not itself arrange invocation. [CHAT-RSI; PACK-RSI, `03-conversation-capture.md`]

The package proposes a trusted `call_purpose` and v1 eligibility for delivery `task_execution`, excluding capture, distillation, evaluation, replay, and Improvement-group runs. This avoids a loop in which capture invokes a model, whose response creates another capture. Dreaming can consume other common kit capabilities without contributing its own self-assessments as ordinary delivery evidence.

A completed response containing a tool request may be examined using currently available evidence; do not invent the future tool result. Later results/corrections can link back. Streaming fragments are not separate completed responses. The exact runtime callback and choice of response boundary remain to be reconciled with the actual code.

### 8.4 Extraction prompt: preserve evidence, permit silence

The highest-priority prompt change was from “summarize points for improvement” to **identify newly observed evidence worth investigating**. An extractor should not manufacture a lesson after every normal exchange. [CHAT-RSI; PACK-RSI]

Supply the latest conversation delta plus relevant earlier approved requirements/messages, observable tool/check results, and previous observation references. Avoid repeatedly summarizing all history. Missing expected behavior remains uncertainty.

Capture specific user corrections, explicit scoped future-behavior requests, observable requirement/behavior mismatches, relevant tool/verification failures, and verified recoveries. Do not use self-praise, self-criticism, absence of complaint, or an unverified attempted fix as proof of success. Preserve contradictory later evidence.

The proposed signal types are:

```text
user_correction | user_requested_policy | behavior_mismatch |
tool_failure | verification_failure | verified_recovery
```

Each observation separates summary, trigger context, expected behavior, observed behavior, supporting and contradicting references, suspected cause, attempted fix, fix verification status, and related observation IDs. The model returns observations only. Trusted code stamps identity, time, deployed versions, permissions/scope, and storage metadata.

Return `{"observations": []}` when no signal qualifies. Distinguish valid empty output from a skipped invocation, invalid reference, timeout, malformed output, redaction rejection, and failed persistence.

Use the preserved [capture prompt](docs/rsi/prompts/capture-system.md), [skill template](docs/rsi/skills/conversation-capture/SKILL.md), and [capture design](docs/rsi/03-conversation-capture.md) as starting material, not installed production configuration.

### 8.5 Extraction validation outside the model

Validate schema and check every supporting/contradicting reference against actual authorized input. A syntactically valid invented message ID still fails. Check that a claimed verified recovery is supported by observable evidence. Minimize and redact material before it reaches Git. Conversation text and tool output are untrusted evidence, not commands that can change destinations or policy. [PACK-RSI]

The extractor should not receive broad GitHub credentials. Submit results to a narrow trusted writer. Verify that the dreaming repository's readers are authorized for the source material; provenance does not make centralization permissible. Keep a minimal redacted excerpt where a live session reference would expire. Do not retain unnecessary personal data, secrets, or raw internal reasoning.

The prompt test set should include ordinary no-signal exchanges, genuine corrections, missing context, delayed contradiction, duplicate incidents, unverified repairs, verified recovery, project-only policy requests, secrets, injected instructions, and non-task calls. Measure capture quality and cost, not the volume of “lessons.” Thresholds and budgets have not been fixed.

### 8.6 GitHub-only capture records

The drafted v1 contract uses one capture envelope per eligible response event, holding zero or more observations and the allowed evidence excerpts. Earlier prose suggested one file per observation; the envelope refinement avoids partial event completion. Explicitly preserve this evolution. [CHAT-RSI; PACK-RSI, `04-github-records-and-provenance.md`]

Suggested dreaming-repository lanes:

```text
protected executable/configuration branch (proposed: main)
  agent/  prompts/  schemas/  policy/repositories.yaml

append-oriented data branch (proposed: experience-data)
  captures/<source>/<session>/<capture-id>.json
  candidates/<candidate-id>/v<revision>/candidate.json
  evaluations/<candidate-id>/v<revision>/<run-id>.json
  events/<candidate-id>/<event-id>.json
  runs/<run-id>.json
```

Do not merge data into executable policy just because new evidence arrived. Load policy from a protected, pinned revision. Branch names and paths are proposals. Access incompatibility may require separate dreaming repositories or rejected ingress rather than a single unrestricted central store.

Use stable capture identity from trusted scope, source repository, session/event, and extractor version. Reuse already committed output on transport retry instead of rerunning the model and overwriting evidence. Different extractor versions can reinterpret the same incident; they do not create independent incidents. An ID with different content is an integrity conflict. Later feedback is a new linked observation.

A durable receipt identifies repository, branch, path, and commit after successful persistence. Do not advance the capture checkpoint before that contract succeeds. A containing commit cannot be truthfully embedded as its own precomputed content reference; use returned receipts or subsequent linking records.

A serialized trusted writer and conflict handling were recommended for the MVP. GitHub-only persistence means there is an unavoidable first-write dependency: during an outage, an in-memory retry queue does not survive a dead process. Do not promise lossless, nonblocking capture without an available durable event/replay source. Make task success and capture-durability failure independently visible. [PACK-RSI]

### 8.7 Provenance versus routing

| Identity/version | Why it matters |
| --- | --- |
| Source agent repository ID and historical name | Where the observed behavior came from |
| Source agent commit, group, and agent ID | Which deployed implementation/executor produced it |
| Workspace ID, repository binding, artifact snapshot | Which project context was involved |
| Shared kit version | Whether the shared component version contributed |
| Extractor/prompt/model version | How the incident was interpreted |
| Session/response/event IDs | Correlation, deduplication, delayed feedback |
| Authorized data scope | Who may inspect the evidence |
| Target repository/base revision/paths | Where the candidate should change behavior |

**Source agent repository, workspace repository, and target repository are not interchangeable.** Record source facts at capture time; allow target routing to remain unresolved until distillation and code inspection. A verification agent can discover a requirements-agent defect; an incident in a Requirements Agent can be caused by the shared kit. Generality is not established by a model saying “this applies everywhere.” [CHAT-RSI; PACK-RSI]

A project-specific fact belongs in its governed project knowledge/artifacts. A domain-scoped rule may belong in scoped knowledge. A reusable behavioral mechanism can become an evaluated candidate for an agent or the shared kit. Capturing a user request does not approve it globally.

### 8.8 Dreaming Agent responsibilities

A bounded run receives trigger identity, authorized evidence range/snapshot, fixed policy/registry revision, readable sources, permitted targets, and evaluation budget. [PACK-RSI, `05-dreaming-agent.md`]

It selects and normalizes evidence; distinguishes duplicate incidents from independent support; retains counterevidence; compares existing skills, candidates, rejected proposals, and open PRs; distills a falsifiable hypothesis with scope and downside; inspects code to identify the owner; versions a candidate; prepares a bounded change; obtains authorized evaluation; and opens/updates a target-repository PR.

It may correctly conclude that the evidence is insufficient, the issue is transient, the change already exists, ownership is unresolved, or the material is project knowledge rather than a global agent improvement. Use `target: null`/an unresolved-routing state rather than guessing. Proposed one-target-per-candidate-revision behavior is an MVP simplification; dependent kit/consumer changes need linked PRs and explicit ordering, not an assumed atomic cross-repository merge.

A PR is prepared from a branch in the target repository or an authorized fork. The unrelated dreaming repository is not merged into the target. Use stable candidate IDs and proposal branch naming so a timeout after successful PR creation can be reconciled before retrying.

The agent cannot approve or merge its own proposal, widen credentials, rewrite routing policy, weaken mandatory checks, bypass workspace isolation, or deploy itself. Improvements to the Dreaming Agent itself need a separately authorized maintainer path. That path is not enabled accidentally by a universal capture hook.

### 8.9 Candidate contract and versioning

A candidate revision should include source observations, independent-incident evidence, contradictions, hypothesis, applicability and exclusions, proposed behavior/mechanism, expected benefit, downside, target-owner rationale, exact base, affected paths/consumers, evaluation plan, and linked PR/outcome records. See [candidate schema](docs/rsi/schemas/candidate.schema.json) and [candidate example](docs/rsi/examples/candidate.json).

Git file history and candidate revisions serve different purposes. A test and PR need a stable candidate revision even when the file has Git history. Materially changed scope or hypothesis gets a new revision; a changed evaluated diff requires renewed applicable checks. Rejected proposals preserve evidence and reviewer reasons rather than disappearing.

One mechanism can span several files; one file can contain several unrelated mechanisms. Prefer one clear behavioral hypothesis per improvement PR. Deletion/merging of redundant skills can be a candidate. Mandatory safety, authorization, and approval controls are not performance-driven pruning targets.

### 8.10 Evaluation, promotion, adoption, and rollback

The proposed evaluation records pin baseline/candidate commits, model/kit configuration, evaluation-set and evaluator revisions, scenarios, repeated runs where appropriate, budget, quality metrics, efficiency, and mandatory invariants. Include motivating cases, negative activation cases, regressions, and relevant consuming agents for kit changes. Predeclare acceptance criteria rather than selecting them after seeing the result. [PACK-RSI, `06-evaluation-and-approval.md`]

For redundant clarification, test already-confirmed, genuinely missing, contradictory, outdated, and unauthorized cross-workspace information. Asking fewer questions is not the goal when a necessary clarification would be suppressed.

Candidate-authored tests can add evidence but cannot replace or weaken the trusted gate. Evaluation should not expose production secrets or writer credentials. Separate development cases from assessment cases; once assessment failures drive iteration, do not call them untouched holdout evidence. Track improvement-discovery cost separately from deployed per-task cost.

The human PR package should explain the problem, exact change, supporting/opposing evidence, evaluation results and uncertainty, affected consumers, cost, rollout, and rollback. The approval applies to the reviewed revision, not permanently to a candidate title. Effective repository controls and reviewer authority must be inspected, not inferred from the design document.

Track **approved / merged / released / adopted per consumer / measured benefit** independently. A copied skill installed at initialization will not necessarily update when the kit repository changes. Long-running sessions need consistent versions unless an explicit migration policy permits a change. A revert is not proof that every consumer has rolled back.

## 9. Research inspiration: preserve concepts, verify attribution

The session began with a request to interpret Google's latest “RRSI” research. An earlier assistant supplied the title `RRSI: Regularized Recursive Self-Improvement of Agent Harnesses`, publication/version dates, repositories, and benchmark claims. **Those external claims were not independently reverified while preparing this handoff. Do not cite them as established facts or use their numbers as acceptance thresholds.** [CHAT-RESEARCH]

The engineering ideas carried into the design were: improve the harness rather than assume weight training; treat learning as experiments; constrain the number of independent changes; preserve experiment history including failure; screen task-specific memorization and evaluation manipulation; consider performance variability and cost; test on genuinely different work; and allow simplification instead of endless instruction accumulation.

These are recorded as discussion-derived design proposals. The existing RSI package explicitly avoids benchmark/reproduction claims. A future research-verification task should identify the actual primary paper/repository, version, evaluation protocol, limitations, and any mismatch with the earlier answer before building an empirical argument around it. That verification is not a prerequisite for documenting this platform's independently stated governance requirements.

## 10. Other SDLC ideas to preserve

### Requirements clarification and BABOK

**USER:** The requirements agent should interactively translate generic BRD/functional requirements into a localized BRD, escalating when clarification is needed, then support smaller units such as Jira stories or Git issues. The focus at that point was requirements gathering, not a fully autonomous end-to-end code factory. Every governed step should receive strict review and explicit approval. [HIST-WORKSPACE]

**EXPLORATORY USER IDEA:** Feed the agent condensed BABOK guidance to make clarification more professional. No actual condensed text, licensed source corpus, ingestion method, retrieval design, or implemented skill was recovered. Preserve the idea, but do not claim the agent is BABOK-compliant or that loading a book substitutes for evaluated elicitation behavior.

A potential future requirements capability could cover stakeholder discovery, business goals, scope, assumptions, constraints, ambiguity, acceptance criteria, and traceability. These are possible evaluation dimensions, not a recovered approved checklist. Review them with the user and actual source material rather than inventing an authoritative condensed BABOK.

### Domain knowledge versus workflow training

The user used Investments categories to illustrate how knowledge might be organized, not to request a rigid taxonomy for every client. A domain knowledge scope, delivery workspace, agent source repository, and shared learning target can all differ. A correct business fact can still be inappropriate in a globally installed skill. [HIST-APPROVAL; CHAT-RSI]

### Runtime and implementation context

The user has Java/Python engineering experience, but no particular language/framework for this SDLC repository was established by the inspected material. An earlier nearby conversation asked about starting/resuming a Pi agent and viewing history; this is a runtime lead, not proof the SDLC platform uses Pi or a known version. Inspect the actual repository before depending on any runtime or CLI integration.

Do not import unrelated earlier FastAPI/Vue, PostgreSQL, Chroma, MontyDB, RAG, logistics, football-analysis, billing, or licensing project architecture as requirements for this platform. The handoff's relevant preference is shared interfaces, explicit ownership, iterative design, and GitHub-backed continuity.

## 11. Historical alternatives and conflicts to revisit

This is deliberately not a cleanup that discards earlier ideas. Keep this table when moving decisions into ADRs.

| Topic | Earlier idea / wording | Later refinement or unresolved issue | Classification |
| --- | --- | --- | --- |
| Project name | “SDOC” in a transcribed discussion | Broader conversation consistently concerns SDLC; verify actual product/repository naming. | HISTORICAL alias |
| Shared kit | `sdlc-agent-kit` | Latest user wording and both packages use `sdlc-dev-kit`; no actual rename verified. | Latest naming preference; migration OPEN |
| Agent naming | BA Agent, Architecture Agent | Requirements and Design functional groups/agents proposed; human roles remain separate. | USER exploration + PROPOSAL |
| Workspace granularity | Shared workspace around story/CR; later “one project, one new repo?” | Logical delivery case with configurable anchor and repo binding; do not confuse a question with a decision. | Latest PROPOSAL |
| Repository allocation | One repository per independently governed project | Latest workspace package proposes many cases per appropriate client/access-bound repository; dedicated repositories remain supported. | Earlier default superseded in package, not a universal final policy |
| Business categories | Investments/Payments categories could imply workspace partitioning | Categories are metadata/knowledge scopes, not required storage partitions. | Latest PROPOSAL responding to user concern |
| State machine | One artifact/truth state machine plus scratch layer | Separate run, work-item, artifact, approval, execution, and synchronization state; logical stores retain different authority. | PROPOSAL refinement |
| Scratch contents | Record the agent's “thoughts” / “thinking process” | Save concise rationale, observable actions/evidence, open questions, and checkpoints; not hidden reasoning. | Preserve intent; refined implementation boundary |
| Approval layers | Stage gate plus “uncategorized” gate | Shared mechanism with lifecycle and scoped decision/action subjects; stage relation optional. | CONFIRMED-DIRECTION at service level; detailed contract PROPOSAL |
| Approval sequence | Approve BRD, create PR, say “go ahead,” merge | Present fixed proposal first; bind approval to revision; distinguish decision, application, and transition. | PROPOSAL clarification |
| GitHub only | All durable storage is GitHub | Remains core MVP/RSI constraint; Jira-connected mode adds explicit delivery-field authority while GitHub retains ledger/baselines. | USER constraint + integration extension |
| Capture frequency | Summarize improvements after each LLM call | Invoke after eligible complete responses; zero observations is valid; do not force one lesson/commit/PR per call. | USER goal + PROPOSAL mechanics |
| Capture unit | One observation file | Latest RSI package uses one capture-event envelope with zero/multiple observations. | Latest proposed contract |
| Training trigger | Human-triggered training/distillation | Automatic capture; manually triggered bounded dreaming remains v1 baseline; scheduling is separate and OPEN. | Recovered USER history + initial PROPOSAL |
| Source/target | Dreaming agent PRs “to the source repo” | Record origin separately; target the behavior owner, which can be another agent or the kit. | Explicit user routing need + refinement |
| General lessons | Generality suggests shared kit | Require applicability, owner inspection, affected-consumer analysis, and evaluation. | PROPOSAL guardrail |
| Learning memory | Accumulate conversation summaries and distilled lessons | Distinguish evidence, candidate, tested change, release, adoption; retain failures and contradictory evidence. | PROPOSAL refinement |
| Capture everywhere | Shared skill for all agents | Exclude capture/dreaming/evaluation/replay calls from ordinary experience capture; still allow common kit initialization. | USER distribution goal + PROPOSAL eligibility |
| Independent development | SDLC stages pictured as one pipeline | User notes development can be separate and iterative; preserve shared baseline/governance across runs. | USER clarification |
| Test visibility | Tester may need BRD but perhaps not dev source | Access depends on verification responsibility and customer authorization; not settled. | OPEN |
| Supervisor | Supervisor handles dependencies/cycles/conflicts | Separate deterministic enforcement from semantic assistance and escalation. | USER need + PROPOSAL boundary |
| Research evidence | Earlier answer presented precise RRSI attribution/results | Primary-source verification still required before relying on them. | UNVERIFIED |
| Documentation versus code | Documents, schemas, and installers were generated | No proof services, hooks, GitHub protections, or Jira workflows are implemented. | Verified documentation only |

## 12. Existing deliverables and how to read them

### A. RSI package

Start with [RSI README](docs/rsi/README.md). The preserved payload contains:

```text
docs/rsi/
  README.md
  01-agent-taxonomy.md
  02-system-architecture.md
  03-conversation-capture.md
  04-github-records-and-provenance.md
  05-dreaming-agent.md
  06-evaluation-and-approval.md
  07-implementation-backlog.md
  prompts/capture-system.md
  prompts/dreaming-agent-system.md
  skills/conversation-capture/SKILL.md
  schemas/capture-output.schema.json
  schemas/capture-record.schema.json
  schemas/candidate.schema.json
  examples/                         # Synthetic records and registry
  templates/                        # Evaluation record and improvement PR
  REFERENCES.md
  VALIDATION.md
```

It is a proposed v1 design plus starter contracts, not production deployment. Exact schema names/fields may need adaptation to existing code. The original archive also contains `Install-Docs.ps1`, its package README, and its own manifest. Those original root files are retained inside the source ZIP, not flattened into the combined bundle.

### B. Workspace/approval package

Start with [workspace README](docs/workspace/README.md). This package is particularly important because it refines the older repository-allocation advice:

```text
docs/workspace/
  README.md
  01-workspace-boundaries.md
  02-shared-approval-service.md
  03-github-persistence.md
  04-jira-integration.md
  05-implementation-backlog.md
  examples/                         # Synthetic workspace, policy, approval,
                                    # action, event, snapshot, outbox records
  REFERENCES.md
  VALIDATION.md
```

Its original ZIP contains `Install-WorkspaceDocs.ps1`, its package README, and its manifest. Preserve these as source-package files rather than mixing two different root manifests/installers.

### C. Relationship between the packages

The two payloads complement one another; neither claims a live implementation. Workspace truth is not the dreaming repository. Workspace approval, runtime-action authorization, and improvement approval reuse concepts but not automatic authority. The workspace addendum must be considered when reading older prose that assumed one repository per workspace.

Both original ZIPs are included under `source-packages/` in the complete handoff bundle. The unpacked `docs/rsi/` and `docs/workspace/` content is byte-for-byte preserved. The new handoff adds context and flags conflicts without silently editing the old baselines. Its own manifest records the combined payload.

Read inherited `REFERENCES.md` files as leads supporting those documents at their creation time. Vendor capabilities and actual organizational settings must be rechecked at implementation time. The handoff does not refresh or recertify those references.

## 13. Open decisions for the new workspace

Do not ask the user to restate facts already recorded. Resolve repository-specific questions by inspection where possible, then discuss only material choices that remain.

| Decision | What is already known | What remains to establish |
| --- | --- | --- |
| Actual repository topology | Shared kit, delivery agents, dreaming, workspace/scratch concepts | Real remotes/IDs, mono- versus multi-repo layout, existing directories and ownership |
| Canonical naming | Latest kit wording is `sdlc-dev-kit`; functional agent names proposed | Display-only aliases versus actual package/repository migration |
| Runtime integration | Common initialization and per-response capture wanted | Exact runtime, lifecycle callback, install/discovery mechanism, response boundary |
| Existing implementation | Documentation packages exist | What services, tests, hooks, schemas, and approval paths actually work |
| Workspace anchor | Shared lifecycle work around stories/CRs; no mandatory business taxonomy | Tenant-specific epic/CR/story rules, split/merge behavior, provisional intake |
| Physical isolation | Different scopes must not leak | Repository/credential boundaries, dreaming ingress audience, scratch bindings |
| Collaboration model | Multiple users/agents share a case | Edit ownership, reservations, branch/worktree strategy, conflict reconciliation |
| Source visibility | Tester may need different information from developer | Per-agent/task read policies and authorized implementation-source access |
| Approval UX | Explicit authenticated human decisions required | GitHub-native review versus platform/Jira interface and verified evidence adapter |
| Approval policy | Role, revision, consequence, and scope matter | Client-authorized approvers, quorum, delegation, expiry/revocation, bootstrap |
| Revision binding | Exact approved subject and relevant dependency freshness | Canonical bundle/hash format, covered fields, invalidation rules, application races |
| Jira mode | User wants integration; GitHub approval ledger retained | Hosting/version, auth, fields, workflow mapping, write scope, external enforcement |
| Capture durability | GitHub-only; ephemeral session risk | Availability of replayable events, bounded latency, loss reporting, retry ownership |
| Capture semantics | Evidence, not compulsory lessons | Which tool-call responses qualify, context budget, deduplication across later feedback |
| Retention/privacy | Minimal authorized evidence, no secrets | Retention periods, deletion/remediation process, cross-client aggregation policy |
| Dreaming cadence | Human-triggered training history and initial bounded-run proposal | Future schedule, budgets, trigger authority; not automatic promotion |
| Evaluation | Compare fixed revisions; test negatives/regressions; protect invariants | Concrete datasets, evaluators, repetitions, thresholds, cost/latency budgets |
| Shared-kit changes | General improvements can target kit | Consumer inventory, compatibility tests, rollout approval, dependency updates |
| Release/adoption | Separate from merge | Packaging, version pinning, generated skill copies, long-running session upgrades |
| Self-improvement of dreaming | Possible only through separate governance | Whether included at all in initial scope and who independently reviews it |
| Requirements methodology | Condensed BABOK was discussed | Source material, rights, skill/retrieval approach, quality criteria, actual need |
| Supervisor | Dependencies, conflict resolution, and backtracking required | Which functions are deterministic services versus agent-assisted interpretation |
| Research lead | Earlier RRSI discussion influenced ideas | Actual primary publication/repository and correction of any earlier inaccuracies |

## 14. Suggested first Codex session

This is a handoff task proposal, not permission for remote changes.

### Step 1 — Inspect without losing local work

Read existing repository instructions, including any applicable `AGENTS.md`; inspect the working tree and actual project structure; identify uncommitted changes; locate the kit, agent definitions, runtime entry points, workspace/state code, approval code, capture/dreaming code, tests, and documentation. Do not reset changes, rename repositories, replace root instructions, install skills, or push merely because this document names an intended design.

### Step 2 — Build a reconciliation matrix

For each major component, record the relevant code/doc path, actual implemented behavior, this handoff's intended direction, status label, contradiction/gap, and smallest next action. Focus first on workspace identity, approval authority, shared initialization, capture hook, durable writer, dreaming pipeline, and adoption.

Distinguish a Markdown stub from an implemented interface and an implemented interface from a validated end-to-end flow. Inspect example values before treating them as production configuration.

### Step 3 — Preserve history in decisions

Propose concise ADRs for workspace identity/storage boundaries, approval service/subject types, authoritative state and recovery, kit/agent naming, capture eligibility/provenance, dreaming permissions/evaluation, and optional Jira field ownership. Link historical alternatives from Section 11. Do not declare a proposal accepted merely because it appears in the earlier package.

### Step 4 — Select a small end-to-end slice

The earlier backlogs suggest two connected demonstration slices. Choose their order after inspecting code:

**Delivery/governance slice:** resolve one workspace, draft a BRD, create a revision-bound proposal, obtain legitimate test-environment human review, persist evidence, apply the authorized baseline, resume after interruption, and keep approval/merge/transition distinct.

**Improvement slice:** capture one real correction from one delivery agent, validate/redact/persist it, run manually triggered dreaming, produce one candidate, evaluate positive and negative cases, create a reviewable target change, then exercise the authorized release/adoption/rollback process.

Start with synthetic/test data and narrow permissions. Add a second agent to test common contracts before claiming shared-kit generality. Jira read/link integration can precede issue creation and workflow writes. Do not make an all-agent autonomous platform the first deliverable.

### Step 5 — Define acceptance and failure cases before extending scope

Carry forward at least these scenarios from the packages:

| Scenario | Expected property |
| --- | --- |
| Two users/agents open the same authorized external case | One workspace mapping; no loss of another contributor's work |
| User disappears and returns after the runtime session expires | Reconstruct accepted baseline, pending proposal, questions, and permissions from durable records |
| Model writes “approved” or invents an approver | No authority granted |
| Reviewed artifact or relevant dependency changes | Applicable authorization becomes stale; historical review retained |
| PR merge succeeds but local event persistence fails | Reconcile actual merge and record missing event idempotently |
| Captured evidence contains an instruction to change another repo | No permission expansion or executable-policy change |
| Capture itself invokes an LLM | No recursive capture loop |
| Capture yields no learning signal | Valid empty outcome, not invented improvement |
| Duplicate event or retry appears | Reuse accepted record; do not increase independent-incident count |
| Same ID arrives with different content | Explicit integrity conflict |
| GitHub first write fails and the process dies | Honest durability/loss behavior, not a claim that RAM was a queue |
| Target owner cannot be established | Candidate retained unresolved; no guessed PR |
| PR creation succeeds but its response is lost | Reconcile before attempting another creation |
| Candidate changes its own required checks or policy | Reject/escalate outside ordinary improvement authority |
| Kit PR is merged while consumers remain pinned | Adoption state remains unchanged until verified update |
| Jira acceptance criteria change after approval | Detect covered-content drift without rewriting the historical baseline |
| Jira is unavailable after GitHub approval | Keep synchronization pending; do not fabricate a Jira update |
| Action outcome is ambiguous after a crash | Reconcile or record unknown; avoid blind re-execution |
| A released consumer regresses | Identify the affected version, previous known-good version, and verified rollback outcome |

## 15. Copy-ready opening request for Codex

```text
Read CODEX-HANDOFF.md, docs/rsi/README.md, and docs/workspace/README.md,
then inspect this repository and its existing instructions and working tree.

This handoff preserves our SDLC-platform and RSI design discussions,
including superseded proposals and unresolved decisions. Do not assume
that documented services or example configuration are implemented.

First produce a reconciliation of implemented behavior, documentation-only
proposals, conflicts, obsolete assumptions, and missing decisions. Preserve
our constraints: shared sdlc-dev-kit capabilities, a separate Dreaming Agent,
GitHub-backed durable RSI/approval records, recoverable collaborative
workspaces, and human-governed promotion. Account for the later logical-
workspace model and optional Jira integration instead of assuming that
every project or story must have a new repository.

Identify the smallest useful next implementation slice and its tests after
the inspection. Keep older alternatives visible. Do not rename repositories,
overwrite uncommitted work, modify production policy, or push changes merely
because an earlier document suggested them.
```

## 16. Completion and confidence statement

The new handoff captures the relevant current-session and recovered historical SDLC/RSI context, plus the two inspected documentation packages. It preserves user intent separately from recommendations, includes the newer workspace/Jira refinements, and identifies research and implementation claims that require verification.

It does **not** claim exhaustive access to every prior conversation, access to the Windows repository, implemented runtime behavior, current vendor validation, real approval evidence, or a successful deployment. The source ZIPs and their document payloads are preserved unchanged so the receiving workspace can compare history rather than rely solely on this synthesis.

The next workspace should tackle the remaining design and implementation questions with the user and the actual codebase. This handoff's goal is continuity without false certainty.
