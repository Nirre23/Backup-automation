# Set the path to the source folder
variable "source_dir" {
  type    = string
  default = "../source"
  description = "Source directory containing the files to back up"
}
# Set the path to the backup folder
variable "backup_dir" {
  type    = string
  default = "../backups"
  description = "Destination directory where the backup files are stored"
}
