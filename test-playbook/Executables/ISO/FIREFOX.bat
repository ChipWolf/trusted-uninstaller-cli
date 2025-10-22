mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned"
PowerShell -NoP -C "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%AME_ISOPATH%\Users\Default\AppData\Roaming\OpenShell\Pinned\Firefox.lnk'); $S.TargetPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'; $S.WorkingDirectory = 'C:\Program Files\Mozilla Firefox'; $S.Save()"

if not exist "AME-Firefox-Injection" (
	echo. & echo No supplied AME-Firefox-Injection folder detected.
	exit /b 4
)

echo. & echo Generating random string...

:GenRND
@echo off

setlocal EnableDelayedExpansion
set "RNDConsist=abcdefghijklmnopqrstuvwxyz0123456789"
set /a "RND=%RANDOM% %% 36"
set "RNDStr=!RNDStr!!RNDConsist:~%RND%,1!"
if "%RNDStr:~7%"=="" (goto GenRND)
endlocal & set "RNDStr=%RNDStr%"

@echo on
:PROFILENAME

echo. & echo Injecting profile...
@echo ON

:: This could also be set manually in the profiles.ini file
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%"
robocopy "AME-Firefox-Injection" "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%" /E /xf "3647222921wleabcEoxlt-eengsairo.sqlite" > NUL
mkdir "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%\storage\default\moz-extension+++41087662-660a-4251-8c0c-38aa4da5b325^userContextId=4294967295\idb"
copy /y "AME-Firefox-Injection\3647222921wleabcEoxlt-eengsairo.sqlite" "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\Profiles\%RNDStr%.%profileName%\storage\default\moz-extension+++41087662-660a-4251-8c0c-38aa4da5b325^userContextId=4294967295\idb"

:: Sets profile as the default
echo [Install%NewCode%]>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo Default=Profiles/%RNDStr%.%profileName%>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo Locked=^1>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo.>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo [Profile0]>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo Name=%profileName%>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo IsRelative=^1>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"
echo Path=Profiles/%RNDStr%.%profileName%>> "%AME_ISOPATH%\Users\Default\AppData\Roaming\Mozilla\Firefox\profiles.ini"

echo. & echo Successfully injected custom Firefox configs.
endlocal & exit /b 0