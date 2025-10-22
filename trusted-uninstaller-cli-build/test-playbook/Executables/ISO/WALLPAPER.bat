
NSudoLC -U:T -P:E -M:S -Priority:RealTime -UseCurrentConsole -Wait icacls "%AME_ISOPATH%\Windows\Resources\Themes\aero.theme" /reset /t
PowerShell -NoP -C "$Content = (Get-Content '%AME_ISOPATH%\Windows\Resources\Themes\aero.theme'); $Content = $Content -replace 'Wallpaper=%%SystemRoot%%.*', 'Wallpaper=%%SystemRoot%%\web\wallpaper\Windows\ame_wallpaper_4K.bmp'; $Content = $Content -replace 'SystemMode=.*', 'SystemMode=Dark'; $Content -replace 'AppMode=.*', 'AppMode=Light' | Set-Content '%AME_ISOPATH%\Windows\Resources\Themes\aero.theme'"

@echo OFF

if exist "ame_wallpaper_4K.bmp" (
	move /y "ame_wallpaper_4K.bmp" "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows"
	icacls "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /reset
)

reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSpotlightCollectionOnDesktop /t REG_DWORD /d 1 /f

if not exist "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows" echo mkdir "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows" & mkdir "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows"

if exist "img0_*" (
	echo takeown /f "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows\*.jpg"
	takeown /f "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows\*.jpg"
	echo icacls "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows\*.jpg" /reset
	icacls "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows\*.jpg" /reset
	echo move /y img0_*.jpg "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows"
	move /y img0_*.jpg "%AME_ISOPATH%\Windows\Web\4K\Wallpaper\Windows"
)

if exist "img0.jpg" (
	echo takeown /f "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
	takeown /f "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
	echo icacls "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /reset
	icacls "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /reset
	echo move /y "img0.jpg" "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
	move /y "img0.jpg" "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
)

if not exist "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" set "wallFail=true" & goto lockScreen

echo reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f
reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\Control Panel\Desktop" /v WallPaper /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f
reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\SOFTWARE\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings" /v EnabledState /t REG_DWORD /d 0 /f
reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v BackgroundType /t REG_DWORD /d 0 /f
reg add "HKEY_USERS\HKCU-%AME_ISOGUID%\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers" /v CurrentWallpaperPath /t REG_SZ /d "%WINDIR%\Web\Wallpaper\Windows\ame_wallpaper_4K.bmp" /f

:lockScreen

		echo reg add "HKU\HKCU-%AME_ISOGUID%\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
		reg add "HKU\HKCU-%AME_ISOGUID%\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f

		if exist "img100.jpg" (
			echo takeown /f "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg"
			takeown /f "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg"
			echo icacls "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg" /reset
			icacls "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg" /reset
			echo copy "img100.jpg" "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg" /Y
			copy "img100.jpg" "%AME_ISOPATH%\Windows\Web\Screen\img100.jpg" /Y
		)

		if exist "img103.png" (
			echo takeown /f "%AME_ISOPATH%\Windows\Web\Screen\img103.png"
			takeown /f "%AME_ISOPATH%\Windows\Web\Screen\img103.png"
			echo icacls "%AME_ISOPATH%\Windows\Web\Screen\img103.png" /reset
			icacls "%AME_ISOPATH%\Windows\Web\Screen\img103.png" /reset
			echo copy "img103.png" "%AME_ISOPATH%\Windows\Web\Screen\img103.png" /Y
			copy "img103.png" "%AME_ISOPATH%\Windows\Web\Screen\img103.png" /Y
		)

		if exist "img0.jpg" (
			echo takeown /f "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
			takeown /f "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg"
			echo icacls "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /reset
			icacls "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /reset
			echo copy "img0.jpg" "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /Y
			copy "img0.jpg" "%AME_ISOPATH%\Windows\Web\Wallpaper\Windows\img0.jpg" /Y
		)

exit /b 0