$projectPath = Split-Path -Parent $PSScriptRoot

$source = Join-Path $projectPath "source"
$backup = Join-Path $projectPath "backups"

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

function Start-Backup {
    param (
        [string]$source,
        [string]$backup
    )

    $timeStamp = Get-Date -Format "yyyy-MM-dd_HH.mm.ss"

    $files = @(Get-ChildItem -LiteralPath $source -File)
    $fileCount = $files.Count
    $createdFiles = @()

    if ($fileCount -eq 0) {
        throw "No files found in source folder: $source"
    }

    foreach ($file in $files) {
        $newName = "$($file.BaseName)_$timeStamp$($file.Extension)"

        Copy-Item -LiteralPath $file.FullName -Destination (Join-Path $backup $newName) -ErrorAction Stop

        $createdFiles += $newName
    }

    Write-Host "Created backup files:" -ForegroundColor DarkMagenta
    $createdFiles | ForEach-Object { Write-Host $_ -ForegroundColor Cyan }

    Write-Host "Backup completed successfully! Files copied: $fileCount" -ForegroundColor Green

    return $createdFiles
}

function Test-BackupResult {
    param (
        [string]$backup,
        [string[]]$createdFiles
    )

    $successCount = 0

    foreach ($file in $createdFiles) {
        if (Test-Path -LiteralPath (Join-Path $backup $file)) {
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
    Write-Host "Backup failed: $($_.Exception.Message)" -ForegroundColor Red
}
