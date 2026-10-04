# SDLC Agent Platform — Governed RSI Design

**Status:** Proposed implementation baseline · **Version:** 0.1.0 · **Date:** 2026-10-01  
**Intended local project:** `C:\WORKSPACE\sdlc-agent`

## Decision in one paragraph

Every delivery agent receives the same `conversation-capture` skill from
`sdlc-dev-kit`. A trusted runtime hook invokes that capability after eligible
LLM responses; installation alone is not the scheduling mechanism. Capture
records evidence, not permanent lessons. A separate **Dreaming Agent** reads
that evidence from a GitHub dreaming repository, distills bounded improvement
candidates, evaluates proposed changes, and opens PRs against the repository
that owns the behavior. A human authorizes the reviewed change. The Dreaming
Agent cannot approve itself, bypass policy, or silently update running agents.

## Naming convention

Use **functional capability names** for agent groups and public agents:
Requirements, Design, Implementation, and Verification. Keep BA, architect,
developer, and QA engineer as human accountability or specialist-persona labels.
A group can initially contain one agent; the name does not require a multi-agent
implementation. The Dreaming Agent belongs to the **Improvement** group, separate
from the delivery groups.

`sdlc-dev-kit` is the canonical name in this proposal. Earlier discussion used
`sdlc-agent-kit`. This package does not rename an existing repository; resolve
actual repository identities in a trusted registry before implementation.

## Read in this order

| Document | Purpose |
| --- | --- |
| [01 — Agent taxonomy](01-agent-taxonomy.md) | Group, agent, human role, skill, tool, and runtime boundaries |
| [02 — System architecture](02-system-architecture.md) | Components, authority, operating modes, and end-to-end flow |
| [03 — Conversation capture](03-conversation-capture.md) | Triggering, evidence quality, prompt contract, privacy, and failure behavior |
| [04 — GitHub records and provenance](04-github-records-and-provenance.md) | Storage, identity, routing inputs, deduplication, and lifecycle records |
| [05 — Dreaming Agent](05-dreaming-agent.md) | Distillation, routing, versioning, bounded changes, and recovery |
| [06 — Evaluation and approval](06-evaluation-and-approval.md) | Independent checks, PR review, release, adoption, and rollback |
| [07 — Implementation backlog](07-implementation-backlog.md) | Phased work with acceptance criteria |

## Supporting assets

- [Capture skill template](skills/conversation-capture/SKILL.md) and
  [extraction prompt](prompts/capture-system.md).
- [Dreaming Agent prompt](prompts/dreaming-agent-system.md).
- [Capture output schema](schemas/capture-output.schema.json),
  [stored capture schema](schemas/capture-record.schema.json), and
  [candidate schema](schemas/candidate.schema.json).
- [Example extractor output](examples/capture-output.json),
  [empty output](examples/capture-empty.json),
  [stored record](examples/capture-record.json), and
  [candidate](examples/candidate.json).
- [Example repository registry](examples/repositories.example.yaml),
  [evaluation record template](templates/evaluation-record.yaml), and
  [PR body template](templates/improvement-pr.md).
- [Technical references](REFERENCES.md) and [package validation](VALIDATION.md).

The schemas are a proposed v1 data contract. Example organizations, IDs, hashes,
versions, observations, and results are **illustrative**, not records from an
inspected repository. Policy YAML and evaluation YAML are templates, not a
claimed existing SDK configuration format.

## Scope and non-goals

This is documentation plus starter contracts and prompts, not an implemented
runtime or a production-ready GitHub integration. Existing local code, branch
rules, permissions, CI, and repository layout have not been inspected. No live
agent, workflow, skill installation, repository rename, PR, or release is made
by this package. All files are staged under `docs/rsi`; no root `AGENTS.md`,
production prompt, or `.github/workflows` file is replaced.

The design concerns harness improvement: prompts, skills, tools, workflow,
retrieval, and context handling. It does not implement model-weight training,
and does not make benchmark or research-reproduction claims.

## Operating invariants

Evidence is not an approved requirement. An observation is not a validated
lesson. A candidate is not an accepted change. An approved PR is not a released
version, and a released kit version is not necessarily adopted by consumers.
Task-artifact approval, runtime authorization, and improvement approval remain
separate decisions.

Automatic capture is the requested architecture. Human-triggered distillation
is the **recommended initial operating mode**, not an assertion about existing
implementation. Scheduling can be added later without changing promotion rules.
