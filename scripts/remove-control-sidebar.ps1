# Remove unused control sidebar from CFM files
param([string]$Path)

Get-ChildItem -Path $Path -Filter "*.cfm" -Recurse |
    Where-Object { $_.FullName -notmatch '\.backup' } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw

        # Remove the control sidebar block
        $pattern = '(?s)\s*<!-- Control Sidebar -->\s*<aside class="control-sidebar[^"]*">\s*<!-- Control sidebar content goes here -->\s*<div class="p-3">\s*<h5>Title</h5>\s*<p>Sidebar content</p>\s*</div>\s*</aside>\s*<!-- /\.control-sidebar -->'

        $newContent = $content -replace $pattern, ''

        if ($content -ne $newContent) {
            Set-Content $_.FullName -Value $newContent -NoNewline
            Write-Host "Updated: $($_.FullName)"
        }
    }
