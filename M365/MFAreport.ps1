<#
.SYNOPSIS
Exports MFA registration status for all Microsoft 365 users.

.DESCRIPTION
Connects to Microsoft Graph and checks whether users have
registered any strong authentication methods (MFA).

Outputs results to CSV for security auditing.

.CONFIGURATION
Edit ONLY the values in the CONFIG SECTION below.

.REQUIREMENTS
- Microsoft Graph PowerShell SDK
- Permissions: User.Read.All, AuditLog.Read.All
#>

# ============================================================
# CONFIG SECTION – EDIT THESE VALUES ONLY
# ============================================================

$ReportFolder = "C:\Reports"           # Where to save the report
$ReportName = "MFAStatus.csv"        # Output CSV filename
$GraphScopes = @("User.Read.All", "AuditLog.Read.All")

# ============================================================
# DO NOT EDIT BELOW THIS LINE
# ============================================================

Import-Module Microsoft.Graph -ErrorAction Stop

Connect-MgGraph -Scopes $GraphScopes | Out-Null

if (!(Test-Path $ReportFolder)) {
    New-Item -ItemType Directory -Path $ReportFolder -Force | Out-Null
}

$Results = foreach ($User in Get-MgUser -All -Property DisplayName, UserPrincipalName) {
    try {
        $Methods = Get-MgUserAuthenticationMethod -UserId $User.Id
        $HasMFA = ($Methods.Count -gt 1)  # Password always exists; more methods = MFA

        [PSCustomObject]@{
            DisplayName       = $User.DisplayName
            UserPrincipalName = $User.UserPrincipalName
            MFARegistered     = $HasMFA
        }
    } catch {
        Write-Warning "Could not check MFA for $($User.UserPrincipalName)"
    }
}

$CsvPath = Join-Path $ReportFolder $ReportName
$Results | Export-Csv -Path $CsvPath -NoTypeInformation

Write-Host "MFA status report saved to $CsvPath"
