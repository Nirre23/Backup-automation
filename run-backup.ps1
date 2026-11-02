$projectPath = $PSScriptRoot
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

Write-Host "Project setup completed!" -ForegroundColor Green

$backupScript = Join-Path $projectPath "scripts/backup.ps1"

Write-Host "Starting backup..." -ForegroundColor Cyan

& $backupScript
