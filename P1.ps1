$ErrorActionPreference = "Stop"
$tempDir = "$env:TEMP\rt"
$p2Path = "$tempDir\P2.ps1"

# Wait for P2.ps1 to exist (in case download is slow, though Lua waits)
$timeout = 30
while (-not (Test-Path $p2Path) -and $timeout -gt 0) {
    Start-Sleep -Seconds 1
    $timeout--
}

if (-not (Test-Path $p2Path)) {
    Write-Error "P2.ps1 not found"
    exit 1
}

# Elevate
Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$p2Path`"" -Wait
