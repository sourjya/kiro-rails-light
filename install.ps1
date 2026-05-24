# kiro-rails-light - PowerShell Installer with upgrade support
# Usage: curl.exe -fsSL https://raw.githubusercontent.com/sourjya/kiro-rails-light/main/install.ps1 -o install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; Remove-Item install.ps1

$ErrorActionPreference = "Stop"

$Repo = "sourjya/kiro-rails-light"
$Branch = "main"
$BaseUrl = "https://raw.githubusercontent.com/$Repo/$Branch"
$CurrentVersion = "0.2.0"
$VersionFile = ".kiro/.kiro-rails-light-version"
$OverridesFile = ".kiro/steering/user-lib-overrides.md"

# ──────────────────────────────────────────────
# Managed files - overwritten on every upgrade
# ──────────────────────────────────────────────
$ManagedFiles = @(
    ".kiro/steering/api-design-package-structure.md"
    ".kiro/steering/code-quality.md"
    ".kiro/steering/testing-standards.md"
    ".kiro/steering/versioning-git.md"
    ".kiro/steering/pitfalls.md"
    ".kiro/steering/change-discipline.md"
    ".kiro/hooks/fix-spiral-detector.kiro.hook"
    ".kiro/hooks/type-check-on-stop.kiro.hook"
    ".kiro/hooks/package-manifest-verify.kiro.hook"
    ".kiro/hooks/comment-standards-check.kiro.hook"
    ".kiro/prompts/review-dependency-risk.md"
    ".kiro/prompts/review-test-quality.md"
    ".kiro/prompts/review-api-surface.md"
    "scripts/export-to-tools.sh"
)

# Stale files removed during upgrade
$StaleFiles = @()

# Directories to create
$Dirs = @(
    ".kiro/steering"
    ".kiro/hooks"
    ".kiro/prompts"
    "scripts"
)

# ──────────────────────────────────────────────
# Safety check
# ──────────────────────────────────────────────
$cwd = (Get-Location).Path
if ($cwd -eq $env:USERPROFILE -or $cwd -eq "C:\") {
    Write-Host "Error: don't run this in your home or root directory. cd into your project first." -ForegroundColor Red
    exit 1
}

# ──────────────────────────────────────────────
# Detect install type
# ──────────────────────────────────────────────
$installType = "fresh"
$installedVersion = ""

if (Test-Path $VersionFile) {
    $installedVersion = Get-Content $VersionFile -Raw
    $installedVersion = $installedVersion.Trim()
    if ($installedVersion -eq $CurrentVersion) {
        Write-Host "kiro-rails-light v$CurrentVersion is already installed. Nothing to do."
        exit 0
    }
    $installType = "upgrade"
    Write-Host "Upgrading kiro-rails-light: v$installedVersion -> v$CurrentVersion"
} elseif (Test-Path ".kiro/steering/*.md") {
    $installType = "upgrade"
    $installedVersion = "0.0.0"
    Write-Host "Detected existing files (no version file). Upgrading to v$CurrentVersion"
} else {
    Write-Host "Installing kiro-rails-light v$CurrentVersion into $cwd..."
}

# ──────────────────────────────────────────────
# Create directories
# ──────────────────────────────────────────────
foreach ($dir in $Dirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
}

# ──────────────────────────────────────────────
# Download managed files
# ──────────────────────────────────────────────
$downloaded = 0
$updated = 0
$failed = 0
$total = $ManagedFiles.Count
$current = 0

foreach ($file in $ManagedFiles) {
    $current++
    $fileName = Split-Path $file -Leaf
    Write-Host "`r  Downloading [$current/$total] $fileName" -NoNewline

    $dir = Split-Path $file -Parent
    if ($dir -and -not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    try {
        Invoke-WebRequest -Uri "$BaseUrl/$file" -OutFile $file -UseBasicParsing -ErrorAction Stop
        if ((Test-Path $file) -and $installType -eq "upgrade") {
            $updated++
        } else {
            $downloaded++
        }
    } catch {
        Write-Host ""
        Write-Host "  Warning: could not download $file" -ForegroundColor Yellow
        $failed++
    }
}
Write-Host ""

# ──────────────────────────────────────────────
# User overrides - never overwrite
# ──────────────────────────────────────────────
if (-not (Test-Path $OverridesFile)) {
    try {
        Invoke-WebRequest -Uri "$BaseUrl/$OverridesFile" -OutFile $OverridesFile -UseBasicParsing -ErrorAction Stop
        $downloaded++
    } catch {}
}

# ──────────────────────────────────────────────
# Remove stale files
# ──────────────────────────────────────────────
$removed = 0
if ($installType -eq "upgrade") {
    foreach ($file in $StaleFiles) {
        if (Test-Path $file) {
            Remove-Item $file -Force
            $removed++
            Write-Host "  Removed stale: $file"
        }
    }
}

# ──────────────────────────────────────────────
# Write version file
# ──────────────────────────────────────────────
Set-Content -Path $VersionFile -Value $CurrentVersion -NoNewline

# ──────────────────────────────────────────────
# Dependency check
# ──────────────────────────────────────────────
Write-Host ""
Write-Host "Dependency check:"

$depOk = 0
$depMissing = 0

if (Get-Command git -ErrorAction SilentlyContinue) {
    $gitVer = git --version 2>$null
    Write-Host "  $([char]0x2713) $gitVer"
    $depOk++
} else {
    Write-Host "  x git - fix-spiral-detector hook will not work" -ForegroundColor Yellow
    $depMissing++
}

if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVer = node --version 2>$null
    Write-Host "  $([char]0x2713) node $nodeVer"
    $depOk++
} else {
    Write-Host "  . node - type-check-on-stop will skip TypeScript checks" -ForegroundColor Yellow
    $depMissing++
}

if (Get-Command npm -ErrorAction SilentlyContinue) {
    $npmVer = npm --version 2>$null
    Write-Host "  $([char]0x2713) npm $npmVer"
    $depOk++
} else {
    Write-Host "  . npm - package-manifest-verify cannot run" -ForegroundColor Yellow
    $depMissing++
}

Write-Host ""
if ($depMissing -eq 0) {
    Write-Host "All hooks fully operational."
} else {
    Write-Host "$depOk found, $depMissing optional missing. Steering files work regardless."
}

# ──────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────
Write-Host ""
if ($installType -eq "fresh") {
    Write-Host "Done! $downloaded files installed."
    Write-Host ""
    Write-Host "Your customization file: .kiro/steering/user-lib-overrides.md"
    Write-Host "  This is the only file you need to edit."
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. Edit .kiro/steering/user-lib-overrides.md with your lib's details"
    Write-Host "  2. git add .kiro/ scripts/ && git commit -m 'feat: add kiro-rails-light steering'"
} else {
    Write-Host "Done! $downloaded new, $updated updated, $removed removed."
    if ($removed -gt 0) { Write-Host "  Stale files from previous versions were cleaned up." }
    Write-Host ""
    Write-Host "Your customization file was not modified: .kiro/steering/user-lib-overrides.md"
}
