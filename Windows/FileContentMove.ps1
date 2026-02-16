<#
.SYNOPSIS
Moves all contents from one folder to another.

.DESCRIPTION
Prompts for a source folder and a destination folder.
Moves all files and subfolders from the source to the destination.

If the destination folder does not exist, it will be created.

.CONFIGURATION
You will be prompted to enter:
- Source folder path
- Destination folder path
#>

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Prompt user for paths
$Source = Read-Host "Enter the FULL source folder path"
$Destination = Read-Host "Enter the FULL destination folder path"

# Validate source
if (-not (Test-Path $Source)) {
    Write-Host "Source folder does not exist. Exiting." -ForegroundColor Red
    exit 1
}

# Create destination if missing
if (-not (Test-Path $Destination)) {
    Write-Host "Destination folder does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
}

try {
    Move-Item -Path (Join-Path $Source "*") -Destination $Destination -Force -ErrorAction Stop
    Write-Host "Files moved successfully!" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
