#Deletes Windows and user temporary files to free disk space and improve performance.

del /q /f /s %TEMP%\*      <-------------- deletes user temp files

del /q /f /s C:\Windows\Temp\*   <----- deltes windows system temp files