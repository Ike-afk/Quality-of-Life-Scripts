<#
.SYNOPSIS
Checks for successful Windows Server Backup versions.

.DESCRIPTION
Runs "wbadmin get versions" and verifies that at least one successful
backup version exists.

If backup versions are found, the script outputs the results.
If none are found, it reports a failure.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.NOTES
Requires:
- Windows Server Backup feature installed
- Script must be run as Administrator
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ExpectedKeyword = "Version identifier"   # Only change if OS language differs

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

# Verify wbadmin is available
if (-not (Get-Command wbadmin -ErrorAction SilentlyContinue)) {
    Write-Error "wbadmin is not installed or not available on this system."
    exit 1
}

# Execute backup status check
$Status = wbadmin get versions 2>&1

if ($Status -match $ExpectedKeyword) {
    Write-Host "Backups found:" -ForegroundColor Green
    $Status
} else {
    Write-Host "No successful backups found!" -ForegroundColor Red
    exit 1
}
