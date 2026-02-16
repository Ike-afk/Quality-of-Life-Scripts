
****fore running this script: Change the folder path location & Destination folder path location****



$source = Read-Host "Enter the source folder path"


$destination = Read-Host "Enter the destination folder path (inside your Google Drive folder)"
if (-Not (Test-Path $source)) {
    Write-Host "Source folder does not exist. Exiting." -ForegroundColor Red
    exit
}
if (-Not (Test-Path $destination)) {
    Write-Host "Destination folder does not exist. Creating it..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $destination
}
try {
    Move-Item -Path "$source\*" -Destination $destination -Force
    Write-Host "Files moved successfully!" -ForegroundColor Green
} catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
