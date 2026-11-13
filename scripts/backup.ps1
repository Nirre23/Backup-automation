# Get the project path
$projectPath = Split-Path -Parent $PSScriptRoot

# Check that the source and backup folders exist
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

# Copy source files to the backup folder
function Start-Backup {
    param (
        [string]$sourceFolder,
        [string]$backupFolder,
        [string]$timeStamp
    )

    # Get files directly in the source folder, excluding source-info.txt
    $sourceFiles = @(
        Get-ChildItem -LiteralPath $sourceFolder -File |
            Where-Object { $_.Name -ne "source-info.txt" }
    )
    $fileCount = $sourceFiles.Count

    # Stop if there are no eligible files to back up
    if ($fileCount -eq 0) {
        throw "No files found in source folder: $sourceFolder"
    }

    # Copy each file with a prefixed name and keep track of the new names
    $backedUpFiles = @()
    foreach ($file in $sourceFiles) {
        $backupFileName = "$($config.filePrefix)_$($file.BaseName)_$timeStamp$($file.Extension)"
        $destinationPath = Join-Path $backupFolder $backupFileName

        Copy-Item `
            -LiteralPath $file.FullName `
            -Destination $destinationPath `
            -ErrorAction Stop

        $backedUpFiles += $backupFileName
    }

    Write-Host "Backup completed! Files copied: $fileCount" -ForegroundColor Green
    return $backedUpFiles
}

# Verify that each expected backup file was created
function Test-BackupResult {
    param (
        [string]$backupFolder,
        [string[]]$backedUpFiles
    )

    # Collect the names of any expected files that are missing
    $missingFiles = @()
    foreach ($file in $backedUpFiles) {
        $backupFilePath = Join-Path $backupFolder $file

        if (!(Test-Path -LiteralPath $backupFilePath)) {
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

# Load the configuration, run the backup, and handle any errors
try {
    $configPath = Join-Path $projectPath "config.json"
    $config = Get-Content -Path $configPath -Raw -ErrorAction Stop |
        ConvertFrom-Json -ErrorAction Stop

    $sourceFolder = Join-Path $projectPath $config.sourceFolder
    $backupFolder = Join-Path $projectPath $config.backupFolder

    # Make sure both folders exist before starting the backup
    Test-BackupFolders -sourceFolder $sourceFolder -backupFolder $backupFolder

    # Create one timestamp for the backup file names and metadata
    $backupTime = Get-Date -Format $config.timestampFormat

    # Copy the source files and store the returned backup file names
    $backupList = Start-Backup `
        -sourceFolder $sourceFolder `
        -backupFolder $backupFolder `
        -timeStamp $backupTime

    # Check the backup files using the list returned by Start-Backup
    Test-BackupResult -backupFolder $backupFolder -backedUpFiles $backupList

    # Update the last successful backup time
    $lastBackupFilePath = Join-Path $backupFolder "last-backup.txt"
    $backupInformation = @(
        "Last successful backup: $backupTime"
        ""
        "Files included:"
        $backupList
    )

    Set-Content `
        -LiteralPath $lastBackupFilePath `
        -Value $backupInformation `
        -ErrorAction Stop

    Write-Host "Last backup time updated!" -ForegroundColor Green
}
catch {
    throw "Backup failed: $($_.Exception.Message)"
}
