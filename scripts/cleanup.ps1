$projectPath = Split-Path -Parent $PSScriptRoot

$source = Join-Path $projectPath "source"
$backup = Join-Path $projectPath "backups"

function Remove-ProjectFolder {
    param ([string]$path)

    if (Test-Path -LiteralPath $path) {
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
        Write-Host "Removed: $path" -ForegroundColor Yellow
    }
    else {
        Write-Host "Folder already missing: $path" -ForegroundColor Gray
    }
}

try {
    Write-Host "WARNING: This will delete the source and backups folders, including all their contents!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

    if ($confirmation -ieq "yes") {
        Remove-ProjectFolder $source
        Remove-ProjectFolder $backup

        Write-Host "Cleanup completed successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red
}
