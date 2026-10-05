# SDLC SDK platform implementation plans

Start with the [MVP plan](docs/planning/2026-10-04-sdk-platform-mvp.md) for the smaller first release. The [full implementation plan](docs/superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md) and its [design](docs/superpowers/specs/2026-10-04-rsi-workspace-approval-design.md) remain the long-term roadmap.

This repository contains the planning handoff for extending an existing `sdlc-dev-kit` installed across SDLC agents. Shared workspace, approval, capture, persistence coordination, and RSI governance logic belong inside that SDK. GitHub transport and authentication use the agent platform's existing MCP capability. A separate Dreaming Agent uses the shared functions to propose governed improvements.

The plan preserves the existing SDK's Python version, tooling, packaging, and consumers. It does not prescribe a replacement SDK or a standalone controller product.

## Hand off to Copilot

1. Open the existing SDK checkout in VS Code and make this planning bundle available in the workspace.
2. Read the MVP plan and the SDK repository's own instructions. Human-only merging is confirmed: the SDK verifies review/merge evidence and records acceptance.
3. Continue the reported **WS-01** implementation using the existing integration map and execution log. Reuse verified foundation work; do not restart INT-00. The planning session did not have SDK source access.
4. Use the MVP plan's continuation prompt: direct implementation, no Superpowers or TDD, and available local SDK checks. Copilot cannot connect to the agent platform; hand off platform wiring and validation that require access. The [Copilot guide](docs/planning/copilot-handoff-guide.md) retains the older workflow as historical reference only.

The MVP covers one real consumer, shared resumable work, capture, verified approval and one bounded improvement PR. The following milestones remain the full roadmap; completing an MVP subset does not complete them.

| Milestone | Result |
| --- | --- |
| M1 | Workspace-bound capture through an existing delivery consumer. |
| M2 | Shared revision-bound approval, scoped effects, and recovery. |
| M3 | A separate bounded dreaming run produces an evaluated target proposal. |
| M4 | Governed release, explicit adoption/rollback, and shared SDK installation verified. |

The MVP release boundary is confirmed. This repository does not contain the SDK implementation or evidence that its tests or live end-to-end workflow have run.

## Supporting material and history

- [Review and decision record](docs/planning/2026-10-03-handoff-review.md)
- [Latest historical handoff](<CODEX-HANDOFF(1).md>) and [original handoff](CODEX-HANDOFF.md)
- [RSI design baseline](docs/rsi/README.md)
- [Workspace and approval baseline](docs/workspace/README.md)
- [Superseded delivery-only proposal](docs/superpowers/specs/2026-10-03-delivery-foundation-design.md)
- [Original package entry point](START-HERE.md), [manifest](handoff-manifest.json), and [validation record](HANDOFF-VALIDATION.md)

Historical documents, schemas, examples, and source archives are preserved for traceability. Use the MVP profile for first-release scope and the full SDK plan for retained long-term requirements. The legacy installer is preserved source material; it is not required to use these plans and must not be run against the combined handoff manifest.
