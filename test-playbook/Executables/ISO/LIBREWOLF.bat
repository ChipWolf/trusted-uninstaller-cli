@echo OFF

rmdir /q /s "%APPDATA%\Microsoft\Windows\Start Menu\Programs\LibreWolf"

mkdir "%AME_ISOPATH%\Users\Default\.librewolf"
copy /y "librewolf.overrides.cfg" "%AME_ISOPATH%\Users\Default\.librewolf"

echo 	PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Public\Desktop\LibreWolf.lnk'); $S.TargetPath = '%ProgramFiles%\LibreWolf\librewolf.exe'; $S.WorkingDirectory = '%ProgramFiles%\LibreWolf'; $S.Save()"
PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Public\Desktop\LibreWolf.lnk'); $S.TargetPath = '%ProgramFiles%\LibreWolf\librewolf.exe'; $S.WorkingDirectory = '%ProgramFiles%\LibreWolf'; $S.Save()"

copy /y "%AME_ISOPATH%\Users\Public\Desktop\LibreWolf.lnk" "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned"

PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\ProgramData\Microsoft\Windows\Start Menu\Programs\LibreWolf.lnk'); $S.TargetPath = '%ProgramFiles%\LibreWolf\librewolf.exe'; $S.WorkingDirectory = '%ProgramFiles%\LibreWolf'; $S.Save()"
REM PowerShell -NoP -C "$Content = (Get-Content '%~dp0\Layout.xml'); $Content = $Content -replace '%%ALLUSERSPROFILE%%\\Microsoft\\Windows\\Start Menu\\Programs\\Firefox.lnk', '%%ALLUSERSPROFILE%%\\Microsoft\\Windows\\Start Menu\\Programs\\LibreWolf.lnk' | Set-Content '%~dp0\Layout.xml'"
