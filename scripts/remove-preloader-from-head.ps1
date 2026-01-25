# Remove preloader div from inside <head> tags in CFM files
# The preloader is now included via top_navbar.cfm

param(
    [string]$Path = "."
)

Get-ChildItem -Path $Path -Filter "*.cfm" -Recurse |
    Where-Object { $_.FullName -notmatch '\\\.backup' -and $_.FullName -notmatch '\\inc\\' } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw

        # Pattern to match preloader div (handles various whitespace and class variations)
        $pattern = '(?s)\s*<!-- Preloader -->\s*<div class="preloader[^"]*">\s*<img[^>]*>\s*</div>\s*'

        $newContent = $content -replace $pattern, "`n"

        if ($content -ne $newContent) {
            Set-Content $_.FullName -Value $newContent -NoNewline
            Write-Host "Removed preloader: $($_.FullName)"
        }
    }

Write-Host "Done!"
