
$source = "./source"
$backup = "./backups"

function Test-BackupFolders {
    param (
        [string]$source,
        [string]$backup
    )

    if (!(Test-Path $source)) {
        throw "Source folder missing: $source"
    }

    if (!(Test-Path $backup)) {
        throw "Backup folder missing: $backup"
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
        $createdFiles = @()

        foreach ($file in $files) {
            $newName = "$($file.BaseName)_$timeStamp$($file.Extension)"

            Copy-Item -Path $file.FullName -Destination (Join-Path $backup $newName) -ErrorAction Stop

            $createdFiles += $newName
        }

        Write-Host "Created backup files:" -ForegroundColor DarkMagenta
        Write-Host $createdFiles -ForegroundColor Cyan

        Write-Host "Backup completed successfully! Files copied: $fileCount" -ForegroundColor Green

        return $createdFiles
    }
    catch {
        Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor DarkRed
        return @()
    }
}

function Test-BackupResult {
    param (
        [string]$backup,
        [string[]]$createdFiles
    )

    $successCount = 0

    foreach ($file in $createdFiles) {
        if (Test-Path (Join-Path $backup $file)) {
            $successCount++
        }
    }

    if ($successCount -eq $createdFiles.Count -and $createdFiles.Count -gt 0) {
        Write-Host "Backup verification successful!" -ForegroundColor Green
    }
    else {
        Write-Host "Backup verification failed!" -ForegroundColor Red
    }
}

try {


    Test-BackupFolders -source $source -backup $backup

    $createdFiles = Start-Backup -source $source -backup $backup

    Test-BackupResult -backup $backup -createdFiles $createdFiles

}
catch {
    Write-Host "Error:$($_.Exception.Message)" -ForegroundColor Red
}
