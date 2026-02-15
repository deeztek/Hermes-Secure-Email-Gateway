<#
.SYNOPSIS
    Hermes SEG - Publish Template Manifest (Interactive Wrapper)

.DESCRIPTION
    Interactive wrapper that guides you through generating and uploading
    a template manifest to the license validation server.

    This script will prompt for:
    - Build version (e.g., build-260120)
    - API key (if not set via environment variable)
    - Confirmation before upload

.PARAMETER None
    This script uses interactive prompts instead of parameters.

.EXAMPLE
    .\scripts\publish_manifest.ps1

.NOTES
    Environment Variables (optional):
    - HERMES_MANIFEST_API_KEY: Pre-set API key to skip prompt
    - HERMES_VALIDATE_URL: Override validation server URL
#>

$ErrorActionPreference = "Stop"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

Clear-Host
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "        Hermes SEG - Template Manifest Publisher                " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

# =============================================================================
# Step 1: Get build version
# =============================================================================
Write-Host "Step 1: Build Version" -ForegroundColor Yellow
Write-Host 'Enter the build version [e.g., build-260120]:'
$Version = Read-Host ">"

if ([string]::IsNullOrWhiteSpace($Version)) {
    Write-Host "Error: Version is required" -ForegroundColor Red
    exit 1
}

Write-Host ""

# =============================================================================
# Step 2: Generate manifest
# =============================================================================
Write-Host "Step 2: Generate Manifest" -ForegroundColor Yellow
Write-Host "Generating manifest for $Version..."
Write-Host ""

try {
    & "$ScriptDir\generate_manifest.ps1" -Version $Version
    if (-not $?) {
        Write-Host "Error: Manifest generation failed" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Error: Manifest generation failed - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""

# =============================================================================
# Step 3: Confirm upload
# =============================================================================
Write-Host "Step 3: Upload to License Server" -ForegroundColor Yellow
$Confirm = Read-Host 'Upload manifest to validate.hermesseg.io? [y/N]'

if ($Confirm -notmatch "^[Yy]$") {
    Write-Host "Upload cancelled. Manifest saved to manifest.json" -ForegroundColor Yellow
    Write-Host "To upload later, run:"
    Write-Host "  .\scripts\upload_manifest.ps1"
    exit 0
}

Write-Host ""

# =============================================================================
# Step 4: Get API key
# =============================================================================
$ApiKey = $env:HERMES_MANIFEST_API_KEY

if ([string]::IsNullOrWhiteSpace($ApiKey)) {
    Write-Host "Step 4: API Authentication" -ForegroundColor Yellow
    Write-Host "Enter the manifest upload API key:"
    $SecureKey = Read-Host ">" -AsSecureString
    $ApiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureKey)
    )

    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        Write-Host "Error: API key is required" -ForegroundColor Red
        exit 1
    }

    $env:HERMES_MANIFEST_API_KEY = $ApiKey
}

Write-Host ""

# =============================================================================
# Step 5: Upload manifest
# =============================================================================
Write-Host "Step 5: Uploading Manifest" -ForegroundColor Yellow
Write-Host ""

try {
    & "$ScriptDir\upload_manifest.ps1"
    if (-not $?) {
        Write-Host "Error: Manifest upload failed" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Error: Manifest upload failed - $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "                  Manifest Published!                           " -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Build $Version is now ready for deployment."
Write-Host ""
