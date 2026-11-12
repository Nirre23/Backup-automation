# Get the project path
$projectPath = Split-Path -Parent $PSScriptRoot

# Check that both folders exist
function Test-BackupFolders {
    param (
        [string]$sourceFolder,
        [string]$backupFolder
    )

    if (!(Test-Path -LiteralPath $sourceFolder)) {
        throw "Source folder missing: $sourceFolder"
    }

    if (!(Test-Path -LiteralPath $backupFolder)) {
        throw "Backup folder missing: $backupFolder"
    }
}

# Copy files from the source folder to the backup folder
function Start-Backup {
    param (
        [string]$sourceFolder,
        [string]$backupFolder
    )

    # Add the current date and time to the backup file names
    $timeStamp = Get-Date -Format $config.timestampFormat

    # Get all source files except source-info.txt
    $sourceFiles = @(
        Get-ChildItem -LiteralPath $sourceFolder -File |
        Where-Object { $_.Name -ne "source-info.txt" })
    $fileCount = $sourceFiles.Count

    # Stop if there are no files to back up
    if ($fileCount -eq 0) {
        throw "No files found in source folder: $sourceFolder"
    }

    # Copy each file with a new name and remember the names
    $backedUpFiles = @()
    foreach ($file in $sourceFiles) {
        $backupFileName = "$($config.filePrefix)_$($file.BaseName)_$timeStamp$($file.Extension)"
        Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $backupFolder $backupFileName) -ErrorAction Stop
        $backedUpFiles += $backupFileName
    }


    Write-Host "Backup completed! Files copied: $fileCount" -ForegroundColor Green
    return $backedUpFiles
}

# Check that the backup files were created
function Test-BackupResult {
    param (
        [string]$backupFolder,
        [string[]]$backedUpFiles
    )

    # Collect the names of any files that are missing
    $missingFiles = @()
    foreach ($file in $backedUpFiles) {
        if (!(Test-Path -LiteralPath (Join-Path $backupFolder $file))) {
            $missingFiles += $file
        }
    }

    # Show whether the backup was successful
    if ($missingFiles.Count -eq 0) {
        Write-Host "Backup verification successful!" -ForegroundColor Green
    }
    else {
        throw "Backup verification failed. Missing files: $($missingFiles -join ', ')"
    }
}

# Run the backup and handle any errors
try {
    $configPath = Join-Path $projectPath "config.json"
    $config = Get-Content -Path $configPath -Raw -ErrorAction Stop |
    ConvertFrom-Json -ErrorAction Stop

    $sourceFolder = Join-Path $projectPath $config.sourceFolder
    $backupFolder = Join-Path $projectPath $config.backupFolder

    # Make sure both folders exist before starting the backup
    Test-BackupFolders -sourceFolder $sourceFolder -backupFolder $backupFolder

    # Copy the source files and store the returned backup file names
    $backupList = Start-Backup -sourceFolder $sourceFolder -backupFolder $backupFolder

    # Check the backup files using the list returned by Start-Backup
    Test-BackupResult -backupFolder $backupFolder -backedUpFiles $backupList

    # Update the last successful backup time
    $lastBackupFilePath = Join-Path $backupFolder "last-backup.txt"
    $backupTime = Get-Date -Format $config.timestampFormat

    $backupInformation = @(
        "Last successful backup: $backupTime"
        ""
        "Files included:"
        $backupList
    )

    Set-Content -LiteralPath $lastBackupFilePath -Value $backupInformation -ErrorAction Stop

    Write-Host "Last backup time updated!" -ForegroundColor Green
}
catch {
    throw "Backup failed: $($_.Exception.Message)"
}
