# AdminLTE 3 to AdminLTE 4 Migration Script (PowerShell)
# This script updates CFM files with the new AdminLTE 4 class names and data attributes

param(
    [Parameter(Mandatory=$true)]
    [string]$HtmlDir
)

Write-Host "Starting AdminLTE 4 migration in: $HtmlDir" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Get all CFM files (excluding backup directories)
$cfmFiles = Get-ChildItem -Path $HtmlDir -Filter "*.cfm" -Recurse |
    Where-Object { $_.FullName -notmatch '\.backup' }

Write-Host "Found $($cfmFiles.Count) CFM files to process (excluding backups)" -ForegroundColor Green
Write-Host ""

foreach ($file in $cfmFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $modified = $false
    $originalContent = $content

    # 1. Body class changes
    $content = $content -replace 'class="hold-transition sidebar-mini layout-fixed"', 'class="layout-fixed sidebar-expand-lg bg-body-tertiary"'
    $content = $content -replace 'class="hold-transition sidebar-mini sidebar-collapse"', 'class="layout-fixed sidebar-expand-lg sidebar-collapse bg-body-tertiary"'
    $content = $content -replace 'class="hold-transition sidebar-mini"', 'class="layout-fixed sidebar-expand-lg bg-body-tertiary"'

    # 2. Wrapper div changes
    $content = $content -replace '<div class="wrapper">', '<div class="app-wrapper">'

    # 3. Content wrapper changes (div to main)
    $content = $content -replace '<div class="content-wrapper">', '<main class="app-main">'
    $content = $content -replace '</div><!-- /.content-wrapper -->', '</main>'
    $content = $content -replace '<!-- /.content-wrapper -->', '</main><!-- replaced content-wrapper -->'

    # 4. Data attribute changes (Bootstrap 4 to Bootstrap 5)
    $content = $content -replace 'data-toggle="', 'data-bs-toggle="'
    $content = $content -replace 'data-dismiss="', 'data-bs-dismiss="'
    $content = $content -replace 'data-target="', 'data-bs-target="'
    $content = $content -replace 'data-backdrop="', 'data-bs-backdrop="'
    $content = $content -replace 'data-keyboard="', 'data-bs-keyboard="'
    $content = $content -replace 'data-focus="', 'data-bs-focus="'
    $content = $content -replace 'data-ride="', 'data-bs-ride="'
    $content = $content -replace 'data-slide="', 'data-bs-slide="'
    $content = $content -replace 'data-slide-to="', 'data-bs-slide-to="'
    $content = $content -replace 'data-interval="', 'data-bs-interval="'
    $content = $content -replace 'data-parent="', 'data-bs-parent="'
    $content = $content -replace 'data-spy="', 'data-bs-spy="'
    $content = $content -replace 'data-offset="', 'data-bs-offset="'

    # 5. Close button class changes
    $content = $content -replace 'class="close"', 'class="btn-close"'
    $content = $content -replace 'class="close ', 'class="btn-close '

    # 6. Margin/padding left/right to start/end (Bootstrap 5)
    $content = $content -replace '(\s|")ml-(\d)', '$1ms-$2'
    $content = $content -replace '(\s|")mr-(\d)', '$1me-$2'
    $content = $content -replace '(\s|")pl-(\d)', '$1ps-$2'
    $content = $content -replace '(\s|")pr-(\d)', '$1pe-$2'

    # 7. Float left/right to start/end
    $content = $content -replace 'float-left', 'float-start'
    $content = $content -replace 'float-right', 'float-end'

    # 8. Text alignment
    $content = $content -replace 'text-left', 'text-start'
    $content = $content -replace 'text-right', 'text-end'

    # 9. Border left/right to start/end
    $content = $content -replace 'border-left', 'border-start'
    $content = $content -replace 'border-right', 'border-end'

    # 10. Badge changes
    $content = $content -replace 'badge-primary', 'text-bg-primary'
    $content = $content -replace 'badge-secondary', 'text-bg-secondary'
    $content = $content -replace 'badge-success', 'text-bg-success'
    $content = $content -replace 'badge-danger', 'text-bg-danger'
    $content = $content -replace 'badge-warning', 'text-bg-warning'
    $content = $content -replace 'badge-info', 'text-bg-info'
    $content = $content -replace 'badge-light', 'text-bg-light'
    $content = $content -replace 'badge-dark', 'text-bg-dark'

    # Check if content was modified
    if ($content -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Updated: $($file.FullName)" -ForegroundColor Yellow
        $modified = $true
    }
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Migration complete!" -ForegroundColor Green
Write-Host ""
Write-Host "IMPORTANT: Manual review required for:" -ForegroundColor Red
Write-Host "1. Check that content-wrapper closing tags are properly replaced"
Write-Host "2. Verify modal and dropdown functionality"
Write-Host "3. Test all interactive components"
