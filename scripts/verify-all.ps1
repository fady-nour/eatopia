param(
    [switch] $SkipE2E
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$backendRoot = Join-Path $repoRoot "Eatopia"
$frontendRoot = Join-Path $repoRoot "frontend-src"

function Invoke-Step {
    param(
        [string] $Name,
        [scriptblock] $Command
    )

    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan
    & $Command
}

function Invoke-Native {
    param(
        [scriptblock] $Command
    )

    & $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Native command failed with exit code $LASTEXITCODE."
    }
}

Invoke-Step "Backend tests" {
    Push-Location $backendRoot
    try {
        Invoke-Native { dotnet test ".\Eatopia.sln" --configuration Release -v minimal }
    }
    finally {
        Pop-Location
    }
}

Invoke-Step "Frontend unit tests" {
    Push-Location $frontendRoot
    try {
        Invoke-Native { npm run test:ci }
    }
    finally {
        Pop-Location
    }
}

Invoke-Step "Frontend production build" {
    Push-Location $frontendRoot
    try {
        Invoke-Native { npm run build }
    }
    finally {
        Pop-Location
    }
}

if (-not $SkipE2E) {
    Invoke-Step "Frontend E2E tests" {
        Push-Location $frontendRoot
        try {
            Invoke-Native { npm run e2e }
        }
        finally {
            Pop-Location
        }
    }
}

Write-Host ""
Write-Host "All quality gates passed." -ForegroundColor Green
