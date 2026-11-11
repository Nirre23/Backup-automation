# Backup Automation

## Goal

The goal of this project is to build a simple local backup solution using Terraform and PowerShell.

Terraform creates the required folders and generates the project's configuration file. PowerShell creates test files and runs the backup by copying files from a source folder to a backup folder.

The solution also checks that the files were copied correctly and handles errors that may happen while it runs.

## How it works

### Terraform

Terraform creates the `source` and `backups` folders.

I use the Local provider and `local_file` resources to create an empty `.keep` file in each folder. This also creates the folders if they do not already exist.

The `terraform/main.tf` file contains the provider settings, variables, resources, and outputs. The folder paths are set with variables, so they are easy to change.

Terraform also creates the project's `config.json` file using `jsonencode()`. This file contains shared settings used by the PowerShell scripts.

I have also added outputs that show the paths to the source folder, backup folder, and configuration file.

The Terraform configuration is idempotent. I tested this by running the setup script multiple times. After the initial creation, Terraform detected that no changes were needed and reported 0 resources added, changed or destroyed.

### PowerShell

PowerShell creates test files, runs the backup, and checks the result.

The backup script:

- Checks that the source and backup folders exist.
- Gets files directly from the source folder. It does not search subfolders.
- Copies the files to the backup folder with a prefix and timestamp in each file name.
- Saves the names of the new files in a list.
- Checks that the backup files exist.
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
- `scripts/backup.ps1` copies the files and checks that the backup files exist.
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

The backup files are saved in `backups`. Each file name includes a prefix and timestamp.

**4. Reset the project**

```powershell
./scripts/cleanup.ps1
```

The script asks you to enter `yes` to confirm. Both `source` and `backups`, including all their contents, will be removed. The `config.json` file will also be removed.

After that, you can run `setup-folders.ps1` again to create the folders and configuration file.

## Results

The result is a working local backup solution. Terraform creates the folders and configuration file, while PowerShell creates test files, copies files, and checks the result.

Each backup file name includes a prefix and timestamp. This means earlier backups stay in the folder and are not overwritten.

I tested the process by removing the folders and then creating them again with Terraform. I also tested the backup with test files and checked that the copies were saved in the right folder.

I also tested what happens when the source folder is empty. The script stops and shows a clear error message instead of creating an empty backup.

I also tested the idempotency of Terraform by running it more than once. It works as expected. If the folders and configuration file already exist and nothing needs to change, Terraform reports that no changes are needed.

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
