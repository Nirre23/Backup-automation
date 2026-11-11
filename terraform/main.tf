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

# Create the source folder by adding a .keep file
resource "local_file" "source_file" {
  filename = "${var.source_dir}/.keep"
  content  = ""
}

# Create the backup folder by adding a .keep file
resource "local_file" "backup_file" {
  filename = "${var.backup_dir}/.keep"
  content  = ""
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
  value = dirname(local_file.source_file.filename)
}

# Show the path to the backup folder
output "backup_directory" {
  value = dirname(local_file.backup_file.filename)
}

output "config_json"{
  value = local_file.config.filename
}
