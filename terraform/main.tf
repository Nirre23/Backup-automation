# Use the local provider to create files on this computer
provider "local" {}

# Set the source folder name relative to the project root
variable "source_dir" {
  type        = string
  default     = "source"
  description = "Source directory containing the files to back up"
}

# Set the backup folder name relative to the project root
variable "backup_dir" {
  type        = string
  default     = "backups"
  description = "Destination directory where the backup files are stored"
}

# Create an information file in the source folder
resource "local_file" "source_folder" {
  filename = "${path.module}/../${var.source_dir}/source-info.txt"
  content  = "This folder contains files that will be included in the backup."
}

# Create an information file in the backup folder
resource "local_file" "backup_folder" {
  filename = "${path.module}/../${var.backup_dir}/backup-info.txt"
  content  = "This folder contains backup copies of the source files."
}

# Create config.json in the project root.
# Use the same folder variables as the information file paths above.
resource "local_file" "config" {
  filename = "${path.module}/../config.json"

  content = jsonencode({
    sourceFolder    = var.source_dir
    backupFolder    = var.backup_dir
    filePrefix      = "backup"
    timestampFormat = "yyyy-MM-dd_HH.mm.ss"
  })
}

# Display the source folder path after provisioning
output "source_directory" {
  value = dirname(local_file.source_folder.filename)
}

# Display the backup folder path after provisioning
output "backup_directory" {
  value = dirname(local_file.backup_folder.filename)
}

# Display the config.json path after provisioning
output "config_json" {
  value = local_file.config.filename
}
