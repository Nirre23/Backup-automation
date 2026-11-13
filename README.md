# Backup Automation

## Goal

The goal of this project is to build a simple local backup solution using Terraform and PowerShell.

Terraform creates the required folders and generates the project's configuration file. PowerShell creates test files and runs the backup by copying files from a source folder to a backup folder.

The solution checks that the backup files were created and handles errors that may happen while it runs.

## How it works

### Terraform

Terraform creates the `source` and `backups` folders.

I use the Local provider and `local_file` resources to create information files in the folders: `source-info.txt` in `source` and `backup-info.txt` in `backups`. These files also cause the folders to be created if they do not already exist.

The `terraform/main.tf` file contains the provider settings, variables, resources, and outputs. Terraform uses variables for the source and backup folder paths. However, `config.json` uses the fixed folder names `source` and `backups`, so changing the Terraform paths alone will not update the configuration used by the PowerShell scripts.

Terraform also creates the project's `config.json` file using `jsonencode()`. This file contains shared settings used by the PowerShell scripts.

I have also added outputs that show the paths to the source folder, backup folder, and configuration file.

The Terraform configuration can be applied more than once. If its files have not been changed, Terraform reports that no changes are needed.

### PowerShell

PowerShell creates test files, runs the backup, and checks the result.

The backup script:

- Checks that the source and backup folders exist.
- Gets files directly from the source folder, except for `source-info.txt`. It does not search subfolders.
- Creates one timestamp per backup run and uses it in each backup file name and in `last-backup.txt`.
- Saves the names of the new files in a list.
- Checks that the backup files exist.
- Creates or updates `last-backup.txt` after the backup files have been checked. The file records the time of the successful backup and lists the files that were copied.
- Handles errors using `try/catch`.

I have also created a separate script for test files. It creates text files in the source folder with increasing numbers, such as `test_1.txt`, `test_2.txt`, and so on. Each file also contains the date and time when it was created.

### Configuration file

The project uses a shared `config.json` file created by Terraform.

The file contains:

- `sourceFolder` – the name of the source folder.
- `backupFolder` – the name of the backup folder.
- `filePrefix` – the prefix used in backup file names.
- `timestampFormat` – the format used for the date and time.

The test file script and backup script read their settings from this file. The cleanup script does not need to read the JSON file. Instead, it uses fixed paths to remove both folders and the configuration file.

### Scripts

The project has four separate PowerShell scripts:

- `scripts/setup-folders.ps1` starts Terraform and applies the configuration to create the folders and `config.json`.
- `scripts/create-testfile.ps1` creates test files in the source folder with increasing numbers.
- `scripts/backup.ps1` copies eligible files, checks that the backup files exist, and records the backup time and copied file names in `last-backup.txt`.
- `scripts/cleanup.ps1` asks for confirmation before removing the `source` and `backups` folders and the `config.json` file. You must enter `yes` to continue.

Each script has its own task. You can create the folders, make test files, run backups, and reset the project separately.

### Tools

- PowerShell 7
- Terraform
- WSL2 (Ubuntu)
- Visual Studio Code
- Git and GitHub

## Running the project

Open PowerShell in the project's main folder.

**1. Create the folders**

```powershell
./scripts/setup-folders.ps1
```

The script starts Terraform and creates the folders and `config.json`.

**2. Create test files**

```powershell
./scripts/create-testfile.ps1
```

The script creates a text file in `source`. You can also add your own files there.

**3. Run the backup**

```powershell
./scripts/backup.ps1
```

The backup files are saved in `backups`. Each file name includes a prefix and timestamp. The script skips `source-info.txt`. After a successful backup, it creates or updates `last-backup.txt` with the backup time and the names of the copied files.

**4. Reset the project**

```powershell
./scripts/cleanup.ps1
```

The script asks you to enter `yes` to confirm. Both `source` and `backups`, including all their contents, will be removed. The `config.json` file will also be removed.

After that, you can run `setup-folders.ps1` again to create the folders and configuration file.

## Results

The result is a working local backup solution. Terraform creates the folders, information files, and configuration file, while PowerShell creates test files, copies files, checks the result, and records the last successful backup time and copied file names in `last-backup.txt`.

Each backup file name includes a prefix and timestamp. This means earlier backups stay in the folder and are not overwritten.

I tested the process by removing the folders and then creating them again with Terraform. I also tested the backup with test files and checked that the copies were saved in the right folder.

I also tested what happens when there are no files to back up. The script skips `source-info.txt`, so if there are no other files in the source folder, it stops and shows an error instead of creating a backup.

I also tested applying Terraform more than once. After applying the updated configuration for the first time, later runs report that no changes are needed as long as Terraform-managed files have not changed. The `last-backup.txt` file is managed by the backup script, so Terraform does not reset its contents.

Terraform reported:

```text
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.
```

## What I learned

During this project, I learned how Terraform and PowerShell can work together to automate tasks that would otherwise take time to do by hand.

In PowerShell, I learned more about variables, functions, loops, and error handling. Error handling was difficult at first, but it became clearer as I used it more.

With Terraform, I learned how to create and manage files and folders in an organized way. I also learned how variables can make settings easier to change.

If I continue working on this project, I would like to:

- **Add support for subfolders**, so the backup can include whole folder structures and not just files in one folder.
- **Schedule backups**, so they do not have to be started by hand each time.
- **Store old backups in an archive**, to save space and keep things organized.

## AI and other sources

I used ChatGPT to get explanations, troubleshoot problems, and discuss the code and how it is organized.

I reviewed, changed, and tested the code myself to understand how the different parts of the project work. I am responsible for the final solution and how it works.

## GitHub

Repository: [Backup Automation – GitHub](https://github.com/Nirre23/Backup-automation)
