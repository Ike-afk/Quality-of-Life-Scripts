#Tracks user logon and logoff activity from the Security event logs for auditing or troubleshooting.

Get-EventLog -LogName Security -InstanceId 4624,4634 |
Select-Object TimeGenerated, @{Name="User";Expression={$_.ReplacementStrings[5]}}, Message |
Export-Csv "C:\Reports\UserLogons.csv" -NoTypeInformation
