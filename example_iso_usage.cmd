@echo off
rem Example batch file demonstrating ISO mastering functionality
rem This should be run as Administrator on a Windows system

echo AME Trusted Uninstaller - ISO Mastering Examples
echo =================================================
echo.

rem Basic ISO mastering example
echo Example 1: Basic ISO mastering
echo Command: TrustedUninstaller.CLI.exe ISO "AME-Windows11" --ISOPath "Win11_22H2.iso" --OutputPath "Win11_AME_Basic.iso"
echo.

rem Advanced example with drivers and custom settings
echo Example 2: Advanced ISO with drivers and custom OOBE
echo Command: TrustedUninstaller.CLI.exe ISO "AME-Windows11" ^
echo   --ISOPath "Win11_22H2.iso" ^
echo   --OutputPath "Win11_AME_Advanced.iso" ^
echo   --Architecture X64 ^
echo   --NetworkDrivers ^
echo   --GraphicsDrivers ^
echo   --SystemDrivers ^
echo   --Username "AMEUser" ^
echo   --Password "SecurePass123" ^
echo   --AutoLogon
echo.

rem ARM64 example for Surface devices
echo Example 3: ARM64 ISO for Surface devices
echo Command: TrustedUninstaller.CLI.exe ISO "AME-Windows11-ARM" ^
echo   --ISOPath "Win11_ARM64.iso" ^
echo   --OutputPath "Win11_AME_Surface.iso" ^
echo   --Architecture Arm64 ^
echo   --SystemDrivers ^
echo   --GraphicsDrivers
echo.

rem ESD format example
echo Example 4: Output in ESD format (smaller file size)
echo Command: TrustedUninstaller.CLI.exe ISO "AME-Windows11" ^
echo   --ISOPath "Win11_22H2.iso" ^
echo   --OutputPath "Win11_AME.iso" ^
echo   --ESD
echo.

rem Verified build example
echo Example 5: Verified build with specific Windows version
echo Command: TrustedUninstaller.CLI.exe ISO "AME-Windows11" ^
echo   --ISOPath "Win11_22H2.iso" ^
echo   --OutputPath "Win11_AME_Verified.iso" ^
echo   --ISOBuild "22631" ^
echo   --ISOUpdateBuild "22631.2428" ^
echo   --Verified
echo.

echo Prerequisites:
echo - Run as Administrator
echo - Minimum 20GB free disk space
echo - Input Windows ISO file
echo - AME Playbook extracted and ready
echo - mkisofs.exe in the application directory
echo.

echo For more information, see README.md and ISO_MASTERING.md
pause