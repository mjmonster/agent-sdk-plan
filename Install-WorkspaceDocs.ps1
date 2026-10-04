#requires -Version 5.1
<#
.SYNOPSIS
Copies this documentation package into an existing SDLC project.
.DESCRIPTION
Validates the payload manifest and checks all destinations before copying.
Identical existing files are skipped; differing existing files cause an error.
Copies only docs/workspace content. Does not install agent skills or edit Git config.
No Git commit, push, repository rename, dependency install, or policy change.
Supports -WhatIf. This script has not been executed on Windows by its author.
.PARAMETER TargetRoot
The existing project folder. Defaults to C:\WORKSPACE\sdlc-agent.
#>
[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$TargetRoot = 'C:\WORKSPACE\sdlc-agent'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Assert-NoReparsePoint {
    param([Parameter(Mandatory = $true)][string]$Path)
    $current = [IO.Path]::GetFullPath($Path)
    while (-not [string]::IsNullOrEmpty($current)) {
        if (Test-Path -LiteralPath $current) {
            $item = Get-Item -LiteralPath $current -Force
            if (($item.Attributes -band [IO.FileAttributes]::ReparsePoint) -ne 0) {
                throw "Refusing a symbolic link or junction in path: $current"
            }
        }
        $parent = [IO.Path]::GetDirectoryName($current)
        if ($parent -eq $current) { break }
        $current = $parent
    }
}

if (-not (Test-Path -LiteralPath $TargetRoot -PathType Container)) {
    throw "The target project folder does not exist: $TargetRoot. Create or select the intended project folder first."
}
$targetItem = Get-Item -LiteralPath $TargetRoot
if ($targetItem.PSProvider.Name -ne 'FileSystem') {
    throw 'TargetRoot must be a filesystem folder.'
}
$target = [IO.Path]::GetFullPath($targetItem.FullName)
$sourceRoot = [IO.Path]::GetFullPath($PSScriptRoot)
Assert-NoReparsePoint -Path $target
Assert-NoReparsePoint -Path $sourceRoot
$manifestPath = Join-Path $sourceRoot 'manifest.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$entries = @($manifest.files)
if ($entries.Count -eq 0) { throw 'The payload manifest is empty.' }

$plan = @()
$conflicts = @()
$seen = @{}
foreach ($entry in $entries) {
    $relative = [string]$entry.path
    if ($relative -notmatch '^docs/workspace/[A-Za-z0-9_./-]+$' -or
        $relative -match '(^|/)\.\.?(/|$)' -or
        $relative.Contains('//') -or
        [IO.Path]::IsPathRooted($relative)) {
        throw "Unsafe payload path: $relative"
    }
    if ($seen.ContainsKey($relative)) { throw "Duplicate manifest path: $relative" }
    $seen[$relative] = $true
    $source = [IO.Path]::GetFullPath((Join-Path $sourceRoot $relative))
    $destination = [IO.Path]::GetFullPath((Join-Path $target $relative))
    Assert-NoReparsePoint -Path $source
    Assert-NoReparsePoint -Path $destination
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Missing payload file: $relative"
    }
    $sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
    if ($sourceHash -ne [string]$entry.sha256) {
        throw "Payload hash mismatch: $relative"
    }
    $skip = $false
    if (Test-Path -LiteralPath $destination) {
        if (-not (Test-Path -LiteralPath $destination -PathType Leaf)) {
            $conflicts += "$relative (destination is not a regular file)"
        } elseif ((Get-FileHash -LiteralPath $destination -Algorithm SHA256).Hash -eq $sourceHash) {
            $skip = $true
        } else {
            $conflicts += "$relative (existing content differs)"
        }
    }
    # Detect a file occupying any would-be parent directory before any copying.
    $parent = [IO.Path]::GetDirectoryName($destination)
    while (-not [string]::IsNullOrEmpty($parent) -and $parent -ne $target) {
        if ((Test-Path -LiteralPath $parent) -and
            -not (Test-Path -LiteralPath $parent -PathType Container)) {
            $conflicts += "$relative (a parent path is a file: $parent)"
            break
        }
        $parent = [IO.Path]::GetDirectoryName($parent)
    }
    $plan += [pscustomobject]@{
        Source = $source; Destination = $destination; Relative = $relative; Skip = $skip
    }
}
if ($conflicts.Count -gt 0) {
    throw ("No files were copied. Resolve these conflicts first:`n" + ($conflicts -join "`n"))
}

$copied = 0
$skipped = 0
foreach ($item in $plan) {
    if ($item.Skip) { $skipped++; continue }
    if ($PSCmdlet.ShouldProcess($item.Destination, 'Copy new documentation file')) {
        Assert-NoReparsePoint -Path $item.Destination
        [void][IO.Directory]::CreateDirectory([IO.Path]::GetDirectoryName($item.Destination))
        # Do not overwrite a file that appears after the preflight.
        [IO.File]::Copy($item.Source, $item.Destination, $false)
        $copied++
    }
}
Write-Output "Copied $copied documentation files; skipped $skipped identical files. Target: $target"
Write-Output 'No Git commit, push, runtime skill installation, or application configuration change was performed.'
