$projectPath = Split-Path -Parent $PSScriptRoot

$source = Join-Path $projectPath "source"
$backup = Join-Path $projectPath "backups"
$configPath = Join-Path $projectPath "config.json"

# Remove a file or folder if it exists
function Remove-ProjectFolder {
    param ([string]$path)

    if (Test-Path -LiteralPath $path) {
        Remove-Item -LiteralPath $path -Recurse -Force -ErrorAction Stop
        Write-Host "Removed: $path" -ForegroundColor Yellow
    }
    else {
        Write-Host "Folder already missing: $path" -ForegroundColor Blue
    }
}

# Ask for confirmation before deleting anything
try {
    Write-Host "WARNING: This will delete the source and backups folders, including all their contents, and the config.json file!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

    # Only continue if the user confirms with "yes"
    if ($confirmation -ieq "yes") {
        foreach ($folder in @($source, $backup, $configPath)) {
            Remove-ProjectFolder -path $folder
        }

        Write-Host "Cleanup completed! (Missing folders were skipped)" -ForegroundColor Green
    }
    else {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Cleanup failed: $($_.Exception.Message)" -ForegroundColor Red
}
