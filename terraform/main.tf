# Create the backup folder by adding a .keep file
resource "local_file" "source_folder" {
  filename = "${var.source_dir}/.keep"
  content  = ""
}

# Create the source folder by adding a .keep file
resource "local_file" "backup_folder" {
  filename = "${var.backup_dir}/.keep"
  content  = ""
}

# Show the path to the source folder
output "source_directory" {
  value = dirname(local_file.source_folder.filename)
}

# Show the path to the backup folder
output "backup_directory" {
  value = dirname(local_file.backup_folder.filename)
}
