<#
.SYNOPSIS
Performs a lightweight folder backup using Robocopy.

.DESCRIPTION
Copies a specified source folder to a destination location (external drive or network share)
using Robocopy with mirror mode enabled.

The script:
- Mirrors the source directory (/MIR)
- Retries failed copies twice
- Waits 5 seconds between retries
- Logs output to a dated log file
- Creates the log directory if it does not exist

This is intended for quick operational backups outside of a formal backup system.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.NOTES
Requires: Robocopy (built into Windows)
Run as: Standard user (Admin not required unless accessing restricted paths)
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$Source = "C:\Data"                        # Folder to back up
$Destination = "\\NAS01\Backups\Workstation1"   # Backup target (external drive or network share)
$LogFolder = "C:\Reports"                     # Folder where logs will be saved

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Validate source path
if (!(Test-Path $Source)) {
    Write-Error "Source path does not exist: $Source"
    exit 1
}

# Ensure log folder exists
if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
}

# Build log file path
$Log = Join-Path $LogFolder ("BackupCopy_{0}.log" -f (Get-Date -Format "yyyy-MM-dd"))

# Execute backup
Robocopy $Source $Destination /MIR /R:2 /W:5 /LOG:$Log

Write-Host "Backup completed. Log saved to $Log"
