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

    # Start with the first file number
    $number = 1
    $fileName = "test_{0:D3}.txt" -f $number
    $filePath = Join-Path $folder $fileName

    # If the name is already taken, try the next number
    while (Test-Path -LiteralPath $filePath) {
        $number++
        $fileName = "test_{0:D3}.txt" -f $number
        $filePath = Join-Path $folder $fileName
    }

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
