@echo off

if exist "%AME_ISOPATH%\Program Files\UngoogledChromium\bin\chrome.exe" exit /b 0

mkdir "%AME_ISOPATH%\Program Files\UngoogledChromium"

copy /y "UGC\chrlauncher.ini" "%AME_ISOPATH%\Program Files\UngoogledChromium"
copy /y "UGC\chrlauncher.exe" "%AME_ISOPATH%\Program Files\UngoogledChromium"
copy /y "UGC\chrome.exe" "%AME_ISOPATH%\Program Files\UngoogledChromium"
copy /y "UGC\ugc_uninstaller.exe" "%AME_ISOPATH%\Program Files\UngoogledChromium\Ungoogled Uninstaller.exe"

PowerShell -NoP -C "Start-Process -FilePath '%AME_ISOPATH%\Program Files\UngoogledChromium\chrlauncher.exe' -WindowStyle Hidden -Wait"