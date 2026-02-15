# =============================================================================
# Hermes SEG - Generate Template Manifest (PowerShell)
# =============================================================================
# Generates a JSON manifest of SHA-256 hashes for Pro Edition template files.
# Run this script from the repository root before uploading to the license server.
#
# Usage:
#   .\scripts\generate_manifest.ps1 [-Version <version>]
#
# Examples:
#   .\scripts\generate_manifest.ps1                        # Prompts for version
#   .\scripts\generate_manifest.ps1 -Version build-260120  # Explicit version
#
# Output:
#   manifest.json - JSON file with template hashes
# =============================================================================

param(
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"

# Prompt for version if not provided
if ([string]::IsNullOrWhiteSpace($Version)) {
    Write-Host 'Enter the build version (e.g., build-260120):' -ForegroundColor Yellow
    $Version = Read-Host ">"
    if ([string]::IsNullOrWhiteSpace($Version)) {
        Write-Host "Error: Version is required" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
}

# Source directory (relative to repo root)
$SrcDir = "config\hermes\var\www\html"

# Output file
$Output = "manifest.json"

# Pro templates config file (shared with manifest_verify.cfm)
$TemplatesConfig = "config\hermes\var\www\html\admin\2\inc\pro_templates.json"

# Load templates from shared config
if (-not (Test-Path $TemplatesConfig)) {
    Write-Host "Error: Templates config not found: $TemplatesConfig" -ForegroundColor Red
    Write-Host "Run this script from the repository root."
    exit 1
}

$config = Get-Content $TemplatesConfig | ConvertFrom-Json
$Templates = $config.templates

Write-Host "Generating manifest for version: $Version" -ForegroundColor Green
Write-Host "Source directory: $SrcDir"
Write-Host ""

# Check if source directory exists
if (-not (Test-Path $SrcDir)) {
    Write-Host "Error: Source directory not found: $SrcDir" -ForegroundColor Red
    Write-Host "Run this script from the repository root."
    exit 1
}

# Build manifest object
$manifest = [ordered]@{
    version = $Version
    generated = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    algorithm = "SHA-256"
    templates = [ordered]@{}
}

# Track processed files
$found = 0
$missing = 0

foreach ($template in $Templates) {
    # Convert forward slashes to backslashes for Windows
    $templatePath = $template -replace '/', '\'
    $filepath = Join-Path $SrcDir $templatePath

    if (Test-Path $filepath) {
        # Read file content and normalize line endings to LF (Unix style)
        # This ensures consistent hashes across Windows/Linux
        $content = [System.IO.File]::ReadAllText($filepath)
        $normalizedContent = $content -replace "`r`n", "`n" -replace "`r", "`n"
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($normalizedContent)
        $stream = [System.IO.MemoryStream]::new($bytes)
        $hash = (Get-FileHash -InputStream $stream -Algorithm SHA256).Hash.ToLower()
        $stream.Dispose()

        # Add to manifest (use forward slashes for JSON consistency)
        $manifest.templates[$template] = $hash

        Write-Host "  [OK] $template" -ForegroundColor Green
        $found++
    } else {
        Write-Host "  [MISSING] $template" -ForegroundColor Yellow
        $missing++
    }
}

# Compute fingerprint (SHA-256 of all hashes concatenated in sorted order)
$sortedPaths = $manifest.templates.Keys | Sort-Object
$concatenatedHashes = ""
foreach ($path in $sortedPaths) {
    $concatenatedHashes += $manifest.templates[$path].ToLower()
}
$fingerprintBytes = [System.Text.Encoding]::UTF8.GetBytes($concatenatedHashes)
$sha256 = [System.Security.Cryptography.SHA256]::Create()
$fingerprintHash = $sha256.ComputeHash($fingerprintBytes)
$fingerprint = [BitConverter]::ToString($fingerprintHash).Replace("-", "").ToLower()

# Add fingerprint to manifest
$manifest["fingerprint"] = $fingerprint

# Write JSON file
$manifest | ConvertTo-Json -Depth 3 | Set-Content -Path $Output -Encoding UTF8

Write-Host ""
Write-Host "======================================"
Write-Host "Templates found: $found" -ForegroundColor Green
if ($missing -gt 0) {
    Write-Host "Templates missing: $missing" -ForegroundColor Yellow
}
Write-Host "Fingerprint: $fingerprint" -ForegroundColor Cyan
Write-Host "Output file: $Output" -ForegroundColor Green
Write-Host "======================================"

# Validate JSON
try {
    $null = Get-Content $Output | ConvertFrom-Json
    Write-Host "JSON validation: OK" -ForegroundColor Green
} catch {
    Write-Host "JSON validation: FAILED" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Next step: Upload manifest to license server"
Write-Host "  .\scripts\upload_manifest.ps1 $Version"
