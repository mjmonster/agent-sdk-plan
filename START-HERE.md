# Start Here — SDLC Platform / RSI Codex Handoff

Read [CODEX-HANDOFF.md](CODEX-HANDOFF.md) first. It preserves the available SDLC and RSI discussion history, distinguishes user requirements from proposals, and includes older alternatives, unresolved decisions, and a suggested first Codex session.

## Contents

| Path | Purpose |
| --- | --- |
| [CODEX-HANDOFF.md](CODEX-HANDOFF.md) | Self-contained project-memory handoff and copy-ready opening request |
| [docs/rsi/README.md](docs/rsi/README.md) | Earlier RSI design, capture/dreaming prompts, schemas, examples, and backlog |
| [docs/workspace/README.md](docs/workspace/README.md) | Earlier workspace, approval, GitHub persistence, and Jira addendum |
| [source-packages/sdlc-agent-rsi-docs.zip](source-packages/sdlc-agent-rsi-docs.zip) | Original RSI archive, unchanged, including its original installer and manifest |
| [source-packages/sdlc-agent-workspace-docs.zip](source-packages/sdlc-agent-workspace-docs.zip) | Original workspace archive, unchanged, including its original installer and manifest |
| [HANDOFF-VALIDATION.md](HANDOFF-VALIDATION.md) | Checks performed for this handoff and their limits |
| [handoff-manifest.json](handoff-manifest.json) | SHA-256 hashes and byte sizes for the combined payload |

## Move into the intended workspace

The intended destination is `C:\WORKSPACE\sdlc-agent`.

Extract this bundle into a **separate temporary folder first**, rather than overwriting an existing project. Place `CODEX-HANDOFF.md` at the project root and compare the two documentation directories with any existing copies. Preserve local changes and let Codex reconcile differences before replacing files.

The standalone Markdown handoff remains readable without the bundle; its relative links to earlier documents resolve when the accompanying `docs/` directories are present.

This bundle intentionally has **no new auto-installer and no root `AGENTS.md`**. Original installers are inside their respective source ZIPs and use their own manifests. Do not mix their package-root files or run them as though they use the combined manifest.

## Begin in Codex

Use the opening request in Section 15 of `CODEX-HANDOFF.md`. Ask the receiving workspace to inspect the actual code and reconcile implemented behavior, proposals, obsolete assumptions, and open decisions before choosing an implementation slice.

Nothing in this bundle was written directly to the Windows directory. No code, live policy, repository permissions, Jira data, PR, agent installation, or deployment was changed by its preparation. The original documentation payloads remain unchanged; historical corrections and qualifications are in the new handoff.
