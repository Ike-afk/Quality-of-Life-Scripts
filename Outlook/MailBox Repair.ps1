# ================================
# Everett Carpet – Mailbox Repair Notes
# User: office@everettcarpet.com
# Admin: ironstacksupport@everettcarpet.onmicrosoft.com
# Purpose: Fix issue where user can send but not receive email,
#          even though message trace shows "Delivered".
# ================================

# 1) OPEN WINDOWS POWERSHELL
#    (Not PowerShell ISE, not CMD. Run as admin if needed.)

# 2) ALLOW SCRIPT EXECUTION FOR THIS SESSION ONLY
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# 3) INSTALL EXCHANGE ONLINE MODULE
#    (Fixes "module could not be loaded" error)
Install-Module -Name ExchangeOnlineManagement -Scope CurrentUser -Force -AllowClobber

# 4) IMPORT THE MODULE
Import-Module ExchangeOnlineManagement

# 5) CONNECT TO EXCHANGE ONLINE USING ADMIN ACCOUNT
Connect-ExchangeOnline -UserPrincipalName "ironstacksupport@everettcarpet.onmicrosoft.com"

# 6) RUN MAILBOX REPAIR
#    This fixes hidden/corrupted folders where inbound mail disappears.

# Repair folder structure corruption
New-MailboxRepairRequest -Mailbox "office@everettcarpet.com" -CorruptionType FolderView, ProvisionedFolder, SearchFolder

# Rebuild default mailbox folders (Inbox, Junk, Sent, etc.)
Set-Mailbox -Identity "office@everettcarpet.com" -Force

# 7) DISCONNECT SESSION
Disconnect-ExchangeOnline -Confirm:$false

# 8) AFTER REPAIR:
#    - Wait 10–30 minutes
#    - Log into https://outlook.office.com as office@everettcarpet.com
#    - Send a test email from Gmail to confirm it now appears in Inbox/Junk
