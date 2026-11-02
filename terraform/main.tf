provider "local" {}

variable "project_name" {
  default = "backup-automation"
}


resource "local_file" "source_folder" {
  filename = "../source/.keep"
  content  = "# Källmapp för ${var.project_name}"
}

resource "local_file" "backup_folder" {
  filename = "../backups/.keep"
  content  = "# Backupmapp för ${var.project_name}"
}

output "project_path" {
  value = "../"
}


