# 01 — Agent Groups, Agents, and Shared Capabilities

## Decision

Name delivery groups by the function and outputs they own, not by a human job
title. The proposed examples—Requirements Agent instead of BA Agent, and Design
Agent instead of Architecture Agent—are **function-based naming**. Reserve
human role names for expertise and accountability.

This makes an agent's remit explicit without implying that it replaces all
responsibilities of a business analyst or architect. It also avoids binding the
platform to a particular organization's job titles. This is a design judgment,
not a universal industry naming rule.

## Proposed vocabulary

| Layer | Meaning | Example |
| --- | --- | --- |
| Agent group | Stable functional boundary; may contain one or several agents | `requirements`, `design`, `improvement` |
| Agent | A configured executor with its own objective, tools, and permissions | `requirements-primary`, `design-architecture`, `dreaming` |
| Skill | Reusable instructions and related resources for a bounded capability | `conversation-capture`, `requirements-clarification` |
| Tool | A typed executable operation with enforced authorization | Submit capture record; read approved artifact |
| Runtime hook | Application-controlled invocation at a lifecycle event | Invoke capture after an eligible completed response |
| Human role | A person or accountable review function | Business analyst, architect, repository maintainer |

Do not create a separate autonomous agent merely because a function exists.
Capture should be a shared capability; the Dreaming Agent warrants separation
because it has a different objective, lifecycle, evidence view, and authority.

## Initial groups

| Group ID | User-facing agent | Typical responsibility | Typical human reviewer |
| --- | --- | --- | --- |
| `requirements` | Requirements Agent | Clarification, BRDs, requirements, acceptance-criteria traceability | Business analyst or product owner |
| `design` | Design Agent | System design, architecture, interfaces, technical decisions | Architect or technical lead |
| `implementation` | Implementation Agent | Code changes and implementation notes | Developer or technical lead |
| `verification` | Verification Agent | Test design, execution evidence, defect reporting | QA engineer or designated reviewer |
| `improvement` | Dreaming Agent | Evidence distillation, experiments, improvement PRs | Target repository maintainer |

Only create these deployed agents when needed. The table is a taxonomy, not a
requirement to build five agents immediately. Release/operations can become a
separate group later if its ownership boundary is useful.

"Design" can mean architecture, UX, or detailed component design. In v1,
explicitly scope the Design Agent to **system and technical design**. Use
`design-architecture` and `design-experience` if both disciplines are introduced;
do not quietly assign UX work to an architecture-only agent.

## Group expansion without renaming the function

A Requirements group might later contain a clarification agent, an artifact
author, and a requirements-quality checker. They share a capability boundary
but need not share a process, model, or credential. Record both `agent_group`
and `agent_id`; group membership never grants repository access by itself.

Skills describe capabilities such as `requirements-clarification` or
`artifact-completeness-check`, not job titles such as `business-analyst`.
Personas can state domain expertise, but persona text does not confer authority.

## Shared kit boundary

`sdlc-dev-kit` owns cross-agent contracts and runtime support: initialization,
workspace access conventions, approval interfaces, capture, provenance,
validation interfaces, and compatible version metadata. A specialized agent
owns its domain-specific behavior. The Dreaming Agent is another consumer of
platform support, not the shared kit itself.

Distribution and activation are separate. All delivery agents install a pinned
capture skill version and register the runtime hook. The Dreaming Agent can
have the same kit installed while its improvement runs are excluded from
ordinary capture to avoid recursive ingestion.

## Migration rule

Use stable repository IDs and explicit aliases for historical names. Preserve
historical agent labels in existing observations. Add current canonical labels
in registry metadata rather than rewriting history. Renaming a display label
does not rename a repository, change ownership, or redirect a PR automatically.
No actual repository migration is performed by these documents.
