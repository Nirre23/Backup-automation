$projectPath = Split-Path -Parent $PSScriptRoot

$configPath = Join-Path $projectPath "config.json"
$config = Get-Content -Path $configPath -Raw | ConvertFrom-Json

$source = Join-Path $projectPath $config.sourceFolder
# Create a new test file in the source folder
function New-TestFile {
    param (
        [string]$folder
    )

    # Check that the source folder exists
    if (!(Test-Path -LiteralPath $folder)) {
        throw "Source folder missing: $folder"
    }

    # Find the first available file number
    $number = 1

    while (Test-Path -LiteralPath (Join-Path $folder "test_$number.txt")) {
        $number++
    }
    # Create the file name and full file path
    $fileName = "test_$number.txt"
    $filePath = Join-Path $folder $fileName

    # Add some text and the current date and time to the file
    $content = "Test file number $number was created $(Get-Date -Format $config.timestampFormat)"
    Set-Content -LiteralPath $filePath -Value $content -ErrorAction Stop

    Write-Host "Created test file: $fileName" -ForegroundColor Green

}

# Create the test file and handle any errors
try {
    New-TestFile -folder $source
}
catch {
    Write-Host "Could not create test file: $($_.Exception.Message)" -ForegroundColor Red
}
