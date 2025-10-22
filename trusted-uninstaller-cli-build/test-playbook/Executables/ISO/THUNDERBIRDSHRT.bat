
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell"
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned"

PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned\Thunderbird.lnk'); $S.TargetPath = '%SYSTEMDRIVE%\Program Files\Mozilla Thunderbird\thunderbird.exe'; $S.WorkingDirectory = 'C:\Program Files\Mozilla Thunderbird'; $S.Save()"
