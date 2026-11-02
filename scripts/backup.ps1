$source = "./source"
$backup = "./backups"

function Test-BackupFolders {
    param (
        [string]$source,
        [string]$backup
    )

    if (!(Test-Path $source)) {
        throw "Källmappen saknas: $source"
    }

    if (!(Test-Path $backup)) {
        throw "Backupmappen saknas: $backup"
    }
}

function Start-Backup {
    Get-ChildItem -Path $source -File | ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $backup
    }
}

Test-BackupFolders -source $source -backup $backup
Start-Backup
