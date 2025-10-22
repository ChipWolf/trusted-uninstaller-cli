@echo OFF

:sfcCmdChecks

if not exist "%~dp0\sfc.exe" (
		echo. & echo No supplied sfc.exe detected
		exit /b 2
)

:sfc1ExeCheck

if exist "%AME_ISOPATH%\Windows\System32\sfc1.exe" (
	echo sfc1.exe already exists, assigning permissions... & echo.

	echo takeown /f "%AME_ISOPATH%\Windows\System32\sfc.exe" /a
	takeown /f "%AME_ISOPATH%\Windows\System32\sfc.exe" /a
	echo icacls "%AME_ISOPATH%\Windows\System32\sfc.exe" /grant Administrators:F
	icacls "%AME_ISOPATH%\Windows\System32\sfc.exe" /grant Administrators:F
	echo del /q /f "%AME_ISOPATH%\Windows\System32\sfc.exe"
	del /q /f "%AME_ISOPATH%\Windows\System32\sfc.exe"
)



:managePermissions

echo Assigning permissions and renaming sfc.exe... & echo.

@echo ON

if exist "%AME_ISOPATH%\Windows\System32\sfc.exe" (
	takeown /f "%AME_ISOPATH%\Windows\System32\sfc.exe" /a > NUL 2>&1
	icacls "%AME_ISOPATH%\Windows\System32\sfc.exe" /grant Administrators:F > NUL 2>&1
	rename "%AME_ISOPATH%\Windows\System32\sfc.exe" "sfc1.exe" > NUL 2>&1
)
copy /y "sfc.exe" "%AME_ISOPATH%\Windows\System32" 1> NUL

takeown /f "%AME_ISOPATH%\Windows\System32\en-US\sfc.exe.mui" /a > NUL 2>&1
icacls "%AME_ISOPATH%\Windows\System32\en-US\sfc.exe.mui" /grant Administrators:F > NUL 2>&1
rename "%AME_ISOPATH%\Windows\System32\en-US\sfc.exe.mui" "sfc1.exe.mui" > NUL 2>&1

PowerShell -NoP -C "Get-Acl '%AME_ISOPATH%\Windows\System32\diskmgmt.msc' | Set-Acl '%AME_ISOPATH%\Windows\System32\sfc.exe'" > NUL 2>&1
PowerShell -NoP -C "Get-Acl '%AME_ISOPATH%\Windows\System32\diskmgmt.msc' | Set-Acl '%AME_ISOPATH%\Windows\System32\sfc1.exe'" > NUL 2>&1
PowerShell -NoP -C "Get-Acl '%AME_ISOPATH%\Windows\System32\diskmgmt.msc' | Set-Acl '%AME_ISOPATH%\Windows\System32\sfc1.exe.mui'" > NUL 2>&1
goto complete

:complete

@echo Successfully deployed sfc modification.
@exit /b 0
