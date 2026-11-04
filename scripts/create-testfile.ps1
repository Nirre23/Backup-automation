$projectPath = Split-Path -Parent $PSScriptRoot
$source = Join-Path $projectPath "source"

function New-TestFile {
    param (
        [string]$folder
    )

    if (!(Test-Path -LiteralPath $folder)) {
        throw "Source folder missing: $folder"
    }

    # Count existing test files (.keep and other files are ignored)
    $existing = @(Get-ChildItem -LiteralPath $folder -File -Filter "test_*.txt")
    $number = $existing.Count + 1

    # Build the name for example  test_001.txt
    $fileName = "test_{0:D3}.txt" -f $number
    $filePath = Join-Path $folder $fileName

    # If the name is already taken , try the next number
    while (Test-Path -LiteralPath $filePath) {
        $number++
        $fileName = "test_{0:D3}.txt" -f $number
        $filePath = Join-Path $folder $fileName
    }

    $content = "Test file number $number created $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Set-Content -LiteralPath $filePath -Value $content -ErrorAction Stop

    Write-Host "Created test file: $fileName" -ForegroundColor Green
    return $fileName
}

try {
    New-TestFile -folder $source | Out-Null
}
catch {
    Write-Host "Could not create test file: $($_.Exception.Message)" -ForegroundColor Red
}
