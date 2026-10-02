# Run after a completed research milestone or manual note editing.
param([string]$Message = ('research: notes updated ' + (Get-Date -Format 'yyyy-MM-dd HH:mm')))
$ErrorActionPreference = 'Stop'
$vaultPath = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$logFolder = Join-Path $env:USERPROFILE '.codex/research-sync'
New-Item -ItemType Directory -Force -Path $logFolder | Out-Null
$env:GIT_TERMINAL_PROMPT = '0'
$env:GCM_INTERACTIVE = 'never'
$syncLock = $null
Push-Location $vaultPath
try {
    $syncLock = [System.IO.File]::Open((Join-Path $vaultPath '.git/research-sync.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
    $staged = @(git diff --cached --name-only)
    if ($LASTEXITCODE -ne 0) { throw 'Cannot read Git index.' }
    if ($staged.Count -gt 0) { throw 'Existing staged changes: finish that Git operation first.' }
    # Actual folder name is resolved from this script, avoiding shell encoding issues.
    $researchFolder = Split-Path (Split-Path $PSScriptRoot -Parent) -Leaf
    git add -- .gitignore $researchFolder
    if ($LASTEXITCODE -ne 0) { throw 'Staging research files failed.' }
    git diff --cached --quiet
    if ($LASTEXITCODE -eq 1) {
        git commit --only -m $Message -- .gitignore $researchFolder
        if ($LASTEXITCODE -ne 0) { throw 'Commit failed; nothing was pushed.' }
    } elseif ($LASTEXITCODE -ne 0) { throw 'Cannot check staged diff.' }
    git push origin main
    if ($LASTEXITCODE -ne 0) { throw 'Push failed. Local commits remain saved. Do not force-push.' }
    ('{0} SUCCESS {1}' -f (Get-Date -Format o), (git rev-parse HEAD)) | Add-Content -LiteralPath (Join-Path $logFolder 'sync.log')
} catch {
    ('{0} FAILED {1}' -f (Get-Date -Format o), $_.Exception.Message) | Add-Content -LiteralPath (Join-Path $logFolder 'sync.log')
    throw
} finally {
    if ($null -ne $syncLock) { $syncLock.Dispose() }
    Pop-Location
}
