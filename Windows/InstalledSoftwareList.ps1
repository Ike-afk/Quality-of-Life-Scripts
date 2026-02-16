#Generates an inventory report of all applications installed on a Windows system for compliance or auditing.

Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Sort-Object DisplayName |
Export-Csv "C:\Reports\Installed_Software.csv" -NoTypeInformation
