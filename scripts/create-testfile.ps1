$projectPath = Split-Path -Parent $PSScriptRoot

# Create a new test file in the source folder
function New-TestFile {
    param (
        [string]$sourceFolderPath
    )

    # Check that the source folder exists
    if (!(Test-Path -LiteralPath $sourceFolderPath)) {
        throw "Source folder missing: $sourceFolderPath"
    }

    # Find the first available file number
    $testFileNumber = 1

    while (Test-Path -LiteralPath (Join-Path $sourceFolderPath "test_$testFileNumber.txt")) {
        $testFileNumber++
    }
    # Create the file name and full file path
    $testFileName = "test_$testFileNumber.txt"
    $testFilePath = Join-Path $sourceFolderPath $testFileName

    # Add some text and the current date and time to the file
    $testFileContent = "Test file number $testFileNumber was created $(Get-Date -Format $configuration.timestampFormat)"
    Set-Content -LiteralPath $testFilePath -Value $testFileContent -ErrorAction Stop

    Write-Host "Created test file: $testFileName" -ForegroundColor Green

}

# Create the test file and handle any errors
try {
    $configFilePath = Join-Path $projectPath "config.json"
    $configuration = Get-Content -Path $configFilePath -Raw -ErrorAction Stop |
        ConvertFrom-Json -ErrorAction Stop

    $sourceFolderPath = Join-Path $projectPath $configuration.sourceFolder
    New-TestFile -sourceFolderPath $sourceFolderPath
}
catch {
    Write-Host "Could not create test file: $($_.Exception.Message)" -ForegroundColor Red
}
