copy /y "amecs.exe" "%AME_ISOPATH%\Windows\System32"

mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned"
echo PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned\Configure AME.lnk'); $S.TargetPath = '%WINDIR%\System32\amecs.exe'; $S.Save()"
PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned\Configure AME.lnk'); $S.TargetPath = '%WINDIR%\System32\amecs.exe'; $S.Save()"
