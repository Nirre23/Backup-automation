provider "local" {}

variable "source_dir" {
  type    = string
  default = "../source"
}

variable "backup_dir" {
  type    = string
  default = "../backups"
}

resource "local_file" "source_folder" {
  filename = "${var.source_dir}/.keep"
  content  = ""
}

resource "local_file" "backup_folder" {
  filename = "${var.backup_dir}/.keep"
  content  = ""
}

output "source_directory" {
  value = dirname(local_file.source_folder.filename)
}

output "backup_directory" {
  value = dirname(local_file.backup_folder.filename)
}
