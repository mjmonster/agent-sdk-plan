# SDLC Workspace and Approval Documentation Package

Prepared for `C:\WORKSPACE\sdlc-agent`. The Windows folder has **not** been changed.
A direct local-file connection was not available. This package adds documentation,
not an implemented SDK service. The existing local repository has not been inspected.

Start at `docs/workspace/README.md`. The payload covers logical workspace boundaries,
the confirmed shared approval service design, GitHub persistence/recovery, proposed
Jira integration, an implementation backlog, primary references, and synthetic records.
It complements the existing RSI package without modifying its `docs/rsi` files.

## Install into the intended local project

Save the ZIP in Downloads, then run in PowerShell:

```powershell
$stage = Join-Path $env:TEMP ("sdlc-workspace-docs-" + [guid]::NewGuid().ToString("N"))
Expand-Archive -LiteralPath "$HOME\Downloads\sdlc-agent-workspace-docs.zip" -DestinationPath $stage
& (Join-Path $stage 'Install-WorkspaceDocs.ps1') -TargetRoot 'C:\WORKSPACE\sdlc-agent'
```

Append `-WhatIf` to the final command to preview without copying. The target directory
must already exist. Follow your organization's script execution policy; this package
does not change or bypass it.

The installer verifies a SHA-256 payload manifest, copies only `docs/workspace/`, skips
identical files, and aborts before copying on detected differing-file conflicts. It
rejects symbolic-link/junction paths. It makes no Git commit or push and does not
install dependencies, rename repositories, alter agent instructions, connect Jira,
configure branch protection, or change application code. It does not overwrite your
existing architecture documents.

Multi-file copying is not an atomic filesystem transaction. Disk errors or concurrent
changes can interrupt a copy; rerun to skip matching files and expose conflicts.
The installer is supplied as source; it has not been executed on Windows here.
The manifest checks consistency, not cryptographic publisher identity.

All example tenants, roles, hashes, issue keys, review identities, and event IDs are
synthetic. They do not attest that a client approved anything or that an API call ran.
