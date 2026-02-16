<#
.SYNOPSIS
Runs Exchange Online mailbox repair for common hidden/corrupted folder issues.

.DESCRIPTION
Connects to Exchange Online and creates a Mailbox Repair Request for the target mailbox.
Useful when mail is missing, folders behave oddly, or searches/folder views appear corrupted.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- ExchangeOnlineManagement module installed
- Exchange admin permissions to run mailbox repair
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$AdminUPN = "admin@domain.com"     # <-- Put your admin login UPN here
$MailboxUPN = "user@domain.com"      # <-- Put the mailbox to repair here

# Corruption types to repair:
# FolderView, ProvisionedFolder, SearchFolder are common safe defaults
$CorruptionTypes = @("FolderView", "ProvisionedFolder", "SearchFolder")

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

Write-Host "Starting Exchange Online mailbox repair..." -ForegroundColor Cyan
Write-Host "Admin:   $AdminUPN"
Write-Host "Mailbox: $MailboxUPN" -ForegroundColor Yellow

# Verify module exists
if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    Write-Error "ExchangeOnlineManagement module is not installed. Install it first: Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force"
    exit 1
}

Import-Module ExchangeOnlineManagement -ErrorAction Stop

# Connect
Connect-ExchangeOnline -UserPrincipalName $AdminUPN

try {
    # Run mailbox repair
    New-MailboxRepairRequest -Mailbox $MailboxUPN -CorruptionType $CorruptionTypes | Out-Null
    Write-Host "Mailbox repair request submitted successfully." -ForegroundColor Green
    Write-Host "Note: Repairs can take time. Check status in Exchange admin tools if needed." -ForegroundColor Yellow
} catch {
    Write-Error "Failed to submit mailbox repair request: $($_.Exception.Message)"
    exit 1
} finally {
    Disconnect-ExchangeOnline -Confirm:$false
    Write-Host "Disconnected from Exchange Online." -ForegroundColor Cyan
}
