
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell"
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned"

mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nomacs"

copy /y "Terminal.lnk" "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned\Terminal.lnk"

PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\nomacs\nomacs - Image Lounge.lnk'); $S.TargetPath = '%SYSTEMDRIVE%\Program Files\nomacs\bin\nomacs.exe'; $S.WorkingDirectory = 'C:\Program Files\nomacs'; $S.Save()"
