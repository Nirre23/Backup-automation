# Get the main project folder
$projectPath = Split-Path -Parent $PSScriptRoot
$terraformPath = Join-Path $projectPath "terraform"

# Start terraform
Write-Host "Starting Terraform..." -ForegroundColor Cyan

#Initialize terraform
terraform "-chdir=$terraformPath" init -input=false

# Stop of initialization fails
if ($LASTEXITCODE -ne 0) {
    throw "Terraform initialization failed."
}

# Create the folders using terraform and auto-approve
terraform "-chdir=$terraformPath" apply -auto-approve

# Stop if the setup fails
if ($LASTEXITCODE -ne 0) {
    throw "Terraform apply failed."
}
# Successmessage
Write-Host "Folder setup completed successfully!" -ForegroundColor Green
