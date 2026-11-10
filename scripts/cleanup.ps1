$projectPath = Split-Path -Parent $PSScriptRoot

$configPath = Join-Path $projectPath "config.json"
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

$source = Join-Path $projectPath $config.sourceFolder
$backup = Join-Path $projectPath $config.backupFolder
# Remove folder if it exists
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
    Write-Host "WARNING: This will delete the source and backups folders, including all their contents!" -ForegroundColor Red
    $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"

    # Only continue if the user confirms with "yes"
    if ($confirmation -ieq "yes") {
        foreach ($folder in @($source, $backup)) {
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
