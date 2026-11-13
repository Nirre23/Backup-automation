# Get the project root folder
$projectPath = Split-Path -Parent $PSScriptRoot

# Load the project configuration and create a test file
try {
    $configFilePath = Join-Path $projectPath "config.json"
    $config = Get-Content -LiteralPath $configFilePath -Raw -ErrorAction Stop |
        ConvertFrom-Json -ErrorAction Stop

    $sourceFolderPath = Join-Path $projectPath $config.sourceFolder

    # Stop if the configured source folder does not exist
    if (!(Test-Path -LiteralPath $sourceFolderPath)) {
        throw "Source folder missing: $sourceFolderPath"
    }

    # Find the first available test file number
    $testFileNumber = 1
    $testFilePath = Join-Path $sourceFolderPath "test_$testFileNumber.txt"

    while (Test-Path -LiteralPath $testFilePath) {
        $testFileNumber++
        $testFilePath = Join-Path $sourceFolderPath "test_$testFileNumber.txt"
    }

    # Add the configured timestamp to the test file content
    $timestamp = Get-Date -Format $config.timestampFormat
    $fileContent = "Test file number $testFileNumber was created $timestamp"

    # Create the test file and report its name
    Set-Content -LiteralPath $testFilePath -Value $fileContent -ErrorAction Stop

    Write-Host "Created test file: test_$testFileNumber.txt" -ForegroundColor Green
}
catch {
    # Add context to any error raised while creating the test file
    throw "Could not create test file: $($_.Exception.Message)"
}
