# Get the main project folder
$projectPath = Split-Path -Parent $PSScriptRoot

# Get the Terraform folder path
$terraformPath = Join-Path $projectPath "terraform"

# Start Terraform
Write-Host "Starting Terraform..." -ForegroundColor Cyan

# Initialize Terraform
terraform "-chdir=$terraformPath" init -input=false

# Check if initialization was successful
if ($LASTEXITCODE -ne 0) {
    throw "Terraform initialization failed."
}

# Create the folders using terraform and auto-approve
terraform "-chdir=$terraformPath" apply -auto-approve

# Check if folder creation was successful
if ($LASTEXITCODE -ne 0) {
    throw "Terraform apply failed."
}
# Show success message
Write-Host "Folder setup completed successfully!" -ForegroundColor Green
