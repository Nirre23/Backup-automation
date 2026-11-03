provider "local" {}

resource "local_file" "source_folder" {
  filename = "../source/.keep"
  content  = ""
}

resource "local_file" "backup_folder" {
  filename = "../backups/.keep"
  content  = ""
}

output "source_directory" {
  value = dirname(local_file.source_folder.filename)
}

output "backup_directory" {
  value = dirname(local_file.backup_folder.filename)
}
