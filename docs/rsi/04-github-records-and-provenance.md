# 04 — GitHub-Only Records, Provenance, and Persistence

## Repository layout

Use a protected `main` branch for the Dreaming Agent's code, prompts, schemas,
and routing policy. Use a separate `experience-data` branch for append-oriented
learning records. The branch names are proposed conventions, not inspected
existing branches.

```text
main:                            experience-data:
  agent/                           captures/<source-id>/<session-id>/<capture-id>.json
  prompts/                         candidates/<candidate-id>/v<revision>/candidate.json
  schemas/                         evaluations/<candidate-id>/v<revision>/<run-id>.json
  policy/repositories.yaml         events/<candidate-id>/<event-id>.json
                                   runs/<run-id>.json
```

The data branch is not merged into executable code merely because it receives
new observations. Load executable policy only from a protected, pinned revision.
Choose the storage audience before centralizing evidence; separate dreaming
repositories or reject ingress when scopes cannot safely share access.

## Why one file per capture event?

In v1, one envelope holds all observations extracted from one completed-response
event plus their redacted supporting material. This avoids a partial event in
which some observations were committed but the completion manifest was not.
An empty valid result can be stored as a minimal envelope with no evidence body.
GitHub provides a create/update contents endpoint [S2](REFERENCES.md#s2-github-contents-api).

A status label alone is not an acknowledgment. A persistence receipt contains
the repository ID, branch, path, commit SHA, and capture ID. Do not put the
containing commit SHA inside the file that is about to create that commit;
store it in the writer's returned receipt or a later referencing record.

## Provenance fields

| Field | Source of authority | Purpose |
| --- | --- | --- |
| `source_agent.repository_id` | Trusted deployment registry | Stable repository identity |
| `source_agent.repository_full_name` | Registry snapshot | Readable historical name |
| `source_agent.commit_sha` | Runtime deployment metadata | Version that produced the incident |
| `source_agent.agent_group`, `agent_id` | Runtime registry | Functional group and actual executor |
| `workspace.repository_id`, `commit_sha` | Workspace adapter | Task artifact location and known snapshot |
| `kit.name`, `kit.version` | Resolved deployment dependency | Shared capability version |
| `extractor.version`, `prompt_version`, `model_id` | Runtime configuration | Interpretation provenance |
| `session_id`, `response_id` | Runtime event source | Correlation and deduplication |
| `data_scope` | Access policy | Audience and project separation |
| Candidate `target` | Registry-validated routing decision | Actual owner of the proposed change |

A source repository is not automatically the target repository. The workspace
repository is not automatically either one. Capture source identity now; the
target is resolved during distillation, and stays `null` until then.

## Identity and idempotency

Compute `capture_id` from a canonical encoding of data scope, source repository
ID, session ID, response ID, and extractor version. For example, SHA-256 of a
compact JSON array avoids ambiguous string concatenation. Use synthetic sample
values only in examples; production IDs come from trusted runtime inputs.

Derive observation IDs from `capture_id` plus their stable ordinal in the first
accepted extraction. On retry, read and reuse an existing committed capture
instead of invoking the model again and overwriting different content. An
existing ID with different bytes is a conflict requiring investigation, not a
new observation. For independent-incident counting, use the original event
identity without the extractor-version component, then cluster related events.

Use a single authorized writer per data branch initially. Distinct filenames
do not eliminate branch-update conflicts. Re-read state, verify identity, and
retry boundedly on conflicts. GitHub specifically documents conflicts between
parallel content creation/update and deletion [S2](REFERENCES.md#s2-github-contents-api).
Do not use one shared editable index as the only authority.

## GitHub-only durability tradeoff

The application cannot simultaneously guarantee lossless capture, never delay
completion, survive loss of ephemeral memory, and persist nothing while GitHub
is unavailable. Select an honest failure contract.

Recommended v1: make a bounded write attempt before marking capture complete;
return/report capture failure separately from task success. Retry from an
existing durable conversation/event source when one actually exists. Otherwise
an uncommitted event may be lost after process death. Do not claim a local
in-memory retry list is durable. Adding a GitHub-backed outbox introduces its
own first-write dependency and does not solve an outage at that boundary.

Apply bounded backoff and honor server rate-limit/retry guidance. Do not flood
the API with one uncontrolled parallel writer per agent. Shard paths by source
and session so a single directory does not grow without bound; the contents API
has a directory listing limit [S2](REFERENCES.md#s2-github-contents-api).

## Candidate revisions and events

A candidate is a hypothesis and scoped change proposal, not raw conversation
history. Record explicit revisions even though Git tracks file history: an
experiment and PR must refer to an immutable candidate revision.

Store state changes as events such as `candidate_created`, `evaluation_failed`,
`pr_opened`, `review_changes_requested`, `pr_merged`, `released`,
`consumer_adopted`, or `reverted`. Derived dashboards can be rebuilt from these
records and authoritative GitHub state. An `approved: true` field written by an
agent never substitutes for a GitHub review.

Operational run logs may include error codes and sanitized failure summaries;
they must not reintroduce rejected raw content into the repository. Rejected
candidates retain their evidence links and reviewer reasons. A revision can be
superseded without destroying the original record.

## Permissions and data hygiene

The default Actions `GITHUB_TOKEN` is limited to the workflow repository
[S3](REFERENCES.md#s3-github-actions-token). Cross-repository work can use a
GitHub App with a scoped installation token [S4](REFERENCES.md#s4-github-app-authentication).
Keep credentials in the trusted adapter, not the skill prompt or record.

GitHub token scoping to repositories is not an arbitrary per-file sandbox.
Separate trusted writer execution, enforce branch/path allowlists in code, and
protect executable branches against the writer identity. The Dreaming Agent
must not change the registry or branch rules through its ordinary proposal tools.

Redact before commit. Normal deletion is not a guarantee of removal from Git
history; use a separate approved incident-response process for any sensitive
material that has already been committed [S7](REFERENCES.md#s7-sensitive-git-history).
The append-oriented design is subject to mandatory privacy/security remediation,
not a reason to preserve exposed secrets forever.
