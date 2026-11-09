# Get the project paht and load the shared configuration
$projectPath = Split-Path -Parent $PSScriptRoot

$configPath = Join-Path $projectPath "config.json"
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

$source = Join-Path $projectPath $config.sourceFolder
$backup = Join-Path $projectPath $config.backupFolder

# Check that both folders exists
function Test-BackupFolders {
    param (
        [string]$source,
        [string]$backup
    )

    if (!(Test-Path -LiteralPath $source)) {
        throw "Source folder missing: $source"
    }

    if (!(Test-Path -LiteralPath $backup)) {
        throw "Backup folder missing: $backup"
    }
}

# Copy files from the source folder to the backup folder
function Start-Backup {
    param (
        [string]$source,
        [string]$backup
    )

    # Add the current date and time to the backup file names
    $timeStamp = Get-Date -Format $config.timestampFormat

    # Get all the files in the source folder
    $files = @(Get-ChildItem -LiteralPath $source -File)
    $fileCount = $files.Count

    # Stop if there are no files to back up
    if ($fileCount -eq 0) {
        throw "No files found in source folder: $source"
    }

    # Copy each file with a new name and remember the names
    $createdFiles = @()
    foreach ($file in $files) {
        $newName = "$($config.filePrefix)_$($file.BaseName)_$timeStamp$($file.Extension)"
        Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $backup $newName) -ErrorAction Stop
        $createdFiles += $newName
    }


    Write-Host "Backup completed! Files copied: $fileCount" -ForegroundColor Green
    return $createdFiles
}

# Check that the backup files were created
function Test-BackupResult {
    param (
        [string]$backup,
        [string[]]$createdFiles
    )

    # Collect the names of any files that are missing
    $missing = @()
    foreach ($file in $createdFiles) {
        if (!(Test-Path -LiteralPath (Join-Path $backup $file))) {
            $missing += $file
        }
    }

    # Show whether the backup was successful
    if ($missing.Count -eq 0) {
        Write-Host "Backup verification successful!" -ForegroundColor Green
    }
    else {
        throw "Backup verification failed. Missing files: $($missing -join ', ')"
    }
}

# Run the backup and handle any errors
try {
    Test-BackupFolders -source $source -backup $backup
    $backupResult = Start-Backup -source $source -backup $backup
    Test-BackupResult -backup $backup -createdFiles $backupResult
}
catch {
    Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor Red
}
