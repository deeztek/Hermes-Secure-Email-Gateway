# =============================================================================
# Hermes SEG - Upload Template Manifest to License Server
# =============================================================================
# Uploads manifest.json to validate.hermesseg.io for fingerprint storage.
# Run this AFTER generate_manifest.ps1 and BEFORE deploying to clients.
#
# Usage:
#   .\scripts\upload_manifest.ps1 [manifest_file]
#
# Examples:
#   .\scripts\upload_manifest.ps1                      # Uses .\manifest.json
#   .\scripts\upload_manifest.ps1 build\manifest.json
#
# Environment Variables:
#   MANIFEST_API_KEY  - API key for upload authentication (optional, will prompt if not set)
#
# =============================================================================

param(
    [string]$ManifestFile = "manifest.json"
)

# Colors for output
function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

# License server endpoint
$UploadUrl = "https://validate.hermesseg.io/upload_manifest.cfm"

Write-ColorOutput "======================================" "Cyan"
Write-ColorOutput "  Hermes SEG - Upload Manifest" "Cyan"
Write-ColorOutput "======================================" "Cyan"
Write-Host ""

# Check if manifest file exists
if (-not (Test-Path $ManifestFile)) {
    Write-ColorOutput "Error: Manifest file not found: $ManifestFile" "Red"
    Write-Host ""
    Write-Host "Run generate_manifest.ps1 first:"
    Write-Host "  .\scripts\generate_manifest.ps1 <version>"
    exit 1
}

# Get API key from environment or prompt
$ApiKey = $env:HERMES_MANIFEST_API_KEY
if ([string]::IsNullOrEmpty($ApiKey)) {
    $ApiKey = $env:MANIFEST_API_KEY
}

if ([string]::IsNullOrEmpty($ApiKey)) {
    Write-ColorOutput 'Enter the manifest upload API key:' 'Yellow'
    $SecureKey = Read-Host ">" -AsSecureString
    $ApiKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureKey)
    )

    if ([string]::IsNullOrEmpty($ApiKey)) {
        Write-ColorOutput "Error: API key is required" "Red"
        exit 1
    }
    Write-Host ""
}

# Read and parse manifest
try {
    $ManifestContent = Get-Content $ManifestFile -Raw
    $Manifest = $ManifestContent | ConvertFrom-Json
}
catch {
    Write-ColorOutput "Error: Failed to read manifest file: $_" "Red"
    exit 1
}

$Version = $Manifest.version
$Fingerprint = $Manifest.fingerprint

Write-Host "Manifest file: " -NoNewline
Write-ColorOutput $ManifestFile "Green"
Write-Host "Version: " -NoNewline
Write-ColorOutput $Version "Green"
Write-Host "Fingerprint: " -NoNewline
Write-ColorOutput $Fingerprint "Green"
Write-Host "Upload URL: " -NoNewline
Write-ColorOutput $UploadUrl "Cyan"
Write-Host ""
Write-Host "Uploading..."

# Upload manifest
try {
    $Headers = @{
        "X-API-Key" = $ApiKey
        "Content-Type" = "application/json"
    }

    $Response = Invoke-RestMethod -Uri $UploadUrl `
        -Method Post `
        -Headers $Headers `
        -Body $ManifestContent `
        -TimeoutSec 60 `
        -ErrorAction Stop

    Write-Host ""
    Write-Host "======================================"

    if ($Response.status -eq "success") {
        Write-ColorOutput "Upload successful!" "Green"
        Write-Host ""
        Write-Host "Response:"
        Write-Host "  Version: $($Response.version)"
        Write-Host "  Templates: $($Response.templates)"
        Write-Host "  Fingerprint: $($Response.fingerprint)"
        Write-Host "  Signature: $($Response.signature)"
        Write-Host ""
        Write-ColorOutput "Manifest uploaded. You can now deploy this build to clients." "Green"
    }
    else {
        Write-ColorOutput "Upload failed!" "Red"
        Write-Host "Response: $($Response | ConvertTo-Json)"
        exit 1
    }
}
catch {
    Write-Host ""
    Write-Host "======================================"
    Write-ColorOutput "Upload failed!" "Red"

    if ($_.Exception.Response) {
        $StatusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "HTTP Status: $StatusCode"

        try {
            $Reader = [System.IO.StreamReader]::new($_.Exception.Response.GetResponseStream())
            $ErrorBody = $Reader.ReadToEnd()
            $Reader.Close()
            Write-Host "Response: $ErrorBody"
        }
        catch {
            Write-Host "Error details: $($_.Exception.Message)"
        }
    }
    else {
        Write-Host "Error: $($_.Exception.Message)"
    }

    exit 1
}

Write-Host "======================================"
