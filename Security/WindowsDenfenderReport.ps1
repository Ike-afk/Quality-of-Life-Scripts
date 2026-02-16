#Checks Defender’s protection status, last scan, and definition update age.

Get-MpComputerStatus |
Select-Object AMServiceEnabled, AntispywareEnabled, AntivirusEnabled, QuickScanAge, AntivirusSignatureLastUpdated |
Export-Csv "C:\Reports\DefenderStatus.csv" -NoTypeInformation
