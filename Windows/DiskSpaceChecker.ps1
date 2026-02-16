#Displays free and used disk space for all drives — great for identifying low storage before backups fail.

Get-PSDrive -PSProvider FileSystem |
Select-Object Name, @{Name="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}}, @{Name="Used(GB)";Expression={[math]::round(($_.Used/1GB),2)}}
