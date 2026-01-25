# Fix float-sm-right to float-sm-end
param([string]$Path)

Get-ChildItem -Path $Path -Filter "*.cfm" -Recurse |
    Where-Object { $_.FullName -notmatch '\.backup' } |
    ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $newContent = $content -replace 'float-sm-right', 'float-sm-end'
        if ($content -ne $newContent) {
            Set-Content $_.FullName -Value $newContent -NoNewline
            Write-Host "Updated: $($_.FullName)"
        }
    }
