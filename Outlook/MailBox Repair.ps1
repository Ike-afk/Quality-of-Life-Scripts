

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
Connect-ExchangeOnline -UserPrincipalName "email"

# 6) RUN MAILBOX REPAIR
#    This fixes hidden/corrupted folders where inbound mail disappears.

# Repair folder structure corruption
New-MailboxRepairRequest -Mailbox "office@email.com" -CorruptionType FolderView,ProvisionedFolder,SearchFolder

# Rebuild default mailbox folders (Inbox, Junk, Sent, etc.)
Set-Mailbox -Identity "office@email.com" -Force

# 7) DISCONNECT SESSION
Disconnect-ExchangeOnline -Confirm:$false

# 8) AFTER REPAIR:
#    - Wait 10–30 minutes
#    - Log into https://outlook.office.com as office@email.com
#    - Send a test email from Gmail to confirm it now appears in Inbox/Junk
