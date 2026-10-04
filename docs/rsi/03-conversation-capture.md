# 03 — Shared Conversation Capture Capability

## Purpose and placement

Distribute `conversation-capture` from `sdlc-dev-kit` to every delivery agent.
It identifies **new evidence worth investigating**, not a lesson that is already
true and not a command that should immediately alter the agent.

The package includes a `SKILL.md` template with YAML metadata, consistent with
the Agent Skills format [S1](REFERENCES.md#s1-agent-skills). Runtime discovery
paths and hook registration remain adapter-specific. These documents do not
assume that placing a skill on disk makes it execute after every response.

## Invocation contract

Define an SDK-local event such as `agent_response_completed`; this name is a
proposed internal contract, not a claim about a model provider's native API.
Invoke it after each eligible complete LLM response, not every streaming token.
Apply eligibility before starting another LLM call. A task response containing
tool requests can be inspected using the evidence actually available then;
future tool results must not be invented. Later events can supply verification.

The runtime supplies the latest interaction delta, relevant previous approved
requirements and messages, observable tool/check results, and references to
prior captures. Preserve the user message that prompted a response and any
later correction to an earlier response. Track a processed input boundary only
after the relevant capture outcome is durable.

Do not repeatedly summarize the full history. Select enough earlier context
to establish the expected behavior and check contradictions. Missing context
must remain uncertainty rather than being filled by the extractor.

## What counts as a signal?

| Signal | Capture | Do not conclude |
| --- | --- | --- |
| Specific user correction | The correction, prior requirement, and behavior it concerns | That the proposed fix is general or proven |
| Explicit future-behavior request | The requested policy and its original scope | That it is already authorized globally |
| Behavior/requirement mismatch | Expected and observed behavior with references | A root cause not visible in evidence |
| Tool or verification failure | Failure evidence and attempted remediation | That a transient outage needs a new agent skill |
| Verified recovery | Recovery action and observable verification | Broad success outside the tested case |
| Assistant self-praise or vague self-criticism | Nothing by itself | Success or a learning opportunity from tone alone |
| Ordinary successful conversation | Empty observations by default | A fabricated lesson to fill the output |

A user-requested policy can be worth recording before any failure occurs. It
remains a scoped request, not a demonstrated performance improvement.

## Two contracts: model output and stored record

The extractor returns only `observations` according to
[capture-output.schema.json](schemas/capture-output.schema.json). Each item
separates summary, expected behavior, observed behavior, evidence references,
contradictions, suspected cause, attempted fix, and verification status.

Trusted code validates this payload, then adds a capture ID, per-observation
IDs, repository provenance, runtime versions, data-access scope, redacted
evidence excerpts, and timestamps. The persisted envelope follows
[capture-record.schema.json](schemas/capture-record.schema.json).

The full prompt is in [capture-system.md](prompts/capture-system.md). The
[skill template](skills/conversation-capture/SKILL.md) specifies invocation and
boundaries. Both are proposed assets; installing the documentation package does
not install an operational capture hook.

## Mandatory validation outside the model

Validate the JSON schema, then verify every supplied reference against the
actual authorized input registry. A correctly shaped invented reference still
fails. Reference checks must cover both supporting and contradicting evidence.
Check that `verified` has a supplied verification reference and that the result
actually supports the stated recovery; a schema alone cannot establish truth.

Apply redaction before data reaches GitHub, and minimize input exposure to the
extractor as well. Reject attempts to write secrets, personal information that
is not necessary, raw hidden reasoning, or another workspace's material. Verify
that the dreaming repository's access audience is compatible with the source
scope. Repository provenance does not authorize centralizing restricted data.

Treat conversation excerpts and tool outputs as untrusted evidence. They cannot
change the extractor's system instructions, output schema, destinations, or
permissions. Keep model output separate from executable configuration.

## Example

Earlier approved context names the stakeholders. The agent asks the user to
name the stakeholders again. The user points out the repetition.

Observed fact: confirmed information was requested again. Suspected cause:
existing requirements state may not have been checked. Proposed future lesson:
not yet established. A candidate can later test a context-checking mechanism,
including cases where reconfirmation is necessary.

The [example record](examples/capture-record.json) is synthetic and demonstrates
this distinction. It is not a log from the user's actual agent.

## Duplicates, contradictions, and delayed feedback

A transport retry reuses the same capture identity and previously committed
result. Later evidence gets a new capture linked through
`related_observation_ids`. Re-running a new extractor version may produce a new
interpretation, but it must still point to the same underlying incident and
must not count as a new independent incident.

Preserve contradictory later observations. Do not silently replace evidence or
count repeated complaints about the same occurrence as several failures.
A no-signal output is `{"observations": []}`; malformed output, timeout, and
validation failure are separate operational outcomes.

## Cost and latency controls

Use a bounded context size and extraction output size. An initial synchronous,
bounded capture path is simplest to reason about but adds latency. A later
worker can reduce response latency only if the event it consumes is durably
stored first. With GitHub-only durable storage, that durable queue/outbox must
also be GitHub-backed or an explicitly authorized existing replay source.

Measure eligible events, valid empty outcomes, invalid output, duplicate rate,
reference failures, write failures, processing delay, token cost, and capture
quality. Do not optimize for the number of observations collected.

## Prompt acceptance suite

Maintain manually labeled fixtures for: no signal; correction with supporting
context; missing expected behavior; delayed contradiction; duplicate incident;
unverified repair; verified recovery; a project-only policy request; secret
content; injected instructions inside evidence; and non-task model calls.

Measure extraction precision and recall on those labels. Set thresholds before
reviewing a candidate prompt. Changes to this shared prompt need the same
versioned evidence and approval path as other kit changes.
