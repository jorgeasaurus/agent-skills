#Requires -Version 5.1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Resolve-FullPath {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    [System.IO.Path]::GetFullPath($Path)
}

function Get-BootstrapClonePath {
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

    Join-Path -Path $Root -ChildPath $repoName
}

$repoUrl = 'https://github.com/jorgeasaurus/agent-skills.git'
$branch = 'main'
$cloneRoot = Join-Path -Path $HOME -ChildPath '.agent-skills'
$repoPath = Resolve-FullPath -Path (Get-BootstrapClonePath -Root $cloneRoot -Url $repoUrl)
$installerPath = Join-Path -Path $repoPath -ChildPath 'scripts/Install-AgentSkills.ps1'
$gitCommand = Get-Command -Name git -ErrorAction SilentlyContinue

if (-not $gitCommand) {
    throw 'git is required to bootstrap this installer.'
}

if (-not (Test-Path -LiteralPath $cloneRoot -PathType Container)) {
    $null = New-Item -ItemType Directory -Path $cloneRoot -Force
}

if (Test-Path -LiteralPath $repoPath) {
    Remove-Item -LiteralPath $repoPath -Recurse -Force
}

& $gitCommand.Source clone --depth 1 --branch $branch $repoUrl $repoPath
if ($LASTEXITCODE -ne 0) {
    throw "git clone failed for $repoUrl"
}

if (-not (Test-Path -LiteralPath $installerPath -PathType Leaf)) {
    throw "Installer script was not found after cloning: $installerPath"
}

& $installerPath
if ($LASTEXITCODE -ne 0) {
    throw "Installer script failed: $installerPath"
}