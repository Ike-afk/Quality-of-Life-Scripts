#Lists installed Windows updates to ensure patch compliance across systems.

Get-HotFix |
Select-Object Description, HotFixID, InstalledOn |
Export-Csv "C:\Reports\PatchCompliance.csv" -NoTypeInformation
