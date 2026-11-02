$source = "./source"
$backup = "./backups"

function Test-BackupFolders {
    param (
        [string]$source,
        [string]$backup
    )


    if (!(Test-Path $source)) {
        throw "Sourcefolder missing: $source"
    }

    if (!(Test-Path $backup)) {
        throw "Backupfolder missing: $backup"
    }
}

function Start-Backup {
    param (
        [string]$source,
        [string]$backup
    )

    try {
        $timeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

        $files = @(Get-ChildItem -Path $source -File)
        $fileCount = $files.Count

        foreach ($file in $files) {
            $newName = "$($file.BaseName)_$timeStamp$($file.Extension)"
            Copy-Item -Path $file.FullName -Destination (Join-Path $backup $newName) -ErrorAction Stop
        }

        Write-Host "Backup completed successfully! Files copied: $fileCount" -ForegroundColor Green
    }

    catch {
        Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor DarkRed
    }
}

Test-BackupFolders -source $source -backup $backup

Start-Backup -source $source -backup $backup
