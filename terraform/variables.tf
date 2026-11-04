variable "source_dir" {
  type    = string
  default = "../source"
  description = "Source directory containing the files to back up"
}

variable "backup_dir" {
  type    = string
  default = "../backups"
  description = "Destination directory where the backup files are stored"
}
