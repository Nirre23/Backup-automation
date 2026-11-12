# Get the project root folder
$projectPath = Split-Path -Parent $PSScriptRoot
# Build paths to the source, backup and configuration file
$sourceFolderPath = Join-Path $projectPath "source"
$backupFolderPath = Join-Path $projectPath "backups"
$configFilePath = Join-Path $projectPath "config.json"

# Remove a file or folder if it exists
function Remove-ProjectItem {
    param ([string]$itemPath)

    if (Test-Path -LiteralPath $itemPath) {
        Remove-Item -LiteralPath $itemPath -Recurse -Force -ErrorAction Stop
        Write-Host "Removed: $itemPath" -ForegroundColor Yellow
    }
    else {
        Write-Host "Item already missing: $itemPath" -ForegroundColor Blue
    }
}

# Ask for confirmation before deleting anything
try {
    Write-Host "WARNING: This will delete the source and backups folders, including all their contents, and the config.json file!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

    # Only continue if the user confirms with "yes"
    if ($confirmation -ieq "yes") {
        # Remove the source folder, backup folder, and configuration file
        foreach ($itemPath in @($sourceFolderPath, $backupFolderPath, $configFilePath)) {
            Remove-ProjectItem -itemPath $itemPath
        }

        Write-Host "Cleanup completed! (Missing items were skipped)" -ForegroundColor Green
    }
    else {
        Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    }
}
catch {
    throw "Cleanup failed: $($_.Exception.Message)"
}
