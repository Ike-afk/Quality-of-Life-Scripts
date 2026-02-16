#Ensures client devices stay secure by installing all pending Windows updates and rebooting if required.

Install-Module PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Get-WindowsUpdate -AcceptAll -Install -AutoReboot
