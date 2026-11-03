
$projectPath = Split-Path -Parent $PSScriptRoot
$terraformPath = Join-Path $projectPath "terraform"

Write-Host "Starting Terraform..." -ForegroundColor Cyan

terraform "-chdir=$terraformPath" init -input=false

if ($LASTEXITCODE -ne 0) {
    throw "Terraform initialization failed."
}

terraform "-chdir=$terraformPath" apply -auto-approve

if ($LASTEXITCODE -ne 0) {
    throw "Terraform apply failed."
}

Write-Host "Folder setup completed successfully!" -ForegroundColor Green
