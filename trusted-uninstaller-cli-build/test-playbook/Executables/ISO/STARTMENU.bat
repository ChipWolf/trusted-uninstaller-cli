cd Executables

@if exist "%AME_ISOPATH%\Windows\StartMenuLayout.xml" echo del /q /f "%AME_ISOPATH%\Windows\StartMenuLayout.xml" & del /q /f "%AME_ISOPATH%\Windows\StartMenuLayout.xml"

copy /y "Layout.xml" "%AME_ISOPATH%\Windows\StartMenuLayout.xml"
mkdir "%AME_ISOPATH%\Users\Default\AppData\Local\Microsoft\Windows\Shell"
copy /y "LayoutUser.xml" "%AME_ISOPATH%\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"

reg add "HKU\HKCU-%AME_ISOGUID%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /f
reg add "HKU\HKCU-%AME_ISOGUID%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d 0 /f
reg add "HKU\HKCU-%AME_ISOGUID%\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "C:\Windows\StartMenuLayout.xml" /f

PowerShell -NoP -C "Import-StartLayout -LayoutPath '%AME_ISOPATH%\Windows\StartMenuLayout.xml' -MountPath '%AME_ISOPATH%'"

reg add "HKU\HKLM-SOFTWARE-%AME_ISOGUID%\Policies\Microsoft\Windows\Explorer" /f
reg add "HKU\HKLM-SOFTWARE-%AME_ISOGUID%\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_SZ /d "%SYSTEMDRIVE%\Windows\StartMenuLayout.xml" /f