#Identifies users who haven’t signed in within 90 days — useful for cleanup and license reclamation.

# Ensure Microsoft Graph module is installed
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Microsoft Graph module not found. Installing..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph -Scope AllUsers -Force
}

# Import the module
Import-Module Microsoft.Graph

# Connect to Microsoft Graph with required permissions
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All","AuditLog.Read.All"

# Create output folder if it doesn't exist
$reportPath = "C:\Reports"
if (-not (Test-Path $reportPath)) {
    New-Item -Path $reportPath -ItemType Directory | Out-Null
}

# Define how many days of inactivity to check
$daysInactive = 90
$cutoffDate = (Get-Date).AddDays(-$daysInactive)

Write-Host "Retrieving users... This may take a few minutes." -ForegroundColor Cyan

# Fetch all users
$allUsers = Get-MgUser -All

# Prepare results array
$inactiveUsers = @()

foreach ($user in $allUsers) {
    try {
        $signin = Get-MgAuditLogSignIn -Filter "userPrincipalName eq '$($user.UserPrincipalName)'" -Top 1
        $lastLogon = $signin.CreatedDateTime

        if ($null -eq $lastLogon -or $lastLogon -lt $cutoffDate) {
            $inactiveUsers += [PSCustomObject]@{
                DisplayName       = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                LastLogon         = $lastLogon
            }
        }
    }
    catch {
        Write-Warning "Could not retrieve sign-in data for $($user.UserPrincipalName)"
    }
}

# Export to CSV
$csvPath = "$reportPath\InactiveUsers.csv"
$inactiveUsers | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Report generated: $csvPath" -ForegroundColor Green
