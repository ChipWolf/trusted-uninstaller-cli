@echo OFF

REM reg query "HKLM\System\CurrentControlSet\Services\CryptSvc" /v "LaunchProtected" > NUL 2>&1
REM if not errorlevel 1 (
REM     echo "LaunchProtected value detected."
REM     exit /b 1
REM )

copy /y "%AME_ISOPATH%\Windows\System32\svchost.exe" "%AME_ISOPATH%\Windows\System32\amehost.exe"
if not exist "%AME_ISOPATH%\Windows\System32\amehost.exe" (
    echo "Failed to copy amehost.exe file."
    exit /b 1
)

REM Occasionally communicates with Microsoft servers
reg add "HKU\HKLM-SYSTEM-%AME_ISOGUID%\ControlSet001\Services\CryptSvc" /v "ImagePath" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\amehost.exe -k NetworkService -p" /f
REM Communicates with inference-app-gateway.eastus2.cloudapp.azure.com upon new user creation
reg add "HKU\HKLM-SYSTEM-%AME_ISOGUID%\ControlSet001\Services\lfsvc" /v "ImagePath" /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\amehost.exe -k netsvcs -p" /f