# Moving the SDLC plan into VS Code and GitHub Copilot

> **Current MVP instructions, 2026-10-04:** Use the [MVP plan and continuation prompt](2026-10-04-sdk-platform-mvp.md) from the reported WS-01 state. Use direct implementation without Superpowers or TDD. Copilot cannot connect to the agent platform: perform available local SDK checks and hand off inaccessible wiring/live validation to an operator. Resolve the proposed human-merge boundary before that slice. Reuse completed work. The older planning, test-first and M1 workflow below is preserved as historical full-roadmap guidance and does not govern MVP execution.

## Historical full-roadmap guide

The current MVP places GitHub transport/authentication on the agent platform's existing MCP capability. Copilot implements SDK logic and documented request/result boundaries; it must not add a replacement GitHub client or require local GitHub credentials. Platform tool mapping and live validation are operator work. Older adapter wording below is historical and does not override this boundary.

Prepared 2026-10-03; scope updated 2026-10-04. Use the [SDK RSI/workspace/approval plan](../superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md) and its [current design](../superpowers/specs/2026-10-04-rsi-workspace-approval-design.md). This is a practical workflow recommendation, not a record that Copilot has been configured or implementation completed.

## What carries the project between tools

Use versioned project documents as the handoff: reviewed requirements, accepted decisions, the implementation plan, tests, and progress records. A new coding session should be able to proceed from those files without relying on this conversation.

This planning bundle is tracked in [agent-sdk-plan](https://github.com/mjmonster/agent-sdk-plan), initialized on the `docs/sdk-platform-plan` branch on 2026-10-04. The existing SDK prototype is elsewhere and will be accessible to the receiving Copilot session. Preserve both historical handoffs and package documents when transferring the plan. The [review](2026-10-03-handoff-review.md) distinguishes current scope from superseded proposals.

Recommended final bundle:

- The handoff and documentation files referenced by the plan.
- The review and first-release design, with each decision's acceptance status.
- The detailed implementation plan, including exact task files, public interfaces, failing tests, commands, acceptance criteria, and progress checkboxes.
- Repository-portable development rules and this guide.

Do not carry credentials, personal editor state, caches, or unrelated chat history into the remote repository.

## Carry the rules deliberately

Your current rules are under `~/.claude/rules`, outside this project. The recommendation is to preserve their source and prepare a reviewed repository copy for the implementation environment. Do not make a remote plan depend on `C:/Users/KyuEu/...` paths.

For Copilot, VS Code documents `AGENTS.md` or `.github/copilot-instructions.md` for project-wide guidance and `.github/instructions/**/*.instructions.md` for targeted rules. The Local agent also supports Claude compatibility formats; discovery depends on the selected harness. Verify the files in **Chat: Open Customizations**, then check response References and actual behavior. [Instruction formats and verification](https://code.visualstudio.com/docs/agent-customization/custom-instructions).

Suggested mapping, to be finalized with the implementation plan:

| Existing material | Portable purpose |
| --- | --- |
| Root testing doctrine | Concise project-wide guidance in one primary instruction file. |
| Architecture, scope, config, and security rules | Project-wide requirements, with applicability stated. |
| Python/Java/frontend testing rules | Targeted instruction files for the selected language and file patterns. |
| Claude hook descriptions | Explicit validation commands and a separately verified hook configuration if needed. |
| Planner/reviewer agent names | Named workflow responsibilities; do not assume matching agents are already installed. |

Resolve the rule conflicts recorded in the review before copying them as mandatory Copilot instructions. Keep one maintained source for each requirement and avoid contradictory copies.

VS Code supports skills in project locations including `.github/skills`, `.claude/skills`, and `.agents/skills`. A portable `SKILL.md` may be reused, but scripts, permissions, paths, and tool references still need checking. Discovery does not prove invocation. Start with the few workflows needed for this plan rather than migrating every installed skill. [Agent Skills documentation](https://code.visualstudio.com/docs/agent-customization/agent-skills).

## A short VS Code workflow

1. Open the repository root as a folder. Keep the source, plan, and instructions in the same workspace.
2. Use the Copilot Chat surface and sign in with the intended account. Confirm the chosen session/harness before assuming its instructions or tools.
3. Attach the reviewed design and implementation-plan file to the chat. Ask for a read-only preflight: state the selected task, constraints, affected files, tests, and any mismatch with the current checkout.
4. Start with Plan mode or `/plan` to review that preflight. Use the implementation action only when ready to execute the selected task. In a Local session, the generated plan can live in session memory; save the approved plan into the repository for portability. [Planning controls](https://code.visualstudio.com/docs/agents/run/planning).
5. Implement one independently testable plan task at a time. Require the red test result, passing result, relevant verification, and updated task status before moving to the next task.
6. Inspect changed files in Source Control. Review the diff and test evidence before staging and committing. VS Code provides Git diff, staging, and commit tools; use a feature branch according to the project rules. [Source Control guide](https://code.visualstudio.com/docs/sourcecontrol/overview).
7. Start a new focused conversation for the next independent task, supplying the same plan plus the completed-task state. Use a separate review conversation for material changes. [Context workflow guide](https://code.visualstudio.com/docs/agents/guides/context-engineering-guide).

The first task, INT-00, maps the plan to the existing SDK's source, tests, initialization, response hook, provider adapters, and commands. Keep its Python version and tooling. Shared platform functions belong inside the SDK installed by all agents; do not scaffold a replacement SDK or require a standalone controller. Separate Dreaming Agent orchestration reuses those functions. No SDK source or end-to-end test results need to be sent back to the planning session.

## Useful controls on Windows

| Control | Use |
| --- | --- |
| `Ctrl+Shift+P` | Find commands by name; the fastest way to discover editor functions. |
| `Ctrl+P` | Open a known file, such as the implementation plan. |
| `Ctrl+Shift+F` | Search the workspace. |
| `Ctrl+Shift+G` | Open Source Control and inspect changes. |
| Ctrl+Shift+backtick | Create an integrated terminal. |
| `Ctrl+K`, then `Ctrl+S` | Inspect or change keyboard shortcuts. |

Shortcuts can be customized. If one differs, use the Command Palette or Keyboard Shortcuts editor. [Windows shortcut reference](https://code.visualstudio.com/shortcuts/keyboard-shortcuts-windows.pdf), [terminal guide](https://code.visualstudio.com/docs/terminal/basics).

## Model selection

GitHub's current model list includes GPT-6 variants. Availability depends on the account's Copilot plan, client, and enabled model policies. Verify the model picker in the actual session rather than assuming availability from another application. [Supported Copilot models](https://docs.github.com/en/copilot/reference/ai-models/supported-models).

Keep the plan independent of a model name. A capable implementation model still needs explicit contracts, tests, and review. The model used to write code is also separate from the model/runtime that the SDLC product will eventually use.

Local inspection confirmed VS Code version 1.115.0. The CLI extension inventory could not complete because of filesystem permissions, so this review does not certify the active Copilot installation, profile, sign-in, or account model access. No editor settings or extensions were changed.

## Starting prompt for the implementation session

Attach the current SDK design, detailed plan, and repository rules. When ready to authorize the first milestone, use:

```text
Implement milestone M1 of docs/superpowers/plans/2026-10-04-sdk-rsi-workspace-approval.md
inside this existing sdlc-dev-kit checkout. Read its linked current design and
repository instructions first. The kit is installed for all SDLC agents;
workspace, approval, shared capture, and platform governance belong inside it.
Keep the current Python version, tooling, public consumers, and local changes.
The 2026-10-03 delivery-only design is superseded.

Start with INT-00: map the plan's semantic contracts to actual SDK source and
test paths, record exact native commands, and run the existing baseline checks.
Then execute M1 tasks in dependency order. Reuse verified existing behavior.
For each change, enumerate edge cases, write/run the failing behavior test,
implement the minimum change, run the required checks, and update task evidence.
Continue through routine interface/path mappings without a new scope interview.
Ask only for material scope/authority conflicts or genuinely missing required inputs.

Stop after M1 and report the diff, RED/GREEN evidence, and pending live checks.
Do not push, deploy, expand permissions, or mark later milestones complete.
```

This prompt authorizes M1 only; replace the named milestone when authorizing later work. The planning session does not run the SDK or live-provider journey. The receiving session reports those results honestly and keeps task-level test/review evidence.

## Readiness checklist

- [x] Historical handoffs and current review are available locally.
- [x] Existing rules have been located and their portability gaps recorded.
- [x] RSI, workspace, and approval are included in the active implementation plan.
- [x] Shared platform functions belong in the existing installed SDK; Python/tooling remain unchanged.
- [x] CLI interaction and GitHub PR reviews have been selected.
- [x] Existing BRD import through the CLI has been selected; built-in LLM drafting is deferred.
- [x] A detailed plan is written without requiring prototype access or local end-to-end execution.
- [ ] User reviews the corrected plan; receiving Copilot maps native paths and commands in INT-00.
- [ ] Required instructions are present in the destination repository and discovered by Copilot.
- [ ] Repository remote, default branch, account, model access, and test tools are verified.
- [ ] A fresh session completes the read-only preflight without relying on this chat.
