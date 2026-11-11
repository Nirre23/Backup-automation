# Get the main project folder
$projectPath = Split-Path -Parent $PSScriptRoot

# Get the Terraform folder path
$terraformFolderPath = Join-Path $projectPath "terraform"

# Start Terraform
Write-Host "Starting Terraform..." -ForegroundColor DarkMagenta

# Initialize Terraform
terraform "-chdir=$terraformFolderPath" init -input=false

# Check if initialization was successful
if ($LASTEXITCODE -ne 0) {
    throw "Terraform initialization failed."
}

# Apply the Terraform configuration without confirmation
terraform "-chdir=$terraformFolderPath" apply -auto-approve

# Check if folder creation was successful
if ($LASTEXITCODE -ne 0) {
    throw "Terraform apply failed."
}
# Show success message

Write-Host ""
Write-Host "Folder setup completed successfully!" -ForegroundColor Green

