# SDLC SDK platform implementation plans

Start with the [implementation plan](docs/superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md) and its [current design](docs/superpowers/specs/2026-10-04-rsi-workspace-approval-design.md).

This repository contains the planning handoff for extending an existing `sdlc-dev-kit` installed across SDLC agents. Shared workspace, approval, capture, persistence, and RSI governance functions belong inside that SDK. A separate Dreaming Agent uses those functions to propose governed improvements.

The plan preserves the existing SDK's Python version, tooling, packaging, and consumers. It does not prescribe a replacement SDK or a standalone controller product.

## Hand off to Copilot

1. Open the existing SDK checkout in VS Code and make this planning bundle available in the workspace.
2. Read the implementation plan, current design, and the SDK repository's own instructions.
3. Start with task **INT-00**, which maps the plan's contracts and tests to actual SDK files, interfaces, and commands. The planning session did not have SDK source access.
4. Implement the selected milestone using the plan's test-first steps. The [Copilot guide](docs/planning/copilot-handoff-guide.md) includes a starting prompt for milestone M1.

| Milestone | Result |
| --- | --- |
| M1 | Workspace-bound capture through an existing delivery consumer. |
| M2 | Shared revision-bound approval, scoped effects, and recovery. |
| M3 | A separate bounded dreaming run produces an evaluated target proposal. |
| M4 | Governed release, explicit adoption/rollback, and shared SDK installation verified. |

The plan is ready for implementation handoff. This repository does not contain the SDK implementation or evidence that its tests or live end-to-end workflow have run.

## Supporting material and history

- [Review and decision record](docs/planning/2026-10-03-handoff-review.md)
- [Latest historical handoff](<CODEX-HANDOFF(1).md>) and [original handoff](CODEX-HANDOFF.md)
- [RSI design baseline](docs/rsi/README.md)
- [Workspace and approval baseline](docs/workspace/README.md)
- [Superseded delivery-only proposal](docs/superpowers/specs/2026-10-03-delivery-foundation-design.md)
- [Original package entry point](START-HERE.md), [manifest](handoff-manifest.json), and [validation record](HANDOFF-VALIDATION.md)

Historical documents, schemas, examples, and source archives are preserved for traceability. Follow the 2026-10-04 SDK plan when older alternatives disagree. The legacy installer is preserved source material; it is not required to use this plan and must not be run against the combined handoff manifest.
