#Requires -Version 5.1

<#!
.SYNOPSIS
    Install repository skills into global agent skill folders.

.DESCRIPTION
    Scans the repository root for top-level skill directories containing either
    SKILL.md or skill.md, then copies each skill into the selected user-level
    runtime folders under the current home directory. When the script is not
    running from a local clone of this repository, it bootstraps by cloning the
    repo into a cache directory in the user's home folder. Existing installed
    skill directories are replaced.

.PARAMETER RepositoryRoot
    Repository directory to scan. If omitted, the script uses the local repo
    when available, otherwise it bootstraps a cached clone.

.PARAMETER RepoUrl
    Git URL used when the script needs to bootstrap a cached clone.

.PARAMETER CloneRoot
    Directory that stores the cached clone when bootstrapping.

.PARAMETER Branch
    Branch to clone when bootstrapping.

.PARAMETER Target
    One or more runtimes to install for. Defaults to Agents, Codex, Claude,
    and Copilot.

.PARAMETER PassThru
    Emit an object for each installed skill.

.EXAMPLE
    ./scripts/Install-AgentSkills.ps1

    Installs all repository skills into ~/.agents/skills, ~/.codex/skills,
    ~/.claude/skills, and ~/.copilot/skills, replacing existing copies.

.EXAMPLE
    irm https://raw.githubusercontent.com/jorgeasaurus/agent-skills/main/scripts/Install-AgentSkills.ps1 | iex

    Clones the repository into ~/.agent-skills/agent-skills when needed, then
    installs all skills into the default global runtime folders.

.EXAMPLE
    ./scripts/Install-AgentSkills.ps1 -Target Agents,Codex,Claude -WhatIf

    Shows what would be installed for Agents, Codex, and Claude without
    changing files.
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$RepositoryRoot,

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$RepoUrl = 'https://github.com/jorgeasaurus/agent-skills.git',

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$CloneRoot = (Join-Path -Path $HOME -ChildPath '.agent-skills'),

    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string]$Branch = 'main',

    [Parameter()]
    [ValidateSet('Agents', 'Codex', 'Claude', 'Copilot')]
    [string[]]$Target = @('Agents', 'Codex', 'Claude', 'Copilot'),

    [Parameter()]
    [switch]$PassThru
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedRepositoryRoot = $null

function Resolve-FullPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    [System.IO.Path]::GetFullPath($Path)
}

function Test-IsRepositoryRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path -PathType Container)) {
        return $false
    }

    return (Test-Path -LiteralPath (Join-Path -Path $Path -ChildPath 'scripts/Import-AgentSkills.ps1') -PathType Leaf) -and
        (Test-Path -LiteralPath (Join-Path -Path $Path -ChildPath 'README.md') -PathType Leaf)
}

function Get-BootstrapClonePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Root,

        [Parameter(Mandatory)]
        [string]$Url
    )

    $trimmedUrl = $Url.TrimEnd('/')
    $repoName = [System.IO.Path]::GetFileNameWithoutExtension($trimmedUrl)

    if ([string]::IsNullOrWhiteSpace($repoName)) {
        $repoName = 'agent-skills'
    }

    return Join-Path -Path $Root -ChildPath $repoName
}

function Initialize-BootstrapRepository {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Url,

        [Parameter(Mandatory)]
        [string]$Root,

        [Parameter(Mandatory)]
        [string]$RequestedBranch
    )

    $gitCommand = Get-Command -Name git -ErrorAction SilentlyContinue
    if (-not $gitCommand) {
        throw 'git is required to bootstrap this installer from the repository URL.'
    }

    if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($Root, 'Create bootstrap cache directory')) {
            $null = New-Item -ItemType Directory -Path $Root -Force
        }
    }

    $clonePath = Get-BootstrapClonePath -Root $Root -Url $Url
    $resolvedClonePath = Resolve-FullPath -Path $clonePath

    if (Test-IsRepositoryRoot -Path $resolvedClonePath) {
        return $resolvedClonePath
    }

    if (Test-Path -LiteralPath $resolvedClonePath) {
        if ($PSCmdlet.ShouldProcess($resolvedClonePath, 'Replace incomplete bootstrap directory')) {
            Remove-Item -LiteralPath $resolvedClonePath -Recurse -Force
        }
    }

    if ($PSCmdlet.ShouldProcess($resolvedClonePath, "Clone $Url")) {
        & $gitCommand.Source clone --depth 1 --branch $RequestedBranch $Url $resolvedClonePath
        if ($LASTEXITCODE -ne 0) {
            throw "git clone failed for $Url"
        }
    }

    if (-not (Test-IsRepositoryRoot -Path $resolvedClonePath)) {
        throw "Bootstrapped repository is missing expected files: $resolvedClonePath"
    }

    return $resolvedClonePath
}

function Get-ManifestPath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$DirectoryPath
    )

    foreach ($candidate in @('SKILL.md', 'skill.md')) {
        $manifestPath = Join-Path -Path $DirectoryPath -ChildPath $candidate
        if (Test-Path -LiteralPath $manifestPath -PathType Leaf) {
            return $manifestPath
        }
    }

    return $null
}

function Get-InstallRoot {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('Agents', 'Codex', 'Claude', 'Copilot')]
        [string]$Runtime
    )

    switch ($Runtime) {
        'Agents' {
            return Join-Path -Path $HOME -ChildPath '.agents/skills'
        }

        'Codex' {
            return Join-Path -Path $HOME -ChildPath '.codex/skills'
        }

        'Claude' {
            return Join-Path -Path $HOME -ChildPath '.claude/skills'
        }

        'Copilot' {
            return Join-Path -Path $HOME -ChildPath '.copilot/skills'
        }
    }
}

function Copy-SkillDirectory {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$SourcePath,

        [Parameter(Mandatory)]
        [string]$DestinationPath
    )

    $null = New-Item -ItemType Directory -Path $DestinationPath -Force

    Get-ChildItem -LiteralPath $SourcePath -Force |
        Where-Object { $_.Name -ne 'scripts' } |
        ForEach-Object {
            Copy-Item -LiteralPath $_.FullName -Destination $DestinationPath -Recurse -Force
        }
}

if ($RepositoryRoot) {
    if (-not (Test-Path -LiteralPath $RepositoryRoot -PathType Container)) {
        throw "RepositoryRoot does not exist or is not a directory: $RepositoryRoot"
    }

    $resolvedRepositoryRoot = Resolve-FullPath -Path $RepositoryRoot
}
elseif ($PSScriptRoot) {
    $candidateRepositoryRoot = Split-Path -Parent $PSScriptRoot
    if (Test-IsRepositoryRoot -Path $candidateRepositoryRoot) {
        $resolvedRepositoryRoot = Resolve-FullPath -Path $candidateRepositoryRoot
    }
}

if (-not $resolvedRepositoryRoot) {
    $resolvedRepositoryRoot = Initialize-BootstrapRepository -Url $RepoUrl -Root $CloneRoot -RequestedBranch $Branch
}

if (-not (Test-IsRepositoryRoot -Path $resolvedRepositoryRoot)) {
    throw "RepositoryRoot is missing expected repository files: $resolvedRepositoryRoot"
}

$skillDirectories = @(
    Get-ChildItem -LiteralPath $resolvedRepositoryRoot -Directory -Force |
        Where-Object {
            $null -ne (Get-ManifestPath -DirectoryPath $_.FullName)
        }
        Sort-Object -Property Name
)

if (-not $skillDirectories) {
    throw "No top-level skills were found in repository root: $resolvedRepositoryRoot"
}

foreach ($runtime in $Target) {
    $installRoot = Get-InstallRoot -Runtime $runtime

    if (-not (Test-Path -LiteralPath $installRoot -PathType Container)) {
        if ($PSCmdlet.ShouldProcess($installRoot, "Create $runtime skills directory")) {
            $null = New-Item -ItemType Directory -Path $installRoot -Force
        }
    }

    foreach ($skillDirectory in $skillDirectories) {
        $destinationPath = Join-Path -Path $installRoot -ChildPath $skillDirectory.Name

        if ($PSCmdlet.ShouldProcess($destinationPath, "Install skill '$($skillDirectory.Name)' for $runtime")) {
            if (Test-Path -LiteralPath $destinationPath) {
                Remove-Item -LiteralPath $destinationPath -Recurse -Force
            }

            Copy-SkillDirectory -SourcePath $skillDirectory.FullName -DestinationPath $destinationPath

            $result = [pscustomobject]@{
                Runtime     = $runtime
                Skill       = $skillDirectory.Name
                Source      = $skillDirectory.FullName
                Destination = $destinationPath
                Action      = 'Installed'
                Repository  = $resolvedRepositoryRoot
            }

            Write-Host "Installed $($skillDirectory.Name) for $runtime"
            if ($PassThru) {
                $result
            }
        }
    }
}