# Use the local provider to create files on THIS computer
provider "local" {}

# Set the path to the source folder
variable "source_dir" {
  type        = string
  default     = "../source"
  description = "Source directory containing the files to back up"
}

# Set the path to the backup folder
variable "backup_dir" {
  type        = string
  default     = "../backups"
  description = "Destination directory where the backup files are stored"
}

# Create the source folder information file
resource "local_file" "source_folder" {
  filename = "${var.source_dir}/source-info.txt"
  content  = "This folder contains files that will be included in the backup."
}

# Create the backup folder information file
resource "local_file" "backup_folder" {
  filename = "${var.backup_dir}/backup-info.txt"
  content  = "This folder contains backup copies of the source files."
}

# Create config.json
resource "local_file" "config" {
  filename = "${path.module}/../config.json"

  content = jsonencode({
    sourceFolder    = "source"
    backupFolder    = "backups"
    filePrefix      = "backup"
    timestampFormat = "yyyy-MM-dd_HH.mm.ss"
  })
}

# Show the path to the source folder
output "source_directory" {
  value = dirname(local_file.source_folder.filename)
}

# Show the path to the backup folder
output "backup_directory" {
  value = dirname(local_file.backup_folder.filename)
}

output "config_json" {
  value = local_file.config.filename
}
